# Boundary and Encapsulation Horizon

Read this when deciding **where a hard boundary should exist, how far hardening should descend, or whether YAGNI justifies leaving something flexible**.

## Core rule

> Make the boundary strict and stable; keep the implementation inside it flexible.

A boundary may exist at many scales—function, class, module, library, service, application—but that does **not** mean every scale should be hardened. Hardening everything creates seam overhead; hardening nothing lets change leak everywhere.

The **Encapsulation Horizon** is the chosen scale where a hard contract is enforced. At and above the horizon, accuracy and stability dominate. Below it, implementation flexibility is the default.

## Choose the horizon by responsibility

Do not treat a folder or language-level module as the universal boundary.

A hardened unit should represent one caller-coherent responsibility: one capability with a coherent reason to change.

Use observable signals:

- Does the caller see one coherent capability?
- Does it usually change for one reason?
- Is an `AND` describing peer-level meanings, or merely subordinate steps?
- Would splitting create a chatty seam or shared mutable state?

The module is a useful **initial prior**, not a permanent floor.

## Harden only when the seam is ready

A candidate responsibility should normally be hardened when:

1. the responsibility is sufficiently stable, and
2. the seam is cheap enough to maintain.

Do not harden a still-discovered sub-responsibility merely because a cleaner abstraction can be imagined.

Conversely, once a boundary is known to be needed, **creation cost alone is not a sufficient YAGNI argument against hardening it**. "This is expensive to design/test" does not make the boundary unnecessary. If the design need is real, preserve that need; execution order and migration scope are separate operational decisions.

## Macro → micro

Explore from the outside inward.

- Outermost/public application or service surfaces are hard by definition.
- Major stable module surfaces are hardened by default.
- Below the current horizon, keep structure flexible until independent responsibility and seam value are observed.

This bias exists because under-hardening a macro boundary leaks widely, while over-hardening an internal seam is contained and can usually be relaxed.

## YAGNI across the horizon

YAGNI is intentionally asymmetric:

```yaml
surface_breadth:
  yagni: strong
  rule: "Do not publish future capabilities or extension points without a current reason."

selected_contract_completeness:
  yagni: strongly_restricted
  rule: "Do not omit known guarantees of a selected boundary merely because they are unused today or expensive to implement."

internal_mechanism:
  yagni: strong
  rule: "Do not pre-build speculative abstractions, algorithm families, factories, seams, or optimizations inside the boundary."
```

In short: **YAGNI limits speculative surface and speculative internals; it does not excuse an incomplete selected boundary.**

## Redraw reactively

When a previously cohesive interior develops an independently changing sub-responsibility, it may graduate into a new hardened unit.

Treat `AND` as a warning, not an automatic split:

- subordinate steps under one caller-visible meaning → keep together by default;
- peer-level meanings with different actors, policies, lifecycle, or change reasons → consider splitting.

Prefer maturation that **preserves the existing outer surface** and adds an inner horizon. If internal maturation forces callers to change, re-check whether the original outer responsibility was drawn correctly.

### Graduation is the settlement point

Interior freedom is contained, not free forever. When an internal sub-responsibility graduates into a hard boundary, the project must then define and verify that new surface against code that may have grown freely.

For long-lived interiors, use freedom deliberately: do not pre-harden speculative seams, but remember that a future graduation can have real settlement cost.

## Guardrails

- "Harden public surfaces" does not mean "create an interface everywhere."
- "Flexible interior" does not mean "careless code."
- "YAGNI" does not mean "leave a known contract vague."
- "Module" does not automatically mean folder, package, deployable, or horizon; resolve which meaning is relevant.
