#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
RELEASE_WORKFLOW="$REPO_DIR/.github/workflows/release.yml"
DOCKER_WORKFLOW="$REPO_DIR/.github/workflows/docker.yml"

TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

pass() {
  TESTS_RUN=$((TESTS_RUN + 1))
  TESTS_PASSED=$((TESTS_PASSED + 1))
  printf '  [PASS] %s\n' "$1"
}

fail() {
  TESTS_RUN=$((TESTS_RUN + 1))
  TESTS_FAILED=$((TESTS_FAILED + 1))
  printf '  [FAIL] %s\n' "$1"
}

section() {
  printf '\n\033[1m%s\033[0m\n' "$1"
}

assert_contains() {
  local file_path="$1"
  local pattern="$2"
  local description="$3"
  if grep -Eq "$pattern" "$file_path"; then
    pass "$description"
  else
    fail "$description"
  fi
}

assert_not_contains() {
  local file_path="$1"
  local pattern="$2"
  local description="$3"
  if grep -Eq "$pattern" "$file_path"; then
    fail "$description"
  else
    pass "$description"
  fi
}

section "Release workflow sequencing"
assert_contains "$RELEASE_WORKFLOW" '^\s*docker_prepare:' "release.yml defines docker_prepare tag owner"
assert_contains "$RELEASE_WORKFLOW" '^\s*docker_build_amd64:' "release.yml defines amd64 build lane"
assert_contains "$RELEASE_WORKFLOW" '^\s*docker_build_arm64_native:' "release.yml defines arm64 native lane"
assert_contains "$RELEASE_WORKFLOW" '^\s*docker_build_arm64_qemu:' "release.yml defines arm64 qemu fallback lane"
assert_contains "$RELEASE_WORKFLOW" '^\s*docker_manifest_verify:' "release.yml defines manifest verification gate"
assert_contains "$RELEASE_WORKFLOW" '^\s*docker_promote_stable:' "release.yml defines stable promotion lane"
assert_contains "$RELEASE_WORKFLOW" "linux/amd64" "release.yml references linux/amd64"
assert_contains "$RELEASE_WORKFLOW" "linux/arm64" "release.yml references linux/arm64"
assert_contains "$RELEASE_WORKFLOW" "docker/setup-qemu-action@v3" "release.yml defines explicit qemu fallback path"
assert_contains "$RELEASE_WORKFLOW" "docker buildx imagetools inspect" "release.yml verifies candidate manifest contents"
assert_contains "$RELEASE_WORKFLOW" "ghcr\\.io/griddlehq/flapjack" "release.yml uses canonical image owner"
assert_contains "$RELEASE_WORKFLOW" "^\\s*if:\\s*\\$\\{\\{\\s*runner\\.os\\s*!=\\s*'Windows'\\s*\\}\\}" "unix packaging step uses valid runner.os expression syntax"
assert_contains "$RELEASE_WORKFLOW" "^\\s*if:\\s*\\$\\{\\{\\s*runner\\.os\\s*==\\s*'Windows'\\s*\\}\\}" "windows packaging step uses valid runner.os expression syntax"

section "docker.yml ownership boundaries"
assert_not_contains "$DOCKER_WORKFLOW" '^\s*push:\s*$' "docker.yml no longer auto-publishes on push"
assert_not_contains "$DOCKER_WORKFLOW" '^\s*tags:\s*\["v\*"\]' "docker.yml no longer publishes release tags"
assert_not_contains "$DOCKER_WORKFLOW" "type=semver,pattern=\\{\\{version\\}\\}" "docker.yml no longer publishes semver stable tags"
assert_not_contains "$DOCKER_WORKFLOW" "type=raw,value=latest" "docker.yml no longer publishes latest stable tag"

printf '\n\033[1mResults: %d/%d passed\033[0m\n' "$TESTS_PASSED" "$TESTS_RUN"
if [ "$TESTS_FAILED" -gt 0 ]; then
  printf '\033[0;31m%d test(s) failed\033[0m\n' "$TESTS_FAILED"
  exit 1
fi
printf '\033[0;32mAll tests passed\033[0m\n'
