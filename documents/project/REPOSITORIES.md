# Repository Map

Stable selectors resolve each participating repository, its role, and its checkout location. Live Git/filesystem state remains the source of truth; this table is the routing contract, not a state registry.

| Selector | Role | Git repository / history | Primary checkout | Refs in `Daiki-Yoshida/test` |
|---|---|---|---|---|
| `main` | Management Root | this repository | Project Root | `master` (baseline), `work/<work>/main` |
| `dotnet-test` | Component (.NET experiments) | independent history, same remote | `tests/dotnet-test/` | `component/dotnet-test/*` (planned) |
| `script-test` | Component (script/shell experiments) | independent history, same remote | `tests/script-test/` | `component/script-test/*` (planned) |
| `documents-test` | Component (documentation experiments) | independent history, same remote | `tests/documents-test/` | `component/documents-test/*` (planned) |

Notes:

- `main` is a repository selector, not a Git branch name.
- `tests/<selector>/` checkouts are independent Git repositories; the Management Root never tracks component files (`tests/*/` ignore boundary).
- Selector `documents-test` normalizes the earlier `documetns-test` spelling.
- Component checkouts are planned as registered linked worktrees of this repository's object store; see `COMPONENT_MODEL.md` for mechanics, verification, and alternatives.
- Work-scoped checkouts never go under `tests/`; they resolve under `.worktrees/<work>/<selector>/` per `WORK_AND_BRANCHES.md`.
