# Section 3 — Flutter Basics (Story Craft Walkthrough)

> Date: 9/4/2026
> Audience: students new to Flutter/Dart
> Method: every concept is explained with a real example **from the Story Craft project**, so you can open the file and see it in context.

---

## Table of contents

1. [Arrow functions (`=>`)](#1-arrow-functions-)
2. [Anonymous functions](#2-anonymous-functions)
3. [`ListView.builder`](#3-listviewbuilder)
4. [`GridView`](#4-gridview)
5. [Navigator — `pushNamed()`](#5-navigator--pushnamed)
6. [`pop()`](#6-pop)
7. [`popUntil()`](#7-popuntil)
8. [`pushReplacementNamed()` and `pushNamedAndRemoveUntil()`](#8-pushreplacementnamed-and-pushnamedandremoveuntil)
9. [`initialRoute`, `home`, `routes` / `onGenerateRoute`](#9-initialroute-home-routes--ongenerateroute)
10. [Stateful widget — Counter Screen](#10-stateful-widget--counter-screen)
11. [Converting `int` to `String` — `toString()` and `'$variable'`](#11-converting-int-to-string)
12. [`widget.counter` and `const`](#12-widgetcounter-and-const)
13. [Adding a file to `assets`](#13-adding-a-file-to-assets)
14. [Reading data from a file](#14-reading-data-from-a-file)
15. [SharedPreferences](#15-sharedpreferences)

---

## 1. Arrow functions (`=>`)

### What it is
A short way to write a function that **returns one expression**. Instead of writing `{ return X; }`, you write `=> X`.

### General shape
```dart
// Long version
int add(int a, int b) {
  return a + b;
}

// Arrow version (same thing)
int add(int a, int b) => a + b;
```

### Real example from this project
[`lib/core/services/router/extantions.dart`](../../lib/core/services/router/extantions.dart) line 16:

```dart
void pop() => Navigator.of(this).pop();
```

That single line is a complete function — it pops the current screen off the navigation stack. There's no `{ ... return ... }` because there's only one expression.

### Rules to remember
- `=>` works only when the body is a **single expression**.
- If you need two or more lines, you must use `{ ... }`.

---

## 2. Anonymous functions

### What it is
A function with **no name**. You usually write it inline, where another function expects a function as an argument (a "callback").

### General shape
```dart
// Named function
void onPressed() {
  print('Hello');
}

// Anonymous function (no name) — same behaviour
() {
  print('Hello');
}
```

### Real example from this project
[`lib/features/stories/presentation/widgets/library/story_grid.dart`](../../lib/features/stories/presentation/widgets/library/story_grid.dart):

```dart
itemBuilder: (_, i) {
  final story = stories[i];
  return StoryCard(
    story: story,
    onTap: () => context.pushNamed(
      AppRoutes.storyDetailsPath,
      arguments: story.id,
    ),
  );
},
```

There are **two anonymous functions** here:
- `(_, i) { ... }` — passed to `itemBuilder`. Flutter calls it for every item.
- `() => context.pushNamed(...)` — passed to `onTap`. It's an arrow anonymous function.

### Why `_`?
`_` means "I receive this argument but I don't use it." Here `itemBuilder` gives us `(BuildContext, int)` but we only need the index, so the context becomes `_`.

---

## 3. `ListView.builder`

### What it is
A scrollable vertical list that builds its items **lazily** (only the ones visible on screen). Use it when you have many items.

### Real example from this project
[`lib/features/notifications/presentation/pages/notifications_page.dart`](../../lib/features/notifications/presentation/pages/notifications_page.dart) line 81:

```dart
ListView.builder(
  itemCount: state.items.length,
  itemBuilder: (_, i) {
    final notification = state.items[i];
    return NotificationTile(notification: notification);
  },
)
```

### The two important parameters
| Parameter      | Meaning                                                              |
| -------------- | -------------------------------------------------------------------- |
| `itemCount`    | How many items the list has (usually `myList.length`)                |
| `itemBuilder`  | A function `(context, index) => Widget` that builds item number `index` |

### Why `.builder` instead of `ListView(children: [...])`?
- `ListView(children: [...])` builds **every** widget upfront → slow with many items.
- `ListView.builder` builds widgets **only when they scroll into view** → fast even with thousands of items.

---

## 4. `GridView`

### What it is
Like `ListView`, but items are placed in a **grid** (multiple columns).

### Real example from this project
[`lib/features/stories/presentation/widgets/library/story_grid.dart`](../../lib/features/stories/presentation/widgets/library/story_grid.dart):

```dart
GridView.builder(
  itemCount: stories.length,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,        // 2 columns
    crossAxisSpacing: 12.w,   // horizontal gap
    mainAxisSpacing: 12.h,    // vertical gap
    childAspectRatio: 0.78,   // width / height of each cell
  ),
  itemBuilder: (_, i) {
    final story = stories[i];
    return StoryCard(story: story, onTap: () => ...);
  },
)
```

### Key concept: the **gridDelegate**
The grid needs to know *how* to lay out cells. The most common delegate is `SliverGridDelegateWithFixedCrossAxisCount`, which lets you say "I want X columns."

| Property          | Meaning                                          |
| ----------------- | ------------------------------------------------ |
| `crossAxisCount`  | Number of columns                                |
| `crossAxisSpacing`| Gap between columns                              |
| `mainAxisSpacing` | Gap between rows                                 |
| `childAspectRatio`| Shape of each cell (width ÷ height)              |

---

## 5. Navigator — `pushNamed()`

### What it is
Flutter manages screens like a **stack of cards**. `pushNamed` puts a new card on top of the stack — the user sees the new screen, and can press "back" to return.

### General shape
```dart
Navigator.pushNamed(context, '/login');
```

In this project we wrap it in an extension to make it shorter — see [`lib/core/services/router/extantions.dart`](../../lib/core/services/router/extantions.dart):

```dart
extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }
}
```

So instead of `Navigator.pushNamed(context, '/login')`, we can write `context.pushNamed('/login')`.

### Real example
[`lib/features/auth/login/presentation/pages/login_page.dart`](../../lib/features/auth/login/presentation/pages/login_page.dart) line 88:

```dart
context.pushNamed(AppRoutes.signUpPath);
```

When the user taps "Sign Up" on the login page, this line **pushes** the sign-up page on top.

### Passing data with `arguments`
[`lib/features/stories/presentation/widgets/library/story_grid.dart`](../../lib/features/stories/presentation/widgets/library/story_grid.dart):

```dart
context.pushNamed(
  AppRoutes.storyDetailsPath,
  arguments: story.id,   // pass the story id to the next screen
);
```

The receiving screen reads it via `ModalRoute.of(context)?.settings.arguments`.

---

## 6. `pop()`

### What it is
Removes the **top** screen from the stack — the user goes back to the previous screen.

### General shape
```dart
Navigator.pop(context);
// or with our extension:
context.pop();
```

### When to use
- A "Cancel" or "Back" button on a custom page.
- After a form submits successfully, return to the previous screen.

### Returning a value
You can pass a value back to the screen that pushed you:
```dart
Navigator.pop(context, true);   // tells the previous screen "yes"
```
The screen that called `pushNamed` gets that value because `pushNamed` returns a `Future`:
```dart
final result = await context.pushNamed('/confirm');
if (result == true) { ... }
```

---

## 7. `popUntil()`

### What it is
Pops screens **repeatedly** until a condition is met. Useful when you're 4 screens deep and want to jump back to the home screen in one go.

### General shape
```dart
Navigator.popUntil(context, (route) => route.isFirst);
```
Translation: "Keep popping until the next screen on the stack is the very first one."

You can also pop until a specific named route:
```dart
Navigator.popUntil(context, ModalRoute.withName('/library'));
```
This goes back all the way to `/library` no matter how many screens are on top.

### When to use it in a project like this
Imagine the user is on:
`Library → Story Details → Reader → Settings`
After they tap "Done reading", you want to send them straight back to `Library`. `popUntil(context, ModalRoute.withName(AppRoutes.libraryPath))` does that in one call.

---

## 8. `pushReplacementNamed()` and `pushNamedAndRemoveUntil()`

These are **navigation moves that delete history**. Use them when "back" should NOT go to the previous screen.

### `pushReplacementNamed`
Pushes a new screen and **removes the current one** from the stack.

```dart
context.pushReplacementNamed(AppRoutes.mainLayoutPath);
```

Use case: after **login**. You don't want the user to press back and end up on the login form again.

### `pushNamedAndRemoveUntil`
Pushes a new screen and **removes everything below it** until your predicate returns true.

Real example — [`lib/features/auth/login/presentation/pages/login_page.dart`](../../lib/features/auth/login/presentation/pages/login_page.dart) line 116:

```dart
context.pushNamedAndRemoveUntil(
  AppRoutes.mainLayoutPath,
  predicate: (route) => false,   // remove EVERYTHING under
);
```

`(route) => false` means "no route survives" → the new screen becomes the only one in the stack.

### Quick comparison

| Method                          | New screen | Old screen | Older screens |
| ------------------------------- | ---------- | ---------- | ------------- |
| `pushNamed`                     | added      | kept       | kept          |
| `pushReplacementNamed`          | added      | removed    | kept          |
| `pushNamedAndRemoveUntil(…false)`| added     | removed    | removed       |

---

## 9. `initialRoute`, `home`, `routes` / `onGenerateRoute`

`MaterialApp` needs to know **which screen to show first** and **how to resolve named routes**.

### Three options for the first screen

```dart
// Option A — use `home` (a widget directly)
MaterialApp(home: LoginPage());

// Option B — use `initialRoute` (a named route)
MaterialApp(initialRoute: '/login', routes: { '/login': (_) => LoginPage() });

// Option C — use `onGenerateRoute` (a function that returns Routes)
MaterialApp(initialRoute: '/login', onGenerateRoute: AppRouter.onGenerateRoute);
```

### What this project uses
[`lib/app/story_craft_app.dart`](../../lib/app/story_craft_app.dart):

```dart
MaterialApp(
  initialRoute: isSignedIn
      ? AppRoutes.mainLayoutPath
      : AppRoutes.onboardingPath,
  onGenerateRoute: AppRouter.onGenerateRoute,
)
```

- `initialRoute` is decided at runtime: signed-in users go to the main layout, others see the onboarding.
- `onGenerateRoute` is a function in [`lib/app/router/app_router.dart`](../../lib/app/router/app_router.dart) that receives a `RouteSettings` and returns a `Route`. This style scales better than the `routes: {...}` map because you can read `arguments` and decide what to build.

### Why not `home:`?
Because we need the route name in `initialRoute` to support deep linking and conditional first screens.

---

## 10. Stateful widget — Counter Screen

### Stateless vs Stateful
- **Stateless widget:** Its UI never changes after it's built. (e.g. an icon, a static label.)
- **Stateful widget:** Its UI can change over time. It has a separate `State` object that holds variables.

### The classic Counter Screen
```dart
import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;   // <-- state lives here

  void _increment() {
    setState(() {    // <-- tell Flutter "rebuild me"
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(child: Text('$counter')),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### The flow
1. User taps the `+` button → `_increment()` runs.
2. `setState(() => counter++)` updates the variable AND tells Flutter to rebuild the UI.
3. `build()` runs again with the new value of `counter`.

### Why is `build()` separate from `State` variables?
Because Flutter needs to be able to throw away the old widget tree and rebuild it without losing your data. The `State` object survives across rebuilds; the widget tree is recreated each time.

---

## 11. Converting `int` to `String`

Flutter's `Text(...)` only accepts a `String`. So if your variable is a number, you must convert it.

### Two ways

**A) `.toString()`**
```dart
int counter = 5;
Text(counter.toString());   // "5"
```

**B) String interpolation with `$`**
```dart
int counter = 5;
Text('$counter');           // "5"

// You can mix text and variables:
Text('You have $counter messages');
```

### When to use which?
- For a single value alone, both work; `'$counter'` is shorter.
- When you want to mix variables and text → use `'...'` with `$`.
- When you call a method on the result, use `.toString()`:
  ```dart
  print(counter.toString().length);
  ```
- For complex expressions, wrap them in `${...}`:
  ```dart
  Text('Score: ${player.score + bonus}');
  ```

---

## 12. `widget.counter` and `const`

### `widget.xxx` — accessing a field that lives on the widget from inside the State

When a `StatefulWidget` has a field, the State class reads it via the special `widget` reference:

```dart
class StoryReader extends StatefulWidget {
  const StoryReader({super.key, required this.storyId});
  final String storyId;   // <-- field on the widget

  @override
  State<StoryReader> createState() => _StoryReaderState();
}

class _StoryReaderState extends State<StoryReader> {
  @override
  void initState() {
    super.initState();
    // Read the storyId that the parent passed in:
    print(widget.storyId);   // <-- "widget." gives access
  }

  @override
  Widget build(BuildContext context) {
    return Text('Reading story ${widget.storyId}');
  }
}
```

**Rule:** values *passed to the widget* live on the widget (`widget.x`); values that *change over time* live in the State (just `x`).

### `const` — promise that the value never changes

`const` tells Dart: "this value is fixed at compile time, you can reuse the same instance forever."

```dart
const SizedBox(height: 16)        // built once, reused everywhere
const Text('Hello')               // same
```

Real examples in this project — see [`lib/features/auth/login/presentation/pages/login_page.dart`](../../lib/features/auth/login/presentation/pages/login_page.dart):
```dart
context.pushNamed(AppRoutes.signUpPath);
// ...
const Text('Sign in'),
```

### Why bother with `const`?
- **Performance:** Flutter skips rebuilding `const` widgets because they can never change.
- **Linter:** `flutter analyze` will warn you to add `const` wherever possible.

### Const constructor
To allow `const Buttons(...)`, the class must declare `const` on its constructor (and all fields must be `final`):
```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.label});  // <-- const constructor
  final String label;
}
```

---

## 13. Adding a file to `assets`

Flutter doesn't bundle random files in your app by default — you must declare them in `pubspec.yaml`.

### Step 1 — put the file in a folder
This project keeps assets under `assets/`:
```
assets/
  images/
  icons/
  translations/
```

### Step 2 — declare it in `pubspec.yaml`
[`pubspec.yaml`](../../pubspec.yaml) lines 43-46:
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
    - assets/translations/
```

You can declare a whole folder (with `/`) or a single file (without `/`).

### Step 3 — `flutter pub get`
Run it once after editing pubspec so Flutter rebuilds its asset manifest.

### Step 4 — use the asset
For images:
```dart
Image.asset('assets/images/logo.png')
```
For SVGs (this project uses `flutter_svg`):
```dart
SvgPicture.asset('assets/icons/cloud.svg')
```

Real example — [`lib/features/onboarding/presentation/page/onboarding.dart`](../../lib/features/onboarding/presentation/page/onboarding.dart) line 39:
```dart
SvgPicture.asset(
  Assets.cloud2,
  width: 100.w,
  height: 60.h,
  fit: BoxFit.contain,
)
```
(`Assets.cloud2` is just a constant holding the asset path string — keeping paths in one constants class avoids typos.)

---

## 14. Reading data from a file

For text/JSON files bundled as assets, use `rootBundle.loadString`.

### Steps
1. Add the file under `assets/` and declare it in `pubspec.yaml` (same as above).
2. Read it with `rootBundle`:

```dart
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

Future<List<dynamic>> loadStories() async {
  // 1. Load the raw text
  final raw = await rootBundle.loadString('assets/data/stories.json');

  // 2. Parse JSON into a Dart object
  final List<dynamic> stories = jsonDecode(raw);

  return stories;
}
```

### Important
- It's `async` because reading from disk is not instant — you must `await` it.
- For files **outside** `assets/` (e.g. files the user creates), use the `path_provider` and `dart:io` packages instead.

---

## 15. SharedPreferences

### What it is
A tiny key-value database stored on the device. Use it for **small** pieces of data: user preferences, flags, the last theme they chose, an auth token. **Don't** use it for large lists or user-generated content (use a real database for that).

### Setup
This project already has `shared_preferences: ^2.5.3` in [`pubspec.yaml`](../../pubspec.yaml).

### How this project wraps it
[`lib/core/services/local_storage_service/shared_prefs/shared_pref_helper.dart`](../../lib/core/services/local_storage_service/shared_prefs/shared_pref_helper.dart):

```dart
class SharedPrefsHelper {
  final SharedPreferences prefs;
  SharedPrefsHelper(this.prefs);

  Future<bool> storeData<T>({required String key, required T value}) async {
    if (value is bool)         return await prefs.setBool(key, value);
    if (value is String)       return await prefs.setString(key, value);
    if (value is int)          return await prefs.setInt(key, value);
    if (value is double)       return await prefs.setDouble(key, value);
    if (value is List<String>) return await prefs.setStringList(key, value);
    throw Exception('Unsupported type: ${T.toString()}');
  }

  T? getData<T>({required String key}) {
    final result = prefs.get(key);
    return result as T?;
  }

  Future<bool> removeData({required String key}) async => prefs.remove(key);
  Future<bool> clearData()                          async => prefs.clear();
}
```

### Real usage in the app
[`lib/core/theme/theme_cubit.dart`](../../lib/core/theme/theme_cubit.dart):

```dart
static const _kThemeModeKey = 'theme_mode';

void _loadSavedTheme() {
  final saved = _prefs.getData<int>(key: _kThemeModeKey);
  if (saved != null && saved < ThemeMode.values.length) {
    emit(ThemeMode.values[saved]);
  }
}

void setThemeMode(ThemeMode mode) {
  if (state == mode) return;
  _prefs.storeData<int>(key: _kThemeModeKey, value: mode.index);
  emit(mode);
}
```

So when the user picks dark mode, the app writes `theme_mode: 1` to disk. Next time they open the app, `_loadSavedTheme` reads it back.

### Vanilla example without the helper
```dart
import 'package:shared_preferences/shared_preferences.dart';

Future<void> save() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', 'Ahmed');
}

Future<void> read() async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('username');   // 'Ahmed' or null
  print(name);
}
```

### Rules of thumb
- Use **string keys** that are constants (`static const _kThemeKey = ...`) so you don't typo them.
- Always handle `null` from the getters — there might be no saved value yet.
- It's **persistent**: data survives app restarts but disappears when the user uninstalls the app.

---

## Quick reference — what to remember from each topic

| # | Topic | One-line takeaway |
| --- | --- | --- |
| 1 | Arrow function | `=>` is shorthand for "return one expression" |
| 2 | Anonymous function | A function with no name, used inline as a callback |
| 3 | `ListView.builder` | Lazy-built scrollable list — `itemCount` + `itemBuilder` |
| 4 | `GridView` | Like ListView but with columns, controlled by `gridDelegate` |
| 5 | `pushNamed` | Add a screen on top of the stack |
| 6 | `pop` | Remove the top screen |
| 7 | `popUntil` | Pop repeatedly until a condition is true |
| 8 | `pushReplacement` / `pushAndRemoveUntil` | Replace the screen — back button won't return |
| 9 | `initialRoute` / `onGenerateRoute` | How `MaterialApp` knows the first screen and how to build others |
| 10 | Stateful widget | Use `setState` to change values and rebuild UI |
| 11 | int → String | `.toString()` or `'$variable'` |
| 12 | `widget.x` / `const` | `widget.x` reaches widget fields from State; `const` = compile-time constant |
| 13 | Assets | Put file in `assets/`, declare it in `pubspec.yaml`, then `Image.asset(...)` |
| 14 | Read a file | `rootBundle.loadString('assets/...')` then `jsonDecode` if it's JSON |
| 15 | SharedPreferences | Tiny key-value storage — use it for settings/flags only |
