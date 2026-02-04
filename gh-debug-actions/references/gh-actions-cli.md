# GitHub Actions CLI Quick Reference

## Common Commands
- List runs (filter by workflow/branch/user):
  - `gh run list -R <owner/repo> -w "<workflow>" -b <branch> -u <user> -s failure -L 10`
- View a run summary:
  - `gh run view <run-id> -R <owner/repo>`
- View full logs for a run:
  - `gh run view <run-id> -R <owner/repo> --log`
- View only failed steps:
  - `gh run view <run-id> -R <owner/repo> --log-failed`

## Useful JSON Fields (gh run list --json)
`databaseId, displayTitle, createdAt, conclusion, status, headBranch, workflowName, event, url`

## Log Caveats
- `gh run view --log` may show `UNKNOWN STEP` for lines that cannot be matched to a step.
- Large runs can take time to stream logs. Prefer `--log-failed` for summaries.
- If runs are created by ruleset workflows, the workflow name may be missing in list output.
