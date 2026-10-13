# Agent Entry — test

Canonical project knowledge starts at `documents/INDEX.md` (routing hub). Reusable engineering guidance lives in `documents/artifacts/` — a managed pack; never edit the installed copy.

## Hard boundaries

- GitHub write target: `Daiki-Yoshida/test` only. All other repositories are read-only references.
- Never commit/push/merge/rebase directly on baseline `master`. Work on `work/<work-type>/<work-name>/<repo-selector>` branches; integrate only via authorized PR merge.
- Local reads/writes stay under the Project Root. Do not touch host config, external paths, `.serena/`, or other uncommitted user data.
- Docker-first: host dependencies are Git, Docker/Compose, and shell only. No host Python/Node/npm/dotnet/make installs.
- GitHub Issues/comments are append-only records — never edit or delete.

## Session root

Start at the Project Root (this repository's primary checkout), then route to the selected repository/worktree. Repository selectors and checkout mapping: `documents/project/REPOSITORIES.md`. Work rules: `documents/project/WORK_AND_BRANCHES.md`.
