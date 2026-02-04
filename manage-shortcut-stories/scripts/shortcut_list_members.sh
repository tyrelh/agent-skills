#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${SHORTCUT_API_TOKEN:-}" ]]; then
  echo "SHORTCUT_API_TOKEN is not set" >&2
  exit 1
fi

BASE_URL="${SHORTCUT_API_BASE_URL:-https://api.app.shortcut.com/api/v3}"
PATTERN="${1:-}"

response="$(curl -sS "$BASE_URL/members" \
  -H "Shortcut-Token: $SHORTCUT_API_TOKEN" \
  -H "Content-Type: application/json")"

if command -v jq >/dev/null 2>&1; then
  if [[ -n "$PATTERN" ]]; then
    echo "$response" | jq --arg pattern "$PATTERN" '
      map(select((.profile.name // "" | test($pattern; "i")) or (.profile.email // "" | test($pattern; "i"))))
      | map({id, name: .profile.name, email: .profile.email})
    '
  else
    echo "$response" | jq 'map({id, name: .profile.name, email: .profile.email})'
  fi
else
  echo "$response"
fi
