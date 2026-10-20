@echo off
setlocal

where winget >nul 2>&1
if errorlevel 1 (
	echo WinGet was not found. Install or update App Installer from the Microsoft Store, then retry.
	exit /b 1
)

call :install Microsoft.WindowsTerminal || exit /b 1
call :install Microsoft.PowerShell || exit /b 1
call :install JanDeDobbeleer.OhMyPosh || exit /b 1

echo Installation complete. Close the terminal and open a new PowerShell 7 session.
echo Then run scripts\oh-my-posh-config.ps1 from the repository directory.
exit /b 0

:install
winget list --exact --id "%~1" --source winget --accept-source-agreements >nul 2>&1
if not errorlevel 1 (
	echo %~1 is already installed.
	exit /b 0
)
winget install --exact --id "%~1" --source winget --accept-source-agreements --accept-package-agreements
if errorlevel 1 (
	echo Failed to install %~1. Resolve the WinGet error above and rerun this script.
	exit /b 1
)
exit /b 0
