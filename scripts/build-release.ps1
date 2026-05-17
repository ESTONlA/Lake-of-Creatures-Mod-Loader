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

function Assert-PathExists {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        throw "Missing required release file/folder: $Path"
    }
}

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

Remove-WorkspacePath $outBin
New-Item -ItemType Directory -Force -Path $outLoclm | Out-Null

$managedOutput = Join-Path $root "loclm-csharp\bin\$Configuration\net10.0"
Assert-PathExists $managedOutput
Get-ChildItem -LiteralPath $managedOutput -Force | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $outLoclm -Force -Recurse
}
New-Item -ItemType Directory -Force -Path (Join-Path $outLoclm "mods") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $outLoclm "Logs") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $outLoclm "disabled_mods") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $outLoclm "quarantine") | Out-Null

$proxyDll = Join-Path $root "build\x64\loclm-cxx\$Configuration\version.dll"
Assert-PathExists $proxyDll

New-Item -ItemType Directory -Force -Path $outBin | Out-Null
Copy-Item -Force $proxyDll (Join-Path $outBin "version.dll")

$requiredOutput = @(
    (Join-Path $outBin "version.dll"),
    (Join-Path $outLoclm "loclm-csharp.exe"),
    (Join-Path $outLoclm "loclm-csharp.dll"),
    (Join-Path $outLoclm "loclm-csharp.runtimeconfig.json"),
    (Join-Path $outLoclm "UndertaleModLib.dll"),
    (Join-Path $outLoclm "supported_game_builds.json"),
    (Join-Path $outLoclm "assets\gml\runtime_logger.gml"),
    (Join-Path $outLoclm "mods"),
    (Join-Path $outLoclm "Logs"),
    (Join-Path $outLoclm "disabled_mods"),
    (Join-Path $outLoclm "quarantine")
)

foreach ($path in $requiredOutput) {
    Assert-PathExists $path
}

if ($SkipZip) {
    return
}

Remove-WorkspacePath $dist
New-Item -ItemType Directory -Force -Path $dist | Out-Null

$zipPath = Join-Path $dist $ZipName
Compress-Archive -Path (Join-Path $outBin "*") -DestinationPath $zipPath -Force
Assert-PathExists $zipPath

Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($zipPath)
try {
    $entries = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($entry in $zip.Entries) {
        [void]$entries.Add($entry.FullName.Replace("\", "/"))
    }

    $requiredZipEntries = @(
        "version.dll",
        "loclm/loclm-csharp.exe",
        "loclm/loclm-csharp.dll",
        "loclm/loclm-csharp.runtimeconfig.json",
        "loclm/UndertaleModLib.dll",
        "loclm/supported_game_builds.json",
        "loclm/assets/gml/runtime_logger.gml"
    )

    foreach ($entry in $requiredZipEntries) {
        if (-not $entries.Contains($entry)) {
            throw "Release zip is missing required entry: $entry"
        }
    }
}
finally {
    $zip.Dispose()
}

$hash = Get-FileHash -Algorithm SHA256 $zipPath
"$($hash.Hash)  $ZipName" | Set-Content -Encoding ascii (Join-Path $dist "checksums.txt")
