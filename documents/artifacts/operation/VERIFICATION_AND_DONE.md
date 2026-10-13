# Verification and Done

Read this when deciding what must be verified before reporting completion.

## Separate two questions

1. **Contract conformance** — does the implementation satisfy the intended contract?
2. **Requested outcome** — does the observable result satisfy what the user actually needed?

Do not substitute one for the other.

## Verification discipline

- start with the narrowest relevant verification;
- expand when boundary/blast radius requires it;
- if a test/check fails, report the failure rather than describing it as passed;
- if a check could not be run, state that it was not run;
- do not invent test results.

Test semantics/placement live in `../implementation/TESTING.md`; command/CI execution lives in `../execution/COMMANDS_AND_CI.md`.

## Minimum done report

Unless the task defines stronger criteria, be able to report:

```yaml
changed: "What was changed."
verified: "What was actually checked."
not_verified: "Relevant checks that could not be run."
remaining: "In-scope work still open."
impact: "Public contract, persistent data, or operational impact."
```

A clean implementation is not done if the requested outcome was never meaningfully verified.
