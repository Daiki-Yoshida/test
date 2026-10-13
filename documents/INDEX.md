# Project Documentation — INDEX

Routing hub for canonical project knowledge. Start here; open only what the task needs.

## Project-owned documents

| Document | Owns |
|---|---|
| `project/OVERVIEW.md` | Purpose, repository roles, hard boundaries, current state |
| `project/REPOSITORIES.md` | Selector → repository/role/checkout/ref mapping |
| `project/WORK_AND_BRANCHES.md` | Work Identity, branch/worktree derivation, Work Documents, baseline protection |
| `project/EXECUTION.md` | Docker-first boundary, public commands, managed pack provenance, verification path |
| `project/COMPONENT_MODEL.md` | Independent component histories inside the single permitted remote |

## Managed pack

- `artifacts/` — managed derived snapshot of `Daiki-Yoshida/documents-artifacts`. Entry: `artifacts/INDEX.md`. Never edit the installed copy; source ref and sync mechanism are recorded in `project/EXECUTION.md`.

## Route by task

| Task | Read |
|---|---|
| Any work on this project | `project/OVERVIEW.md` first, then the leaf for the task |
| Create/select a checkout or worktree | `project/REPOSITORIES.md` + `project/WORK_AND_BRANCHES.md` + `artifacts/project/WORKTREES.md` |
| Add or verify a Component Repository | `project/COMPONENT_MODEL.md` + `project/REPOSITORIES.md` |
| Run/bootstrap/verify the project | `project/EXECUTION.md` |
| Branch/commit/PR/reporting rules | `project/WORK_AND_BRANCHES.md` + `artifacts/operation/VERSION_CONTROL_AND_REPORTING.md` |
| Documentation changes | this INDEX — add durable project docs under `documents/project/` and register them in the table above (`artifacts/documentation/` for reusable guidance) |
| Reusable engineering judgment | `artifacts/INDEX.md` |

## Boundaries (summary)

- GitHub writes: `Daiki-Yoshida/test` only; all other repositories read-only.
- Local reads/writes: Project Root only.
- Baseline `master` is never modified directly — integration via authorized PR merge only.
- `.serena/` and other uncommitted user data: protected.
