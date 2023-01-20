# 👋 Welcome to your app CLI

A simple bash CLI framework. Add something like the following to your run commands file:

```bash
alias appcli='source ~/your/path/to/app/utils/cli/init ~/your/path/to/app/utils/cli'
```

 Then run `appcli` to initiate your CLI. Run `info` to see available commands and their documentation.

 ## CLI framework

 ```
 -> cli /
    - commands
    - docs
    - environment
    - init
    - ... 
 ```

### [Commands](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/utils/cli/commands)

Write and place whatever CLI commands you want here. If you want `info` to auto generate usage docs, make sure to add the appropriate doc comments header formatted as follows:

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

Feeling like you have a bunch of similar functions to group? Break them out into a file like `git` and include them in the $DEPS array in [`init`](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/utils/cli/init#L4-L9).

### [Docs](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/utils/cli/docs)

The `awk` script that controls how the commands documation is printed to output.

### [Enironment](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/utils/cli/environment)

Set the CLI environment variables here. `$ROUTE` holds app paths, and `$COLOR` and `$SPACING` can help with `awk` or general string formatting. Anything set here will be available once the CLI is initialized.

### [Init](https://github.com/Michelleeby/omekas-nginx-php-fpm-docker/blob/main/utils/cli/init)

The script that starts the CLI. It takes the CLI working directory as input. It uses this to build the source paths to the dependencies, and it sources all defined dependencies.