#requires -Version 7.0
<#
.SYNOPSIS
  Generates a "mini-Rally" HTML tracker from a pm/ CLAUDE.md tree.

.DESCRIPTION
  CLAUDE.md is the single source of truth. This generator walks a pm root containing
  E<NNN> epic folders (Epic -> Feature -> User Story), parses each item's Status +
  acceptance-criteria checkboxes for progress rollups, renders the markdown body to
  HTML, and emits a sibling HTML page next to every CLAUDE.md plus a portfolio
  index.html at the pm root.

  /pm:init installs a copy of this script into the target repo at <repo>/pm/build-pm-html.ps1
  so the project has a self-contained, project-agnostic generator. Re-run it after editing
  any CLAUDE.md to refresh the HTML (the pm and /pm:plan skills do this automatically).
  Output is static, offline, dependency-free: double-click any .html.

.PARAMETER Path
  The pm root: a folder that directly contains the E<NNN> epic folders (e.g. <repo>/pm).
  If omitted, auto-detects: ./pm when that holds epic folders, else the current directory
  when it does, else errors.

.PARAMETER ProjectName
  Brand shown in the topbar, page <title>, footer, and portfolio hero heading. If omitted,
  defaults to the name of the repo folder that contains the pm root (e.g. "winnie" for
  C:\repo\winnie\pm).

.PARAMETER Lede
  One-line subtitle shown under the portfolio heading on index.html. If omitted, a generic
  tagline is used.

.EXAMPLE
  pwsh build-pm-html.ps1 -Path C:\repo\pm -ProjectName "landfinder" -Lede "Daily land scanner for Middle TN."
.EXAMPLE
  cd C:\repo ; pwsh pm\build-pm-html.ps1   # auto-detects .\pm and the repo folder name
#>
[CmdletBinding()]
param(
    [string]$Path,
    [string]$ProjectName,
    [string]$Lede
)

$ErrorActionPreference = 'Stop'

function Resolve-PmRoot([string]$p) {
    $hasEpics = { param($d) @(Get-ChildItem -LiteralPath $d -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -match '^E\d+$' }).Count -gt 0 }
    if ($p) {
        $rp = (Resolve-Path $p).Path
        if (-not (& $hasEpics $rp)) { throw "No E<NNN> epic folders under -Path '$rp'." }
        return $rp
    }
    $cwd = (Get-Location).Path
    $pm = Join-Path $cwd 'pm'
    if ((Test-Path $pm) -and (& $hasEpics $pm)) { return (Resolve-Path $pm).Path }
    if (& $hasEpics $cwd) { return $cwd }
    throw "Could not locate a pm root (a folder containing E<NNN> epic dirs). Pass -Path <repo>/pm."
}
$pmDir = Resolve-PmRoot $Path

# Project branding: default to the repo folder name (parent of the pm root) and a generic lede.
if (-not $ProjectName) {
    $parent = Split-Path -Parent $pmDir
    $ProjectName = if ($parent) { Split-Path -Leaf $parent } else { 'pm' }
}
if (-not $Lede) {
    $Lede = 'Live progress across every epic, feature, and user story &mdash; rendered straight from the CLAUDE.md tree.'
}

# ---------------------------------------------------------------------------
# Markdown -> HTML (targeted to the subset used by the CLAUDE.md templates)
# ---------------------------------------------------------------------------
function Format-Inline([string]$text) {
    $t = $text -replace '&', '&amp;' -replace '<', '&lt;' -replace '>', '&gt;'
    $t = $t -replace '`([^`]+?)`', '<code>$1</code>'
    $t = $t -replace '\*\*([^*]+?)\*\*', '<strong>$1</strong>'
    $t = $t -replace '\[([^\]]+?)\]\(([^)]+?)\)', '<a href="$2">$1</a>'
    return $t
}

