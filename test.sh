#!/bin/bash

function run_test() {
    atest="${1}"
    expected="${2}"
    result=$(eval $atest)
    ([[ ! "$result" = "$expected" ]] && printf "\e[31mWrong\e[0m\t%s\n" "$atest") ||
            printf "\e[32mCorrect\e[0m\t%s\n" "$atest" 
}

run_test "./build.sh" "Usage: build.sh <single|group1|group2|help>"
run_test "./build.sh help" "Usage: build.sh <single|group1|group2|help>"

run_test "./build.sh help single" "Usage: build.sh single <a> <b> <c>
This is a single command.
It is not part of any group of commands.
<a> - Integer
<b> - Integer
<c> - Integer"
run_test "./build.sh single" "Error: missing <a> parameter.

Usage: build.sh single <a> <b> <c>
This is a single command.
It is not part of any group of commands.
<a> - Integer
<b> - Integer
<c> - Integer"
run_test "./build.sh single 1" "Error: missing <b> parameter.

Usage: build.sh single <a> <b> <c>
This is a single command.
It is not part of any group of commands.
<a> - Integer
<b> - Integer
<c> - Integer"
run_test "./build.sh single 1 2" "Error: missing <c> parameter.

Usage: build.sh single <a> <b> <c>
This is a single command.
It is not part of any group of commands.
<a> - Integer
<b> - Integer
<c> - Integer"
run_test "./build.sh single 1 2 3" "single command: a = 1, b = 2, c = 3"

run_test "./build.sh help group1" "Usage: build.sh group1 <foo|bar>"
run_test "./build.sh group1" "Usage: build.sh group1 <foo|bar>"

run_test "./build.sh help group1 foo" "Usage: build.sh group1 foo <xx>
This is a grouped command.
It is part of group1 group of commands.
<xx> - Integer"
run_test "./build.sh group1 foo" "Error: missing <xx> parameter.

Usage: build.sh group1 foo <xx>
This is a grouped command.
It is part of group1 group of commands.
<xx> - Integer"
run_test "./build.sh group1 foo 1" "group1 foo command: xx = 1"

run_test "./build.sh help group1 bar" "Usage: build.sh group1 bar 
This is a grouped command.
It takes no parameters.
It is part of group1 group of commands."
run_test "./build.sh group1 bar" "group1 bar command"

run_test "./build.sh group2" "Usage: build.sh group2 <baz|qux>"
run_test "./build.sh help group2" "Usage: build.sh group2 <baz|qux>"
