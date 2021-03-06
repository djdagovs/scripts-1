#!/bin/bash
# A simple script that uses 'wget -O' to download files to '/dev/null' to test download speeds.
# Written by simonizor 3/21/2017

STVER="1.0.6"
X="v1.0.6 - Change repo name"
# ^^Remember to update this and speedtestversion.txt every release!
SCRIPTNAME="$0"

updatecheck () {
    echo "Checking for new version..."
    UPNOTES=$(wget -q "https://raw.githubusercontent.com/simoniz0r/scripts/master/speedtest/speedtest.sh" -O - | sed -n '6p' | tr -d 'X="')
    VERTEST=$(wget -q "https://raw.githubusercontent.com/simoniz0r/scripts/master/speedtest/speedtest.sh" -O - | sed -n '5p' | tr -d 'STVER="')
    if [[ $STVER < $VERTEST ]]; then
        echo "Installed version: $STVER -- Current version: $VERTEST"
        echo "A new version is available!"
        echo $UPNOTES
    else
        echo "Installed version: $STVER -- Current version: $VERTEST"
        echo $UPNOTES
        echo "speedtest.sh is up to date."
    fi
}

helpfunc () {
    echo "speedtest.sh - http://www.simonizor.gq/scripts"
    echo "A simple script that uses 'wget' to download files to  '/dev/null' to test download speeds."
    echo "File sizes available for testing are 5MB, 10MB, 100MB, and 200MB."
    echo "Also included is a file from Twitch, Steam, and Google."
    echo "Specify the file size by adding the size after the script name when executing."
    echo "Ex: './speedtest.sh all' './speedtest.sh 200' './speedtest.sh google' './speedtest.sh 5 10 steam google'"

}

main () {
    case $1 in
        5|5m*|5M*)
            wget -O /dev/null http://cachefly.cachefly.net/5mb.test
            ;;
        10|10m*|10M*)
            wget -O /dev/null http://cachefly.cachefly.net/10mb.test
            ;;
        100|100m*|100M*)
            wget -O /dev/null http://cachefly.cachefly.net/100mb.test
            ;;
        200|200m*|200M*)
            wget -O /dev/null http://cachefly.cachefly.net/200mb.test
            ;;
        t*|T*)
            wget -O /dev/null https://launcher.twitch.tv/TwitchLauncherInstaller.exe
            ;;
        s*|S*)
            wget -O /dev/null https://steamcdn-a.akamaihd.net/client/installer/steam.dmg
            ;;
        g*|G*)
            wget -O /dev/null https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
            ;;
        a*|A*)
            echo "5MB"
            wget -O /dev/null http://cachefly.cachefly.net/5mb.test
            echo "10MB"
            wget -O /dev/null http://cachefly.cachefly.net/10mb.test
            echo "100MB"
            wget -O /dev/null http://cachefly.cachefly.net/100mb.test
            echo "200MB"
            wget -O /dev/null http://cachefly.cachefly.net/200mb.test
            echo "Steam"
            wget -O /dev/null https://steamcdn-a.akamaihd.net/client/installer/steam.dmg
            echo "Google"
            wget -O /dev/null https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
            echo "Twitch"
            wget -O /dev/null https://launcher.twitch.tv/TwitchLauncherInstaller.exe
            ;;
        *)
            helpfunc
            updatecheck
    esac
}

type wget >/dev/null 2>&1 || { echo "wget is not installed!"; exit 1; }

if [ -z "$1" ]; then
    helpfunc
    updatecheck
fi
for arg in $@; do
main "$arg"
done