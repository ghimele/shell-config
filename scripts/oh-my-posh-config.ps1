# download the ghimele theme
curl -s https://raw.githubusercontent.com/ghimele/shell-config/main/oh-my-posh-theme/ghimele.omp.json > $env:POSH_THEMES_PATH/ghimele.omp.json

# Create Profile file
New-Item -Path $PROFILE -Type File -Force

# download the font CascadiaCode
oh-my-posh font install CascadiaCode

# configure oh my posh
echo 'oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/ghimele.omp.json" | Invoke-Expression' > $PROFILE