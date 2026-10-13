# Brownfield and Existing Violations

Read this when applying reusable guidance to an existing project with established code and conventions.

## Local convention first

For new/modified code, follow current reusable guidance **unless** an explicit project-local convention intentionally says otherwise.

Project-specific instructions, configuration, and house style are real constraints. Do not rewrite them merely to make the repository resemble this artifact pack.

## Do not turn the task into a violation hunt

```yaml
new_or_modified_code: "Improve toward current rules where compatible with local conventions."
surrounding_violation: "Do not silently fix merely because it was noticed."
scope_guard: "Do not expand task scope into general cleanup."
cleanup_needed_for_correctness: "Treat it as part of the change and evaluate its impact explicitly."
```

If a broader cleanup is valuable but not necessary, report it or make it a separate change.

## Approach questions

If the user asks how to proceed rather than asking for implementation, do not silently convert the question into code changes.

A useful approach answer compares realistic options and trade-offs under the current project constraints. Implementation authority comes from the actual request/context.
