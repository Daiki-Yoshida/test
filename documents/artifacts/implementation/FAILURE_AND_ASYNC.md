# Failure, Async, and Concurrency

Read this when designing failure representation, exception translation, async APIs, cancellation, ordering, thread safety, or concurrency ownership.

## Expected vs system failure

Expected business failure should normally use the project's explicit business-failure representation such as `Result`, `Either`, or `Outcome`.

Avoid hiding meaningful failure in:

- boolean;
- null;
- normal exception control flow.

Reuse the project-standard type when one exists.

System failures—DB outage, invalid configuration, resource exhaustion, unexpected infrastructure faults—may use exceptions or the project's system-failure mechanism. Explicit business results do not imply "never throw."

## Translate failures at boundaries

Do not leak Infrastructure/vendor exception types into Application/Domain/public meaning.

At the boundary:

1. catch the technical failure where appropriate;
2. translate it to a project-owned or domain-meaningful failure;
3. retain diagnostic cause/context when useful;
4. keep vendor/transport detail out of the stable contract unless it is intentionally part of that contract.

## Async/concurrency is contractual when caller-visible

If asynchronous behavior, cancellation, ordering, or thread-safety affects callers, define it.

- Do not hide genuinely async/long-running work behind a misleading sync facade.
- Consider cancellation for long-running or IO operations.
- State required safety: thread-safe, caller-confined, single-threaded, etc.
- Do not leak scheduler/runtime primitives into Domain contracts without need.
- For shared mutable state, define owner plus synchronization or immutability.
- Do not synchronously block across ownership boundaries merely to disguise async work.

Use idiomatic syntax for the language/runtime; the rule is semantic, not tied to Task/Promise/suspend.

## Contract connection

Caller-visible failure, cancellation, determinism, ordering, persistence, and resource behavior are part of contract completeness when load-bearing.

For the full boundary rule, read `../design/CONTRACTS.md`.
