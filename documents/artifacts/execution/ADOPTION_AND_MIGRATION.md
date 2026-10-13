# Execution Environment Adoption and Migration

Read this when introducing the execution model to a new or existing project.

## New project

1. Resolve existing Project Root/repository identities; do not redesign repository topology just for execution tooling.
2. Decide host-control vs managed-runtime boundaries.
3. Create stable public commands for normal work, diagnostics, partial checks, final verification, and scoped cleanup.
4. Map runtime resources from Project/Work/Run ownership; isolate only what actually requires isolation.
5. Expose Work-specific operations through the public command surface without redefining their semantic contract.
6. Validate from a clean-clone-equivalent state.

Check that the environment can:

- bootstrap;
- show selected versions/paths;
- run a minimal check;
- run final verification;
- remove only resources created for the validation scope.

Report undocumented host assumptions.

## Brownfield migration

Inventory:

- current host/runtime dependencies;
- actual build/test/deploy entry points;
- container/image/port/volume/permission state;
- repository/worktree topology;
- CI duplication/differences;
- destructive/reset paths.

Then migrate incrementally:

1. put a stable public command over existing behavior;
2. move project-specific execution into managed runtime/container where appropriate;
3. connect runtime resources to Project/Work/Run scope;
4. add diagnostics and final verification;
5. add Work/worktree operations only when parallelism/isolation actually needs them;
6. align CI to project-managed commands.

Change one execution boundary at a time and keep behavior verifiable.

Keep project-owned temporary and alternate work areas under the resolved Project Root by default, using project-local locations and ignore/cleanup policies. Before an environment migration relocates a repository checkout or materializes an external test/runtime target, apply `../project/WORKSPACE.md` and `../operation/SCOPE_AND_AUTHORITY.md`.

Do not silently move repositories, delete environment state, or create unnecessary worktrees as a side effect of "environment improvement."
