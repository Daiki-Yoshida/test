# Project and Repository Workspace

Read this when resolving Project Root, repository ownership, multi-repository structure, or stable repository identity.

## Static model

**Management Root Repository** owns project-level coordination state.

**Project Root** is the baseline working-tree root of the Management Root Repository and the reference point for project-level paths such as `documents/` and `.worktrees/`.

In a multi-repository Project, the **Management Root Repository** owns Project-level coordination while independent **Component Repositories** own product/component source and Git history. The reusable role model is exactly these two roles.

Do not create a Management Root Repository merely because unrelated repositories share a folder; it must have real Project-level coordination responsibility.

## Physical layout

Component Repository primary checkouts live **under the Project Root by default**:

```text
<project-root>/
├─ documents/
├─ <component-a>/    # independent Component Repository primary checkout
├─ <component-b>/    # independent Component Repository primary checkout
└─ .worktrees/       # Work-specific checkouts — see WORKTREES.md
```

The exact relative path of each component checkout is project-local — resolve it through the project's stable repository mapping; a project may specialize it explicitly. Absent explicit project-local specialization, place component checkouts under the Project Root rather than as sibling directories next to it.

Filesystem containment is placement only: it does not define Git ownership, dependency direction, or Project context. Each Component Repository keeps its own independent Git repository and history.

Static primary checkouts and Work-specific checkouts are different layers. Work-specific repository checkouts resolve only through the Work Root contract — read `WORKTREES.md` when creating them, and do not place ad-hoc checkouts beside the Project Root. A task that sets up repository placement and materializes Work checkouts needs both this file and `WORKTREES.md`.

## Project-owned local work areas

Use the Project Root as the default physical home for project-owned checkouts, isolated legacy state, and temporary validation/scratch outputs. Resolve a suitable project-local location and its Git ignore/tracking and cleanup policy; a test-output directory such as `tests/tmp/` is one possible project-local choice, not a universal path.

When a primary checkout cannot serve a new task safely, evaluate protected state and a contained alternative before creating a separate Project checkout elsewhere. A legacy checkout may be retained in a project-owned isolated area, while new work uses the appropriate primary/Work checkout contract. Relocating an existing Project Root is a structural migration: preserve dirty/index state, Git metadata/worktree registrations, path dependencies, and the identity of the resulting Project Root. Do not treat moving a checkout into its own descendant as a routine move.

Filesystem containment does not grant Git ownership or write permission over every contained resource. For external read access or a justified external write target, apply `../operation/SCOPE_AND_AUTHORITY.md`; use `../safety/INDEX.md` for structural, destructive, or host-level risk. An intentionally isolated harness may use a managed external temporary root when its isolation and cleanup contract requires that.

## Ownership

Management Root Repository may statically own/project:

- Project Documentation;
- project-level Docker/Compose definitions;
- public command wrappers/scripts;
- cross-component coordination;
- the project-level `.worktrees/` coordination namespace.

Component Repository owns its own:

- source/test;
- component-specific CI/release files;
- Git history.

Do not accidentally commit Component Repository source/history as ordinary Management Root Repository files.

## `.worktrees/` ownership boundary

Do not ignore the whole `.worktrees/` tree blindly.

Current model distinguishes:

```text
.worktrees/<work-type>/<work-name>/documents/
  → tracked by the Management Root Repository

.worktrees/<work-type>/<work-name>/<repository>/
  → Git worktree of the participating repository
  → not an ordinary Management Root Repository file
```

Detailed materialization belongs to `WORKTREES.md`.

## Stable repository identity

Each participating repository should be deterministically resolvable by a stable project-local selector/role. That mapping also resolves each Component Repository's default checkout location (see Physical layout).

The live Git/filesystem state remains source of truth; do not create a duplicate registry merely to mirror worktree state.

Work-level branch/path mapping uses that stable repository identity and is covered by Work guidance.

## Development entry root

For development work that belongs to a Project, initialize the AI development session from the **Project Root**.

The Project Root is not only a path-resolution anchor. It is the entry surface for project-owned documentation, agent instructions, routing, policy, public commands, repository ownership, and Work guidance.

Do not treat these as the Project-level AI session root merely because implementation happens there:

- a Work Root;
- a Component Repository checkout;
- a repository-specific Work worktree;
- a linked worktree of the Management Root Repository itself.

Resolve project context first, then route operations to the selected repository/worktree.

```text
Project Root
  -> project context / policy / routing
  -> Work / repository selection
  -> implementation target
```

This does not require every subprocess to run with Project Root as its working directory. Execution-target routing belongs to `../execution/COMMANDS_AND_CI.md`.

A repository that normally acts as a Component Repository may itself be the Management Root Repository when it is intentionally developed as a standalone Project. Repository role is therefore contextual: use the Project context that owns the Work, not a fixed role label or filesystem position.

## Documentation ownership in multi-repository Projects

Management Root Repository owns Project-level documentation/routing. Component Repository may own component-specific documentation where that ownership is appropriate, but Component Repository status alone does not imply a separate Project Documentation tree or a separate Project context.

Project Documentation should route to component-specific knowledge when Project work needs it; do not duplicate component authority into Management Root Repository merely for convenience.

## Primary checkout

A Primary Checkout is a stable reference checkout for repository/root resolution and project-level helper operations. A Component Repository's Primary Checkout lives under the Project Root by default (see Physical layout).

It does not decide which branch/worktree a Work must use.
