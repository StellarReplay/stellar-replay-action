<p align="center">
  <img src="assets/stellar-replay-action-mark.svg" alt="Stellar Replay Action" width="320" />
</p>

<p align="center"><strong>Offline GitHub Actions integration for Stellar Replay.</strong></p>

<p align="center">
  <a href="https://github.com/StellarReplay/stellar-replay-action/actions/workflows/ci.yml"><img src="https://github.com/StellarReplay/stellar-replay-action/actions/workflows/ci.yml/badge.svg?branch=main" alt="Action CI status" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-Apache--2.0-4F8CFF" alt="Apache-2.0 license" /></a>
  <a href="https://github.com/StellarReplay/stellar-replay/releases/tag/v0.1.0"><img src="https://img.shields.io/badge/core-v0.1.0-5BE7C4" alt="Core v0.1.0" /></a>
</p>

<p align="center">
  <a href="https://github.com/StellarReplay/stellar-replay">Core product</a> ·
  <a href="#usage">Usage</a> ·
  <a href="CONTRIBUTING.md">Contributing</a> ·
  <a href="SECURITY.md">Security</a>
</p>

GitHub Actions integration for [Stellar Replay](https://github.com/StellarReplay/stellar-replay).

## Status

The Action is implemented on `main` but has no Action release tag yet. It
downloads the pinned core v0.1.0 release, verifies its published SHA-256
checksum, and runs `validate` or `replay` without wallet credentials or a live
RPC endpoint. It remains a thin integration layer and does not copy the Go
engine.

## Usage

```yaml
- uses: StellarReplay/stellar-replay-action@main
  with:
    fixture: fixtures/get-health.json
    command: validate
    core-version: 0.1.0
```

For deterministic replay:

```yaml
- uses: StellarReplay/stellar-replay-action@main
  with:
    fixture: fixtures/get-health.json
    command: replay
    method: getHealth
```

Supported runners are Linux amd64, Windows amd64, and macOS amd64, matching the
core v0.1.0 release archives. The Action rejects unsupported core versions,
missing fixtures, malformed command choices, missing release assets, and
checksum mismatches. Core fixture semantics remain owned by the core repository.

The current frozen v0.1 boundary and request semantics are defined by the core repository's [Phase 1 decision record](https://github.com/StellarReplay/stellar-replay/blob/main/docs/PHASE_1_DECISION.md). This repository does not redefine them.

## Development

Validate `action.yml` and run the offline contract checks locally. Default tests
must remain network-free; the release download is exercised only by the
workflow-level smoke test. Do not add blockchain credentials or live-network
requirements to Action tests.

## Versioning

The Action has its own semantic version and major-version tags. Compatibility with the supported core CLI and fixture schema is documented in each Action release. It must never depend on an unreleased core commit.
