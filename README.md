# stellar-replay-action

GitHub Actions integration for [Stellar Replay](https://github.com/StellarReplay/stellar-replay).

## Status

Repository foundation only. The core CLI v0.1.0 is released, but this Action is
not released or advertised as working yet. It remains a thin integration layer
and will consume a released `stellar-replay` binary or documented stable
interface; it will not copy the Go engine.

## Planned contract

The eventual Action will accept a fixture path and validation/replay options,
invoke a pinned released core version, and surface failures through the workflow
exit status and logs. Core fixture semantics remain owned by the core repository.

The current frozen v0.1 boundary and request semantics are defined by the core repository's [Phase 1 decision record](https://github.com/StellarReplay/stellar-replay/blob/main/docs/PHASE_1_DECISION.md). This repository does not redefine them.

## Development

Validate `action.yml` structure and workflow YAML locally. Integration tests are
blocked on the Action contract and a stable invocation strategy, not on core
availability. The current composite action intentionally fails closed as a
pre-release guard. Do not add blockchain credentials or live-network
requirements to default Action tests.

## Versioning

The Action has its own semantic version and major-version tags. Compatibility with the supported core CLI and fixture schema is documented in each Action release. It must never depend on an unreleased core commit.

