#!/bin/bash
# A bash script that attempts to make 'rm' easier to use by moving files to '~/.tmp' by default.
# Created by simonizor 3/11/2017

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

help () {
    echo "Tool that uses 'mv' and 'rm' to move files to '~/.tmp' instead of deleting them by default."
    echo "Usage: 'rm /path/to/fileordirectory"
    echo "Arguments:"
    echo "-h/help/? : Shows this help output"
    echo "-i/install : Creates '~/.tmp' directory for storage of removed files/directories."
    echo "-p/perm/permanent : executes the default 'rm' command and will permanently remove files"
    echo "-f/force : executes the 'rm' command with '-f' to forcefully and permanetly remove files and directories."
}
ARG=$1
if [[ "$ARG" == /* ]]; then
    echo "Moving $1 to '~/.tmp'"
    mv $1 ~/.tmp/
elif [[ "$ARG" == ./* ]]; then
    echo "Moving $1 to '~/.tmp'"
    mv $1 ~/.tmp/
elif [[ "$ARG" == ~/* ]]; then
    echo "Moving $1 to '~/.tmp'"
    mv $1 ~/.tmp/
elif [[ "$ARG" == -* ]]; then
    while getopts ":ihpcdf" opt; do
        case "$opt" in
        i|install)
            echo "Creating '~/.tmp' directory for temporary storage of removed files/directories..."
            mkdir ~/.tmp
            echo "Finished!"
            ;;
        h|help)
            help
            exit 0
            ;;
        p|perm|permanent)
            echo "$2 will be permanently deleted!"
            read -p "Continue? Y/N" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                if [ "${2: -1}" = "/" ]; then
                    rm -r $2
                else
                    rm $2
                fi
            else
                echo "$2 was not deleted!"
            fi
            ;;
        c|clear|clean)
            echo "All files in '~/.tmp' will be permanently deleted!"
            read -p "Continue? Y/N" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm -r ~/.tmp/*
            else
                echo "'~/.tmp' was not deleted!"
            fi
            ;;
        f|force)
            echo "$2 will be permanently deleted by force!"
            read -p "Continue? Y/N" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                if [ "${2: -1}" = "/" ]; then
                    rm -rf $2
                else
                    rm -f $2
                fi
            else
                echo "$2 was not deleted!"
            fi
        esac
    done
else
    echo "Invalid arguments passed. See 'easyrm -h' for help."
fi

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

# End of file