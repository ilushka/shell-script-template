# SHELL SCRIPT TEMPLATE

This is a template that I use (mostly) for creating build scripts.

It supports two types of commands: *single* and *grouped*. Single commands look like `./script.sh command` and grouped commands look like `./script.sh group command`. 

The script should work on a purely POSIX shell, but it has not been rigorously tested.

# USAGE

To create a new script:

* Edit the switch case at the bottom of the file. Each case is either a *single* command or a *group*. Add `# cmd-lvl1;` comment to each case. Do not modify the `"help")` and the `*)` case.

```bash
case $1 in
    "some-command") # cmd-lvl1;
        some_command_command $(remove_first_arg "$@")
        ;;
    "group") # cmd-lvl1;
        group_command $(remove_first_arg "$@")
        ;;
    "help") # cmd-lvl1;
        show_usage $(remove_first_arg "$@")
        ;;
    *)
        show_usage
        ;;
esac
```

* If you have *grouped* commands create function with a switch case for each group. Add commands to for the group to the switch case and add one default case `*)` that calls `show_usage "group_name"`. Add `# cmd-lvl2; group_name` comment to each case, except for the default case.

```bash
group_command() {
    case $1 in
        "another-command") # cmd-lvl2; group
            group_another_command_command $(remove_first_arg "$@")
            ;;
        *)
            show_usage "group"
            ;;
    esac
}
```

* Create a function for each command, single or grouped. Function name should be of format: `[group_name_]some_command_command()`, optional group name and and an underscore (`_`) + command name + `_command` suffix. Dashes (`-`) should be replaced by underscores (`_`).

`./build.sh some-group some-command` &rarr; `some_group_some_command_command()`

* Add multi-line comments right after the command's function definition. Add `# cmd-doc-end;` as the last comment. This will be the body of text for the help for that command. First line of the help text should list all arguments for that command, or stay blank.

```bash
group_another_command_command() {
    # <arg1> <arg2> <arg3>
    # This is a grouped command. 
    # <arg1> - Command argument
    # <arg2> - Command argument
    # <arg3> - Command argument
    # cmd-doc-end;
    printf "group another-command: arg1 = %d, arg2 = %d, arg3 = %d\n" $arg1 $arg2 $arg3
}
```

`single_command()` or `group1_foo_command` have some basic command verification examples.

# TODO

