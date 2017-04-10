#!/bin/bash
# Title: smarter apt; smapt.sh
# Author: simonizor
# URL: http://www.simonizor.gq/scripts
# Dependencies: apt for Ubuntu and Ubuntu flavors
# Description: A simple script that adds aliases to make apt easier to use by shortening the arguments, run them as root easily, and append '-y'
# Example: 'smapt-Suuy' runs 'sudo apt update && sudo apt upgrade -y'
# Run this script once to add aliases to your ~/.bash_aliases file or ~/.zsh_aliases file if that exists.


addaliases () {
cat >>~/."$GETUSRSHELL"_aliases <<EOL

alias smapt='apt'
alias smapt-l='apt list'
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
    echo "-l   - apt list - list packages based on package names"
    echo "-se  - apt search - search in package descriptions"
    echo "-sh  - apt show - show package details"
    echo "-sha - apt show -a - show all package details"
    echo "-Si  - sudo apt install - install packages"
    echo "-Sui - sudo apt update && sudo apt install - update packages list and install packages"
    echo "-Sr  - sudo apt remove - remove packages"
    echo "-Sa  - sudo apt autoremove - Remove automatically all unused packages"
    echo "-Sud - sudo apt update - update list of available packages"
    echo "-Sug - sudo apt upgrade - upgrade the system by installing/upgrading packages"
    echo "-Suu - sudo apt update && apt upgrade - run apt update and then apt upgrade"
    echo "-Sfu - sudo apt full-upgrade - fully upgrade the system by removing/installing/upgrading packages"
    echo "-Sar - sudo apt-add-repository - apt-add-repository is a script for adding apt sources.list entries."
    echo "-Ses - sudo apt edit-sources - edit the source information file"
    echo 
    echo "Appedning 'y' will add '-y' to any of the relevant previous options."
    echo "Ex: 'smapt-Siy packagename' runs 'sudo apt install -y packagename'"
    echo
}
EOL
}

if [ -f ~/.zsh_aliases ]; then
    GETUSRSHELL="zsh"
    addaliases
else
    GETUSRSHELL="bash"
    addaliases
fi