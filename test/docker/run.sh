#!/usr/bin/env bash
#
# Runs the plugin smoke test against an official Redmine Docker image.
#
# Usage: test/docker/run.sh [redmine-version ...]
#
# Without arguments all supported Redmine versions are tested.
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEFAULT_VERSIONS=(5.1 6.0 6.1 7.0)
VERSIONS=("${@:-}")
if [ -z "${1:-}" ]; then
  VERSIONS=("${DEFAULT_VERSIONS[@]}")
fi

run_for_version() {
  local version="$1"
  local container="redmine-close-button-test-${version//./-}"

  echo "==> Testing against redmine:${version}"
  docker rm -f "$container" >/dev/null 2>&1 || true
  docker run -d --name "$container" \
    -v "${PLUGIN_DIR}:/usr/src/redmine/plugins/redmine_close_button:ro" \
    "redmine:${version}" >/dev/null

  local ready=0
  for _ in $(seq 1 60); do
    if docker logs "$container" 2>&1 | grep -q 'Listening on'; then
      ready=1
      break
    fi
    if [ "$(docker inspect -f '{{.State.Running}}' "$container")" != "true" ]; then
      break
    fi
    sleep 5
  done

  if [ "$ready" -ne 1 ]; then
    echo "Redmine ${version} failed to start:"
    docker logs "$container" 2>&1 | tail -50
    docker rm -f "$container" >/dev/null 2>&1 || true
    return 1
  fi

  local output status
  set +e
  output=$(docker exec "$container" bash -c \
    'cd /usr/src/redmine && RAILS_ENV=production bundle exec rails runner plugins/redmine_close_button/test/docker/verify_plugin.rb' 2>&1)
  status=$?
  set -e

  docker rm -f "$container" >/dev/null 2>&1 || true

  if [ "$status" -ne 0 ] || ! grep -q '^OK$' <<<"$output"; then
    echo "Smoke test failed on redmine:${version}:"
    grep -vE '^[IWD], \[' <<<"$output" | tail -30
    return 1
  fi

  grep -E '^(Plugin registered|Close button rendered|OK)' <<<"$output"
  echo "==> redmine:${version} OK"
}

failed=0
for version in "${VERSIONS[@]}"; do
  run_for_version "$version" || failed=1
done

exit "$failed"
