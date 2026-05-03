#!/usr/bin/env bash
# Local CI test script — mirrors what Codemagic runs.
# Usage: ./scripts/test.sh [--coverage] [--no-format]

set -euo pipefail

COVERAGE=0
CHECK_FORMAT=1

for arg in "$@"; do
  case "$arg" in
    --coverage) COVERAGE=1 ;;
    --no-format) CHECK_FORMAT=0 ;;
    -h|--help)
      echo "Usage: $0 [--coverage] [--no-format]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 1
      ;;
  esac
done

cd "$(dirname "$0")/.."

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

step() { echo -e "\n${YELLOW}==> $1${NC}"; }
ok()   { echo -e "${GREEN}✓ $1${NC}"; }
fail() { echo -e "${RED}✗ $1${NC}"; exit 1; }

step "Flutter version"
flutter --version

step "Getting dependencies"
flutter pub get
ok "Dependencies installed"

if [ "$CHECK_FORMAT" -eq 1 ]; then
  step "Checking formatting"
  if dart format --output=none --set-exit-if-changed .; then
    ok "Formatting clean"
  else
    fail "Formatting issues found. Run: dart format ."
  fi
fi

step "Analyzing project"
flutter analyze
ok "Analysis passed"

step "Running tests"
if [ "$COVERAGE" -eq 1 ]; then
  flutter test --coverage
  ok "Tests passed (coverage at coverage/lcov.info)"
else
  flutter test
  ok "Tests passed"
fi

echo -e "\n${GREEN}All checks passed.${NC}"
