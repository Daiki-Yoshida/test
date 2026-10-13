# Contracts

Read this when defining or changing a **public/module boundary, API, port, published DTO, or other caller-visible guarantee**.

## Small surface, strong contract

Keep the published surface small. Once a capability is selected for publication, define it strongly.

> YAGNI may remove speculative surface area. It must not weaken the known completeness of a selected contract merely because completing it is expensive or today's consumer does not exercise every case.

Do not add capabilities simply because they are imaginable. Include what the current responsibility semantically requires.

## A contract is more than a signature

Treat a contract as **Signature + Semantics + Constraints**.

Close every leakage channel that matters to callers:

- signature / shapes
- observable semantics and ordering
- side effects
- failure semantics
- resource or time bounds when load-bearing
- determinism expectations
- persisted-data guarantees
- lifecycle / cancellation / concurrency guarantees when caller-visible

Document load-bearing guarantees, not verbose restatements of method names.

## Completeness buys internal freedom

The more freedom the implementation has, the more completely the surface must prevent that freedom from leaking.

```text
loose contract + wild interior     = leakage
complete contract + wild interior  = robust × flexible
```

This is why a pathfinding implementation may freely switch among A*, Dijkstra, parallel search, custom heaps, or GPU execution **if the published pathfinding contract still holds**.

## Responsibility-derived meaning vs future possibility

Do not use "could happen someday" as a reason to grow the contract.

Ask whether the case follows from the selected responsibility itself.

Examples for a pathfinding capability:

- unreachable destination, invalid input, cancellation, failure semantics, resource limits → may be part of the capability's meaningful state space;
- future GPU cluster support or runtime-selectable algorithm registries → implementation/extension speculation unless an actual requirement exists.

## Strong means explicit, not maximally restrictive

A strong contract is explicit about required semantics; it is not maximally restrictive.

Do not promote incidental properties of the current implementation into public guarantees unless they:

- follow from the selected responsibility;
- are a load-bearing user/product requirement; or
- are a property callers should rely on for stability.

Properties that arise accidentally from the algorithm choice—such as shortestness, deterministic tie-breaking, ordering, complexity, or caching behavior—must not shrink internal freedom by becoming contract unless a requirement or the responsibility actually needs them. When they are already caller-visible requirements, define them as part of contract completeness as usual.

## Omission burden

For speculative internal machinery, the proposer must explain why it is needed now.

For a selected hardened boundary, the burden reverses: if a known guarantee is intentionally left undefined or weak, explain why doing so does not compromise boundary safety or stability.

## Contract change level

Classify contract changes independently from destructive-operation or documentation risk.

```yaml
L0_internal:
  meaning: "Private refactor/test/internal implementation."
  action: "Proceed."

L1_local:
  meaning: "Module-local interface/port/non-public DTO with participants owned inside the task scope."
  action: "Proceed and report; reclassify if outer/public behavior is affected."

L2_compatible_public_evolution:
  meaning: "Existing consumers AND providers/implementers remain valid under the previous guarantees."
  action: "Proceed when clearly implied by the request and compatibility is verified; report explicitly."

L3_breaking:
  meaning: "Existing public participants must change, previous guarantees break, persisted data requires migration, or a new external side effect is introduced."
  action: "Do not perform without explicit authorization."
```

"Additive" is not proof of compatibility. A required interface member may leave callers unchanged while breaking every existing implementer or fake.

Evaluate only compatibility dimensions relevant to the medium: source, binary, wire, schema, persisted data.

For detailed compatibility checks, also read `../implementation/COMPATIBILITY.md`.