function Convert-Markdown([string[]]$lines) {
    $sb = [System.Text.StringBuilder]::new()
    $i = 0; $n = $lines.Count
    while ($i -lt $n) {
        $line = $lines[$i]

        # fenced code block
        if ($line -match '^\s*```') {
            $i++; $code = @()
            while ($i -lt $n -and $lines[$i] -notmatch '^\s*```') { $code += $lines[$i]; $i++ }
            $i++
            $enc = ($code | ForEach-Object { $_ -replace '&', '&amp;' -replace '<', '&lt;' -replace '>', '&gt;' }) -join "`n"
            [void]$sb.Append("<pre><code>$enc</code></pre>`n"); continue
        }
        # heading
        if ($line -match '^(#{1,6})\s+(.*)$') {
            $lvl = $Matches[1].Length
            [void]$sb.Append("<h$lvl>$(Format-Inline $Matches[2])</h$lvl>`n"); $i++; continue
        }
        # horizontal rule
        if ($line -match '^\s*---\s*$') { [void]$sb.Append("<hr/>`n"); $i++; continue }
        # blockquote
        if ($line -match '^\s*>\s?(.*)$') {
            $q = @()
            while ($i -lt $n -and $lines[$i] -match '^\s*>\s?(.*)$') { $q += (Format-Inline $Matches[1]); $i++ }
            [void]$sb.Append('<blockquote>' + ($q -join '<br/>') + "</blockquote>`n"); continue
        }
        # table
        if ($line -match '^\s*\|') {
            $tbl = @()
            while ($i -lt $n -and $lines[$i] -match '^\s*\|') { $tbl += $lines[$i]; $i++ }
            $cellsOf = {
                param($r)
                ($r.Trim() -replace '^\|', '' -replace '\|$', '').Split('|') | ForEach-Object { Format-Inline ($_.Trim()) }
            }
            [void]$sb.Append('<table><thead><tr>')
            foreach ($c in (& $cellsOf $tbl[0])) { [void]$sb.Append("<th>$c</th>") }
            [void]$sb.Append('</tr></thead><tbody>')
            for ($k = 1; $k -lt $tbl.Count; $k++) {
                if ($tbl[$k] -match '^[\s:\|\-]+$') { continue }   # separator row
                [void]$sb.Append('<tr>')
                foreach ($c in (& $cellsOf $tbl[$k])) { [void]$sb.Append("<td>$c</td>") }
                [void]$sb.Append('</tr>')
            }
            [void]$sb.Append("</tbody></table>`n"); continue
        }
        # list (one level of nesting + checkbox detection)
        if ($line -match '^(\s*)- (.*)$') {
            $items = @()
            while ($i -lt $n -and $lines[$i] -match '^(\s*)- (.*)$') { $items += $lines[$i]; $i++ }
            [void]$sb.Append("<ul>`n"); $subOpen = $false
            foreach ($it in $items) {
                $null = $it -match '^(\s*)- (.*)$'
                $indent = $Matches[1].Length; $raw = $Matches[2]
                if ($raw -match '^\[( |x|X)\]\s*(.*)$') {
                    $done = $Matches[1] -ne ' '
                    $rest = Format-Inline $Matches[2]
                    $cls = if ($done) { 'ac done' } else { 'ac' }
                    $mark = if ($done) { '&#10003;' } else { '' }
                    $li = "<li class=`"$cls`"><span class=`"box`">$mark</span><span>$rest</span></li>"
                }
                else { $li = '<li>' + (Format-Inline $raw) + '</li>' }
                if ($indent -ge 2) {
                    if (-not $subOpen) { [void]$sb.Append("<ul class=`"sub`">`n"); $subOpen = $true }
                    [void]$sb.Append("$li`n")
                }
                else {
                    if ($subOpen) { [void]$sb.Append("</ul>`n"); $subOpen = $false }
                    [void]$sb.Append("$li`n")
                }
            }
            if ($subOpen) { [void]$sb.Append("</ul>`n") }
            [void]$sb.Append("</ul>`n"); continue
        }
        # blank
        if ($line -match '^\s*$') { $i++; continue }
        # paragraph
        $para = @()
        while ($i -lt $n -and $lines[$i] -notmatch '^\s*$' -and
            $lines[$i] -notmatch '^(#{1,6}\s|\s*>|\s*\||\s*- |\s*```|\s*---\s*$)') {
            $para += (Format-Inline $lines[$i]); $i++
        }
        if ($para.Count) { [void]$sb.Append('<p>' + ($para -join ' ') + "</p>`n") }
    }
    return $sb.ToString()
}

# ---------------------------------------------------------------------------
# Parse one CLAUDE.md into metadata + rendered body
# ---------------------------------------------------------------------------
function Get-Meta([string]$claudePath, [string]$idFallback) {
    $lines = @(Get-Content -LiteralPath $claudePath -Encoding utf8)
    $title = $idFallback; $status = $null; $phase = $null; $depends = $null; $updated = $null; $model = $null

    for ($k = 0; $k -lt [Math]::Min(3, $lines.Count); $k++) {
        if ($lines[$k] -match '^#\s+(.+?)\s*$') { $title = $Matches[1]; break }
    }
    $head = $lines[0..([Math]::Min(15, $lines.Count - 1))]
    foreach ($l in $head) {
        if ($l -match '^\*\*Status:\*\*\s*(.+?)\s*$') { $status = $Matches[1] }
        elseif ($l -match '^\*\*Phase:\*\*\s*(.+?)\s*$') { $phase = $Matches[1] }
        elseif ($l -match '^\*\*Depends on:\*\*\s*(.+?)\s*$') { $depends = $Matches[1] }
        elseif ($l -match '^\*\*Last updated:\*\*\s*(.+?)\s*$') { $updated = $Matches[1] }
        elseif ($l -match '^\*\*Model:\*\*\s*(.+?)\s*$') { $model = $Matches[1] }
    }

    # acceptance-criteria checkboxes, ignoring fenced code blocks (epic charter has template placeholders)
    $acTotal = 0; $acDone = 0; $inFence = $false
    foreach ($l in $lines) {
        if ($l -match '^\s*```') { $inFence = -not $inFence; continue }
        if ($inFence) { continue }
        if ($l -match '^\s*- \[( |x|X)\]') { $acTotal++; if ($Matches[1] -ne ' ') { $acDone++ } }
    }

    # status-log timestamps (Created / first In progress / Done), parsed from a "## Status log" section.
    # Entries look like: "- 2026-06-13T18:42Z — In progress — optional note". Dash may be -, en-, or em-dash.
    $created = $null; $started = $null; $completed = $null; $firstTs = $null; $inLog = $false
    foreach ($l in $lines) {
        if ($l -match '^##\s') { $inLog = [bool]($l -match '^##\s+Status log\s*$'); continue }
        if (-not $inLog) { continue }
        if ($l -match '^\s*-\s+(\S+)\s+[–—-]\s+(.+)$') {
            $ts = $Matches[1]
            $st = (($Matches[2] -split '\s+[–—-]\s+', 2)[0]).Trim()
            if (-not $firstTs) { $firstTs = $ts }
            switch -regex ($st) {
                'Created|Not started' { $created = $ts }
                'In progress' { if (-not $started) { $started = $ts } }
                'Done' { $completed = $ts }
            }
        }
    }
    if (-not $created) { $created = $firstTs }

    # body = everything except the first H1 and the **metadata:** lines
    $body = @(); $skippedH1 = $false
    foreach ($l in $lines) {
        if (-not $skippedH1 -and $l -match '^#\s+') { $skippedH1 = $true; continue }
        if ($l -match '^\*\*(Phase|Status|Depends on|Last updated|Feature|Effort|Story|Model):\*\*') { continue }
        $body += $l
    }

    [pscustomobject]@{
        Title = $title; Status = $status; Phase = $phase; Depends = $depends; Updated = $updated; Model = $model
        Created = $created; Started = $started; Completed = $completed
        AcTotal = $acTotal; AcDone = $acDone; Body = (Convert-Markdown $body)
    }
}

# created / started / done chips, built from the parsed status log (empty when no log present)
function TimeChips($m) {
    $c = ''
    if ($m.Created) { $c += "<span class=`"chip`">created <b>$($m.Created)</b></span>" }
    if ($m.Started) { $c += "<span class=`"chip`">started <b>$($m.Started)</b></span>" }
    if ($m.Completed) { $c += "<span class=`"chip`">done <b>$($m.Completed)</b></span>" }
    $c
}

# ---------------------------------------------------------------------------
# Small view helpers
# ---------------------------------------------------------------------------
function StatusKey([string]$s) {
    switch -regex ($s) { 'Done' { 'done' } 'In progress' { 'wip' } default { 'todo' } }
}
function StatusText([string]$s) { if ($s) { $s } else { 'Not started' } }
function Pct([int]$d, [int]$t) { if ($t -gt 0) { [math]::Round(100 * $d / $t) } else { 0 } }
function Badge([string]$s) {
    $k = StatusKey $s
    "<span class=`"badge $k`"><i class=`"ico`"></i>$(StatusText $s)</span>"
}
function Bar([int]$d, [int]$t) { "<div class=`"bar`"><span style=`"width:$(Pct $d $t)%`"></span></div>" }

$Css = @'
:root{
 --ink:#0e0f13;--ink2:#14161c;--surface:#181b22;--surface2:#1e222b;
 --line:#2a2f3a;--line2:#384050;--text:#e9eaee;--muted:#9aa0ab;--faint:#6b7280;
 --gold:#e8b14c;--gold-bright:#f4cd7e;--gold-dim:#b9893a;
 --done:#5fb87a;--wip:#e8b14c;--todo:#6b7280;
 --mono:'JetBrains Mono','Cascadia Mono','Consolas',ui-monospace,monospace;
 --serif:'Fraunces','Georgia','Hoefler Text',serif;
 --sans:system-ui,'Segoe UI',-apple-system,sans-serif;
}
*{box-sizing:border-box}html{scroll-behavior:smooth}
body{margin:0;background:var(--ink);color:var(--text);font-family:var(--sans);line-height:1.6;
 background-image:radial-gradient(1200px 520px at 82% -12%,rgba(232,177,76,.10),transparent 60%),
  linear-gradient(rgba(255,255,255,.022) 1px,transparent 1px),
  linear-gradient(90deg,rgba(255,255,255,.022) 1px,transparent 1px);
 background-size:auto,44px 44px,44px 44px;background-attachment:fixed;}
a{color:var(--gold);text-decoration:none}a:hover{color:var(--gold-bright)}
.wrap{max-width:1080px;margin:0 auto;padding:0 28px 40px}
.topbar{position:sticky;top:0;z-index:20;backdrop-filter:blur(9px);
 background:linear-gradient(180deg,rgba(14,15,19,.94),rgba(14,15,19,.74));border-bottom:1px solid var(--line)}
.topbar .wrap{padding:13px 28px;display:flex;align-items:center;gap:16px}
.brand{font-family:var(--mono);font-weight:700;letter-spacing:.22em;text-transform:uppercase;font-size:12.5px;color:var(--gold);white-space:nowrap}
.brand .sp{color:var(--faint);margin-left:2px}
.crumb{font-family:var(--mono);font-size:12.5px;color:var(--muted);display:flex;gap:9px;flex-wrap:wrap;align-items:center}
.crumb a{color:var(--muted)}.crumb a:hover{color:var(--gold)}.crumb .sep{color:var(--gold-dim)}.crumb .cur{color:var(--text)}
.hero{padding:54px 0 32px;border-bottom:1px solid var(--line)}
.eyebrow{font-family:var(--mono);font-size:11.5px;letter-spacing:.24em;text-transform:uppercase;color:var(--gold-dim)}
.title{font-family:var(--serif);font-weight:600;font-size:clamp(30px,5vw,52px);line-height:1.04;margin:.22em 0 .05em;letter-spacing:-.012em}
.lede{color:var(--muted);max-width:60ch;margin:.4em 0 0}
.metarow{display:flex;gap:10px;flex-wrap:wrap;align-items:center;margin-top:20px}
.badge{font-family:var(--mono);font-size:11px;letter-spacing:.08em;text-transform:uppercase;padding:5px 11px;border-radius:999px;border:1px solid var(--line2);display:inline-flex;gap:7px;align-items:center;color:#aab0bb}
.badge .ico{width:7px;height:7px;border-radius:50%;background:var(--todo)}
.badge.done{color:#bfe9cd;border-color:rgba(95,184,122,.40);background:rgba(95,184,122,.08)}.badge.done .ico{background:var(--done)}
.badge.wip{color:#f6dca2;border-color:rgba(232,177,76,.42);background:rgba(232,177,76,.09)}.badge.wip .ico{background:var(--wip);animation:pulse 2s infinite}
.badge.todo .ico{background:var(--todo)}
@keyframes pulse{0%{box-shadow:0 0 0 0 rgba(232,177,76,.5)}70%{box-shadow:0 0 0 6px rgba(232,177,76,0)}100%{box-shadow:0 0 0 0 rgba(232,177,76,0)}}
.chip{font-family:var(--mono);font-size:11.5px;color:var(--muted);padding:5px 11px;border:1px solid var(--line);border-radius:999px}
.chip b{color:var(--text);font-weight:500}
.bar{height:8px;border-radius:6px;background:var(--surface2);border:1px solid var(--line);overflow:hidden}
.bar>span{display:block;height:100%;background:linear-gradient(90deg,var(--gold-dim),var(--gold));border-radius:6px;transition:width 1s cubic-bezier(.2,.8,.2,1)}
.bigprog{margin-top:24px;max-width:540px}
.bigprog .lab{display:flex;justify-content:space-between;font-family:var(--mono);font-size:12px;color:var(--muted);margin-bottom:8px}
.bigprog .lab b{color:var(--gold);font-weight:500}
.section-h{font-family:var(--mono);text-transform:uppercase;letter-spacing:.18em;font-size:12px;color:var(--faint);margin:46px 0 18px;display:flex;align-items:center;gap:14px}
.section-h::after{content:"";height:1px;flex:1;background:var(--line)}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(304px,1fr));gap:16px}
.card{display:block;background:linear-gradient(180deg,var(--surface),var(--ink2));border:1px solid var(--line);border-radius:14px;padding:20px 20px 18px;position:relative;overflow:hidden;opacity:0;transform:translateY(10px);animation:rise .6s forwards}
.card::before{content:"";position:absolute;left:0;top:0;bottom:0;width:3px;background:var(--todo)}
.card.done::before{background:var(--done)}.card.wip::before{background:var(--wip)}.card.todo::before{background:var(--todo)}
.card:hover{border-color:var(--line2);transform:translateY(3px);box-shadow:0 20px 44px -24px rgba(0,0,0,.85)}
.card .cid{font-family:var(--mono);font-size:12px;color:var(--gold);letter-spacing:.06em}
.card .ctitle{font-family:var(--serif);font-size:21px;font-weight:600;margin:6px 0 0;line-height:1.13;color:var(--text)}
.card .cfoot{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-top:18px}
.card .cnt{font-family:var(--mono);font-size:11.5px;color:var(--muted);white-space:nowrap}
@keyframes rise{to{opacity:1;transform:none}}
.rows{display:flex;flex-direction:column;gap:8px}
.row{display:grid;grid-template-columns:104px 1fr auto;gap:18px;align-items:center;padding:14px 18px;background:var(--surface);border:1px solid var(--line);border-radius:11px;opacity:0;transform:translateY(8px);animation:rise .5s forwards}
.row:hover{border-color:var(--line2);background:var(--surface2)}
.row .rid{font-family:var(--mono);font-size:13px;color:var(--gold)}
.row .rtitle{font-size:15px;color:var(--text)}
.row .rmeta{display:flex;align-items:center;gap:16px;justify-self:end}
.row .acmini{font-family:var(--mono);font-size:11.5px;color:var(--muted);white-space:nowrap}
.row .bar{width:120px}
.prose{padding-top:8px;font-size:15.5px;color:#d7dade}
.prose h2{font-family:var(--serif);font-size:25px;font-weight:600;margin:40px 0 12px;color:var(--text);letter-spacing:-.01em}
.prose h3{font-family:var(--mono);text-transform:uppercase;letter-spacing:.12em;font-size:12.5px;color:var(--gold-dim);margin:30px 0 10px}
.prose p{margin:12px 0;color:#cfd3da}
.prose ul{list-style:none;padding-left:0;margin:12px 0}
.prose ul.sub{padding-left:24px;margin:4px 0}
.prose li{position:relative;padding-left:22px;margin:7px 0;color:#cfd3da}
.prose li::before{content:"\25B8";position:absolute;left:3px;top:1px;color:var(--gold-dim);font-size:12px}
.prose li.ac{padding-left:32px}.prose li.ac::before{content:none}
.prose li.ac .box{position:absolute;left:0;top:3px;width:17px;height:17px;border:1px solid var(--line2);border-radius:5px;display:inline-flex;align-items:center;justify-content:center;font-size:11px;color:transparent}
.prose li.ac.done .box{background:rgba(95,184,122,.16);border-color:var(--done);color:var(--done)}
.prose li.ac.done>span:last-child{color:#9fb6a6}
.prose code{font-family:var(--mono);font-size:.86em;background:var(--surface2);border:1px solid var(--line);padding:1.5px 6px;border-radius:5px;color:var(--gold-bright)}
.prose pre{background:var(--ink2);border:1px solid var(--line);border-radius:10px;padding:16px 18px;overflow:auto;margin:16px 0}
.prose pre code{background:none;border:none;padding:0;color:#cdd2da;font-size:13px;line-height:1.55}
.prose blockquote{border-left:3px solid var(--gold-dim);margin:16px 0;padding:4px 0 4px 18px;color:var(--muted);font-style:italic}
.prose table{width:100%;border-collapse:collapse;margin:18px 0;font-size:14px}
.prose th{font-family:var(--mono);font-size:11px;letter-spacing:.05em;text-transform:uppercase;text-align:left;color:var(--gold-dim);border-bottom:1px solid var(--line2);padding:9px 12px}
.prose td{border-bottom:1px solid var(--line);padding:9px 12px;color:#cfd3da;vertical-align:top}
.prose tr:hover td{background:var(--surface)}
.prose hr{border:none;border-top:1px solid var(--line);margin:26px 0}
.prose a{border-bottom:1px solid rgba(232,177,76,.28)}
.charter{margin-top:8px;border:1px solid var(--line);border-radius:14px;background:rgba(20,22,28,.5);overflow:hidden}
.charter>summary{cursor:pointer;list-style:none;padding:18px 22px;font-family:var(--mono);font-size:12px;letter-spacing:.16em;text-transform:uppercase;color:var(--muted);display:flex;align-items:center;gap:12px}
.charter>summary::-webkit-details-marker{display:none}
.charter>summary::before{content:"\25B6";color:var(--gold-dim);font-size:11px;transition:transform .2s}
.charter[open]>summary::before{transform:rotate(90deg)}
.charter>summary:hover{color:var(--gold)}
.charter .inner{padding:4px 24px 28px;border-top:1px solid var(--line)}
.sibs{display:flex;justify-content:space-between;gap:14px;margin-top:48px;padding-top:24px;border-top:1px solid var(--line)}
.sib{flex:1;max-width:49%;font-family:var(--mono);font-size:13px;padding:14px 16px;border:1px solid var(--line);border-radius:11px;color:var(--muted)}
.sib:hover{border-color:var(--line2);color:var(--text)}
.sib .dir{font-size:10.5px;color:var(--faint);letter-spacing:.12em;text-transform:uppercase;margin-bottom:3px}
.sib.next{text-align:right}.sib.disabled{opacity:.28;pointer-events:none}
.foot{margin-top:54px;padding-top:22px;border-top:1px solid var(--line);font-family:var(--mono);font-size:11px;color:var(--faint);display:flex;justify-content:space-between;flex-wrap:wrap;gap:12px}
.legend{display:flex;gap:18px;flex-wrap:wrap}.legend span{display:inline-flex;align-items:center;gap:7px}
.legend i{width:8px;height:8px;border-radius:50%;display:inline-block}
.i-done{background:var(--done)}.i-wip{background:var(--wip)}.i-todo{background:var(--todo)}
'@

$FontLink = '<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400;9..144,600;9..144,700&family=JetBrains+Mono:wght@400;500;700&display=swap" rel="stylesheet">'

function Write-Html([string]$file, [string]$html) {
    [System.IO.File]::WriteAllText($file, $html, [System.Text.UTF8Encoding]::new($false))
}

function Page([string]$pageTitle, [string]$crumbHtml, [string]$bodyHtml) {
    $brand = [System.Net.WebUtility]::HtmlEncode($ProjectName)
    $legend = '<div class="legend"><span><i class="i-done"></i>Done</span><span><i class="i-wip"></i>In&nbsp;progress</span><span><i class="i-todo"></i>Not&nbsp;started</span></div>'
    @"
<!DOCTYPE html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>$pageTitle &middot; $brand</title>
$FontLink
<style>$Css</style></head>
<body>
<div class="topbar"><div class="wrap"><span class="brand">$brand<span class="sp">//</span></span><nav class="crumb">$crumbHtml</nav></div></div>
<div class="wrap">
$bodyHtml
<div class="foot"><span>$brand pm tracker &middot; generated from CLAUDE.md</span>$legend</div>
</div></body></html>
"@
}

# ---------------------------------------------------------------------------
# Walk the tree
# ---------------------------------------------------------------------------
$epicDirs = Get-ChildItem -LiteralPath $pmDir -Directory | Where-Object { $_.Name -match '^E\d+$' } | Sort-Object Name
$model = foreach ($e in $epicDirs) {
    $eMeta = Get-Meta (Join-Path $e.FullName 'CLAUDE.md') $e.Name
    $features = foreach ($f in (Get-ChildItem -LiteralPath $e.FullName -Directory | Where-Object { $_.Name -match '^F\d+$' } | Sort-Object Name)) {
        $fMeta = Get-Meta (Join-Path $f.FullName 'CLAUDE.md') $f.Name
        $stories = foreach ($s in (Get-ChildItem -LiteralPath $f.FullName -Directory | Where-Object { $_.Name -match '^US\d+$' } | Sort-Object Name)) {
            $sMeta = Get-Meta (Join-Path $s.FullName 'CLAUDE.md') $s.Name
            [pscustomobject]@{ Id = $s.Name; Dir = $s.FullName; Meta = $sMeta }
        }
        $stories = @($stories)
        [pscustomobject]@{
            Id = $f.Name; Dir = $f.FullName; Meta = $fMeta; Stories = $stories
            Done = @($stories | Where-Object { (StatusKey $_.Meta.Status) -eq 'done' }).Count
            Wip = @($stories | Where-Object { (StatusKey $_.Meta.Status) -eq 'wip' }).Count
            Total = $stories.Count
        }
    }
    $features = @($features)
    [pscustomobject]@{
        Id = $e.Name; Dir = $e.FullName; Meta = $eMeta; Features = $features
        SDone = ($features | Measure-Object Done -Sum).Sum
        STotal = ($features | Measure-Object Total -Sum).Sum
        FDone = @($features | Where-Object { $_.Total -gt 0 -and $_.Done -eq $_.Total }).Count
    }
}
$model = @($model)

# Epic status is derived from its features
function EpicStatus($epic) {
    if ($epic.STotal -gt 0 -and $epic.SDone -eq $epic.STotal) { 'Done' }
    elseif ($epic.SDone -gt 0 -or ($epic.Features | Where-Object { (StatusKey $_.Meta.Status) -ne 'todo' })) { 'In progress' }
    else { 'Not started' }
}

# ---------------------------------------------------------------------------
# Emit: index (portfolio)
# ---------------------------------------------------------------------------
$gDone = ($model | Measure-Object SDone -Sum).Sum
$gTotal = ($model | Measure-Object STotal -Sum).Sum
$crumb = '<span class="cur">Portfolio</span>'
$cards = ''
$idx = 0
foreach ($e in $model) {
    $st = EpicStatus $e; $k = StatusKey $st; $delay = '{0:0.00}' -f ($idx * 0.06)
    $cards += @"
<a class="card $k" href="$($e.Id)/$($e.Id).html" style="animation-delay:${delay}s">
<div class="cid">$($e.Id)</div><div class="ctitle">$($e.Meta.Title)</div>
<div style="margin-top:16px">$(Bar $e.SDone $e.STotal)</div>
<div class="cfoot">$(Badge $st)<span class="cnt">$($e.FDone)/$($e.Features.Count) feat &middot; $($e.SDone)/$($e.STotal) stories</span></div></a>
"@
    $idx++
}
$brandHero = [System.Net.WebUtility]::HtmlEncode($ProjectName)
# The roadmap (pm/PLAN.md) is rendered into the portfolio page so this dashboard is the single
# overall status indicator across every epic, feature, and story.
$planPath = Join-Path $pmDir 'PLAN.md'
$roadmap = ''
if (Test-Path -LiteralPath $planPath) {
    $planHtml = Convert-Markdown (@(Get-Content -LiteralPath $planPath -Encoding utf8))
    $roadmap = "<div class=`"section-h`">Roadmap</div><details class=`"charter`"><summary>Read PLAN.md &mdash; the cross-feature roadmap</summary><div class=`"inner prose`">$planHtml</div></details>"
}
$body = @"
<div class="hero">
<div class="eyebrow">Project tracker</div>
<h1 class="title">$brandHero</h1>
<p class="lede">$Lede</p>
<div class="bigprog"><div class="lab"><span>Portfolio completion</span><span><b>$gDone</b> / $gTotal stories done</span></div>$(Bar $gDone $gTotal)</div>
</div>
<div class="section-h">Epics</div>
<div class="grid">$cards</div>
$roadmap
"@
Write-Html (Join-Path $pmDir 'index.html') (Page 'Portfolio' $crumb $body)

# ---------------------------------------------------------------------------
# Emit: epic, feature, story pages
# ---------------------------------------------------------------------------
foreach ($e in $model) {
    $est = EpicStatus $e
    # ---- Epic page ----
    $crumb = "<a href=`"../index.html`">Portfolio</a><span class=`"sep`">&rsaquo;</span><span class=`"cur`">$($e.Id)</span>"
    $phases = $e.Features | Group-Object { $_.Meta.Phase } | Sort-Object Name
    $featSections = ''
    $idx = 0
    foreach ($pg in $phases) {
        $phaseName = if ($pg.Name) { "Phase $($pg.Name)" } else { 'Features' }
        $featSections += "<div class=`"section-h`">$phaseName</div><div class=`"grid`">"
        foreach ($f in ($pg.Group | Sort-Object Id)) {
            $k = StatusKey $f.Meta.Status; $delay = '{0:0.00}' -f ($idx * 0.05)
            $featSections += @"
<a class="card $k" href="$($f.Id)/$($f.Id).html" style="animation-delay:${delay}s">
<div class="cid">$($f.Id)</div><div class="ctitle">$($f.Meta.Title)</div>
<div style="margin-top:16px">$(Bar $f.Done $f.Total)</div>
<div class="cfoot">$(Badge $f.Meta.Status)<span class="cnt">$($f.Done)/$($f.Total) stories</span></div></a>
"@
            $idx++
        }
        $featSections += '</div>'
    }
    $body = @"
<div class="hero">
<div class="eyebrow">Epic &middot; $($e.Id)</div>
<h1 class="title">$($e.Meta.Title)</h1>
<div class="metarow">$(Badge $est)<span class="chip"><b>$($e.Features.Count)</b> features</span><span class="chip"><b>$($e.FDone)</b> features done</span></div>
<div class="bigprog"><div class="lab"><span>Story completion</span><span><b>$($e.SDone)</b> / $($e.STotal) done</span></div>$(Bar $e.SDone $e.STotal)</div>
</div>
$featSections
<div class="section-h">Epic charter</div>
<details class="charter"><summary>Read the full $($e.Id) charter (from CLAUDE.md)</summary><div class="inner prose">$($e.Meta.Body)</div></details>
"@
    Write-Html (Join-Path $e.Dir "$($e.Id).html") (Page $e.Id $crumb $body)

    # ---- Feature pages ----
    for ($fi = 0; $fi -lt $e.Features.Count; $fi++) {
        $f = $e.Features[$fi]
        $crumb = "<a href=`"../../index.html`">Portfolio</a><span class=`"sep`">&rsaquo;</span><a href=`"../$($e.Id).html`">$($e.Id)</a><span class=`"sep`">&rsaquo;</span><span class=`"cur`">$($f.Id)</span>"
        $rows = ''; $ri = 0
        foreach ($s in $f.Stories) {
            $k = StatusKey $s.Meta.Status; $delay = '{0:0.00}' -f ($ri * 0.04)
            $rows += @"
<a class="row" href="$($s.Id)/$($s.Id).html" style="animation-delay:${delay}s">
<span class="rid">$($s.Id)</span><span class="rtitle">$($s.Meta.Title)</span>
<span class="rmeta"><span class="acmini">$($s.Meta.AcDone)/$($s.Meta.AcTotal) AC</span>$(Badge $s.Meta.Status)</span></a>
"@
            $ri++
        }
        $depChip = if ($f.Meta.Depends -and $f.Meta.Depends -ne 'none') { "<span class=`"chip`">depends&nbsp;on <b>$($f.Meta.Depends)</b></span>" } else { '' }
        $updChip = if ($f.Meta.Updated) { "<span class=`"chip`">updated <b>$($f.Meta.Updated)</b></span>" } else { '' }
        $phChip = if ($f.Meta.Phase) { "<span class=`"chip`">phase <b>$($f.Meta.Phase)</b></span>" } else { '' }
        # sibling features
        $prev = if ($fi -gt 0) { $e.Features[$fi - 1] } else { $null }
        $next = if ($fi -lt $e.Features.Count - 1) { $e.Features[$fi + 1] } else { $null }
        $prevH = if ($prev) { "<a class=`"sib prev`" href=`"../$($prev.Id)/$($prev.Id).html`"><div class=`"dir`">&larr; Prev feature</div>$($prev.Id) &middot; $($prev.Meta.Title)</a>" } else { '<span class="sib prev disabled"></span>' }
        $nextH = if ($next) { "<a class=`"sib next`" href=`"../$($next.Id)/$($next.Id).html`"><div class=`"dir`">Next feature &rarr;</div>$($next.Id) &middot; $($next.Meta.Title)</a>" } else { '<span class="sib next disabled"></span>' }
        $body = @"
<div class="hero">
<div class="eyebrow">Feature &middot; $($f.Id)</div>
<h1 class="title">$($f.Meta.Title)</h1>
<div class="metarow">$(Badge $f.Meta.Status)$phChip$depChip$updChip$(TimeChips $f.Meta)</div>
<div class="bigprog"><div class="lab"><span>Story completion</span><span><b>$($f.Done)</b> / $($f.Total) done</span></div>$(Bar $f.Done $f.Total)</div>
</div>
<div class="section-h">User stories &middot; $($f.Total)</div>
<div class="rows">$rows</div>
<div class="section-h">Feature charter</div>
<div class="prose">$($f.Meta.Body)</div>
<div class="sibs">$prevH$nextH</div>
"@
        Write-Html (Join-Path $f.Dir "$($f.Id).html") (Page $f.Id $crumb $body)

        # ---- Story pages ----
        for ($si = 0; $si -lt $f.Stories.Count; $si++) {
            $s = $f.Stories[$si]
            $crumb = "<a href=`"../../../index.html`">Portfolio</a><span class=`"sep`">&rsaquo;</span><a href=`"../../$($e.Id).html`">$($e.Id)</a><span class=`"sep`">&rsaquo;</span><a href=`"../$($f.Id).html`">$($f.Id)</a><span class=`"sep`">&rsaquo;</span><span class=`"cur`">$($s.Id)</span>"
            $depChip = if ($s.Meta.Depends -and $s.Meta.Depends -ne 'none') { "<span class=`"chip`">depends&nbsp;on <b>$($s.Meta.Depends)</b></span>" } else { '<span class="chip">no deps</span>' }
            $updChip = if ($s.Meta.Updated) { "<span class=`"chip`">updated <b>$($s.Meta.Updated)</b></span>" } else { '' }
            $mdlChip = if ($s.Meta.Model) { "<span class=`"chip`">model <b>$($s.Meta.Model)</b></span>" } else { '' }
            $prev = if ($si -gt 0) { $f.Stories[$si - 1] } else { $null }
            $next = if ($si -lt $f.Stories.Count - 1) { $f.Stories[$si + 1] } else { $null }
            $prevH = if ($prev) { "<a class=`"sib prev`" href=`"../$($prev.Id)/$($prev.Id).html`"><div class=`"dir`">&larr; Prev story</div>$($prev.Id)</a>" } else { '<span class="sib prev disabled"></span>' }
            $nextH = if ($next) { "<a class=`"sib next`" href=`"../$($next.Id)/$($next.Id).html`"><div class=`"dir`">Next story &rarr;</div>$($next.Id)</a>" } else { '<span class="sib next disabled"></span>' }
            $body = @"
<div class="hero">
<div class="eyebrow">User story &middot; $($s.Id)</div>
<h1 class="title">$($s.Meta.Title)</h1>
<div class="metarow">$(Badge $s.Meta.Status)$mdlChip$depChip$updChip$(TimeChips $s.Meta)</div>
<div class="bigprog"><div class="lab"><span>Acceptance criteria</span><span><b>$($s.Meta.AcDone)</b> / $($s.Meta.AcTotal) ticked</span></div>$(Bar $s.Meta.AcDone $s.Meta.AcTotal)</div>
</div>
<div class="prose">$($s.Meta.Body)</div>
<div class="sibs">$prevH$nextH</div>
"@
            Write-Html (Join-Path $s.Dir "$($s.Id).html") (Page $s.Id $crumb $body)
        }
    }
}

$storyCount = ($model | ForEach-Object { $_.Features } | ForEach-Object { $_.Stories } | Measure-Object).Count
$featCount = ($model | ForEach-Object { $_.Features } | Measure-Object).Count
Write-Host "pm tracker built for '$ProjectName':" -ForegroundColor Yellow
Write-Host "  index.html + $($model.Count) epic + $featCount feature + $storyCount story = $(1 + $model.Count + $featCount + $storyCount) pages"
Write-Host "  open: $(Join-Path $pmDir 'index.html')"
