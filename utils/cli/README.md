# 👋 Welcome to your app CLI

A simple bash CLI framework. Add something like the following to your run commands file:

```bash
alias appcli='source ~/your/path/to/app/utils/cli/init ~/your/path/to/app/utils/cli'
```

 Then run `appcli` to initiate your CLI. Run `cli.info` to see available commands and their documentation.

 ## CLI framework

 ```
 -> cli
    - commands
    - docs
    - environment
    - init
 ```

### Commands

Write and place whatever CLI commands you want here. If you want `cli.docs ` to auto generate usage docs, make sure to add the appropriate doc comments header formatted as follows:

```bash
# @name func.doc.example Function documentation example.
# @arg { string } $1 foo The most basic of args.
# @arg { string } $2 bar The second most basic of args.
# @returns Description of what the exit environment is, what the function did.
function func.doc.example() {
    local foo=$1
    local bar=$2
    # Some more code here.
}
```

### Docs

The awk script that controls how the commands documation is printed to output.

### Enironment

Set the CLI environment variables here. `$ROUTES` holds app directory paths, and `$COLORS` and `$SPACING` can help with `awk` or general string formatting. Anything set here will be available once the CLI is initialized.

### Init

The script that starts the CLI. It sources the environment and the commands. It takes the CLI working directory as input. It uses this to build the source paths to the environment and the commands. 

