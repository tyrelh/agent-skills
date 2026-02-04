#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${SHORTCUT_API_TOKEN:-}" ]]; then
  echo "SHORTCUT_API_TOKEN is not set" >&2
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo "Usage: shortcut_get_member.sh <member_id>" >&2
  exit 1
fi

BASE_URL="${SHORTCUT_API_BASE_URL:-https://api.app.shortcut.com/api/v3}"
MEMBER_ID="$1"

response="$(curl -sS -X GET "$BASE_URL/members/$MEMBER_ID" \
  -H "Shortcut-Token: $SHORTCUT_API_TOKEN" \
  -H "Content-Type: application/json")"

if command -v jq >/dev/null 2>&1; then
  echo "$response" | jq .
else
  echo "$response"
fi
