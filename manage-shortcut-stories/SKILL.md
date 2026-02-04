---
name: manage-shortcut-stories
description: Manage Shortcut stories via API. Use when you need to find the most relevant Shortcut ticket for a Codex thread, or update a story's workflow state to in-progress (started) or ready-for-review. Includes keyword-based search with user prompts and workflow state updates. Can also fetch story details by ID.
---

# Manage Shortcut Stories

## Overview
Find the best-matching Shortcut story for the current thread and update its workflow state (started/in-progress or ready for review) using the Shortcut API.

## Quick Start
1. Read `references/shortcut-config.md` for workflow IDs and configuration.
2. Ensure `SHORTCUT_API_TOKEN` is set; fail fast with a clear message if missing.
3. Use the bash scripts in `scripts/` for search and state updates to simplify debugging.
4. Before keyword search, check the current branch for `sc-<id>-` and fetch that story.
5. If a branch story is found, ask the user to confirm it is the correct ticket.
6. For search, collect keywords from the thread and prompt for more if ambiguous.
7. For state updates, update the story with the target `workflow_state_id`.

## Scripts
- `scripts/shortcut_search.sh "<keywords>" [page_size]`
- `scripts/shortcut_set_in_progress.sh <story_id>`
- `scripts/shortcut_set_ready_for_review.sh <story_id>`
- `scripts/shortcut_get_member.sh <member_id>`

All scripts respect:
- `SHORTCUT_API_TOKEN` (required)
- `SHORTCUT_API_BASE_URL` (optional override)
- `SHORTCUT_UPDATE_METHOD` (optional, default `PUT`)
- `SHORTCUT_STARTED_STATE_ID` and `SHORTCUT_READY_FOR_REVIEW_STATE_ID` (optional overrides)
- `SHORTCUT_WORKFLOW_ID` (optional, default from `references/shortcut-config.md` for search filtering)
- `SHORTCUT_SEARCH_DETAIL` (optional, default `full`)

## Task: Find Matching Story
- First check the current branch for a Shortcut ID pattern `sc-<id>-`.
- If found, fetch the story details and prompt the user to confirm it matches this thread.
- Only fall back to keyword search if the branch check is missing or rejected.
- Extract candidate keywords from the thread (feature name, repo/module, error strings, component names, service names).
- If results are ambiguous or too broad, prompt the user for 2-5 more keywords.
- Build a query string by joining keywords with spaces. Avoid stop words.
- Call the Shortcut search endpoint and request a short page size (10-20).
- Filter results by `workflow_id` client-side when `SHORTCUT_WORKFLOW_ID` is set.
- Present the top 3-5 results with `id`, `name`, `workflow_state_id`, `owner_ids`, and `updated_at`.
- If multiple candidates remain, ask the user to pick the correct story.
- Always return at least the story `id` once selected.

### Branch Extraction Example
```bash
branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$branch" =~ sc-([0-9]+)- ]]; then
  story_id="${BASH_REMATCH[1]}"
  echo "Found story ID: $story_id"
fi
```
If `story_id` is found, use the `shortcut-story-details` skill to fetch and show the title and owners, then ask the user to confirm.

### API Example (search)
```bash
curl -sS -G "$SHORTCUT_API_BASE_URL/search/stories" \
  -H "Shortcut-Token: $SHORTCUT_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data-urlencode "query=<keywords>" \
  --data-urlencode "page_size=10" \
  --data-urlencode "detail=full"
```
Use `scripts/shortcut_search.sh` for a debuggable version of this call.

If the endpoint, HTTP method, or response fields differ, ask the user for their Shortcut API details or docs and adjust.

## Task: Move Story to In-Progress
- Use the started state ID from `references/shortcut-config.md`.
- Update the story with `workflow_state_id`.

### API Example (update)
```bash
curl -sS -X PUT "$SHORTCUT_API_BASE_URL/stories/<story_id>" \
  -H "Shortcut-Token: $SHORTCUT_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"workflow_state_id":500004425}'
```
If your API requires `PATCH` instead of `PUT`, swap the method.
Use `scripts/shortcut_set_in_progress.sh` for a debuggable version of this call.

## Task: Move Story to Ready for Review
- Use the ready-for-review state ID from `references/shortcut-config.md`.

### API Example (update)
```bash
curl -sS -X PUT "$SHORTCUT_API_BASE_URL/stories/<story_id>" \
  -H "Shortcut-Token: $SHORTCUT_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"workflow_state_id":500005151}'
```
If your API requires `PATCH` instead of `PUT`, swap the method.
Use `scripts/shortcut_set_ready_for_review.sh` for a debuggable version of this call.

## Task: Resolve Owner Details
- Given a story `owner_ids` entry, fetch the member details from the Shortcut API.
- Present the member `id`, `name`, `profile` (if present), and `email` (if present).

### API Example (member lookup)
```bash
curl -sS -X GET "$SHORTCUT_API_BASE_URL/members/<member_id>" \
  -H "Shortcut-Token: $SHORTCUT_API_TOKEN" \
  -H "Content-Type: application/json"
```
Use `scripts/shortcut_get_member.sh` for a debuggable version of this call.

## Task: Fetch Story by ID
- Accept a numeric story ID.
- Call `GET /api/v3/stories/<story_id>`.
- Present at least `id`, `name`, `workflow_state_id`, `workflow_id`, `owner_ids`, and `updated_at`.

### API Example (story lookup)
```bash
curl -sS -X GET "$SHORTCUT_API_BASE_URL/stories/<story_id>" \
  -H "Shortcut-Token: $SHORTCUT_API_TOKEN" \
  -H "Content-Type: application/json"
```
Use `scripts/shortcut_get_story.sh` for a debuggable version of this call.

## Error Handling
- 401/403: token missing or invalid. Ask the user to confirm `SHORTCUT_API_TOKEN`.
- 404: story not found. Confirm the story ID.
- Other non-2xx: ask the user to confirm the API base URL or provide docs.

## References
- `references/shortcut-config.md`
