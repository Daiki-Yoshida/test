# Documentation Principles and Routing

Read this when creating or restructuring project documentation.

## Priority

```yaml
1: "Information accuracy and completeness"
2: "Correct routing to the needed information"
3: "Token efficiency"
```

If accuracy and token cost conflict, accuracy wins. Solve token cost primarily with **file structure and routing**, not by deleting conditions or detail that changes meaning.

## AI-facing canonical knowledge

Project-owned Project Documentation is the canonical project knowledge that AI agents should be able to route into during development. Human-facing setup/tutorial/background material may coexist, but should not become a competing authority for the same project facts.

## Canonical project documentation root

Use:

```text
<project-root>/documents/
```

as the project documentation namespace and routing root.

Project-owned documentation under this namespace is canonical project knowledge. A managed derived subtree such as `documents/artifacts/` may live there physically without becoming project-owned canonical authority.

Its internal shape is project-specific. `documents/project/` and `documents/reference/` are useful examples, not mandatory directories.

Static placement/Git ownership belongs to project/workspace guidance; this file governs routing and document roles.

## INDEX is the routing hub

`documents/INDEX.md` is required and should route by task/concern.

It should provide:

- inventory of project-owned canonical documentation and purpose;
- managed derived subtrees by their entrypoint rather than mirroring every internal leaf;
- task → document routing;
- useful cross-references.

An AI should not need to read all documentation to find one answer.

## Agent entry files

Files such as `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md` may contain:

- project-local constraints;
- agent role;
- emergency/ambiguity behavior;
- current focus;
- routing to `documents/INDEX.md`.

Do not make them duplicate authorities for detailed project knowledge. Create only entry files for tools actually used.

## README

Keep the root `README.md` as a concise human-facing introduction and pointer to deeper knowledge. Do not turn README into a duplicate authority for Project Documentation.

## One primary concern per file

Prefer a clear primary authority for each concern.

Local restatement for comprehension is fine; do not independently redefine the same rule in multiple documents.

Split by routing value, not by a rigid universal folder taxonomy.

Create a topic directory when it forms a real routed unit (for example several cohesive files that are useful together). Do not create a directory merely to host one small file, and do not treat a numeric file-count threshold as a hard law.

## Progressive disclosure

Typical chain:

```text
agent entry
  → documents/INDEX.md
  → task-relevant project/reference/topic document
  → deeper detail only if needed
```

Use relative links from the referring document.

## Multi-repository Project routing

Repository roles come from Project/workspace guidance.

A Management Root Repository owns the Project-level documentation/routing authority. Component Repositories may own component-specific knowledge according to their Git/source ownership, but **being a Component Repository does not automatically make it an independent Project or require another `documents/INDEX.md`**.

Typical shape:

```text
Project
├─ Management Root Repository
│  └─ documents/INDEX.md
├─ Component Repository A
└─ Component Repository B
```

Project Documentation should route to component-specific knowledge when needed, without duplicating it as a competing authority.

A physical repository that normally participates as a Component Repository may own its own Project Documentation only when it is intentionally used as a standalone Project context, in which case it acts as that context's Management Root Repository.

Do not model Management Root Repository / Component Repository as parent/child repository hierarchy, and do not require a special `documents/project/children.md` document.
