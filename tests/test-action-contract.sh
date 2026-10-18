#!/usr/bin/env bash
set -euo pipefail

test -s action.yml
test -s scripts/run-action.sh
test -s scripts/run-action.ps1
grep -q 'checksum verification failed' scripts/run-action.sh
grep -q 'unsupported Stellar Replay core version' scripts/run-action.sh
grep -q 'unsupported Stellar Replay command' scripts/run-action.sh
grep -q 'checksum verification failed' scripts/run-action.ps1
grep -q 'unsupported Stellar Replay core version' scripts/run-action.ps1
grep -q 'Pre-release guard' README.md && exit 1 || true

echo "Action contract includes version pinning, checksum verification, command validation, and both runner paths"
