#!/bin/bash
# A script copies dotfiles and downloads them fron github
# Dependencies: 'wget'
# Written by simonizor 5/27/2017 - http://www.simonizor.gq/scripts

DIR="/home/$USER/github/dotfiles"
dotfiles="$(cat /home/$USER/.config/cpdots/dotfiles.conf)"
dotrepos="$(cat /home/$USER/.config/cpdots/dotrepos.conf)"

cpdotsmain () {
    case $1 in
        -gita*|--gita*)
            if grep -q "$2" /home/$USER/.config/cpdots/dotrepos.conf; then
                echo "$2 already exists in dotrepos.conf."
                exit 1
            fi
            echo "$2" >> /home/$USER/.config/cpdots/dotrepos.conf
            echo "$2 has been added to dotrepos.conf"
            ;;
        -gitd*|--gitd*)
            DELFILE="$(grep -a "$2" /home/$USER/.config/cpdots/dotrepos.conf)"
            DELNUM="$(echo "$DELFILE" | wc -l)"
            if ! grep -q "$2" /home/$USER/.config/cpdots/dotrepos.conf; then
                echo "Repo not found in dotrepos.conf!"
                exit 1
            fi
            if [[ "$DELNUM" != "1" ]]; then
                echo "$DELNUM results found; refine your input."
                exit 1
            fi
            read -p "Delete repo $DELFILE? Y/N " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                sed -i s#"$DELFILE"##g /home/$USER/.config/cpdots/dotrepos.conf
                sed -i '/^$/d' /home/$USER/.config/cpdots/dotrepos.conf
                echo "Repo $DELFILE has been deleted from dotrepos.conf!"
            else
                echo "$DELFILE was not deleted from dotrepos.conf!"
                exit 0
            fi
            ;;
        -gitl*|--gitl*)
            cat /home/$USER/.config/cpdots/dotrepos.conf
            ;;
        -git*|--git*)
            REALNUM="$(cat /home/$USER/.config/cpdots/dotrepos.conf | wc -l)"
            if [ "$REALNUM" = "0" ]; then
                echo "No repos in dotrepos.conf"
                exit 0
            fi
            cd $DIR
            cd ..
            rm -rf $DIR
            git clone $dotrepos
            ;;
        -l*|--l*)
            REALNUM="$(cat /home/$USER/.config/cpdots/dotfiles.conf | wc -l)"
            if [ "$REALNUM" = "0" ]; then
                echo "No files in $DIR"
                exit 0
            fi
            if [ "$REALNUM" = "1" ]; then
                echo "$REALNUM file or folder."
                echo "File/folder is listed with its original location:"
            else
                echo "$REALNUM files and/or folders."
                echo "Files/folders are listed with their original location:"
            fi
            cat /home/$USER/.config/cpdots/dotfiles.conf
            ;;
        -a*|--a*)
            if [ ! -f "$2" ] && [ ! -d "$2" ]; then
                echo "$2 does not exist!"
                exit 1
            fi
            if grep -q "$2" /home/$USER/.config/cpdots/dotfiles.conf; then
                echo "$2 already exists in $DIR; remove this file in $DIR before proceeding."
                exit 1
            fi
            cp "$2" $DIR/ || { echo "Copy failed!" ; exit 0 ; }
            echo "$2" >> /home/$USER/.config/cpdots/dotfiles.conf
            echo "$2 has been copied to $DIR!"
            ;;
        -c*|--c*)
            for file in $dotfiles; do
            echo "Copying $file..."
            cp $file $DIR/
            done
            ;;
        -r*|--r*)
            RESTORE="$(grep -a "$2" /home/$USER/.config/cpdots/dotfiles.conf)"
            RESTNUM="$(echo "$RESTORE" | wc -l)"
            if ! grep -q "$2" /home/$USER/.config/cpdots/dotfiles.conf; then
                echo "File not found in $DIR!"
                exit 1
            fi
            if [[ "$RESTNUM" != "1" ]]; then
                echo "$RESTNUM results found; refine your input."
                exit 1
            fi
            read -p "Restore $2 to $RESTORE? Y/N " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                cp $DIR/"$2"* $RESTORE
                echo "$RESTORE was restored!"
            else
                echo "$2 was not restored!"
                exit 0
            fi
            if [ ! -f "$RESTORE" ] && [ ! -d "$RESTORE" ]; then
                echo "Restore failed!"
                exit 1
            fi
            ;;
        -d*|--d*)
            DELFILE="$(grep -a "$2" /home/$USER/.config/cpdots/dotfiles.conf)"
            DELNUM="$(echo "$DELFILE" | wc -l)"
            if ! grep -q "$2" /home/$USER/.config/cpdots/dotfiles.conf; then
                echo "File not found in '$DIR'!"
                exit 1
            fi
            if [[ "$DELNUM" != "1" ]]; then
                echo "$DELNUM results found; refine your input."
                exit 1
            fi
            read -p "Perminantly delete $2 (original location $DELFILE)? Y/N " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm -r ~/test/"$2"* || { echo "$2 not found in '$DIR'!" ; exit 1 ; }
            else
                echo "$2 (original location $DELFILE) was not deleted!"
                exit 0
            fi
            sed -i s:"$DELFILE"::g /home/$USER/.config/cpdots/dotfiles.conf
            sed -i '/^$/d' /home/$USER/.config/cpdots/dotfiles.conf
            echo "$2 (original location $DELFILE) has been deleted!"
            ;;
        *)
            echo "cpdots usage:"
            echo "cpdots -h: Show this help output"
            echo "cpdots -a: Add a dotfile to $DIR"
            echo "cpdots -d: Delete a dotfile from $DIR"
            echo "cpdots -l: List dotfiles in $DIR"
            echo "cpdots -r: Restore a dotfile to its original location from $DIR"
            echo "cpdots -c: Copy dotfiles from their orignial locations to $DIR"
            echo "cpdots -gita: Add a repo for downloading dotfiles to $DIR"
            echo "cpdots -gitd: Delete a repo from /home/$USER/.config/cpdots/dotrepos.conf"
            echo "cpdots -git : Download files from repos listed in dotrepos.conf to $DIR using git clone"
            echo "cpdots -repol: List repos in /home/$USER/.config/cpdots/dotrepos.conf"
            ;;
    esac
}

if [ ! -f "/home/$USER/.config/cpdots/dotfiles.conf" ]; then
    if [ ! -d "/home/$USER/.config/cpdots" ]; then
        mkdir /home/$USER/.config/cpdots
    fi
    cp $DIR/dotfiles.conf /home/$USER/.config/cpdots/dotfiles.conf
fi
if [ ! -f "/home/$USER/.config/cpdots/dotrepos.conf" ]; then
    cp $DIR/dotrepos.conf /home/$USER/.config/cpdots/dotrepos.conf
    echo "conf files copied to config directory; run script again."
    exit 0
fi
if [ ! -d "$DIR" ]; then
    mkdir $DIR
    echo "$DIR has been created."
fi
git --version || { echo "git is not installed; exiting..." ; exit 1 ; }
cpdotsmain "$@"