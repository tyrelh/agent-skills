#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${SHORTCUT_API_TOKEN:-}" ]]; then
  echo "SHORTCUT_API_TOKEN is not set" >&2
  exit 1
fi

BASE_URL="${SHORTCUT_API_BASE_URL:-https://api.app.shortcut.com/api/v3}"
PATTERN="${1:-}"
INCLUDE_ARCHIVED="${SHORTCUT_INCLUDE_ARCHIVED:-0}"

response="$(curl -sS "$BASE_URL/projects" \
  -H "Shortcut-Token: $SHORTCUT_API_TOKEN" \
  -H "Content-Type: application/json")"

if command -v jq >/dev/null 2>&1; then
  if [[ "$INCLUDE_ARCHIVED" == "1" ]]; then
    if [[ -n "$PATTERN" ]]; then
      echo "$response" | jq --arg pattern "$PATTERN" 'map(select(.name | test($pattern; "i")))'
    else
      echo "$response" | jq .
    fi
  else
    if [[ -n "$PATTERN" ]]; then
      echo "$response" | jq --arg pattern "$PATTERN" 'map(select(.archived == false)) | map(select(.name | test($pattern; "i")))'
    else
      echo "$response" | jq 'map(select(.archived == false))'
    fi
  fi
else
  echo "$response"
fi
