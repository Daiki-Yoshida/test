# State Ownership and Cross-Boundary Consistency

Read this when a business outcome crosses modules/services/components or multiple mutable states participate in one operation.

## One mutable state, one clear owner

Each mutable business state should have one clear owning boundary.

Other boundaries interact with that state through the owner's contract rather than taking ownership of its internals.

## Cross-boundary outcome needs a coordinator

When one business outcome spans multiple state owners, explicitly assign ownership of:

- coordination;
- consistency strategy;
- failure policy.

An orchestrator may call multiple participants without owning each participant's internal business decisions or state.

## Choose an explicit consistency strategy

Depending on topology and required guarantees, use an appropriate model such as:

- atomic transaction, where actually available;
- retry;
- idempotency;
- compensation;
- explicit intermediate state.

Do not pretend distributed or cross-owner state changes are atomic if the topology cannot provide that guarantee.

## Cross-boundary invariant does not automatically mean merge

An invariant spanning multiple boundaries is first a coordination problem, not automatic evidence that all participants belong in one module.

Revisit the split when these repeat:

- chatty cross-boundary calls;
- effectively shared mutable state;
- both sides must be edited for most changes.

The decision to redraw/harden a boundary belongs with `BOUNDARY_HORIZON.md`; this file governs ownership after the split exists.
