#!/bin/bash

set -e

bin_name=$(basename $0)

show_usage() {
    printf "Usage: ${bin_name} <"
    cat ${bin_name} | awk 'BEGIN { FS = "\""; ORS = "|"; } /\"[a-z]+\"\)/ { print $2; }'
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
    "help")
        show_help
        ;;
esac
