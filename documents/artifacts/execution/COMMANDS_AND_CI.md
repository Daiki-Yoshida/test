# Public Commands and CI

Read this when designing Make targets, wrappers/scripts, command semantics, or local/CI execution paths.

## Expose intent, not raw tool syntax

A public command should make its target and effects understandable before execution.

Use stable purpose-oriented operations rather than requiring humans/AI to reconstruct long provider-specific commands.

A common structure is:

- Makefile or similar router: public operation names/help/parameters;
- wrapper CLI: optional shared checkout/environment selection;
- scripts: complex branching, validation, orchestration, cleanup.

Keep complex shell logic out of a Makefile recipe when a script is clearer/testable.

Provide a discoverable help/status path that explains available operations, required parameters, and destructive effects. Prefer named/structured parameters over one ambiguous catch-all argument.

## Naming

Short names are fine when project scope is unambiguous.

Use `<scope>-<action>` when names such as `up`, `down`, `reset`, `clean`, `deploy`, or `logs` would otherwise hide target/effect.

Do not silently change a formerly non-destructive command into a destructive one.

Separate stop/container removal/volume deletion/full purge semantics.

A scoped command family (`<scope>-up`, `-status`, `-config`, `-verify`, `-down`, `-cleanup`) must share one consistent scope/identity resolution — the same scope name is not a sufficient contract if each command resolves the scope differently. For non-trivial identity derivation, prefer one project-owned resolver/script/config shared by all lifecycle commands over reimplementing the derivation separately per recipe or language; do not over-abstract trivial fixed values.

## Public commands are the execution interface

Project-owned Make targets, wrappers, and scripts are not merely command shortcuts. They are the stable execution interface through which humans, AI, and CI inherit project scope, environment selection, safety checks, and verification paths.

When a project-owned public operation already represents the requested routine operation, prefer that interface instead of reconstructing an underlying raw tool command.

Direct raw-tool execution is reasonable when:

- implementing or repairing the public interface itself;
- diagnosing/failure-isolating the underlying tool;
- no suitable public operation exists;
- project documentation explicitly makes the raw operation the supported path.

Do not bypass the public interface in a way that silently loses its scope, environment, safety, or verification semantics.

## Execution target directory

Keep the AI session rooted at Project Root while allowing a public operation to target another existing checkout/worktree.

For Make-based projects, `DIR` may be used as the named **execution target directory** parameter:

```bash
make DIR=.worktrees/feat/pathfinding/game dev-install
make DIR=.worktrees/feat/pathfinding/game test
make DIR=components/web lint
```

`DIR` is a path-valued execution selector only. It is **not**:

- Work Identity;
- Work Root;
- repository selector;
- branch/runtime identity;
- authorization.

Generic `DIR` semantics must not infer repository roles or silently append project-specific suffixes such as `/main` or `/android`. A project may provide a separate higher-level resolver that specializes its own topology, but the generic directory parameter means the supplied target path.

Recommended path contract:

- resolve relative `DIR` from Project Root;
- treat it as one quoted path value, not a shell-fragment argument;
- normalize harmless spelling differences such as a trailing slash;
- fail if an operation requires an existing target and it does not exist;
- validate canonical/symlink-resolved scope when it affects safety;
- allow absolute or Project-Root-external paths only when the project explicitly supports them;
- when `DIR` is omitted, use the command's documented default target, not accidental process CWD.

A directory selector does not grant destructive authority; see `../safety/DESTRUCTIVE_OPERATIONS.md`.

## Worktree lifecycle is a different API

Do not replace Worktree identity/materialization inputs with `DIR`.

Worktree create/status/remove resolves its path from Work Identity + repository selector as defined in `../project/WORKTREES.md`. `DIR` is for routing ordinary operations to an already resolved/materialized target.

```text
worktree lifecycle:
  WORK + REPO (+ BASE) -> branch/path/materialization

routine execution:
  DIR=<existing target> -> build/install/test/lint/run/verify
```

A project-specific interface may specialize this further, but it must not erase the identity boundary.

## Verification commands

Define a standard final verification path.

Partial checks are useful during development/diagnosis but do not automatically replace the final gate.

Commands should return non-zero on failure and leave diagnostic output.

## Local and CI

CI should call project-managed build/test/validation commands instead of reimplementing them in provider YAML.

Provider-specific provisioning may differ, but converge on the same repository-managed verification scripts/targets.

External repository/tool dependencies must use an explicit ref/policy rather than accidentally consuming whatever latest checkout happens to exist.

Work-specific worktree command semantics live in `../project/WORKTREES.md`.
