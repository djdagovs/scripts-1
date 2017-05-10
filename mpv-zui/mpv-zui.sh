#!/bin/bash
# Title: mpv-zui
# Author: simonizor
# URL: http://www.simonizor.gq/scripts
# Dependencies: mpv, zenity
# Description: A simple script that launches a zenity GUI for opening files or urls in mpv.  Also has some useful arguments added that can be easily customized.

mpvfile () {
    if [ -z $1 ]; then
        MPVFILE=$(zenity --entry --cancel-label="Exit mpv-zui" --title=mpv-zui --entry-text="" --text="Input the path to a local file or input a remote url.\nLeave the entry field blank to open the file selection window.")
        if [[ $? -eq 1 ]]; then
            exit 0
        fi
        if [ -z "$MPVFILE" ]; then
            MPVFILE=$(zenity --file-selection --filename="/home/$USER/")
            if [[ $? -eq 1 ]]; then
                mpvfile
            fi
        fi
    else
        MPVFILE="$1"
    fi
    mpvargs
}

mpvargs () {
    ARGFILE="$(< ~/.config/mpv-zui/args.conf)"
    MPVARGS=$(zenity --entry --title=mpv-zui --cancel-label="List options" --text="Input the arguments that you would like to run mpv with:" --entry-text="$ARGFILE")
        if [[ $? -eq 1 ]]; then
            mpv --list-options | zenity --text-info --cancel-label="Exit mpv-zui" --ok-label="Back" --width=710 --height=600
            if [[ $? -eq 1 ]]; then
                exit 0
            fi
            mpvargs
        fi
    if [ ! -d ~/.config/mpv-zui ]; then
        mkdir ~/.config/mpv-zui
    fi
    echo "$MPVARGS" > ~/.config/mpv-zui/args.conf
    mpvrun
}

mpvrun () {
    mpv $MPVARGS "$MPVFILE"
    MPVARGS=""
    MPVFILE=""
    mpvfile
}

programisinstalled () { # check if inputted program is installed using 'type'
    return=1
    type "$1" >/dev/null 2>&1 || { return=0; }
}

programisinstalled "zenity"
if [ "$return" = "1" ]; then
    programisinstalled "mpv"
    if [ "$return" = "1" ]; then
        if [ ! -d ~/.config/mpv-zui ]; then
            mkdir ~/.config/mpv-zui
        fi
        if [ ! -f ~/.config/mpv-zui/args.conf ]; then
            echo "--border=no --vo=opengl --hwdec=vaapi" > ~/.config/mpv-zui/args.conf
        fi
        mpvfile "$@"
    else
        echo "mpv is not installed!"
    fi
else
    echo "zenity is not installed!"
fi