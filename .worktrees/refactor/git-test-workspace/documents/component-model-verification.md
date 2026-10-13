# Component Repository Model — Local Verification (R0001)

Goal: prove that `tests/<selector>/` can be an independent Git repository (own history) while the only writable GitHub remote stays `Daiki-Yoshida/test`. All checks ran in a project-contained scratch clone `.worktrees/refactor/git-test-workspace/.scratch/component-sim` — no remote writes.

## Setup

```bash
git clone <project-root> .worktrees/refactor/git-test-workspace/.scratch/component-sim
git -C component-sim checkout -b mgmt-work origin/work/refactor/git-test-workspace/main
git -C component-sim checkout --orphan component/dotnet-test/main
git -C component-sim rm -rf .
# write component README.md; commit "chore: dotnet-test component baseline"
git -C component-sim checkout mgmt-work
git -C component-sim worktree add tests/dotnet-test component/dotnet-test/main
```

## Evidence

| Check | Result |
|---|---|
| Independent history | `rev-list --max-parents=0 component/dotnet-test/main` → `f07a215…` (own root); `mgmt-work` → `5340302…` (project initial commit); `merge-base` → none. Disjoint roots confirmed. |
| Component checkout placement | `git worktree add tests/dotnet-test component/dotnet-test/main` registers a linked worktree inside the Management Root working tree; `git worktree list` shows it. |
| Management index isolation | `git status --porcelain` in the management checkout: clean (`tests/*/` ignore boundary). `git ls-files tests/` → `tests/README.md` only — the intentionally tracked file; nothing from `tests/dotnet-test/` enters the index. |
| Component checkout behaves as own repo | inside `tests/dotnet-test`: branch `component/dotnet-test/main`, log shows only its own root commit. |
| Component Work branch mapping | `git -C tests/dotnet-test checkout -b work/refactor/git-test-workspace/dotnet-test` + commit → history `2438bec → f07a215`, disjoint from management. Management status stays clean; management HEAD unchanged (`9fc3675`). |

## GitHub semantics (design-level, not yet exercised on remote)

- `component/<selector>/main` and `work/<work>/<selector>` are ordinary branch names with slashes — PRs work between any two branches in `Daiki-Yoshida/test`, so component review = PR `work/…/<selector>` → `component/<selector>/main`, inside the single permitted remote.
- Disjoint histories never merge into each other by accident; component baseline↔management baseline integration is not meaningful and is not attempted.
- Fresh-clone reproduction: clone the repo, `git worktree add tests/<selector> component/<selector>/main` → primary checkout restored.

## Conclusion

The disjoint-refs-in-one-remote model is viable: true independent history + one permitted remote + clean ownership boundary, verified locally. Alternative if stronger isolation is later needed: a dedicated `git clone` of the same URL at `tests/<selector>/` (same ref namespace; separate object store).

## Deferred

- Remote creation of `component/<selector>/main` baseline refs (push outside `work/*`) — procedure ready; execution deferred to a later Round / explicit approval.
- Per-component runtime definitions (`docker/` extensions per component).
