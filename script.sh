#!/bin/bash

set -e

BIN_NAME=$(basename $0)

function show_usage() {
    case $1 in
        "second")
            printf "Usage: ${BIN_NAME} second <"
            cat ${BIN_NAME} | awk 'BEGIN { FS = "\""; ORS = "|"; } /\"[a-z]+\"\) # second-level-arg/ { print $2; }'
            printf "\b>\n"  # \b (backspace) is to hide last separator
            ;;
        *)
            printf "Usage: ${BIN_NAME} <"
            cat ${BIN_NAME} | awk 'BEGIN { FS = "\""; ORS = "|"; } /\"[a-z]+\"\) # first-level-arg/ { print $2; }'
            printf "\b>\n"
            ;;
    esac
}

function show_readme() {
    printf "
## Quick Start
"
}

function second_commands() {
    case $1 in
        "level") # second-level-arg;
            printf "second level command\n"
            ;;
    esac
}

case $1 in
    "second") # first-level-arg
        second_commands "${@:2}"
        ;;
    "help") # first-level-arg;
        show_usage "${@:2}"
        ;;
    "readme") # first-level-arg;
        show_readme
        ;;
    *)
        show_usage "${@:2}"
        ;;
esac

