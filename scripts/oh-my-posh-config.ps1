# download the ghimele theme
curl -s https://raw.githubusercontent.com/ghimele/shell-config/main/oh-my-posh-theme/ghimele.omp.json > $env:POSH_THEMES_PATH/ghimele.omp.json

# Create Profile file
New-Item -Path $PROFILE -Type File -Force

# download the font CascadiaCode
oh-my-posh font install CascadiaCode

# configure oh my posh
@'
$env:OH_MY_POSH_SHOW_KUBECTL = '1'

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

    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/ghimele.omp.json" | Invoke-Expression
}

function Toggle-OhMyPoshKubectl {
    if ($env:OH_MY_POSH_SHOW_KUBECTL -eq '1') {
        $env:OH_MY_POSH_SHOW_KUBECTL = '0'
    } else {
        $env:OH_MY_POSH_SHOW_KUBECTL = '1'
    }

    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/ghimele.omp.json" | Invoke-Expression
}

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/ghimele.omp.json" | Invoke-Expression
'@ | Set-Content -Path $PROFILE