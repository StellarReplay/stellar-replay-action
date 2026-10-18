#!/usr/bin/env bash
set -euo pipefail

action_file="${1:-action.yml}"

test -s "$action_file"
grep -Eq '^name: [^[:space:]].*' "$action_file"
grep -Eq '^description: [^[:space:]].*' "$action_file"
grep -Eq '^author: [^[:space:]].*' "$action_file"
grep -Eq '^runs:$' "$action_file"
grep -Eq '^  using: composite$' "$action_file"
grep -Eq '^    - name: Download and verify Stellar Replay \(Unix\)$' "$action_file"
grep -Eq '^    - name: Download and verify Stellar Replay \(Windows\)$' "$action_file"
grep -Eq 'run-action\.sh' "$action_file"
grep -Eq 'run-action\.ps1' "$action_file"
grep -Eq '^  fixture:$' "$action_file"
grep -Eq '^    required: true$' "$action_file"

echo "action metadata and fail-closed contract are valid"
