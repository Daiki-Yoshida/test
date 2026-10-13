# tests/

Component Repository primary checkouts live here: `dotnet-test/`, `script-test/`, `documents-test/`.

Each subdirectory is an independent Git repository (own history, own branches). The Management Root never tracks component files — the `tests/*/` ignore boundary in `.gitignore` enforces this.

See `documents/project/REPOSITORIES.md` for the selector map and `documents/project/COMPONENT_MODEL.md` for how independent histories live inside the single permitted GitHub remote.
