# Testing and Verification Structure

Read this when choosing test type, placement, or how to verify implementation behavior.

## Test the meaningful boundary

Typical roles:

- **Unit test** — isolated logic;
- **Integration test** — component interaction / real adapter;
- **Contract test** — implementation conforms to a contract;
- **E2E / requirement verification** — user/product/system observable outcome.

Do not equate contract conformance with task correctness.

```yaml
contract_check: "Does the implementation satisfy the defined contract?"
requirement_check: "Does the observable result satisfy the requested outcome?"
```

Both may be necessary. A perfectly consistent contract + implementation + test can still implement the wrong requirement.

## Test priority

- Domain/Core: correctness and unit tests;
- public port/interface: contract test;
- Infrastructure adapter: integration and/or contract test;
- Application use case: orchestration and expected failures;
- UI: proportional to behavioral complexity/criticality;
- private helper: normally through its public/module boundary; direct test only when isolated logic meaningfully warrants it.

Avoid tests that freeze incidental internal structure.

## Placement

Keep unit/contract tests near the code/contract owner where project conventions allow.

A reusable contract suite belongs near the contract and should run against implementations through a factory/setup mechanism.

Reusable fakes may form a test-support surface; keep them internal if only one module uses them.

Cross-module or cross-runtime E2E tests should live where the full seam can be exercised.

## Runtime seams

When frontend/backend or other deployables are separate runtimes, treat wire DTO/API behavior as a published contract. Do not let one runtime import another runtime's internal Domain/Application/Infrastructure.

Each runtime entrypoint/composition root wires environment/configuration and adapters; keep business logic out of the entrypoint.

For compatibility of an existing published contract, also read `COMPATIBILITY.md`.
