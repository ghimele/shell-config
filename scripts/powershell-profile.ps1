if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Warning 'Oh My Posh was not found. Run scripts\oh-my-posh-install.bat, then reopen PowerShell 7.'
    return
}

$script:ShellConfigThemePath = Join-Path (Split-Path -Parent $PSScriptRoot) 'oh-my-posh-theme\ghimele.omp.json'
$env:OH_MY_POSH_SHOW_KUBECTL = '0'

function Set-OhMyPoshKubectl {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('on', 'off')]
        [string]$State
    )

    if ($State -eq 'on') {
        $env:OH_MY_POSH_SHOW_KUBECTL = '1'
    } else {
        $env:OH_MY_POSH_SHOW_KUBECTL = '0'
    }

    oh-my-posh init pwsh --config $script:ShellConfigThemePath | Invoke-Expression
}

function Toggle-OhMyPoshKubectl {
    if ($env:OH_MY_POSH_SHOW_KUBECTL -eq '1') {
        Set-OhMyPoshKubectl -State off
    } else {
        Set-OhMyPoshKubectl -State on
    }
}

oh-my-posh init pwsh --config $script:ShellConfigThemePath | Invoke-Expression

# Customize the color for directory listings in the shell
$PSStyle.FileInfo.Directory = "`e[1;36m"