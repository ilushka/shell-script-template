#!/bin/bash

function run_test() {
    atest="${1}"
    expected="${2}"
    result=$(eval $atest)
    ([[ ! "$result" = "$expected" ]] && printf "\e[31mWrong\e[0m\t%s\n" "$atest") ||
            printf "\e[32mCorrect\e[0m\t%s\n" "$atest" 
}

run_test "./build.sh" "Usage: build.sh <single|double-cmd1|double-cmd2|help>"
run_test "./build.sh help" "Usage: build.sh <single|double-cmd1|double-cmd2|help>"

run_test "./build.sh help single" "Usage: build.sh single <a> <b> <c>
This is a single command.
It is not part of any subgroup of commands.
<a> - Integer
<b> - Integer
<c> - Integer"
run_test "./build.sh single" "Error: missing <a> parameter.

Usage: build.sh single <a> <b> <c>
This is a single command.
It is not part of any subgroup of commands.
<a> - Integer
<b> - Integer
<c> - Integer"
run_test "./build.sh single 1" "Error: missing <b> parameter.

Usage: build.sh single <a> <b> <c>
This is a single command.
It is not part of any subgroup of commands.
<a> - Integer
<b> - Integer
<c> - Integer"
run_test "./build.sh single 1 2" "Error: missing <c> parameter.

Usage: build.sh single <a> <b> <c>
This is a single command.
It is not part of any subgroup of commands.
<a> - Integer
<b> - Integer
<c> - Integer"
run_test "./build.sh single 1 2 3" "single command: a = 1, b = 2, c = 3"

run_test "./build.sh help double-cmd1" "Usage: build.sh double-cmd1 <foo|bar>"
run_test "./build.sh double-cmd1" "Usage: build.sh double-cmd1 <foo|bar>"

run_test "./build.sh help double-cmd1 foo" "Usage: build.sh double-cmd1 foo <xx>
This is a double command.
It is part of double-cmd1 subgroup of commands.
<xx> - Integer"
run_test "./build.sh double-cmd1 foo" "Error: missing <xx> parameter.

Usage: build.sh double-cmd1 foo <xx>
This is a double command.
It is part of double-cmd1 subgroup of commands.
<xx> - Integer"
run_test "./build.sh double-cmd1 foo 1" "double-cmd1 foo command: xx = 1"

run_test "./build.sh help double-cmd1 bar" "Usage: build.sh double-cmd1 bar 
This is a double command.
It takes no parameters.
It is part of double-cmd1 subgroup of commands."
run_test "./build.sh double-cmd1 bar" "double-cmd1 bar command"

run_test "./build.sh double-cmd2" "Usage: build.sh double-cmd2 <baz|qux>"
run_test "./build.sh help double-cmd2" "Usage: build.sh double-cmd2 <baz|qux>"
