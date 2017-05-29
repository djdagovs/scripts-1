#!/bin/bash
# Clones all of simoniz0r's repos
# Remote exec:
# bash -c "$(wget --quiet https://raw.githubusercontent.com/simoniz0r/UsefulScripts/master/misc/gitclone.sh -O -)"

gitcheck () {
    if [ -d "/home/$USER/$1" ]; then
        read -p "$1 exists; remove before cloning? Y/N "
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            rm -rf "$1" && echo "$1 removed!" || echo "$1 remove failed!"
            git clone https://github.com/simoniz0r/"$1".git
        else
            echo "$1 not removed; skipping..."
        fi
    else
        git clone https://github.com/simoniz0r/"$1".git
    fi
}

if [ ! -d "/home/$USER/github" ]; then
    mkdir /home/$USER/github
    cd /home/$USER/github/
fi
gitcheck "dotfiles"
gitcheck "discorddownloader"
gitcheck "UsefulScripts"
gitcheck "Index"
gitcheck "kde-gaps"
gitcheck "WindowsStuff"
