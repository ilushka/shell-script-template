#!/bin/bash

set -e

BIN_NAME=$(basename $0)

show_usage() {
    printf "Usage: ${BIN_NAME} <"
    cat ${BIN_NAME} | awk 'BEGIN { FS = "\""; ORS = "|"; } /\"[a-z]+\"\) # first-level-arg/ { print $2; }'
    printf ">\n"
}

show_readme() {
    printf "
## Quick Start
"
}

case $1 in
    "help") # first-level-arg;
        show_usage
        ;;
    "readme") # first-level-arg;
        show_readme
        ;;
esac
