# Execution Environment

## Dependency boundary (Docker-first)

Host control plane: Git, Docker/Compose, POSIX shell. Everything else — language runtimes, package managers, test toolchains — runs in managed containers defined under `docker/`. Do not install Python/Node/npm/dotnet/make or other host runtimes for project operations.

## Public commands

`scripts/project.sh` is the stable purpose-based interface. Run it from the Project Root; worktree commands require the Management Root primary checkout.

| Command | Effect |
|---|---|
| `help` | List operations and parameters |
| `status` | Non-mutating diagnosis: branch/HEAD, worktrees, dirty state, tool availability |
| `bootstrap` | Check host deps, build the managed `tools` runtime, print artifacts-sync guidance |
| `verify [DIR=<checkout>]` | Standard final verification (see below) |
| `worktree-create WORK=<w> REPO=<sel> [BASE=<ref>]` | Resolve and materialize a Work checkout, idempotent |
| `worktree-status WORK=<w> REPO=<sel>` | Resolved identity/path/branch/materialization state |
| `worktree-remove WORK=<w> REPO=<sel>` | Remove only the selected clean worktree (branch preserved) |
| `work-docs-commit WORK=<w>` | Record `.worktrees/<w>/documents/` onto `work/<w>/main` |
| `artifacts-sync DIR=<checkout>` | Sync the managed artifacts pack into a checkout's `documents/artifacts/` |
| `cleanup` | Remove project-owned scratch (`.scratch/`, `.worktrees/*/*/.scratch/`, stale `documents/.artifacts.*`) with a target report |

Commands are non-destructive by default, return non-zero on failure, and print resolved targets before acting. `DIR=` is an execution-target selector resolved from the Project Root — it selects where an operation runs, nothing more (see `artifacts/execution/COMMANDS_AND_CI.md`).

## Managed runtime

`docker/compose.yaml` defines the `tools` service (image `test-mgmt-tools:local`: alpine + bash + git). `bootstrap` builds it; `verify` runs in-container checks when the image and daemon are available. All Docker operations stay scoped to these named project resources — no host-wide enumeration or prune.

## Managed artifacts pack

`documents/artifacts/` is a whole-pack managed snapshot of `Daiki-Yoshida/documents-artifacts` at commit `e38e79843388f4a8f8dabde03d6988be4acaf08e` (upstream `main` HEAD at install time). Sync only through the canonical `artifacts.sh` mechanism (`artifacts-sync`); never patch the installed copy — project rules belong in `documents/project/`.

## Final verification path

`./scripts/project.sh verify` before reporting a change done. It checks: shell syntax of public scripts, required documentation and managed-pack presence, ignore boundaries, worktree registration/branch/materialization invariants, and Docker-scoped smoke when available.
