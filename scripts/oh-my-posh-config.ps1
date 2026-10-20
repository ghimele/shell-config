[CmdletBinding()]
param(
    [switch]$SkipFontInstall
)

$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSVersion.Major -lt 7) {
    throw 'Run this script in PowerShell 7 (pwsh), not Windows PowerShell.'
}

if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    throw 'Oh My Posh was not found. Run the installer, close the terminal, then open PowerShell 7 and retry.'
}

$profileScriptPath = Join-Path $PSScriptRoot 'powershell-profile.ps1'
if (-not (Test-Path -LiteralPath $profileScriptPath -PathType Leaf)) {
    throw 'The repository profile script is missing. Restore scripts\powershell-profile.ps1 and retry.'
}

$themeSourcePath = Join-Path (Split-Path -Parent $PSScriptRoot) 'oh-my-posh-theme\ghimele.omp.json'
if (-not (Test-Path -LiteralPath $themeSourcePath -PathType Leaf)) {
    throw 'The repository theme is missing. Restore oh-my-posh-theme\ghimele.omp.json and retry.'
}

$installDirectory = Join-Path $env:LOCALAPPDATA 'shell-config'
$scriptsDirectory = Join-Path $installDirectory 'scripts'
$themeDirectory = Join-Path $installDirectory 'oh-my-posh-theme'
New-Item -Path $scriptsDirectory, $themeDirectory -ItemType Directory -Force | Out-Null
Copy-Item -LiteralPath $profileScriptPath -Destination (Join-Path $scriptsDirectory 'powershell-profile.ps1') -Force
Copy-Item -LiteralPath $themeSourcePath -Destination (Join-Path $themeDirectory 'ghimele.omp.json') -Force

$profileDirectory = Split-Path -Parent $PROFILE
New-Item -Path $profileDirectory -ItemType Directory -Force | Out-Null

if (-not $SkipFontInstall) {
    oh-my-posh font install CascadiaCode
    if ($LASTEXITCODE -ne 0) {
        Write-Warning 'Font installation failed. Run: oh-my-posh font install CascadiaCode'
    }
}

$configuration = @'
# BEGIN shell-config oh-my-posh
if (Test-Path -LiteralPath (Join-Path $env:LOCALAPPDATA 'shell-config\scripts\powershell-profile.ps1') -PathType Leaf) {
    . (Join-Path $env:LOCALAPPDATA 'shell-config\scripts\powershell-profile.ps1')
} else {
    Write-Warning 'Local shell configuration not found. Run scripts\oh-my-posh-config.ps1 from a shell-config checkout.'
}
# END shell-config oh-my-posh
'@

$existingProfile = if (Test-Path -LiteralPath $PROFILE) {
    Get-Content -LiteralPath $PROFILE -Raw
} else {
    ''
}
$managedBlock = '(?ms)^# BEGIN shell-config oh-my-posh\r?\n.*?^# END shell-config oh-my-posh\r?$'
if ($existingProfile -match $managedBlock) {
    $updatedProfile = [regex]::Replace($existingProfile, $managedBlock, [System.Text.RegularExpressions.MatchEvaluator]{ param($match) $configuration })
} else {
    $updatedProfile = $existingProfile + [Environment]::NewLine + $configuration + [Environment]::NewLine
}
if ((Test-Path -LiteralPath $PROFILE) -and $existingProfile -ne $updatedProfile) {
    $backupPath = "$PROFILE.shell-config-backup-$(Get-Date -Format 'yyyyMMddHHmmssfff')"
    Copy-Item -LiteralPath $PROFILE -Destination $backupPath
    Write-Host "Backed up the existing profile to $backupPath."
}
Set-Content -LiteralPath $PROFILE -Value $updatedProfile -Encoding utf8 -NoNewline
Write-Host "Configured Oh My Posh in $PROFILE. Open a new PowerShell 7 session to load it."