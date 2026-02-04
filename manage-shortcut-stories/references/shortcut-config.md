# Shortcut Config

## Authentication
- Environment variable: `SHORTCUT_API_TOKEN`
- Base URL: `https://api.app.shortcut.com/api/v3`
  - Override via `SHORTCUT_API_BASE_URL` if needed.
  - Update method override: `SHORTCUT_UPDATE_METHOD` (default `PUT`)

## Workflow
- Workflow ID: `500004423`
- Started (in-progress) state ID: `500004425`
- Ready for review state ID: `500005151`

## Search
- Search Stories endpoint: `GET /api/v3/search/stories`
- Query params: `query`, `page_size`, optional `detail`, `next`, `entity_types`
- Default workflow filter: `SHORTCUT_WORKFLOW_ID=500004423`
- Default detail mode: `SHORTCUT_SEARCH_DETAIL=full` (ensures `workflow_id` is present)

## Members
- Member lookup endpoint: `GET /api/v3/members/<member_id>`

## Story Details
- Story lookup endpoint: `GET /api/v3/stories/<story_id>`