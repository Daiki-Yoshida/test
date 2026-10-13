# Dependencies and External Systems

Read this for interface/DI decisions, dependency direction, external libraries, SDKs, frameworks, clocks, randomness, or IO.

## Use a contract mechanism where a real boundary exists

Define or reuse an interface/protocol/trait/structural contract when one of these is true:

- public or cross-module boundary;
- injected dependency;
- volatile dependency such as IO/DB/network/filesystem/clock/randomness;
- boundary protecting Domain/Application from Infrastructure;
- role must be replaceable, test-substitutable, or runtime-swappable.

Do not mechanically create interfaces for private helpers, short-lived spikes, or single-implementation logic that does not form a meaningful boundary.

Boundary maturity and seam cost are governed by the design guidance, not by "interfaces everywhere."

## Dependency direction

Dependencies should point toward project-owned abstractions.

- Domain does not depend on external implementations.
- Application depends on Domain and ports it owns.
- Infrastructure implements those ports/contracts.
- The composition root selects concrete implementations.

## Dependency injection

Make volatile behavioral dependencies explicit using an idiomatic mechanism for the language.

Avoid:

- Service Locator inside business components;
- creating IO/config/random/time dependencies invisibly inside them;
- DI-container-style service injection into Domain Entity/Value Object constructors.

Stable value objects/entities/pure utilities may normally be instantiated directly.

If a Domain operation needs an external capability, re-check the domain meaning and prefer a narrow/local capability argument when appropriate.

## External dependency containment

Keep vendor/framework types near the edge.

Strong reasons for a wrapper/adapter/project-owned DTO include:

- vendor type enters Domain/core;
- dependency spreads across multiple modules;
- replacement affects unrelated code;
- vendor vocabulary starts defining domain vocabulary;
- vendor errors/lifecycle/async/side effects invade business logic;
- a widely depended-on or core-domain unit would depend directly on the vendor.

Direct SDK/framework use inside its owning UI/Infrastructure edge is fine if it does not leak inward.

## Inheritance

Use inheritance when it enforces a real behavioral/lifecycle/framework contract.

Do not choose inheritance merely for code reuse or structural similarity; prefer composition when no strict is-a contract exists.
