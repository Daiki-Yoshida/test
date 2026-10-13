# Work Identity

Read this when a concrete implementation effort needs a stable identity across branches, worktrees, runtime state, logs, outputs, or work-specific documents.

## Meaning

A **Work Identity** represents *what the development work is trying to accomplish*.

It owns:

- work-level ownership;
- resource identity;
- lifecycle.

It is above tool-specific identifiers.

```text
User Goal
   ↓
Work Identity
   ├─ branch / optional worktree
   ├─ runtime/test state
   ├─ logs / outputs
   └─ Work Documents
```

Git represents Work Identity where useful; Git does not define it.

## When to establish it

Do not create Work Identity for every early idea or exploratory discussion.

Establish it when the implementation goal has become concrete and the project workflow is moving into implementation.

- AI may propose a Work Identity.
- **Before implementation begins, the user explicitly confirms the Work Identity.**
- Do not rush to create one during an exploratory discussion whose implementation goal is still unclear.

Materialize work-scoped state only after that identity is confirmed.

## Naming

Conceptual form:

```text
<work-type>/<work-name>
```

Examples:

```text
feat/pathfinding
fix/login-timeout
refactor/payment-boundary
```

Use a human-readable name that expresses the goal. Branch naming syntax may specialize this project-locally.

## Work Root

The standard Work Root shape is:

```text
<project-root>/.worktrees/<work-type>/<work-name>/
├─ documents/
└─ <repository-selector>/
```

Use the same conceptual shape for single- and multi-repository projects.

Do not introduce a parallel `.work/<identity>/` root merely to duplicate this Work Root. External systems may own state outside the filesystem when appropriate.

## Work Root is not the session root

The Work Root is the physical area that groups Work Documents and participating repository worktrees. It is **not** the Project-level AI development session root.

Keep this distinction:

```text
Agent Session Root = Project Root
Work Root          = .worktrees/<work-type>/<work-name>/
```

Start from Project Root, resolve the Work and participating repositories there, then operate on the selected repository worktree.

A repository-specific worktree may be the command target without becoming the Project context root. Generic command-target routing is covered by `../execution/COMMANDS_AND_CI.md`.

## Work Documents

```text
.worktrees/<work-type>/<work-name>/documents/
```

is formal work-specific knowledge for active design, investigation, decisions, migration plans, and verification—not a throwaway temp folder.

Project Documentation describes the current canonical project state; Work Documents describe the active change.

Work Documents are owned by the Management Root Repository and should become visible from the project's **baseline branch** while the Work is active. The baseline branch is the project-defined stable coordination/documentation branch; its literal name is not fixed to `main`.

This is a lifecycle/visibility goal, not implicit VCS authority. Use the project-authorized commit/merge workflow. If baseline publication is not yet authorized, preserve the Work context in an authorized Management Root Repository working state and report publication as pending rather than claiming it already happened.

Reconcile durable conclusions into Project Documentation when the Work completes.

## Repository participation

A base Work may span multiple repositories. Each repository maps deterministically from:

```text
Work Identity + repository selector
```

to its branch/worktree identity.

A repository selector is a stable project-local repository identity, **not a Git branch name**. A selector named `main` does not imply that the repository's baseline branch is also named `main`.

Do not make filesystem paths or random run IDs the primary work identity.
