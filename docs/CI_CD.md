# Story Craft — CI/CD Pipeline

This document describes the continuous integration and delivery pipeline for the Story Craft Flutter app.

Two CI providers are wired up, each playing a different role:

- **GitHub Actions** ([`.github/workflows/ci.yml`](../.github/workflows/ci.yml)) — fast feedback on every push/PR. Runs on Linux, no signing or secrets needed. Acts as the merge gate.
- **Codemagic** ([`codemagic.yaml`](../codemagic.yaml)) — Mac-based release pipeline. Builds signed iOS/Android artifacts and pushes them to **Firebase App Distribution**.

---

## Overview

```
                   ┌─────────────────────────────────────────────┐
                   │              Developer pushes               │
                   └──────────────────────┬──────────────────────┘
                                          │
            ┌─────────────────────────────┼─────────────────────────────┐
            │                             │                             │
   push / pull_request           push to main                        tag v*
            │                             │                             │
            ▼                             ▼                             ▼
  ┌──────────────────────┐     ┌──────────────────────┐     ┌──────────────────────┐
  │  GitHub Actions: CI  │     │  Codemagic:          │     │  Codemagic:          │
  │  - test (Ubuntu)     │     │  android-build       │     │  android-build       │
  │  - android debug APK │     │  + Firebase distrib. │     │  ios-build           │
  └──────────┬───────────┘     └──────────┬───────────┘     └──────────┬───────────┘
             │                            │                            │
             ▼                            ▼                            ▼
        merge gate              Firebase App Distribution    Firebase App Distribution
                                    → qa-testers                 → qa-testers
```

### Workflow inventory

**GitHub Actions** ([`.github/workflows/ci.yml`](../.github/workflows/ci.yml)):

| Job             | Trigger                       | Purpose                                     |
| --------------- | ----------------------------- | ------------------------------------------- |
| `test`          | every `push` / `pull_request` | Format check, static analysis, unit tests + coverage upload |
| `android-build` | `push` to `main` (after `test` passes) | Sanity debug-APK build, uploaded as artifact |

**Codemagic** ([`codemagic.yaml`](../codemagic.yaml)):

| Workflow        | Trigger                       | Purpose                                     |
| --------------- | ----------------------------- | ------------------------------------------- |
| `test`          | every `push` / `pull_request` | Same checks as GitHub Actions, runs on Mac  |
| `android-build` | `push` to `main` + `v*` tag   | Build release APK + AAB, distribute APK     |
| `ios-build`     | `v*` tag                      | Build signed IPA, distribute to testers     |

---

## Environment

- **Runner:** `mac_mini_m2` (Codemagic-hosted)
- **Flutter:** pinned to `3.41.6` (matches local dev environment)
- **Xcode:** `latest`
- **CocoaPods:** `default`

Pinning the Flutter version prevents unexpected breakage when the Flutter team ships a new stable.

---

## GitHub Actions

