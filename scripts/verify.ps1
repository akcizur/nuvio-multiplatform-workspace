$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Lock = Join-Path $Root 'UPSTREAMS.lock'
$Failed = $false
foreach ($line in Get-Content $Lock) {
    if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#')) { continue }
    $id, $repo, $branch, $sha, $license, $class, $relpath = $line.Split('|')
    $path = Join-Path $Root ($relpath -replace '/', [IO.Path]::DirectorySeparatorChar)
    if (-not (Test-Path (Join-Path $path '.git'))) {
        if ($class -eq 'core') { Write-Host "[missing] $id ($relpath)"; $Failed = $true }
        else { Write-Host "[not fetched] $id ($class)" }
        continue
    }
    $actual = (git -C $path rev-parse HEAD).Trim()
    if ($actual -ne $sha) { Write-Host "[mismatch] $id expected=$sha actual=$actual"; $Failed = $true }
    else { Write-Host "[ok] $id $actual" }
    if (Test-Path (Join-Path $path '.gitmodules')) {
        $subStatus = git -C $path submodule status --recursive
        if ($subStatus -match '(?m)^[-+U]') { Write-Host "[submodule warning] $id has missing, changed or conflicted submodules"; $Failed = $true }
    }
}
if ($Failed) { throw 'Verification failed. See messages above.' }
Write-Host 'All fetched core repositories match the lockfile.'
