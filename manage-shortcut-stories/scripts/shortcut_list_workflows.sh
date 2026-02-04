#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${SHORTCUT_API_TOKEN:-}" ]]; then
  echo "SHORTCUT_API_TOKEN is not set" >&2
  exit 1
fi

BASE_URL="${SHORTCUT_API_BASE_URL:-https://api.app.shortcut.com/api/v3}"
PATTERN="${1:-}"

response="$(curl -sS "$BASE_URL/workflows" \
  -H "Shortcut-Token: $SHORTCUT_API_TOKEN" \
  -H "Content-Type: application/json")"

if command -v jq >/dev/null 2>&1; then
  if [[ -n "$PATTERN" ]]; then
    echo "$response" | jq --arg pattern "$PATTERN" '
      map(select(.name | test($pattern; "i")))
      | map({id, name, default_state_id, states: [.states[] | {id, name, type, verb}]})
    '
  else
    echo "$response" | jq 'map({id, name, default_state_id, states: [.states[] | {id, name, type, verb}]})'
  fi
else
  echo "$response"
fi
