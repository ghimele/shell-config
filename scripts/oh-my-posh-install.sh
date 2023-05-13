#!/bin/bash

# install oh my posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# download the font CascadiaCode
oh-my-posh font install CascadiaCode

#download the ghimele theme
curl -s https://raw.githubusercontent.com/ghimele/shell-config/main/oh-my-posh-theme/ghimele.omp.json > ghimele.omp.json

# change the bash prompt using the ghimele theme
echo " " >> ./.profile
echo 'eval "$(oh-my-posh init bash --config ./ghimele.omp.json)"' >> ./.profile