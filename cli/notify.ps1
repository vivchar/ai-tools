#requires -Version 5.1
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('Stop', 'Notification')]
    [string]$Type
)

$ErrorActionPreference = 'SilentlyContinue'

$raw = [Console]::In.ReadToEnd()
$data = if ([string]::IsNullOrWhiteSpace($raw)) { @{} } else { $raw | ConvertFrom-Json }

$cwd  = if ($data.cwd)     { [string]$data.cwd }     else { '' }
$msgIn = if ($data.message) { [string]$data.message } else { '' }
$name = if ($cwd) { Split-Path -Leaf $cwd } else { '' }

if ($Type -eq 'Stop') {
    $title = 'Claude Code'
    $msg   = if ($name) { "Готово в $name" } else { 'Готово' }
    $sound = 'Asterisk'
} else {
    $title = 'Claude Code ждёт'
    $msg   = if ($name) { "$msgIn ($name)" } else { $msgIn }
    $sound = 'Beep'
}

$shown = $false
if (Get-Module -ListAvailable -Name BurntToast) {
    try {
        Import-Module BurntToast -ErrorAction Stop
        New-BurntToastNotification -Text $title, $msg -ErrorAction Stop
        $shown = $true
    } catch { $shown = $false }
}

if (-not $shown) {
    try {
        Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
        Add-Type -AssemblyName System.Drawing -ErrorAction Stop
        $ni = New-Object System.Windows.Forms.NotifyIcon
        $ni.Icon    = [System.Drawing.SystemIcons]::Information
        $ni.Visible = $true
        $ni.ShowBalloonTip(5000, $title, $msg, [System.Windows.Forms.ToolTipIcon]::Info)
        Start-Sleep -Milliseconds 300
        $ni.Dispose()
    } catch {
        # last-resort: write to stderr so the user sees something in logs
        [Console]::Error.WriteLine("[$title] $msg")
    }
}

try {
    [System.Media.SystemSounds]::$sound.Play()
} catch { }
