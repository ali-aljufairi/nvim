param(
    [string]$Product = "Code",
    [string]$SourceDir = $PSScriptRoot,
    [string]$UserDir,
    [ValidateSet("Auto", "Link", "Copy")]
    [string]$Mode = "Auto"
)

$ErrorActionPreference = "Stop"
$timestamp = Get-Date -Format "yyyyMMddHHmmss"

if (-not $UserDir) {
    switch ($Product) {
        "Code" { $UserDir = Join-Path $env:APPDATA "Code\User" }
        "Code - Insiders" { $UserDir = Join-Path $env:APPDATA "Code - Insiders\User" }
        "VSCodium" { $UserDir = Join-Path $env:APPDATA "VSCodium\User" }
        "Cursor" { $UserDir = Join-Path $env:APPDATA "Cursor\User" }
        default { $UserDir = Join-Path $env:APPDATA "$Product\User" }
    }
}

New-Item -ItemType Directory -Force -Path $UserDir | Out-Null

function Link-File {
    param(
        [string]$SourceFile,
        [string]$TargetFile
    )

    if (-not (Test-Path -LiteralPath $SourceFile)) {
        return
    }

    $sourceItem = Get-Item -LiteralPath $SourceFile -Force
    $resolvedSource = $sourceItem.FullName
    $tempTarget = "$TargetFile.new.$timestamp"

    if (Test-Path -LiteralPath $tempTarget) {
        Remove-Item -LiteralPath $tempTarget -Force
    }

    if (Test-Path -LiteralPath $TargetFile) {
        $item = Get-Item -LiteralPath $TargetFile -Force
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            if ($item.Target -eq $resolvedSource) {
                Write-Host "Already linked: $TargetFile"
                return
            }
        }
    }

    $shouldCopy = $Mode -eq "Copy" -or $resolvedSource.StartsWith("\\wsl$\") -or $resolvedSource.StartsWith("\\wsl.localhost\")
    $publishedAsLink = $false

    if (-not $shouldCopy) {
        try {
            New-Item -ItemType SymbolicLink -Path $tempTarget -Target $resolvedSource | Out-Null
            $publishedAsLink = $true
        }
        catch {
            if ($Mode -eq "Link") {
                throw
            }
        }
    }

    if (-not $publishedAsLink) {
        Copy-Item -LiteralPath $resolvedSource -Destination $tempTarget -Force
    }

    if (Test-Path -LiteralPath $TargetFile) {
        Rename-Item -LiteralPath $TargetFile -NewName ((Split-Path $TargetFile -Leaf) + ".backup.$timestamp")
    }

    Move-Item -LiteralPath $tempTarget -Destination $TargetFile -Force

    if ($publishedAsLink) {
        Write-Host "Linked $TargetFile -> $resolvedSource"
    }
    else {
        Write-Host "Copied $resolvedSource -> $TargetFile"
    }
}

Link-File -SourceFile (Join-Path $SourceDir "settings.json") -TargetFile (Join-Path $UserDir "settings.json")
Link-File -SourceFile (Join-Path $SourceDir "keybindings.json") -TargetFile (Join-Path $UserDir "keybindings.json")
Link-File -SourceFile (Join-Path $SourceDir "mcp.json") -TargetFile (Join-Path $UserDir "mcp.json")