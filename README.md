# stellar-replay-action

GitHub Actions integration for [Stellar Replay](https://github.com/StellarReplay/stellar-replay).

## Status

Repository foundation only. The core CLI has not reached a released interface, so this Action is not released or advertised as working yet. The Action will remain a thin integration layer and will consume a released `stellar-replay` binary or documented stable interface; it will not copy the Go engine.

## Planned contract

The eventual Action will accept a fixture path and validation/replay options, invoke a pinned released core version, and surface failures through the workflow exit status and logs. Core fixture semantics remain owned by the core repository.

## Development

Validate `action.yml` structure and workflow YAML locally. Integration tests will be added when the core CLI interface is released. Do not add blockchain credentials or live-network requirements to default Action tests.

## Versioning

The Action has its own semantic version and major-version tags. Compatibility with the supported core CLI and fixture schema is documented in each Action release. It must never depend on an unreleased core commit.

