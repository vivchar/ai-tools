#requires -Version 5.1
$ErrorActionPreference = 'SilentlyContinue'

$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
$data = $raw | ConvertFrom-Json

$cwd   = if ($data.cwd) { [string]$data.cwd } else { '' }
$model = if ($data.model -and $data.model.display_name) { [string]$data.model.display_name } else { '?' }
$ctxRaw = 0
if ($data.context_window -and $null -ne $data.context_window.used_percentage) {
    $ctxRaw = $data.context_window.used_percentage
}
$ctx = [int][math]::Floor([double]$ctxRaw)
if ($ctx -lt 0)   { $ctx = 0 }
if ($ctx -gt 100) { $ctx = 100 }

$branch = ''
if ($cwd -and (Test-Path -LiteralPath (Join-Path $cwd '.git'))) {
    $branch = (& git -C $cwd branch --show-current 2>$null | Out-String).Trim()
}

$E      = [char]27
$RESET  = "$E[0m"
$DIM    = "$E[38;2;110;110;110m"
$ACCENT = "$E[38;2;125;160;60m"
$BLUE   = "$E[34m"
$PINK   = "$E[1;35m"

function Get-GradColor([int]$p) {
    if ($p -ge 60) {
        $r = 220; $g = 50; $b = 50
    } elseif ($p -le 10) {
        $r = 90; $g = 190; $b = 80
    } elseif ($p -le 35) {
        $n = $p - 10
        $r = 90 + [int][math]::Floor((130 * $n) / 25)
        $g = 190
        $b = 80 - [int][math]::Floor((40 * $n) / 25)
    } else {
        $n = $p - 35
        $r = 220
        $g = 190 - [int][math]::Floor((140 * $n) / 25)
        $b = 40 + [int][math]::Floor((10 * $n) / 25)
    }
    return "$E[1;38;2;$r;$g;${b}m"
}

$ctxColor = Get-GradColor $ctx

$filled = [int][math]::Floor(($ctx * 10) / 100)
$blockFilled = [char]0x2593
$blockEmpty  = [char]0x2591
$bar = ''
for ($i = 0; $i -lt 10; $i++) {
    if ($i -lt $filled) {
        $bar += (Get-GradColor (($i + 1) * 10)) + $blockFilled
    } else {
        $bar += "$DIM$blockEmpty"
    }
}
$bar += $RESET

$home = $env:USERPROFILE
if ($cwd -and $home -and $cwd.ToLower().StartsWith($home.ToLower())) {
    $dirDisplay = '~' + $cwd.Substring($home.Length)
} else {
    $dirDisplay = $cwd
}
$repoName = if ($cwd) { Split-Path -Leaf $cwd } else { '' }

$prefix = ''
if ($branch) {
    $prefix = "$ACCENT ${repoName}:${branch}$RESET | "
}

$robot = [char]::ConvertFromUtf32(0xF09D1)
$speed = [char]::ConvertFromUtf32(0xF04C5)

$out = "${prefix}${PINK}${robot} ${model}${RESET} | ${ctxColor}${speed}${RESET} ${bar} ${ctxColor}${ctx}%${RESET}`n${BLUE}${dirDisplay}${RESET}"
[Console]::Out.Write($out)
