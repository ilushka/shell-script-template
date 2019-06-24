#!/bin/bash

set -e

# 
################################################################################

BIN=$(basename $0)

function count_words() {
    echo "$@" | wc -w | sed 's/^[[:space:]]*//g'
}

function get_single_cmd_usage() {
    sed -n 's/[[:space:]]*\"\([a-z0-9-]*\)\") # first-level-arg;/\1/p' ${BIN} | tr '\n' '|'
}

function get_double_cmd_usage() {
    sed -n 's/[[:space:]]*\"\([a-z0-9-]*\)\") # second-level-arg; '"${1}"'/\1/p' ${BIN} | tr '\n' '|'
}

function get_single_cmd_help() {
    awk '/function '"$(echo "${1}" | tr '-' '_')"'_command()/{f=1; next;} /# arg-doc-end;/{f=0} f' ${BIN} | sed 's/^[[:space:]]*# //g'
}

function get_double_cmd_help() {
    awk '/function '"$(echo "${1}_${2}" | tr '-' '_')"'_command()/{f=1; next;} /# arg-doc-end;/{f=0} f' ${BIN} | sed 's/^[[:space:]]*# //g'
}

function show_usage() {
    arg_count=$(count_words $@)
    if [[ $arg_count -eq 0 ]]; then
        printf "Usage: ${BIN} $(get_single_cmd_usage) \b>\n"  # \b (backspace) is to hide last separator
    elif [[ $arg_count -eq 1 ]]; then
        dbl_usage=$(get_double_cmd_usage $1)
        if [[ ! -z "$dbl_usage" ]]; then
            printf "Usage: ${BIN} ${1} <${dbl_usage}\b>\n"    # \b (backspace) is to hide last separator
        else
            printf "Usage: ${BIN} ${1}\n$(get_single_cmd_help $1)\n"
        fi
    elif [[ $arg_count -eq 2 ]]; then
        printf "Usage: ${BIN} ${1} ${2}\n$(get_double_cmd_help $1 $2)\n"
    fi
}

# COMMAND FUNCTIONS
################################################################################

function single_command() {
    # This is a single command.
    # It is not part of a subgroup of commands.
    # arg-doc-end;
    printf "Single command: single\n"
}

function double_cmd1_foo_command() {
    # This is a double command.
    # It is part of a double-cmd1 subgroup of commands.
    # arg-doc-end;
    printf "Double command: double-cmd1 foo\n"
}

function double_cmd1_bar_command() {
    # This is a double command.
    # It is part of a double-cmd1 subgroup of commands.
    # arg-doc-end;
    printf "Double command: double-cmd1 bar\n"
}

function double_cmd2_baz_command() {
    # This is a double command.
    # It is part of a double-cmd2 subgroup of commands.
    # arg-doc-end;
    printf "Double command: double-cmd2 baz\n"
}

function double_cmd2_qux_command() {
    # This is a double command.
    # It is part of a double-cmd2 subgroup of commands.
    # arg-doc-end;
    printf "Double command: double-cmd2 qux\n"
}

# COMMAND TREE
################################################################################

function double_cmd1_command() {
    case $1 in
        "foo") # second-level-arg; double-cmd1
            double_cmd1_foo_command "${@:2}"
            ;;
        "bar") # second-level-arg; double-cmd1
            double_cmd1_bar_command "${@:2}"
            ;;
        *)
            show_usage "double-cmd1"
            ;;
    esac
}

function double_cmd2_command() {
    case $1 in
        "baz") # second-level-arg; double-cmd2
            double_cmd2_baz_command "${@:2}"
            ;;
        "qux") # second-level-arg; double-cmd2
            double_cmd2_qux_command "${@:2}"
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
        double_cmd1_command "${@:2}"
        ;;
    "double-cmd2") # first-level-arg;
        double_cmd2_command "${@:2}"
        ;;
    "help") # first-level-arg;
        show_usage "${@:2}"
        ;;
    *)
        show_usage
        ;;
esac
