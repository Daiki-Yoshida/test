# Integration Safety and Re-read Triggers

Read this for repository integration operations or when changing the development-environment model itself.

## Integration

Use the target repository's own merge/rebase/PR policy.

- integrate in the repository that owns the branch;
- do not commit Component Repository changes as ordinary Management Root Repository files;
- rerun required validation on the integrated HEAD;
- when Management Root Repository-side tooling changed, verify components against the intended ref;
- one merged component branch does not automatically complete a multi-repository Work.

This guidance does not define PR approval/release governance.

## Re-read the relevant environment guidance when

**Must re-read**
- first contact with a project using this model;
- Management Root Repository / Component Repository topology changes;
- worktree contract is added/redesigned;
- host/container boundary changes;
- destructive operation is added.

**Should re-read**
- resource naming/isolation changes;
- public command structure changes;
- local/CI path changes;
- external repository/tool ref policy changes.

**Usually no re-read needed**
- routine use of an established command;
- routine worktree creation under an established contract;
- small internal script change that preserves the public command contract.

Use operation safety levels from `DESTRUCTIVE_OPERATIONS.md` independently from code-contract or documentation-structure levels.
