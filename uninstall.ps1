#Requires -Version 5.0
<#
.SYNOPSIS
    Claude Agent Dev Team — PowerShell Uninstaller
.DESCRIPTION
    Removes skills installed by install.ps1 from ~/.claude/skills/
.PARAMETER Yes
    Skip confirmation prompt
.EXAMPLE
    ./uninstall.ps1        # Prompt before removing
    ./uninstall.ps1 -Yes   # Remove without prompting
#>

[CmdletBinding()]
param(
    [switch]$Yes
)

$ErrorActionPreference = 'Stop'

$SkillsDir = Join-Path (Join-Path $HOME '.claude') 'skills'
$RetroDir = Join-Path $HOME 'retros'

$Skills = @(
    '_shared'
    'security-engineer'
    'it-architect'
    'project-manager'
    'project-engineer'
    'ux-designer'
    'code-reviewer'
    'database-engineer'
    'sre'
    'qa-engineer'
    'technical-writer'
    'retro'
    'team-plan'
    'team-review'
    'standup'
    'grooming'
    'spike'
    'postmortem'
    'onboard'
)

# Check if anything is installed
$found = 0
foreach ($skill in $Skills) {
    $target = Join-Path $SkillsDir $skill
    if (Test-Path $target) { $found++ }
}

if ($found -eq 0) {
    Write-Host "Nothing to uninstall - no Claude Agent Dev Team skills found in $SkillsDir"
    return
}

Write-Host "Found $found installed skill(s) in $SkillsDir"
Write-Host ''

if (-not $Yes) {
    $confirm = Read-Host 'Remove all Claude Agent Dev Team skills? [y/N]'
    if ($confirm -notmatch '^[Yy]$') {
        Write-Host 'Aborted.'
        return
    }
}

Write-Host ''
Write-Host 'Uninstalling Claude Agent Dev Team skills...'
$removed = 0
foreach ($skill in $Skills) {
    $target = Join-Path $SkillsDir $skill
    if (Test-Path $target) {
        Remove-Item $target -Recurse -Force
        Write-Host "  Removed: $skill"
        $removed++
    }
}

Write-Host ''
Write-Host "Done. Removed $removed skill(s) from $SkillsDir"
Write-Host "Note: $RetroDir was not removed (may contain your retrospectives)"
