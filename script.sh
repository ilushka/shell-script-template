#!/bin/bash

set -e

bin_name=$(basename $0)

show_usage() {
    printf "Usage: ${bin_name} <"
    cat ${bin_name} | awk 'BEGIN { FS = "\""; ORS = "|"; } /\"[a-z]+\"\) # first-level-arg/ { print $2; }'
    printf ">\n"
}

show_readme() {
    printf "
README

# Quick Start:
##
"
}

show_help() {
    show_usage
    show_readme
}

case $1 in
    "help") # first-level-arg;
        show_help
        ;;
esac
