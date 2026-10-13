# Version Control and Reporting

Read this when deciding whether to commit/push or how to report a completed engineering change.

## Commit/push authority

Default reusable rule:

```yaml
commit_push: "Do not commit or push unless the user/project workflow authorizes it."
default_branch: "For implementation source changes, do not directly commit on the default/baseline branch unless the project explicitly uses that workflow."
project_rule: "A more specific project-local VCS policy overrides this reusable default."
```

Static repository ownership belongs to project structure guidance. Work-specific branch/worktree lifecycle belongs to project/work guidance.

## Work Documents publication

Work guidance may require Work Documents to become visible from the Project baseline, but that lifecycle goal does not itself grant commit/push/merge authority.

- use the project-authorized documentation/coordination publication path;
- if publication is not yet authorized, preserve the Work context in an authorized Management Root Repository working state and report publication as pending;
- never report baseline publication that has not actually happened.

## Reporting

Report facts needed to understand the result:

- what changed;
- why;
- public/data/operation impact;
- actual verification results;
- checks not run or failed;
- intentionally retained work resources or remaining issues when relevant.

Do not hide failed/unperformed verification behind a generic "done."

Use the language/form appropriate for the user and context; do not impose legacy fixed reporting language.
