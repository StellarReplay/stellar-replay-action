#!/usr/bin/env bash
set -euo pipefail

action_file="${1:-action.yml}"

test -s "$action_file"
grep -Eq '^name: [^[:space:]].*' "$action_file"
grep -Eq '^description: [^[:space:]].*' "$action_file"
grep -Eq '^author: [^[:space:]].*' "$action_file"
grep -Eq '^runs:$' "$action_file"
grep -Eq '^  using: composite$' "$action_file"
grep -Eq '^    - name: Pre-release guard$' "$action_file"
grep -Eq 'exit 1$' "$action_file"
grep -Eq '^  fixture:$' "$action_file"
grep -Eq '^    required: true$' "$action_file"

echo "action metadata and fail-closed contract are valid"
