# Diagnostics and Recovery

Read this when a development environment/operation fails.

## Prefer observation before mutation

Provide/seek operations equivalent to:

- help;
- diagnostics;
- non-mutating status;
- final validation.

Do not print secrets in diagnostics.

Show the selected repository/checkout and, when relevant, Work Identity, worktree, runtime namespace, ports, mounts, and ownership.

## Diagnose in order

```yaml
1_target: "workspace/component/branch/checkout/worktree"
2_host_boundary: "required control-plane tools and permissions"
3_versions: "container/runtime/tool/lock state"
4_runtime: "container/network/port/mount/ownership/volume"
5_command: "public command parameters and exit status"
6_git: "dirty state, branch ownership, worktree metadata, remote refs"
7_ci_difference: "provider setup or external repository ref mismatch"
```

## Recovery rules

- prefer repairing/recreating only the affected Work-scoped resource;
- preserve source changes before rebuild/delete;
- understand the failure before using force;
- do not begin with global Docker prune or broad file deletion;
- report the failing layer and evidence;
- do not call recovery complete until the failed operation is rerun and succeeds — if the rerun is blocked or not authorized, report recovery as unverified/incomplete instead of substituting an auxiliary check or repeating an unsafe effect.
