# Compatibility

Read this before evolving an existing public/module contract, DTO, interface, wire schema, or persisted format.

## Additive is not automatically compatible

A change may look additive for callers while breaking providers, implementations, fakes, binaries, schemas, or stored data.

Verify both sides:

- consumer / caller;
- provider / implementer.

Evaluate only compatibility dimensions relevant to the medium:

- source;
- binary;
- wire;
- schema;
- persisted data.

Example: adding a required interface member can leave callers untouched while breaking all existing implementers. Treat it as breaking, not automatically compatible.

## Preserve previous guarantees

A compatible public evolution keeps existing participants valid under the guarantees they already relied on.

If previous participants must change, a prior guarantee changes, persisted data requires migration, or a new external side effect appears, route the change through the breaking-contract confirmation level in `../design/CONTRACTS.md`.

## Compatibility is separate from requirement correctness

After compatibility is established, still verify that the new observable outcome satisfies the requested change.

Contract conformance and requested-outcome verification are related but distinct.

## Keep the narrowest meaningful verification path

Do not force a full E2E suite or heavyweight acceptance document for every compatible local change.

Choose verification proportional to blast radius while covering the compatibility dimensions actually affected.
