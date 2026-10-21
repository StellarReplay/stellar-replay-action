$ErrorActionPreference = 'Stop'
$fixture = $env:STELLAR_REPLAY_FIXTURE
$commandName = if ($env:STELLAR_REPLAY_COMMAND) { $env:STELLAR_REPLAY_COMMAND } else { 'validate' }
$version = if ($env:STELLAR_REPLAY_CORE_VERSION) { $env:STELLAR_REPLAY_CORE_VERSION } else { '0.1.1' }
$repository = if ($env:STELLAR_REPLAY_CORE_REPOSITORY) { $env:STELLAR_REPLAY_CORE_REPOSITORY } else { 'StellarReplay/stellar-replay' }
if (-not $fixture) { throw 'fixture is required' }
if ($version -ne '0.1.1') { Write-Error "unsupported Stellar Replay core version: $version"; exit 2 }
if ($commandName -notin @('validate','replay')) { Write-Error "unsupported Stellar Replay command: $commandName"; exit 2 }
if (-not (Test-Path -LiteralPath $fixture -PathType Leaf)) { Write-Error "fixture not found: $fixture"; exit 2 }
$workdir = Join-Path $env:RUNNER_TEMP 'stellar-replay-action'
if (Test-Path -LiteralPath $workdir) { Remove-Item -LiteralPath $workdir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $workdir | Out-Null
$asset = "stellar-replay-$version-windows-amd64.zip"
$base = "https://github.com/$repository/releases/download/v$version"
Invoke-WebRequest -UseBasicParsing "$base/$asset" -OutFile (Join-Path $workdir $asset)
Invoke-WebRequest -UseBasicParsing "$base/SHA256SUMS" -OutFile (Join-Path $workdir 'SHA256SUMS')
$expected = (Select-String -Path (Join-Path $workdir 'SHA256SUMS') -Pattern ([regex]::Escape($asset))).Line.Split()[0]
$actual = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $workdir $asset)).Hash.ToLowerInvariant()
if ($actual -ne $expected.ToLowerInvariant()) { Write-Error 'release checksum verification failed'; exit 1 }
Expand-Archive -LiteralPath (Join-Path $workdir $asset) -DestinationPath $workdir
$binary = Join-Path $workdir 'stellar-replay.exe'
if (-not (Test-Path -LiteralPath $binary -PathType Leaf)) { throw 'release archive did not contain stellar-replay.exe' }
$args = @($commandName, '--fixture', $fixture)
if ($commandName -eq 'replay') {
  if ($env:STELLAR_REPLAY_REQUEST_FILE) { $args += @('--request-file', $env:STELLAR_REPLAY_REQUEST_FILE) }
  if ($env:STELLAR_REPLAY_METHOD) { $args += @('--method', $env:STELLAR_REPLAY_METHOD) }
  if ($env:STELLAR_REPLAY_PARAMS) { $args += @('--params', $env:STELLAR_REPLAY_PARAMS) }
}
& $binary @args
exit $LASTEXITCODE
