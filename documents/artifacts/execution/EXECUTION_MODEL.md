# Development Execution Model

Read this when deciding where project commands/runtime should execute and how the environment should remain reproducible.

## Environment is a contract

A development environment defines:

- where tools execute;
- which stable public commands humans/AI/CI use;
- how runtime state is materialized;
- how the same repository state can be reproduced and verified.

Internal Docker/script structure may change; public daily operations should remain understandable and stable.

## Control plane vs execution plane

**Host control plane**
- Git/source control;
- Docker/Compose;
- command routing;
- authentication/remote access;
- minimal orchestration tooling.

**Project execution plane**
- language runtime;
- package manager;
- compiler/build toolchain;
- test runtime;
- DB/migration CLI;
- project-specific cloud/deploy CLI.

Prefer repository-managed execution environments over undocumented host installations.

## Reproducibility

A repository state should contain enough information to reproduce its development behavior.

Prefer:

- managed tool/runtime versions or explicit supported ranges;
- lock files;
- repository-managed environment definitions;
- local and CI paths converging on the same project commands;
- explicit refs when depending on another Management Root Repository or project-level tool.

Reproducibility means changes are intentional and traceable, not frozen forever.