Defined in [`.github/workflows/ci.yml`](../.github/workflows/ci.yml). Uses [`subosito/flutter-action`](https://github.com/subosito/flutter-action) to install Flutter.

### Job: `test`

Runs on `ubuntu-latest` for every push and PR on every branch. Concurrency is keyed on workflow + ref, so newer commits cancel older in-flight runs on the same branch.

**Steps:** checkout → Flutter setup → `pub get` → format check → `flutter analyze` → `flutter test --coverage` → upload `coverage/lcov.info` as an artifact (14-day retention).

### Job: `android-build`

Runs only on `push` to `main`, gated on `test` passing. Builds an unsigned debug APK as a smoke test that the Android build still works on Linux. Uploads `app-debug.apk` as an artifact. Does **not** publish to Firebase — that's Codemagic's job (see below).

### Why both providers?

- GitHub Actions is free for public repos and has tight PR integration → ideal for the merge gate.
- Codemagic provides Mac runners, Xcode signing, and a first-class Firebase App Distribution publishing block → ideal for shipping signed builds.

If you eventually want a single source of truth, you can drop the Codemagic `test` workflow and let GitHub Actions own all CI checks while Codemagic handles only the release builds.

---

## Codemagic Workflows

### 1. `test` — Test & Analyze

**Triggers:** every push and every pull request, on all branches.

**Steps:**
1. Print Flutter version (diagnostics)
2. `flutter pub get`
3. `dart format --output=none --set-exit-if-changed .` — fails CI if any file needs reformatting
4. `flutter analyze` — static analysis using the rules in [`analysis_options.yaml`](../analysis_options.yaml)
5. `flutter test --coverage` — runs the suite in [`test/`](../test/) and emits `coverage/lcov.info`

**Artifacts:** `coverage/lcov.info` (downloadable from the build in Codemagic)

**Max duration:** 30 minutes

---

### 2. `android-build` — Android Build & Firebase Distribution

**Triggers:**
- Every push to `main` (continuous QA builds)
- Any tag matching `v*` (releases)

**Steps:**
1. `flutter pub get`
2. `flutter test` (sanity gate — no build if tests are red)
3. `flutter build apk --release`
4. `flutter build appbundle --release`

**Artifacts:**
- `build/app/outputs/flutter-apk/*.apk`
- `build/app/outputs/bundle/release/*.aab`

**Distribution:** APK is published to Firebase App Distribution, group `qa-testers`. Release notes include the Codemagic build ID, branch, and commit SHA.

**Max duration:** 60 minutes

---

### 3. `ios-build` — iOS Build & Firebase Distribution

**Triggers:** `v*` tags only (iOS requires signing, so we don't run it on every push).

**Steps:**
1. `flutter pub get`
2. `flutter test`
3. `xcode-project use-profiles` — applies provisioning profiles from the `ios_signing` env group
4. `cd ios && pod install`
5. `flutter build ipa --release --export-options-plist=/Users/builder/export_options.plist`

**Artifacts:** `build/ios/ipa/*.ipa`

**Distribution:** IPA published to Firebase App Distribution, group `qa-testers`.

**Max duration:** 60 minutes

---

## Required Codemagic Environment Variables

Configure these in the Codemagic UI under **Teams → Integrations → Environment variables**, then reference them by group in `codemagic.yaml`.

### Group: `firebase_credentials`

| Variable                   | Description                                                                                          | Secret |
| -------------------------- | ---------------------------------------------------------------------------------------------------- | ------ |
| `FIREBASE_SERVICE_ACCOUNT` | Full JSON contents of a Firebase service account key (Project Settings → Service accounts → Generate new private key) | ✅     |
| `FIREBASE_ANDROID_APP_ID`  | Android app ID, e.g. `1:123456789:android:abc123`                                                    |        |
| `FIREBASE_IOS_APP_ID`      | iOS app ID, e.g. `1:123456789:ios:abc123`                                                            |        |

### Group: `ios_signing`

Either configure Codemagic's automatic code signing for iOS (recommended), or supply:

| Variable                   | Description                                  | Secret |
| -------------------------- | -------------------------------------------- | ------ |
| Distribution certificate   | `.p12` file + password                       | ✅     |
| Provisioning profile       | `.mobileprovision`                           |        |
| `APP_STORE_CONNECT_KEY_*`  | If using App Store Connect API for signing   | ✅     |

### Tester Group

The Firebase App Distribution group is currently **`qa-testers`**. To change it, edit `codemagic.yaml` (`publishing.firebase.android.groups` and `.ios.groups`) and ensure the group exists in **Firebase Console → App Distribution → Testers & Groups**.

---

## Local Equivalent

The [`scripts/test.sh`](../scripts/test.sh) script mirrors the `test` job (in both providers) so contributors can validate locally before pushing.

```bash
# Run the same checks Codemagic runs
./scripts/test.sh

# With coverage report
./scripts/test.sh --coverage

# Skip the formatting check (e.g. while iterating)
./scripts/test.sh --no-format
```

The script will fail fast on the first error and use coloured output to highlight what passed/failed.

---

## Test Suite

Located in [`test/widget_test.dart`](../test/widget_test.dart). Covers:

- **`Buttons` widget** — label rendering, tap handling, loading state, prefix/suffix icons
- **`ThemeCubit`** — default state, mode switching, deduplication of identical emits, `toggleLightDark` behaviour, persistence via `SharedPreferences`

The full app (`StoryCraftApp`) is **not** mounted in widget tests because bootstrapping touches Firebase and EasyLocalization, both of which require non-trivial mocking. New tests should follow the same pattern: pick a focused widget or cubit and test it in isolation.

---

## Release Process

1. **Land changes on `main`** — the `test` workflow gates every PR. Once merged, the `android-build` workflow auto-publishes a fresh APK to the `qa-testers` group for QA validation.
2. **Cut a release tag** when ready to ship:
   ```bash
   git tag v1.2.3
   git push origin v1.2.3
   ```
3. Both `android-build` and `ios-build` run in parallel; signed artifacts land in Firebase App Distribution.
4. Promote builds from Firebase to Play Store / App Store manually (this pipeline does not yet publish to the stores).

### Versioning

Update `version:` in [`pubspec.yaml`](../pubspec.yaml) before tagging — Flutter uses `<semver>+<buildNumber>`. The git tag should match the semver portion (e.g. `pubspec` `1.2.3+45` → tag `v1.2.3`).

---

## Troubleshooting

| Symptom                                        | Likely cause                                                                          |
| ---------------------------------------------- | ------------------------------------------------------------------------------------- |
| `dart format` step fails                       | A file isn't formatted. Run `dart format .` locally and recommit.                     |
| `flutter analyze` step fails                   | Lint violation. Reproduce with `./scripts/test.sh --no-format` locally.               |
| Tests pass locally but fail on Codemagic       | Likely Flutter version drift. Check the `flutter:` field in `codemagic.yaml`.         |
| Firebase upload fails with "permission denied" | Service account JSON is wrong, or it lacks the *Firebase App Distribution Admin* role.|
| iOS build fails at `xcode-project use-profiles`| `ios_signing` env group missing or signing assets expired.                            |
| APK uploads but testers don't get an email     | Tester group name in `codemagic.yaml` doesn't match the one in Firebase Console.      |

---

## Future Improvements

- **Coverage gate:** fail PRs that drop coverage below a threshold (e.g. Codecov action consuming the GitHub Actions `coverage-lcov` artifact).
- **Play Store / App Store publishing:** add `google_play` and `app_store_connect` publishing blocks to Codemagic for tagged releases.
- **Integration tests:** add a `flutter drive` workflow once a critical user flow is locked down.
- **Branch-protection rule:** require the GitHub Actions `test` job to pass before merging to `main`.
- **Consolidate CI:** if running both providers feels redundant, keep GitHub Actions for checks and Codemagic only for release builds + Firebase distribution.
