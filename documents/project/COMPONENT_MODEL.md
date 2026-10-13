# Component Repository Model

## Goal

Each `tests/<selector>/` owns an independent Git history and responsibility, while the only permitted GitHub write target remains `Daiki-Yoshida/test`.

## Model: disjoint ref namespace inside the same remote

Component histories live as independent roots under a `component/<selector>/*` branch namespace of the same remote:

```text
Daiki-Yoshida/test
├─ master                              (Management Root baseline)
├─ work/<work>/main                    (Management Root Work branches)
├─ component/dotnet-test/main          (component baseline — planned)
├─ component/script-test/main          (planned)
├─ component/documents-test/main       (planned)
└─ work/<work>/<component-selector>    (component Work branches)
```

- **Primary checkout**: `tests/<selector>/` is a registered linked worktree bound to `component/<selector>/main` (`git worktree add`). Same object store, disjoint history. A dedicated `git clone` of the same URL is the alternative when stronger isolation is needed.
- **Review flow**: a component Work branch merges via PR onto `component/<selector>/main` — entirely inside the permitted remote. GitHub PRs operate between any two branches of one repository; slashes in names are normal.
- **Ownership boundary**: the Management Root never tracks component files (`tests/*/` ignore boundary; `git ls-files tests/` shows only the intentionally tracked `tests/README.md` — nothing from `tests/<selector>/` enters the Management Root index).
- **Fresh-clone reproduction**: clone `Daiki-Yoshida/test`, then `git worktree add tests/<selector> component/<selector>/main` recreates each primary checkout.

## Verified locally in R0001

In a project-contained scratch clone (no remote writes):

- an orphan `component/dotnet-test/main` has a disjoint root commit from `master` → independent history;
- `git worktree add tests/dotnet-test component/dotnet-test/main` registers a component checkout inside the Management Root working tree;
- the `tests/*/` boundary keeps `git status` clean, and `git ls-files tests/` lists only the intentionally tracked `tests/README.md` → component files under `tests/<selector>/` never enter the Management Root index;
- the component checkout works as a normal repository for its own Work branches.

Full evidence: `.worktrees/refactor/git-test-workspace/documents/component-model-verification.md`.

## Deferred / not done in R0001

- Creating remote `component/<selector>/main` baseline refs — the procedure above is ready; execution awaits the next Round / explicit approval.
- Component-specific runtime/CI definitions.
