#!/bin/bash
# A simple script that uses 'wget -O' to download files to '/dev/null' to test download speeds.
# Written by simonizor 3/21/2017

STVER="1.0.1"
X="v1.0.1 - Changed download links to cachefly for more reliable speed tests.  Also added a file from Twitch, Steam, and Google."
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
    echo "File sizes available for testing are 5MB, 10MB, 20MB, 50MB, 100MB, and 200MB."
    echo "Also included is a file from Twitch, Steam, and Google."
    echo "Specify the file size by adding the size after the script name when executing."
    echo "Ex: './speedtest.sh 512' './speedtest.sh google'"

}

PROGRAM="wget"
programisinstalled
if [ $return = "1" ]; then
    case $1 in
            5|5mb|5MB)
                wget -O /dev/null http://cachefly.cachefly.net/5mb.test
                ;;
            10|10mb|10MB)
                wget -O /dev/null http://cachefly.cachefly.net/10mb.test
                ;;
            50|50mb|50MB)
                wget -O /dev/null http://cachefly.cachefly.net/50mb.test
                ;;
            100|100mb|100MB)
                wget -O /dev/null http://cachefly.cachefly.net/100mb.test
                ;;
            200|200mb|200MB)
                wget -O /dev/null http://cachefly.cachefly.net/200mb.test
                ;;
            twitch|Twitch)
                wget -O /dev/null https://launcher.twitch.tv/TwitchLauncherInstaller.exe
                ;;
            steam|Steam)
                wget -O /dev/null https://steamcdn-a.akamaihd.net/client/installer/steam.dmg
                ;;
            google|Google)
                wget -O /dev/null https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
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