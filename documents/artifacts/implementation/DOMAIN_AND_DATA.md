# Domain and Data Boundaries

Read this for Domain modeling, entity state, DTOs, mapping, external representations, or data ownership.

## Match model richness to domain complexity

Use a rich Domain model when invariants, meaningful state transitions, or business rules are strongly tied to the entity's state.

Use a lightweight model for CRUD/data-holder cases with little domain behavior.

"Lightweight" does not mean moving business rules into UI or Infrastructure.

## Entity state

Ordinary identity-preserving updates may use mutable rich entities.

For critical flows where state changes which operations are valid, type-driven state transitions may be appropriate.

Keep the chosen lifecycle model internally consistent.

## Domain purity is about meaning, not primitive types

Normally keep these out of Domain:

- DB/HTTP/filesystem IO;
- external API DTOs;
- framework annotations;
- vendor SDK types;
- UI framework types.

Time, color, text, etc. may still be Domain concepts when they exist because of business meaning rather than UI/technology needs.

## State ownership

Mutable business state has one clear owning boundary.

When one outcome spans multiple owners, coordination may live elsewhere, but participants keep ownership of their internal state and decisions.

For cross-owner consistency strategy, read `../design/STATE_AND_CONSISTENCY.md`.

## DTO and mapping ownership

Domain Entity/Value Object should not own conversion to external representations.

Typical placement:

- Application: Domain ↔ use-case request/response;
- Infrastructure: DB/API/filesystem model ↔ Domain;
- UI: Application response ↔ ViewModel.

Small one-off mapping may remain inline inside the owning boundary. Extract mapping when reuse, complexity, or semantic significance justifies it.

Naming guide:

- **Mapper**: structural DTO ↔ Domain;
- **Converter**: value/type conversion;
- **Assembler**: builds a result from multiple sources;
- **Adapter**: fits an external API/SDK to a project-owned contract;
- **Translator**: maps external/vendor concepts into domain concepts.
