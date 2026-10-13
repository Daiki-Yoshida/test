# Performance-Shaped Interaction

Read this when performance pressure might change an API/contract interaction shape.

## Do not redesign public interaction from intuition

"Seems slow" is not enough to reshape a boundary.

Use this gate:

1. confirm the performance requirement is actually load-bearing;
2. gather representative measurement or a defensible structural bound;
3. first try optimization that preserves the current contract;
4. change interaction shape only when the current shape is itself the limiting constraint;
5. preserve semantic capability and ownership boundary where possible;
6. apply normal compatibility rules to existing published contracts;
7. verify the redesigned behavior against the actual requirement.

## Possible interaction shapes

Depending on evidence, candidates may include:

- batching;
- streaming;
- pagination;
- async;
- cancellation;
- backpressure.

These are not universal performance recommendations.

Internal mechanisms—buffer ownership, cache layout, pooling, algorithm/data-structure choice—remain internal unless callers genuinely depend on them.

## Resource guarantees may be contractual

If callers/product/system truly depend on latency, throughput, bounded memory/work, or similar limits, those guarantees may belong in the boundary contract.

If interaction shape or caller-visible resource guarantees change, also read `../design/CONTRACTS.md`.
