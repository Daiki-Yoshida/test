# Documentation Workflow and Maintenance

Read this for new-project setup, brownfield documentation migration, ongoing updates, structural review, or Work Documents reconciliation.

## New project

1. Create only the AI entry files for tools the project actually uses.
2. Create `documents/`.
3. Create `documents/INDEX.md` as the routing hub.
4. Add project-level context needed now.
5. Add reference/topic documents as demand appears; do not pre-create empty taxonomy.

## Brownfield adoption

Before reorganizing:

1. inventory existing documentation;
2. classify current/canonical, audience-specific, duplicate, and obsolete material;
3. preserve deliberate project-local conventions unless the task intends to change them;
4. move/merge gradually while keeping routing valid;
5. preserve information during structural migration—do not silently delete content merely because it does not fit the new shape.

Treat **structural migration** and **content improvement/rewrite** as separate concerns. Do not turn a routing migration into an uncontrolled rewrite, and do not use documentation cleanup as an excuse for unrelated project restructuring.

## Ongoing updates

When implementation or a decision changes durable project knowledge, update the owning document and routing references in the same change when practical.

Update proportionally: a tiny implementation change does not require rereading or rewriting the entire documentation set. If a new durable document is added, register it in the routing hub.

Do not maintain parallel manual version registries when Git history already tracks document evolution.

## Multi-repository Projects

Do not create a separate Project Documentation tree merely because a Project contains multiple Component Repositories.

- keep Project-level policy, architecture, routing, and cross-component coordination in Management Root Repository-owned Project Documentation;
- keep component-specific knowledge with its actual owner when appropriate;
- update Project routing when a component knowledge location/responsibility changes;
- treat a Component Repository as an independent Project only in an intentional standalone Project context;
- do not reintroduce parent/child repository hierarchy or a required `documents/project/children.md` role.

## Managed artifact copies

Artifact v2 is delivered as one managed pack under `documents/artifacts/`, with `documents/artifacts/INDEX.md` as its entrypoint. Reusable guidance installed into a target project is a **managed derived snapshot**, not ordinary project-owned documentation.

- update it from its canonical source or the explicit distribution/sync mechanism;
- do not patch only the installed copy and let it permanently diverge;
- updates replace the managed pack according to its distribution contract; a leaf removed from the canonical pack may therefore disappear on the next exact-replacement sync;
- do not reintroduce legacy module-selective ownership assumptions;
- removing the whole managed root requires the distribution mechanism's explicit remove operation; merely not touching it in an unrelated project edit is not a remove request;
- record project-specific overrides in project-owned instructions/documentation rather than editing the managed copy;
- if the reusable guidance itself is wrong, fix the canonical source and redistribute it.

The project INDEX may route to the installed artifact entrypoint; it does not need to mirror every internal artifact file as an independent authority.

## Work Documents reconciliation

Work-specific investigation/design lives with the Work while it is active.

At completion, reconcile rather than copy everything:

```text
Work Documents
   ↓ review
durable confirmed knowledge → Project Documentation
temporary hypotheses/logs    → discard when no longer needed
```

Do not preserve raw work notes as permanent project authority merely because they existed.

## Delete safely

Before deleting or moving a document:

- search the documentation tree for references;
- update/remove incoming links;
- update `documents/INDEX.md`;
- preserve the reason in Git history.

Do not leave broken routing.

## Documentation change level

```yaml
DOC_L0_content:
  action: "Existing-file content edit; proceed."

DOC_L1_additive:
  action: "Add a file inside established routing; proceed and report."

DOC_L2_structural:
  examples: ["move", "rename", "routing path change", "delete"]
  action: "Proceed only when clearly implied by the task; report explicitly."

DOC_L3_model_change:
  examples: ["replace the authority/routing model", "rebuild the whole documents tree"]
  action: "Do not perform without an explicit request."
```

Documentation risk is separate from code-contract and destructive-operation risk.


## Re-read triggers

Re-read the documentation-routing guidance before:

- first applying it to a project;
- creating/rebuilding the `documents/` tree;
- new-project documentation setup;
- brownfield adoption.

Re-read or re-check the relevant routing when:

- adding a new agent entry file;
- moving documents across directories;
- changing single-repository ↔ multi-repository Project topology or repository roles;
- uncertain where new information belongs.

Routine content edits inside an established routing structure do not require a full strategy re-read.
