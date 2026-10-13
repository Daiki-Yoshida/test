# Project Overview

## Purpose

`Daiki-Yoshida/test` is reorganized as a durable test project for Git/GitHub and development-routine experimentation, following the documents-artifacts model and a Docker-first environment contract. The previous `tiny-text-inspector` TypeScript content was removed as a normal Git change; its history remains in `master` ancestry.

## Repository roles

- **Management Root Repository** — this repository (baseline `master`, selector `main`). Owns project coordination: `documents/`, repository mapping, Docker/command definitions, and the `.worktrees/` namespace.
- **Component Repositories** — independent Git histories checked out at `tests/<selector>/`. See `REPOSITORIES.md` and `COMPONENT_MODEL.md`.

## Hard boundaries

- GitHub writes: `Daiki-Yoshida/test` only. `Daiki-Yoshida/documents-artifacts` and `Daiki-Yoshida/ai-development-orchestration` are read-only references. No new repositories or accounts; no pushes elsewhere.
- Local reads/writes stay inside the Project Root. No host configuration or dependency changes.
- Baseline `master` is never modified directly. Work happens on `work/<work>/<selector>` branches; baseline integration requires explicit authorization (PR merge).
- Existing history, branches, Issues, PRs, and uncommitted user state (e.g. `.serena/`) are protected. GitHub records are append-only.
- Coordination Issue for the current Work: <https://github.com/Daiki-Yoshida/test/issues/7>.

## Current state (R0001)

Foundation on `work/refactor/git-test-workspace/main`: documentation routing, managed artifacts pack, public commands, and the Work's management worktree. Component baselines and remote `component/*` refs are not yet created — see `COMPONENT_MODEL.md`.
