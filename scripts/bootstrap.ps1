param(
    [switch]$IncludeOptional,
    [switch]$IncludeReferences,
    [switch]$All
)
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Lock = Join-Path $Root 'UPSTREAMS.lock'
if ($All) { $IncludeOptional = $true; $IncludeReferences = $true }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Git is required but was not found.' }

foreach ($line in Get-Content $Lock) {
    if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#')) { continue }
    $parts = $line.Split('|')
    if ($parts.Length -ne 7) { throw "Invalid lock row: $line" }
    $id, $repo, $branch, $sha, $license, $class, $relpath = $parts
    if ($class -eq 'optional' -and -not $IncludeOptional) { continue }
    if ($class -eq 'reference' -and -not $IncludeReferences) { continue }
    $url = "https://github.com/NuvioMedia/$repo.git"
    $dest = Join-Path $Root ($relpath -replace '/', [IO.Path]::DirectorySeparatorChar)
    $parent = Split-Path -Parent $dest
    New-Item -ItemType Directory -Force -Path $parent | Out-Null

    if (Test-Path (Join-Path $dest '.git')) {
        $current = (git -C $dest rev-parse HEAD).Trim()
        if ($current -eq $sha) {
            Write-Host "[ok] $id already at $sha"
            if (Test-Path (Join-Path $dest '.gitmodules')) { git -C $dest submodule update --init --recursive }
            continue
        }
        if ((git -C $dest status --porcelain).Trim()) { throw "$relpath has local changes; refusing to overwrite it." }
        throw "$relpath is at $current, expected $sha. Remove this folder explicitly and retry."
    }
    if (Test-Path $dest) { throw "$dest exists but is not a Git checkout." }

    $tmp = "$dest.bootstrap.$PID"
    if (Test-Path $tmp) { Remove-Item -Recurse -Force $tmp }
    New-Item -ItemType Directory -Force -Path $tmp | Out-Null
    Write-Host "[clone] $id ($repo @ $sha; $license)"
    git -C $tmp init -q
    git -C $tmp remote add origin $url
    git -C $tmp fetch --depth 1 origin $sha
    if ($LASTEXITCODE -ne 0) { Remove-Item -Recurse -Force $tmp; throw "Could not fetch pinned commit for $repo." }
    git -C $tmp checkout --detach FETCH_HEAD
    if (Test-Path (Join-Path $tmp '.gitmodules')) { git -C $tmp submodule update --init --recursive }
    git lfs version *> $null
    if ($LASTEXITCODE -eq 0) {
        git -C $tmp lfs pull
        if (Test-Path (Join-Path $tmp '.gitmodules')) { git -C $tmp submodule foreach --recursive 'git lfs pull || true' }
    }
    Move-Item -Path $tmp -Destination $dest
}
Write-Host "Bootstrap complete. Run .\scripts\verify.ps1"
