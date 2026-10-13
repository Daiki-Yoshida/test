# Work Identity, Branches, and Worktrees

## Work Identity

`<work-type>/<work-name>` (current: `refactor/git-test-workspace`). A Work Identity is confirmed before implementation begins, per `artifacts/project/WORK_IDENTITY.md`.

## Deterministic mapping

```text
WORK + REPO
  → branch:  work/<work-type>/<work-name>/<repo-selector>
  → worktree: <project-root>/.worktrees/<work-type>/<work-name>/<repo-selector>/
  → Work Documents: <project-root>/.worktrees/<work-type>/<work-name>/documents/
```

- Missing Work branches are created with an explicit or documented base (default `master` for selector `main`) via `git branch --no-track` — never from accidental HEAD, never auto-tracking the base.
- A same-name remote Work branch may become the upstream after the first push.

## Worktrees

Create/status/remove only through `scripts/project.sh worktree-*`, run from the Management Root primary checkout. The commands enforce the validated materialization contract (`--no-checkout` → worktree-local non-cone sparse `'/*' '!/.worktrees/'` → `reset --hard HEAD`) so a Management Root worktree never recursively materializes `.worktrees/`. See `artifacts/project/WORKTREES.md`.

## Work Documents

`.worktrees/<work>/documents/` holds work-scoped knowledge tracked by the Management Root; sibling repository checkouts under the same Work Root stay untracked (`.gitignore` boundary). Baseline publication is a lifecycle goal that requires authorized integration; until then `./scripts/project.sh work-docs-commit WORK=<w>` records the documents onto `work/<w>/main` without touching `master`.

## Baseline protection

- No direct commits/pushes/merges/rebases on `master`; no force-push or history rewrite.
- Integration happens only through authorized PR merge.
- Existing branches, Issues, PRs, records, and uncommitted user state are preserved.
