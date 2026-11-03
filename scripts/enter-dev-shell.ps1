[CmdletBinding()]
param(
    [string]$QtRoot = $env:LISTENFREE_QT_ROOT,
    [string]$VcpkgRoot = $env:VCPKG_ROOT,
    [string]$QtToolsRoot = $env:LISTENFREE_QT_TOOLS_ROOT,
    [switch]$Quiet
)
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($QtRoot) -or [string]::IsNullOrWhiteSpace($QtToolsRoot)) {
    throw 'Set LISTENFREE_QT_ROOT and LISTENFREE_QT_TOOLS_ROOT (or pass QtRoot and QtToolsRoot). No developer-machine toolchain path is assumed.'
}
if ([string]::IsNullOrWhiteSpace($VcpkgRoot)) {
    $VcpkgRoot = Join-Path (Split-Path $PSScriptRoot -Parent) '_vendor\vcpkg'
}
$toolRoots = [ordered]@{
    Qt = $QtRoot
    CMake = (Join-Path $QtToolsRoot 'CMake_64\bin')
    Ninja = (Join-Path $QtToolsRoot 'Ninja')
    Compiler = (Join-Path $QtToolsRoot 'mingw1310_64\bin')
}
foreach ($entry in $toolRoots.GetEnumerator()) {
    if (-not (Test-Path -LiteralPath $entry.Value -PathType Container)) {
        throw "ListenFree toolchain component '$($entry.Key)' was not found at '$($entry.Value)'."
    }
}
if (-not (Test-Path -LiteralPath (Join-Path $VcpkgRoot 'vcpkg.exe') -PathType Leaf)) {
    throw "ListenFree vcpkg executable was not found at '$VcpkgRoot'."
}
$env:LISTENFREE_QT_ROOT = $QtRoot
$env:LISTENFREE_QT_TOOLS_ROOT = $QtToolsRoot
$env:QT_ROOT = $QtRoot
$env:CMAKE_PREFIX_PATH = $QtRoot
$env:QT_HOST_PATH = $QtRoot
$env:VCPKG_ROOT = $VcpkgRoot
$env:VCPKG_DEFAULT_TRIPLET = 'x64-mingw-dynamic'
$env:VCPKG_DEFAULT_HOST_TRIPLET = 'x64-mingw-dynamic'
$pathEntries = @((Join-Path $QtRoot 'bin'), $toolRoots.CMake, $toolRoots.Ninja, $toolRoots.Compiler)
$env:Path = (($pathEntries + ($env:Path -split ';')) | Select-Object -Unique) -join ';'
if (-not $Quiet) {
    Write-Output "ListenFree Windows toolchain: Qt=$QtRoot; tools=$QtToolsRoot; vcpkg=$VcpkgRoot"
}
