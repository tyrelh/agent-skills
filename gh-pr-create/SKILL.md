---
name: "gh-pr"
description: "Use this skill when a user asks to create a GitHub PR (pull request). It contains conventions for creating PRs."
---

# GitHub PR Create

## Overview

Use this skill as a reference for creating PRs.
Use `references/teammates.md` for teammate names to GitHub handle lookups when adding reviewers.
Use `references/tags.md` for mapping generic tag requests to exact GitHub label names.

## Prerequisites

Use the `gh` CLI and `git` CLI whenever possible.

Ensure `gh` is authenticated (for example, run `gh auth login` once), then run `gh auth status` with escalated permissions (include workflow/repo scopes) so `gh` commands succeed. If sandboxing blocks `gh auth status`, rerun it with `sandbox_permissions=require_escalated`.

## Conventions

### Branch Naming

Format: `<type>[(<scope>)]-sc-<story or ticket number>-<short description>`
Example: `feat(billing)-sc-12345-add-new-feature`

Loosely follow conventional commits for naming branches.

The `type(scope)`, `sc-#`, and `descriptsion` should be separated by a dash `-`.

#### Types

- Use the prefix `build-` for changes to the build system.
- Use the prefix `chore-` for chore changes.
- Use the prefix `ci-` for changes to the testing and validation systems.
- Use the prefix `cd-` for changes to the deployment systems.
- Use the prefix `docs-` for documentation changes.
- Use the prefix `feat-` for new features, generally customer facing.
- Use the prefix `fix-` for bug fixes.
- Use the prefix `perf-` for performance improvements.
- Use the prefix `refactor-` for refactoring changes.
- Use the prefix `revert-` for reverting changes.
- Use the prefix `style-` for style changes.

#### Scope

You can include an optional scope after the type prefix. Try to avoid using scopes unless you feel it's necessary. Lean on using project domains as scopes.

Example: `fix(accounts)`

#### Story or Ticket Number

Always require a branch to have a story or ticket number. If the ticket number isn't known yet, ask the user if you can search for it or create it. We use Shortcut for stories. I use the terms story and ticket interchangeably.

Format: `sc-<story or ticket number>`
Example: `sc-12345`

#### Description

Keep the description concise and clear. Don't use too technical of language, branch and PR names make it into our public changelogs.

Avoid special characters, use only letters, numbers, and hyphens.

Example: `add-new-feature`
Example: `use-resolved-product-instead-of-variant-for-payout`

### Branch Creation

Ensure you branch off of the main branch unless otherwise specified.

Create the branch locally and push it to the remote repository.

### PR Creation

Create the PR using the `gh` CLI.
