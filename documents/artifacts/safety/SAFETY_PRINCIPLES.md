# Development Safety Principles

Read this for the default safety posture of development operations.

## Priority

Prefer, in order:

1. host and data safety;
2. reproducibility;
3. repository/resource isolation;
4. safe parallel AI/developer operation;
5. explicit targets and side effects;
6. diagnosability/recovery;
7. local/CI path consistency;
8. convenience.

Safety should not make routine work unnecessarily cumbersome.

> Make the safe operation the easiest/default operation.

## Effective targets

Check where an operation actually writes, including targets reached through symlinks, mounts, nested repositories, and host/container APIs, when those boundaries affect ownership or safety. A contained legacy checkout or temporary workspace needs a defined owner, Git ignore/tracking boundary, and cleanup scope. Repository-root relocation additionally needs a state-preservation and registration plan.

General external-write authorization belongs to `../operation/SCOPE_AND_AUTHORITY.md`; destructive and host-risk gates remain in `DESTRUCTIVE_OPERATIONS.md`.

## Default design

- routine commands are non-destructive by default;
- destructive effects have explicit names and narrow scope;
- diagnostics/status are easy to discover;
- cleanup targets only the selected Project/Work-owned resources;
- one standard final verification path exists.

Put safety into command/resource design instead of relying on repeated manual caution.
