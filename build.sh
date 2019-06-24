#!/bin/sh

# UTILITIES 
################################################################################

BIN=$(basename $0)

remove_first_arg() {
    echo "$@ " | cut -d ' ' -f2-
}

count_words() {
    echo "$@" | wc -w | sed 's/^[[:space:]]*//g'
}

get_single_cmd_usage() {
    sed -n 's/[[:space:]]*\"\([a-z0-9-]*\)\") # cmd-lvl1;.*$/\1/p' ${BIN} | tr '\n' '|' | sed 's/|$//g'
}

get_group_usage() {
    sed -n 's/[[:space:]]*\"\([a-z0-9-]*\)\") # cmd-lvl2; '"${1}"'.*$/\1/p' ${BIN} | tr '\n' '|' | sed 's/|$//g'
}

get_single_cmd_help() {
    awk '/'"$(echo "${1}" | tr '-' '_')"'_command\(\)/{f=1; next;} /# cmd-doc-end;/{f=0} f' ${BIN} | sed 's/^[[:space:]]*#[[:space:]]*//g'
}

get_grouped_cmd_help() {
    awk '/'"$(echo "${1}_${2}" | tr '-' '_')"'_command\(\)/{f=1; next;} /# cmd-doc-end;/{f=0} f' ${BIN} | sed 's/^[[:space:]]*#[[:space:]]*//g'
}

show_usage() {
    arg_count=$(count_words $@)
    if [ $arg_count -eq 0 ]; then
        printf "Usage: ${BIN} <$(get_single_cmd_usage)>\n"
    elif [ $arg_count -eq 1 ]; then
        dbl_usage=$(get_group_usage $1)
        if [ ! -z "$dbl_usage" ]; then
            printf "Usage: ${BIN} ${1} <${dbl_usage}>\n"
        else
            printf "Usage: ${BIN} ${1} $(get_single_cmd_help $1)\n"
        fi
    elif [ $arg_count -eq 2 ]; then
        printf "Usage: ${BIN} ${1} ${2} $(get_grouped_cmd_help $1 $2)\n"
    fi
    exit 1
}

# COMMAND FUNCTIONS
################################################################################

single_command() {
    # <a> <b> <c>
    # This is a single command.
    # It is not part of any group of commands.
    # <a> - Integer
    # <b> - Integer
    # <c> - Integer
    # cmd-doc-end;

    a=$1
    [ "_$a" = "_" ] && printf "Error: missing <a> parameter.\n\n" && show_usage "single" 
    shift
    b=$1
    [ "_$b" = "_" ] && printf "Error: missing <b> parameter.\n\n" && show_usage "single" 
    shift
    c=$1
    [ "_$c" = "_" ] && printf "Error: missing <c> parameter.\n\n" && show_usage "single" 
    printf "single command: a = %d, b = %d, c = %d\n" $a $b $c
}

group1_foo_command() {
    # <xx>
    # This is a grouped command.
    # It is part of group1 group of commands.
    # <xx> - Integer
    # cmd-doc-end;

    xx=$1
    [ "_$xx" = "_" ] && printf "Error: missing <xx> parameter.\n\n" && show_usage "group1" "foo" 
    shift
    printf "group1 foo command: xx = %d\n" $xx
}

group1_bar_command() {
    #
    # This is a grouped command.
    # It takes no parameters.
    # It is part of group1 group of commands.
    # cmd-doc-end;

    printf "group1 bar command\n"
}

group2_baz_command() {
    #
    # This is a grouped command.
    # It takes no parameters.
    # It is part of group2 group of commands.
    # cmd-doc-end;

    printf "group2 baz command\n"
}

group2_qux_command() {
    #
    # This is a grouped command.
    # It is part of group2 group of commands.
    # cmd-doc-end;

    printf "group2 qux command\n"
}

# COMMAND TREE
################################################################################

# Command groups:

group1_command() {
    case $1 in
        "foo") # cmd-lvl2; group1 
            group1_foo_command $(remove_first_arg "$@")
            ;;
        "bar") # cmd-lvl2; group1
            group1_bar_command $(remove_first_arg "$@")
            ;;
        *)
            show_usage "group1"
            ;;
    esac
}

group2_command() {
    case $1 in
        "baz") # cmd-lvl2; group2
            group2_baz_command $(remove_first_arg "$@")
            ;;
        "qux") # cmd-lvl2; group2
            group2_qux_command $(remove_first_arg "$@")
            ;;
        *)
            show_usage "group2"
            ;;
    esac
}

# Single commands:

case $1 in
    "single") # cmd-lvl1;
        single_command $(remove_first_arg "$@")
        ;;
    "group1") # cmd-lvl1;
        group1_command $(remove_first_arg "$@")
        ;;
    "group2") # cmd-lvl1;
        group2_command $(remove_first_arg "$@")
        ;;
    "help") # cmd-lvl1;
        show_usage $(remove_first_arg "$@")
        ;;
    *)
        show_usage
        ;;
esac
