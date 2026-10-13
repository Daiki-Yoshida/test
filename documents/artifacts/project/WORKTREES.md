# Worktree Contract

Read this only when a project has adopted Work-specific Git worktrees and you are creating, diagnosing, or removing them. Work Identity itself does not require every project or every Work to use a worktree.

## Identity inputs

Routine operations use:

```yaml
WORK: "<work-type>/<work-name>"
REPO: "<stable project repository selector>"
BASE: "required only when a missing Work branch needs a start ref and no documented default exists"
```

Keep `REPO` explicit when this capability is adopted, even for a single-repository project, so the public contract does not change if the project later grows. `REPO` is a stable repository selector, not a Git branch name.

Callers should not manually supply:

- arbitrary worktree path;
- sparse-checkout decision;
- branch name by default.

Resolve them deterministically from Work + repository identity.

## Path

```text
<project-root>/.worktrees/<work-type>/<work-name>/<repo-selector>/
```

Fail closed if unrelated filesystem content occupies the target.

## Branch semantics

A branch start ref and an upstream are different decisions.

For a missing Work branch:

- use explicit `BASE` or documented project default;
- never use accidental current HEAD as the base;
- creating from a base must not automatically imply tracking that base branch.

A same-name remote Work branch may track its corresponding remote branch according to project policy.

## Management Root Repository materialization invariant

When the selected repository's stable role owns (or can later receive) tracked project-level `.worktrees/**` coordination state, a nested linked worktree must **not recursively materialize the project-level `.worktrees/` tree**.

Do not decide applicability only from whether the currently selected branch already contains `.worktrees/**`; a first Work or an older base branch can receive that coordination state later.

Validated creation sequence:

```bash
git worktree add --no-checkout <path> <branch>

git -C <path>   sparse-checkout set --no-cone '/*' '!/.worktrees/'

git -C <path>   reset --hard HEAD
```

This low-level sequence should be wrapped in a project-owned create operation. Reapply the policy on recreation because worktree-local sparse state is removed with the worktree.

Do not blindly apply this sparse policy to independent Component Repositories whose role does not own the project-level coordination namespace. Current branch-tree inspection can be diagnostic, but stable repository role is the primary applicability signal.

## Create contract

Preflight at least:

- Project Root/repository resolves;
- Work syntax is valid;
- branch resolves deterministically;
- missing branch has explicit/documented base;
- target path is absent or the exact requested registered worktree;
- no unrelated content occupies the path;
- branch is not owned by another incompatible writable worktree;
- Management Root Repository ignore boundary covers the sibling worktree path where required;
- required materialization capability is supported.

Create should be idempotent:

- exact existing valid worktree → no-op success;
- conflicting/invalid existing state → diagnose and fail;
- do not steal a branch or destructively repair by default.

Verify before returning success:

- the registered Git worktree path equals the resolved path;
- the checked-out branch equals the resolved Work branch;
- the single-writable-checkout ownership invariant holds;
- for a Management Root Repository checkout, Work Documents remain materialized/tracked and the sibling worktree path does not appear as ordinary untracked project content — never blanket-ignore Work Documents;
- where the materialization contract applies, ordinary repository content is materialized, nested `.worktrees/` is absent, and worktree-local sparse state is active.

Creation that fails these checks is not successful even if its commands exited 0.

If creation partially fails, roll back only state created by that invocation when safe. Do not delete pre-existing worktrees or branches.

## Status contract

Status is non-mutating and should expose enough to diagnose identity and materialization:

- Work Identity;
- repository selector/root;
- resolved branch/path;
- registered state;
- current HEAD/branch;
- clean/dirty state;
- materialization/sparse state when applicable;
- whether nested project-level `.worktrees/` is absent;
- Work Documents visibility where relevant.

Use Git/filesystem as source of truth; do not create a duplicate registry.

## Remove contract

Preflight at least:

- the resolved path is a registered worktree of the expected repository;
- resolved identity/branch matches the requested WORK/REPO expectation;
- the worktree has no uncommitted changes;
- commits are preserved according to project policy.

Normal remove:

- targets only the selected registered worktree;
- refuses dirty state;
- uses normal `git worktree remove`, not force;
- does not delete the branch;
- does not delete Work Documents;
- does not delete the Work Root;
- does not delete sibling repositories.

Force removal, branch deletion, Work Root purge, unpreserved commit loss, or shared-resource deletion are destructive operations and require safety guidance.

## Validation boundary

Reference validation demonstrated the contract for the test repository below. Here, `REPO: main` is that repository's selector and must not be read as a universal selector or branch-name requirement:

```yaml
topology: "single repository"
REPO: "main"
case: "Management Root Repository itself as linked worktree"
Git: "2.43.0"
OS: "WSL2/Linux"
```

Validated: materialization, create/status/remove, idempotent create, conflict guards, dirty-remove refusal, remove/recreate, base-ref/upstream separation.

Not fully validated by that reference implementation:

- real multi-repository mapping;
- independent Component Repository normal materialization path;
- macOS / native Windows Git;
- all older/newer Git versions.

Do not present those unvalidated areas as experimentally proven.
