param(
    [string]$Configuration = "Release",
    [string]$OutputDirectory = "dist",
    [string]$ZipName = "LOCLM-Windows-x64.zip",
    [switch]$SkipZip
)

$ErrorActionPreference = "Stop"

$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$rootWithSeparator = $root.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
$outBin = Join-Path $root "out\bin"
$outLoclm = Join-Path $outBin "loclm"
$dist = Join-Path $root $OutputDirectory

function Remove-WorkspacePath {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return
    }

    $resolved = (Resolve-Path $Path).Path
    if (-not $resolved.Equals($root, [StringComparison]::OrdinalIgnoreCase) -and
        -not $resolved.StartsWith($rootWithSeparator, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to remove path outside workspace: $resolved"
    }

    Remove-Item -LiteralPath $resolved -Recurse -Force
}

dotnet restore (Join-Path $root "loclm-csharp\loclm-csharp.csproj")
dotnet restore (Join-Path $root "mod_template\CreatureProbe.csproj")
dotnet build (Join-Path $root "loclm-csharp\loclm-csharp.csproj") -c $Configuration --no-restore
dotnet build (Join-Path $root "mod_template\CreatureProbe.csproj") -c $Configuration --no-restore

cmake -S $root -B (Join-Path $root "build\x64")
cmake --build (Join-Path $root "build\x64") --config $Configuration --target loclm-cxx

Remove-WorkspacePath $outLoclm
New-Item -ItemType Directory -Force -Path $outLoclm | Out-Null

$managedOutput = Join-Path $root "loclm-csharp\bin\$Configuration\net10.0"
Copy-Item -Force -Recurse (Join-Path $managedOutput "*") $outLoclm
New-Item -ItemType Directory -Force -Path (Join-Path $outLoclm "mods") | Out-Null

$proxyDll = Join-Path $root "build\x64\loclm-cxx\$Configuration\version.dll"
if (-not (Test-Path $proxyDll)) {
    throw "Missing built proxy DLL: $proxyDll"
}

New-Item -ItemType Directory -Force -Path $outBin | Out-Null
Copy-Item -Force $proxyDll (Join-Path $outBin "version.dll")

if ($SkipZip) {
    return
}

Remove-WorkspacePath $dist
New-Item -ItemType Directory -Force -Path $dist | Out-Null

$zipPath = Join-Path $dist $ZipName
Compress-Archive -Path (Join-Path $outBin "*") -DestinationPath $zipPath -Force

$hash = Get-FileHash -Algorithm SHA256 $zipPath
"$($hash.Hash)  $ZipName" | Set-Content -Encoding ascii (Join-Path $dist "checksums.txt")
