#!/usr/bin/env bash
set -euo pipefail

fixture="${STELLAR_REPLAY_FIXTURE:?fixture is required}"
command_name="${STELLAR_REPLAY_COMMAND:-validate}"
version="${STELLAR_REPLAY_CORE_VERSION:-0.1.1}"
repository="${STELLAR_REPLAY_CORE_REPOSITORY:-StellarReplay/stellar-replay}"

case "$version" in
  0.1.1) ;;
  *) echo "::error::unsupported Stellar Replay core version: $version" >&2; exit 2 ;;
esac
case "$command_name" in
  validate|replay) ;;
  *) echo "::error::unsupported Stellar Replay command: $command_name" >&2; exit 2 ;;
esac
test -f "$fixture" || { echo "::error::fixture not found: $fixture" >&2; exit 2; }

workdir="${RUNNER_TEMP:-${TMPDIR:-/tmp}}/stellar-replay-action"
rm -rf "$workdir"
mkdir -p "$workdir"
if [[ "${RUNNER_OS:-Linux}" == "macOS" ]]; then platform=darwin; else platform=linux; fi
asset="stellar-replay-${version}-${platform}-amd64.tar.gz"
base="https://github.com/${repository}/releases/download/v${version}"
curl --fail --location --silent --show-error --retry 2 "$base/$asset" -o "$workdir/$asset"
curl --fail --location --silent --show-error --retry 2 "$base/SHA256SUMS" -o "$workdir/SHA256SUMS"
expected="$(awk -v asset="$asset" '$2 == asset { print $1 }' "$workdir/SHA256SUMS")"
test -n "$expected" || { echo "::error::release checksum is missing for $asset" >&2; exit 1; }
actual="$(sha256sum "$workdir/$asset" | awk '{print $1}')"
test "$actual" = "$expected" || { echo "::error::release checksum verification failed" >&2; exit 1; }
tar -xzf "$workdir/$asset" -C "$workdir"
binary="$workdir/stellar-replay"
test -x "$binary" || { echo "::error::release archive did not contain stellar-replay" >&2; exit 1; }

args=("$command_name" --fixture "$fixture")
if [[ "$command_name" == replay ]]; then
  if [[ -n "${STELLAR_REPLAY_REQUEST_FILE:-}" ]]; then args+=(--request-file "$STELLAR_REPLAY_REQUEST_FILE"); fi
  if [[ -n "${STELLAR_REPLAY_METHOD:-}" ]]; then args+=(--method "$STELLAR_REPLAY_METHOD"); fi
  if [[ -n "${STELLAR_REPLAY_PARAMS:-}" ]]; then args+=(--params "$STELLAR_REPLAY_PARAMS"); fi
fi
exec "$binary" "${args[@]}"
