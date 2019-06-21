#!/bin/bash

set -e

BIN_NAME=$(basename $0)

function show_usage() {
    if [[ -z "$1" ]]; then
        printf "Usage: ${BIN_NAME} <"
        cat ${BIN_NAME} | sed -n 's/[[:space:]]*\"\([a-z0-9-]*\)\") # first-level-arg;/\1/p' | tr '\n' '|'
        printf "\b>\n"  # \b (backspace) is to hide last separator
    else
        dbl_usage=$(cat script.sh  | sed -n 's/[[:space:]]*\"\([a-z0-9-]*\)\") # second-level-arg; '"${1}"'/\1/p' | tr '\n' '|')
        if [[ ! -z "$dbl_usage" ]]; then
            printf "Usage: ${BIN_NAME} ${1} <${dbl_usage}\b>\n"  # \b (backspace) is to hide last separator
        else
            printf "Usage: ${BIN_NAME} ${1}\n"
        fi
    fi
}

function single_command() {
    printf "Single command\n"
}

function double_command1() {
    case $1 in
        "foo") # second-level-arg; double-cmd1
            ;;
        "bar") # second-level-arg; double-cmd1
            ;;
        *)
            show_usage "double-cmd1"
            ;;
    esac
}

function double_command2() {
    case $1 in
        "baz") # second-level-arg; double-cmd2
            ;;
        "qux") # second-level-arg; double-cmd2
            ;;
        *)
            show_usage "double-cmd2"
            ;;
    esac
}
case $1 in
    "single") # first-level-arg;
        single_command "${@:2}"
        ;;
    "double-cmd1") # first-level-arg;
        double_command "${@:2}"
        ;;
    "double-cmd2") # first-level-arg;
        double_command2 "${@:2}"
        ;;
    "help") # first-level-arg;
        show_usage "${@:2}"
        ;;
    *)
        show_usage "${@:2}"
        ;;
esac
