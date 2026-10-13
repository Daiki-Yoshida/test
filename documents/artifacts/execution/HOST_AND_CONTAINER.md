# Host and Container Responsibilities

Read this for Docker-first boundaries, mounts, caches, networks, ports, secrets, or runtime resource reuse.

## Default responsibility split

Host normally owns:

- Docker/Compose;
- Git;
- command entry/routing;
- authentication/remote tooling.

Managed project/container environment normally owns:

- language runtime/package manager;
- compiler/build/test tools;
- DB/migration/project-specific CLI.

Do not install host runtimes merely because container commands feel inconvenient. Document any deliberate host exception and how version drift is controlled.

Routine development commands should not depend on privilege escalation such as `sudo` unless the project has an explicit, justified host-level operation.

## Docker-first execution

Run build/test/lint/format/migration/project CLI through repository-managed definitions where practical.

Avoid hidden dependence on:

- manually created global containers/networks;
- host-global packages;
- unpinned critical `latest` tooling.

Respect lock files inside containers too.

## Resource identity and reuse

Use deterministic, human-readable identity based on project/component/role and, only when isolation requires it, Work Identity.

Do not create separate images/networks/volumes simply because a branch/worktree exists.

Reuse safely shareable caches/images. Separate mutable state only when parallelism, isolation, configuration, or project rules require it.

When a Work-scoped runtime is materialized through env vars, config files, a Compose project name, or resource selectors, propagate the same resolved configuration to every counterpart lifecycle operation — status, verify, stop, cleanup. A create path that resolves `R(work)` paired with a teardown that falls back to `R(default)` is a lifecycle defect. Where practical, verify via rendered config/dry-run that start and stop paths resolve the same resource identities.

## Mounts and ownership

Files generated into host bind mounts should remain editable/removable by the host user.

Prefer UID/GID-aware solutions rather than running the entire container as root.

Keep caches/build outputs out of Git unless deliberately source-controlled.

## Ports and networks

Prefer internal container networking when host exposure is unnecessary.

When parallel isolated runtimes need host ports, allocate them explicitly by scope rather than letting Work instances collide.

## Secrets

- never bake secrets into images or commit them;
- separate samples from real values;
- avoid printing secrets in logs/diagnostics/CI;
- use appropriate build-time/runtime secret mechanisms;
- routine build/test should not require AI to read secret values.
