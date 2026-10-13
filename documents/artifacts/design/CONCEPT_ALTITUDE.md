# Concept Altitude

Read this when deciding whether a concept is feature-specific, reusable, shared, or merely first used by one feature.

## First consumer is not automatically the owner

Model a concept by **what it is**, not by the feature that first happens to need it.

A responsibility sentence that does not need the feature name is a signal that the concept may be consumer-neutral.

Example: if "stairs" means "move an actor between connected locations when activated", the fact that a dungeon feature first needs it does not justify baking `Dungeon` into the concept.

## Neutrality is not proof of shared semantic identity

A feature-free description alone does **not** prove that two consumers share the same contract.

Before promoting a concept into a shared abstraction, compare:

- invariants
- preconditions and postconditions
- success/failure meaning
- lifecycle/state transitions
- reason to change

If the evidence is insufficient, keep the concept neutral but local.

## Separate three decisions

These are independent:

1. **semantic altitude** — what the concept means;
2. **physical placement** — where the code currently lives;
3. **hardening/sharing** — whether multiple consumers depend on one published abstraction.

A neutral concept may remain physically inside the first consumer's module until real reuse/stability appears.

## YAGNI boundary

YAGNI should prevent:

- unused interfaces;
- speculative seams;
- premature shared-module extraction;
- future-only extension machinery.

YAGNI should **not** force a general concept to adopt feature-specific meaning.

Neutral naming/types are often nearly free at creation time; removing semantic pollution later is expensive after references and assumptions spread.
