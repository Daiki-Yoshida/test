# Responsibility and Splitting

Read this when deciding whether code belongs in one unit, whether a unit should split, or whether an internal responsibility has matured enough to become a boundary.

## Responsibility is caller-coherent meaning

A responsibility is not a method count or class size. It is a coherent capability with a reason to change.

Use these operational signals:

1. **reason to change** — do the parts change for the same business reason?
2. **caller coherence** — does the caller see one capability?
3. **AND test** — does the description join peer-level meanings or merely subordinate steps?
4. **seam cost** — would splitting reduce change impact or just add traffic/mapping?
5. **state/consistency** — can ownership remain explicit after the split?

## AND is a warning, not an order

Keep together when the steps are subordinate to one higher meaning.

Example:

```text
evaluate candidate AND compute cost AND reconstruct route
→ still "find a path"
```

Consider splitting when meanings are peer-level:

```text
find a path AND charge customer AND notify user
→ different actors/policies/lifecycles
```

## Split signals

A split is stronger when:

- the parts have different actors, policy, lifecycle, or change rates;
- one part is stable while another changes frequently;
- a sub-responsibility can be tested independently;
- the outer surface can remain stable while an inner boundary is introduced.

Keep together when:

- both parts change together;
- callers still see one coherent capability;
- splitting creates high-frequency back-and-forth;
- mutable invariants remain practically shared;
- tests need nearly identical setup on both sides.

## Hardening is separate from identifying responsibility

A distinct responsibility is only a candidate boundary.

Hardening also requires sufficient stability and an acceptable seam. A responsibility still being discovered should stay flexible.

Do not use implementation expense alone to claim that a known, stable boundary is unnecessary.

## Design priority when rules compete

Prefer, in order:

1. clear boundary and contract;
2. stable external interface;
3. localized change;
4. explicit side effects;
5. internal elegance/purity.

Avoid over-engineering, but do not use "avoid over-engineering" to justify mixed responsibilities, vague failure semantics, silent contract breakage, or leaking external dependencies.
