#!/bin/bash
# A simple script that uses 'wget -O' to download files to '/dev/null' to test download speeds.
# Written by simonizor 3/21/2017

STVER="1.0.4"
X="v1.0.4 - Added option to run all tests './speedtest.sh all'."
# ^^Remember to update this and speedtestversion.txt every release!
SCRIPTNAME="$0"

updatescript () {
cat >/tmp/updatescript.sh <<EOL
runupdate () {
    rm -f $SCRIPTNAME
    wget -O $SCRIPTNAME "https://raw.githubusercontent.com/simoniz0r/UsefulScripts/master/speedtest.sh"
    chmod +x $SCRIPTNAME
    if [ -f $SCRIPTNAME ]; then
        echo "Update finished!"
        rm -f /tmp/updatescript.sh
        exit 0
    else
        read -p "Update Failed! Try again? Y/N " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            runupdate
        else
            echo "speedtest.sh was not updated!"
            exit 0
        fi
    fi
}
runupdate
EOL
}

updatecheck () {
    echo "Checking for new version..."
    UPNOTES=$(curl -v --silent https://raw.githubusercontent.com/simoniz0r/UsefulScripts/master/speedtestversion.txt 2>&1 | grep X= | tr -d 'X="')
    VERTEST=$(curl -v --silent https://raw.githubusercontent.com/simoniz0r/UsefulScripts/master/speedtestversion.txt 2>&1 | grep STVER= | tr -d 'STVER="')
    if [[ $STVER != $VERTEST ]]; then
        echo "Installed version: $STVER -- Current version: $VERTEST"
        echo "A new version is available!"
        echo $UPNOTES
        read -p "Would you like to update? Y/N " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo
            echo "Creating update script..."
            updatescript
            chmod +x /tmp/updatescript.sh
            echo "Running update script..."
            exec /tmp/updatescript.sh
            exit 0
        else
            echo
            echo "speedtest.sh was not updated."
        fi
    else
        echo "Installed version: $STVER -- Current version: $VERTEST"
        echo $UPNOTES
        echo "speedtest.sh is up to date."
    fi
}

programisinstalled () {
  # set to 1 initially
  return=1
  # set to 0 if not found
  type $PROGRAM >/dev/null 2>&1 || { return=0; }
  # return value
}

helpfunc () {
    echo "A simple script that uses 'wget' to download files to  '/dev/null' to test download speeds."
    echo "File sizes available for testing are 5MB, 10MB, 100MB, and 200MB."
    echo "Also included is a file from Twitch, Steam, and Google."
    echo "Specify the file size by adding the size after the script name when executing."
    echo "Ex: './speedtest.sh all' './speedtest.sh 200' './speedtest.sh google' './speedtest.sh 5 10 steam google'"

}

main () {
    PROGRAM="wget"
    programisinstalled
    if [ $return = "1" ]; then
        case $1 in
                5|5m*|5M*)
                    wget -O /dev/null http://cachefly.cachefly.net/5mb.test
                    ;;
                10|10m*|10M*)
                    wget -O /dev/null http://cachefly.cachefly.net/10mb.test
                    ;;
                100|100m*|100MB)
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
                all|All)
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
                    PROGRAM="curl"
                    programisinstalled
                    if [ $return = "1" ]; then
                        updatecheck
                    fi
        esac
    else
        echo "wget is not installed!"
    fi
}

main "$1"
if [ ! -z $2 ]; then
    main "$2"
fi
if [ ! -z $3 ]; then
    main "$3"
fi
if [ ! -z $4 ]; then
    main "$4"
fi
if [ ! -z $5 ]; then
    main "$5"
fi
if [ ! -z $6 ]; then
    main "$6"
fi
if [ ! -z $7 ]; then
    main "$7"
fi