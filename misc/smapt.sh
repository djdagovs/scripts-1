#!/bin/bash
# Title: smarter apt; smapt.sh
# Author: simonizor
# URL: http://www.simonizor.gq/scripts
# Dependencies: apt for Ubuntu and Ubuntu flavors
# Description: A simple script that adds aliases to make apt easier to use by shortening the arguments, run them as root easily, and append '-y'
# Example: 'smapt-Suuy' runs 'sudo apt update && sudo apt upgrade -y'
# Running this script will create '~/.smapt_aliases' which will be loaded through your ~/.bashrc or ~/.zshrc; running it again will replace '~/.smapt_aliases'
# Remote install:
# via wget: bash -c "$(wget https://raw.githubusercontent.com/simoniz0r/UsefulScripts/master/misc/smapt.sh -O -)" && $SHELL
# via curl: bash -c "$(curl -fsSL https://raw.githubusercontent.com/simoniz0r/UsefulScripts/master/misc/smapt.sh)" && $SHELL

addaliases () {
cat >~/.smapt_aliases <<EOL
alias smapt='smapt-help'
alias smapt-l='apt list'
alias smapt-lu='apt list --upgradeable'
alias smapt-m='apt-mark'
alias smapt-msa='apt-mark showauto'
alias smapt-msm='apt-mark showauto'
alias smapt-msu="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"
alias smapt-msd="comm -23 <(apt-mark showauto | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"
alias smapt-plw="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u) | tee $2"
alias smapt-se='apt search'
alias smapt-sh='apt show'
alias smapt-sha='apt show -a'
alias smapt-Si='sudo apt install'
alias smapt-Siy='sudo apt install -y'
alias smapt-Sui='sudo apt update && sudo apt install'
alias smapt-Suiy='sudo apt update && sudo apt install -y'
alias smapt-Sr='sudo apt remove'
alias smapt-Sry='sudo apt remove -y'
alias smapt-Sa='sudo apt autoremove'
alias smapt-Say='sudo apt autoremove -y'
alias smapt-Sud='sudo apt update'
alias smapt-Sug='sudo apt upgrade'
alias smapt-Sugy='sudo apt upgrade -y'
alias smapt-Suu='sudo apt update && sudo apt upgrade'
alias smapt-Suuy='sudo apt update && sudo apt upgrade -y'
alias smapt-Sfu='sudo apt full-upgrade'
alias smapt-Sfuy='sudo apt full-upgrade -y'
alias smapt-Sar='sudo apt-add-repository'
alias smapt-Sary='sudo apt-add-repository -y'
alias smapt-Ses='sudo apt edit-sources'

smapt-help () {
    echo
    echo "smapt - http://www.simonizor.gq/scripts"
    echo "smarter apt; a set of aliases that shorten apt's arguments"
    echo
    echo "smapt-l   - apt list - list packages based on package names"
    echo "smapt-lu  - apt list --upgradeable - list packages that have available upgrades"
    echo "smapt-m   - apt-mark - simple command line interface for marking packages as manually or automatically installed"
    echo "smapt-msa - apt-mark showauto - Print the list of automatically installed packages"
    echo "smapt-msm - apt-mark showmanual - Print the list of manually installed packages"
    echo "smapt-msu - apt-mark showmanual - Print the list of user installed packages"
    echo "smapt-msd - apt-mark showauto - Print the list of user packages that were installed as dependencies"
    echo "smapt-plw - apt-mark showmanual - Write user installed package list to specified file"
    echo "smapt-se  - apt search - search in package descriptions"
    echo "smapt-sh  - apt show - show package details"
    echo "smapt-sha - apt show -a - show all package details"
    echo "smapt-Si  - sudo apt install - install packages"
    echo "smapt-Sui - sudo apt update && sudo apt install - update packages list and install packages"
    echo "smapt-Sr  - sudo apt remove - remove packages"
    echo "smapt-Sa  - sudo apt autoremove - Remove automatically all unused packages"
    echo "smapt-Sud - sudo apt update - update list of available packages"
    echo "smapt-Sug - sudo apt upgrade - upgrade the system by installing/upgrading packages"
    echo "smapt-Suu - sudo apt update && sudo apt upgrade - run apt update and then apt upgrade"
    echo "smapt-Sfu - sudo apt full-upgrade - fully upgrade the system by removing/installing/upgrading packages"
    echo "smapt-Sar - sudo apt-add-repository - apt-add-repository is a script for adding apt sources.list entries."
    echo "smapt-Ses - sudo apt edit-sources - edit the source information file"
    echo 
    echo "Appedning 'y' will add '-y' to any of the relevant arguments."
    echo "Ex: 'smapt-Siy packagename' runs 'sudo apt install -y packagename'"
    echo
}
EOL
}

loadaliases () {
cat >>~/$RCFILE <<EOL


if [ -f ~/.smapt_aliases ]; then
    . ~/.smapt_aliases
fi
EOL
}

if [ -f ~/.zshrc ]; then
    RCFILE=".zshrc"
    if grep -q -a 'smapt_aliases' ~/.zshrc; then
        echo "smapt aliases added to .zshrc!"
    else
        loadaliases
        if grep -q -a 'smapt_aliases' ~/.zshrc; then
            echo "smapt aliases added to .zshrc!"
        fi
    fi
fi
RCFILE=".bashrc"
addaliases
if grep -q -a 'smapt_aliases' ~/.bashrc; then
    echo "smapt aliases added to .bashrc!"
else
    loadaliases
    if grep -q -a 'smapt_aliases' ~/.bashrc; then
        echo "smapt aliases added to .bashrc!"
        exit 0
    fi
fi