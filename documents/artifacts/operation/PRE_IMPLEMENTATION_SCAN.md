# Pre-Implementation Scan

Read this before a non-trivial change to decide which guidance and verification are actually needed.

## Scale the scan to blast radius

A quick sanity check is enough for many typo/comment/test-only/private-helper changes.

Expand the scan when touching:

- public contract;
- responsibility/module boundary;
- external dependency;
- persistent data;
- caller-visible performance/resource guarantee;
- cross-boundary state or failure behavior.

## Questions

Ask only the relevant questions:

1. **Outcome** — what observable result is required?
2. **Responsibility/boundary** — which unit owns the meaning?
3. **Concept/state** — does concept identity or state ownership change?
4. **Dependency spread** — could an external dependency leak inward/across modules?
5. **Mapping/translation** — who owns the boundary conversion?
6. **Compatibility/risk** — do existing consumers/providers or operations change?
7. **Verification path** — what is the narrowest meaningful evidence of success?

## Route rather than duplicate

- responsibility/horizon/contract → `../design/INDEX.md`
- code structure/dependencies/domain/failure/tests/performance → `../implementation/INDEX.md`
- operation risk → `../safety/INDEX.md`
- runtime/command/CI → `../execution/INDEX.md`
- work/repository identity → `../project/INDEX.md`

The scan identifies questions; the specialized guidance owns the answers.
