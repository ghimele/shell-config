#!/bin/bash

# install oh my posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# download the font CascadiaCode
oh-my-posh font install CascadiaCode

#download the ghimele theme
curl -s https://raw.githubusercontent.com/ghimele/shell-config/main/oh-my-posh-theme/ghimele.omp.json > ghimele.omp.json

# change the bash prompt using the ghimele theme
cat >> ./.profile <<'EOF'

export OH_MY_POSH_SHOW_KUBECTL=1

oh-my-posh-kubectl-on() {
  export OH_MY_POSH_SHOW_KUBECTL=1
  eval "$(oh-my-posh init bash --config ./ghimele.omp.json)"
}

oh-my-posh-kubectl-off() {
  export OH_MY_POSH_SHOW_KUBECTL=0
  eval "$(oh-my-posh init bash --config ./ghimele.omp.json)"
}

oh-my-posh-kubectl-toggle() {
  if [ "${OH_MY_POSH_SHOW_KUBECTL:-1}" = "1" ]; then
    export OH_MY_POSH_SHOW_KUBECTL=0
  else
    export OH_MY_POSH_SHOW_KUBECTL=1
  fi
  eval "$(oh-my-posh init bash --config ./ghimele.omp.json)"
}

eval "$(oh-my-posh init bash --config ./ghimele.omp.json)"
EOF