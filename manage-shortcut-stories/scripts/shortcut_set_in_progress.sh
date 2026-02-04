#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${SHORTCUT_API_TOKEN:-}" ]]; then
  echo "SHORTCUT_API_TOKEN is not set" >&2
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo "Usage: shortcut_set_in_progress.sh <story_id>" >&2
  exit 1
fi

BASE_URL="${SHORTCUT_API_BASE_URL:-https://api.app.shortcut.com/api/v3}"
METHOD="${SHORTCUT_UPDATE_METHOD:-PUT}"
STATE_ID="${SHORTCUT_STARTED_STATE_ID:-500004425}"
STORY_ID="$1"

payload="{\"workflow_state_id\":${STATE_ID}}"

response="$(curl -sS -X "$METHOD" "$BASE_URL/stories/$STORY_ID" \
  -H "Shortcut-Token: $SHORTCUT_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$payload")"

if command -v jq >/dev/null 2>&1; then
  echo "$response" | jq .
else
  echo "$response"
fi
