#!/bin/bash

pad="$(printf '%0.1s' " "{1..60})"
prepad="$(printf '%-0s')"
padlength1=19
padlength2=9
HEADNUM="10"
SORT="cat"
SORTNUM="2,2"
SORTPERCENT="%cpu"

main () {
    printf '%s' "$prepad" "$(tput setaf 4)$(tput smso)COMMAND "
    printf '%*.*s' 0 $((padlength1 - 7 )) "$pad"
    printf '%s' " %CPU "
    printf '%*.*s' 0 $((padlength2 - 6 )) "$pad"
    printf '%s' " %MEM "
    printf '%*.*s' 0 $((padlength2 - 7 )) "$pad"
    printf '%s\n' " COUNT$(tput setaf 7)$(tput rmso)"
    PSCOMMS="$(ps -eo comm --sort=-"$SORTPERCENT" --no-headers | tr ' ' '-')"
    for command in $(echo "$PSCOMMS" | awk '!seen[$1]++' | head -n "$HEADNUM"); do
        if [ "$command" = "Web-Content" ]; then
            command="Web Content"
        fi
        CPU=" $(ps H -eo %cpu,comm --sort=-"$SORTPERCENT" --no-headers | grep "$command" | awk '{ SUM += $1} END { print SUM }') "
        MEM=" $(ps -eo %mem,comm --sort=-"$SORTPERCENT" --no-headers | grep "$command" | awk '{ SUM += $1} END { print SUM }') "
        COUNT=" $(ps -eo comm --sort=-"$SORTPERCENT" --no-headers | grep "$command" | wc -l)"
        command="$(echo "$command" | tr -d '[:space:]')"
        printf '%s' "$prepad" "$command "
        printf '%*.*s' 0 $((padlength1 - ${#command} )) "$pad"
        printf '%s' "$CPU"
        printf '%*.*s' 0 $((padlength2 - ${#CPU} )) "$pad"
        printf '%s' "$MEM"
        printf '%*.*s' 0 $((padlength2 - ${#MEM} )) "$pad"
        printf '%s\n' "$COUNT"
    done | $(echo "$SORT")
}

for arg in "$@"; do
    case $arg in
        -r=*)
            case ${arg:3} in
                1*|2*|3*|4*|5*|6*|7*|8*|9*)
                    HEADNUM="${arg:3}"
                    ;;
                *)
                    echo "${arg:3} is not a valid number choice!"
                    exit 1
                    ;;
            esac
            ;;
        -p=*)
            case ${arg:3} in
                0*|1*|2*|3*|4*|5*|6*|7*|8*|9*)
                    PREPADNUM="%-${arg:3}s"
                    prepad="$(printf "$PREPADNUM")"
                    ;;
                *)
                    echo "${arg:3} is not a valid number choice!"
                    exit 1
                    ;;
            esac
            ;;
        -s=*)
            case ${arg:3} in
                cpu)
                    SORTNUM="2,2"
                    SORTPERCENT="%cpu"
                    SORT="sort -h -k "$SORTNUM" -r"
                    ;;
                mem)
                    SORTNUM="3,3"
                    SORTPERCENT="%mem"
                    SORT="sort -h -k "$SORTNUM" -r"
                    ;;
                name)
                    SORTNUM="1,1"
                    SORTPERCENT="comm"
                    SORT="sort -h -k "$SORTNUM""
                    ;;
                count)
                    SORTNUM="4,4"
                    SORT="sort -h -k "$SORTNUM" -r"
                    ;;
                *)
                    echo "${arg:3} is not a valid choice!"
                    exit 1
                    ;;
            esac
            ;;
        -h)
            padlength1=30
            printf '%s' "$prepad" "Usage: pstop [ARGUMENT(s)]"
            printf '%s\n' "$prepad" "'pstop' uses 'ps' to get CPU and RAM usage for running processes.  'pstop' outputs a list of running commands in a clean, easy to read format.  It can also be used with the 'watch' command as a process monitor."
            printf '%s\n' "$prepad" "Arguments:"
            printf '%s' "$prepad" "pstop -r=n "
            printf '%*.*s' 0 $((padlength1 - 11 )) "$pad"
            printf '%s\n' " Change amount of rows to be outputted.  Default is 10 rows."
            printf '%s' "$prepad" "pstop -s=method "
            printf '%*.*s' 0 $((padlength1 - 16 )) "$pad"
            printf '%s\n' " Change sorting method.  Options are 'name','cpu','mem', and 'count'.  Default sorting is 'cpu'."
            printf '%s' "$prepad" "pstop -p=n "
            printf '%*.*s' 0 $((padlength1 - 11 )) "$pad"
            printf '%s\n' " Add padding to beginning of 'pstop' output.  Default is no padding."
            printf '%s' "$prepad" "pstop -h "
            printf '%*.*s' 0 $((padlength1 - 9 )) "$pad"
            printf '%s\n' " Shows help output."
            printf '%s\n' "$prepad" "Examples:"
            printf '%s' "$prepad" "pstop -r=20 "
            printf '%*.*s' 0 $((padlength1 - 11 )) "$pad"
            printf '%s\n' "Changes amount of rows to be outputted to 20."
            printf '%s' "$prepad" "pstop -p=20 "
            printf '%*.*s' 0 $((padlength1 - 11 )) "$pad"
            printf '%s\n' "Changes padding before output to be 20."
            printf '%s' "$prepad" "pstop -s=name"
            printf '%*.*s' 0 $((padlength1 - 12 )) "$pad"
            printf '%s\n' "Changes sorting method to be sorted by command name."
            printf '%s' "$prepad" "pstop -s=cpu"
            printf '%*.*s' 0 $((padlength1 - 11 )) "$pad"
            printf '%s\n' "Changes sorting method to be sorted by %CPU."
            printf '%s' "$prepad" "pstop -s=mem"
            printf '%*.*s' 0 $((padlength1 - 11 )) "$pad"
            printf '%s\n' "Changes sorting method to be sorted by %MEM."
            printf '%s' "$prepad" "pstop -s=count"
            printf '%*.*s' 0 $((padlength1 - 13 )) "$pad"
            printf '%s\n' "Changes sorting method to be sorted by command count."
            printf '%s' "$prepad" "pstop -r=15 -p=20 -s=mem"
            printf '%*.*s' 0 $((padlength1 - 23 )) "$pad"
            printf '%s\n' "Changes amount of rows to be outputted to 15, padding before output to be 20, and sorting method to be %MEM."
            printf '%s\n' "$prepad" "Using 'pstop' as a process monitor:"
            printf '%s' "$prepad" "The 'watch' command can be used to use 'pstop' as a process monitor."
            printf '%s\n' "$prepad" "Example:"
            printf '%s' "$prepad" "watch -t /path/to/pstop.sh -r=7 -p=20 -s=cpu"
            printf '%s\n' "$prepad" "Uses the 'watch' command with the '-t' argument to remove the header output from 'watch'.  Arguments work as explained above."
            exit 0
            ;;
    esac
done
main