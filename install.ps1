#requires -Version 5.1
$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsDir = Join-Path $ScriptDir 'skills'

$ClaudeSkills = Join-Path $env:USERPROFILE '.claude\skills'
$AgentsSkills = Join-Path $env:USERPROFILE '.agents\skills'

New-Item -ItemType Directory -Force -Path $ClaudeSkills, $AgentsSkills | Out-Null

function New-LinkOrJunction {
    param([string]$Path, [string]$Target)
    if (Test-Path -LiteralPath $Path) {
        $item = Get-Item -LiteralPath $Path -Force
        if ($item.LinkType) {
            (Get-Item -LiteralPath $Path -Force).Delete()
        } else {
            Remove-Item -LiteralPath $Path -Recurse -Force
        }
    }
    try {
        New-Item -ItemType SymbolicLink -Path $Path -Target $Target -ErrorAction Stop | Out-Null
        return 'symlink'
    } catch {
        New-Item -ItemType Junction -Path $Path -Target $Target | Out-Null
        return 'junction'
    }
}

Write-Host "Installing skills from $SkillsDir..."

$count = 0
Get-ChildItem -LiteralPath $SkillsDir -Directory | ForEach-Object {
    $name = $_.Name
    $kind1 = New-LinkOrJunction -Path (Join-Path $ClaudeSkills $name) -Target $_.FullName
    $kind2 = New-LinkOrJunction -Path (Join-Path $AgentsSkills $name) -Target $_.FullName
    $kind  = if ($kind1 -eq $kind2) { $kind1 } else { "$kind1/$kind2" }
    Write-Host "  ok $name ($kind)"
    $count++
}

Write-Host ""
Write-Host "Done. Installed $count skills."
Write-Host "To update - git pull (links point at the repo, no re-install needed)."
