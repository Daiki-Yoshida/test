# R0001 Work Notes — refactor/git-test-workspace

Round scope: preflight + Management Root minimal foundation on `work/refactor/git-test-workspace/main` + local verification of the component model. Coordination: Issue #7, instruction comment 6145618905, corrections/HOLDs 6145653627 → 6146041554 (+6146128339 fact fix).

## Preflight facts

- Project Root `/home/fuyur/projects/personal/sandbox/test` = repo top-level = `pwd -P`; `.git` is a real dir inside the root; no symlinks, no nested `.git`, no alternates, no prior worktrees, no `.worktrees/` dir.
- `master` HEAD `8acf440` = `origin/master` = GitHub observation. Repo-local `.git/config` only (no user/credential/includes). Untracked: `.serena/` only (protected).
- Remote branches: `add-new-file`, `agent/typescript-text-inspector`, `chatgpt-*`, `master` — no `work/*`/`component/*` collisions.
- Host: git 2.43.0, Docker server 29.6.2, Compose v5.3.1, bash — control plane only.
- Upstream `documents-artifacts` main HEAD = `e38e79843388f4a8f8dabde03d6988be4acaf08e` = Supervisor snapshot; no drift. `EXECUTOR.md` at pinned `c0b9ef3…`.

## Safety application

- Git commands executed under `GIT_CONFIG_NOSYSTEM=1` + `GIT_CONFIG_GLOBAL`/`XDG_CONFIG_HOME` pointing at nonexistent paths inside Project Root (no file creation — per correction 6146041554). Commit identity via `GIT_AUTHOR/COMMITTER_*` env.
- `.git/executor-env` creation attempt: denied by tool permissions → NOT_RUN, not retried. `.git/info/exclude` parity edit: denied → not retried; primary status shows `?? .worktrees/` (accepted).
- `docker images` (host-wide enumeration): never executed — NOT_RUN (corrected per comment 6146128339). `docker version`/`compose version`: completed reads.

## Work branch commits (on work/refactor/git-test-workspace/main)

- `40d8a12` refactor: foundation — documents routing, AGENTS/README, `.gitignore` boundaries, `scripts/project.sh`, `docker/`, `tests/README.md`; removed legacy `src/`, `test/`, `package*.json`, `tsconfig.json` as normal deletes.
- `9fc3675` chore: managed artifacts pack (`documents-artifacts@e38e798`, 42 files, via canonical `artifacts.sh --non-interactive`).
- `ea01c3c` docs: corrected component ownership wording to measured facts.

## Materialization verification (management worktree)

`worktree add --no-checkout` → `sparse-checkout set --no-cone '/*' '!/.worktrees/'` → `reset --hard HEAD`. Verified: registered path/branch, `config.worktree` sparse on (non-cone), nested `.worktrees/` absent, clean status, ignore boundary (sibling repos ignored, `documents/` trackable).

## Pending / next round

- Remote `component/<selector>/main` refs and real component checkouts (local model verified; remote creation deferred).
- Baseline publication of Work Documents + foundation merge — requires authorized PR merge approval.
- `.serena/` remains untracked and untouched.
