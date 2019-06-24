# SHELL SCRIPT TEMPLATE

This is a template that I use (mostly) for creating build scripts.

It supports two types of **commands**: single and grouped. Single commands look like `./script.sh command` and grouped commands look like `./script.sh group command`. 

The script should work on a purely POSIX shell, but it has not been rigorously tested.

# USAGE

To create a new script:

* Update switch case at the bottom of the file. Each case is either a *single* or *grouped* command. Add `# cmd-lvl1;` comment to each case.
* If you have *grouped* commands create function with switch case for each group. Add commands to for the group to the switch case add `# cmd-lvl2; group_name` comment to each case.
* Create a function for each command.
* Add multiline comments right after command function definition. Add `# cmd-doc-end;` as last comment. This will be text body for help for that command. First line of the help text should list all arguments for that command, or stay blank.
* `single_command()` or `group1_foo_command` has some basic command verification.

# TODO

