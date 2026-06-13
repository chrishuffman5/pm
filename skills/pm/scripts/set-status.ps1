#requires -Version 7.0
<#
.SYNOPSIS
  Change the Status of a PM-tree node (epic / feature / story) and keep everything in step.

.DESCRIPTION
  A status change is the one edit that must never drift: downstream agents read Status to
  decide whether they can depend on this work, and the HTML tracker rolls it up. This script
  makes the change atomic — in one call it:

    1. Rewrites the **Status:** line in the node's CLAUDE.md.
    2. Bumps **Last updated:** to today.
    3. Appends a timestamped entry to the node's "## Status log" (creating the section if
       absent) so the file carries a full history: Created -> In progress -> (intermediate) ->
       Done. An optional -Note records why the transition happened.
    4. Regenerates the HTML tracker (unless -NoHtml) so the sibling .html and the parent
       rollups reflect the new state immediately.

  CLAUDE.md stays the single source of truth; this script only writes the metadata lines and
  the log, never the body. Use it instead of hand-editing the Status: line so the timestamped
  history is always captured.

.PARAMETER Path
  Path to the node's CLAUDE.md (a feature, story, or epic charter). The file must already have
  a **Status:** line.

.PARAMETER Status
  The new status. Conventional vocabulary: Not started, In progress, Blocked, Done, Cancelled.
  Other values are allowed but warned about, so a typo doesn't silently become a new status.

.PARAMETER Note
  Optional free text appended to the log entry — e.g. "blocked on RealTracs API key",
  "merged PR #42". This is the per-transition note-taking surface.

.PARAMETER NoHtml
  Skip the HTML regeneration step (e.g. when batching several status changes; regenerate once
  at the end with build-pm-html.ps1).

.EXAMPLE
  pwsh set-status.ps1 -Path pm/E100/F1004/US10402/CLAUDE.md -Status "In progress"
.EXAMPLE
  pwsh set-status.ps1 -Path pm/E100/F1004/CLAUDE.md -Status "Done" -Note "all 9 stories merged"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][string]$Status,
    [string]$Note,
    [switch]$NoHtml
)

$ErrorActionPreference = 'Stop'

$claude = (Resolve-Path -LiteralPath $Path).Path
if (-not (Test-Path -LiteralPath $claude -PathType Leaf)) { throw "Not a file: $claude" }

$known = @('Not started', 'In progress', 'Blocked', 'Done', 'Cancelled')
if ($Status -notin $known) {
    Write-Warning "Status '$Status' is not one of the conventional values ($($known -join ', ')). Writing it anyway."
}

# Timestamps: UTC ISO-8601 to the minute (sortable, unambiguous) for the log; local date for Last updated.
$stamp = [DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mmZ')
$today = (Get-Date).ToString('yyyy-MM-dd')

# Preserve the file's existing newline style so we don't churn line endings in git.
$raw = [System.IO.File]::ReadAllText($claude)
$nl = if ($raw -match "`r`n") { "`r`n" } else { "`n" }
$lines = [System.Collections.Generic.List[string]]($raw -split "`r?`n")

# --- 1. Rewrite **Status:** (search the head; it lives in the first ~15 metadata lines) ---
$statusIdx = -1
for ($i = 0; $i -lt [Math]::Min(20, $lines.Count); $i++) {
    if ($lines[$i] -match '^\*\*Status:\*\*') { $statusIdx = $i; break }
}
if ($statusIdx -lt 0) { throw "No '**Status:**' line found in $claude — is this an epic/feature/story CLAUDE.md?" }
$prevStatus = ($lines[$statusIdx] -replace '^\*\*Status:\*\*\s*', '').Trim()
$lines[$statusIdx] = "**Status:** $Status"

# --- 2. Bump or insert **Last updated:** ---
$updIdx = -1
for ($i = 0; $i -lt [Math]::Min(20, $lines.Count); $i++) {
    if ($lines[$i] -match '^\*\*Last updated:\*\*') { $updIdx = $i; break }
}
if ($updIdx -ge 0) { $lines[$updIdx] = "**Last updated:** $today" }
else { $lines.Insert($statusIdx + 1, "**Last updated:** $today") }

# --- 3. Append a "## Status log" entry ---
$entry = if ($Note) { "- $stamp — $Status — $Note" } else { "- $stamp — $Status" }
$logIdx = -1
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^##\s+Status log\s*$') { $logIdx = $i; break }
}
if ($logIdx -ge 0) {
    # Insert after the last consecutive bullet in the existing log section.
    $j = $logIdx + 1
    $lastBullet = $logIdx
    while ($j -lt $lines.Count -and $lines[$j] -notmatch '^##\s') {
        if ($lines[$j] -match '^\s*-\s') { $lastBullet = $j }
        $j++
    }
    $lines.Insert($lastBullet + 1, $entry)
}
else {
    # Create the section at end of file.
    if ($lines.Count -gt 0 -and $lines[$lines.Count - 1].Trim() -ne '') { $lines.Add('') }
    $lines.Add('## Status log')
    $lines.Add($entry)
}

[System.IO.File]::WriteAllText($claude, ($lines -join $nl), [System.Text.UTF8Encoding]::new($false))
Write-Host "Status: '$prevStatus' -> '$Status'  ($stamp)" -ForegroundColor Yellow
Write-Host "  $claude"

# --- 4. Regenerate the HTML tracker ---
if (-not $NoHtml) {
    # Walk up from the node to find the pm root: the ancestor that holds build-pm-html.ps1.
    $dir = Split-Path -Parent $claude
    $gen = $null
    while ($dir) {
        $candidate = Join-Path $dir 'build-pm-html.ps1'
        if (Test-Path -LiteralPath $candidate) { $gen = $candidate; break }
        $parent = Split-Path -Parent $dir
        if ($parent -eq $dir) { break }
        $dir = $parent
    }
    if ($gen) {
        & $gen -Path (Split-Path -Parent $gen)
    }
    else {
        Write-Warning "No build-pm-html.ps1 found in any parent of the node; skipped HTML regen. (Run build-pm-html.ps1 manually, or pass -NoHtml to silence this.)"
    }
}
