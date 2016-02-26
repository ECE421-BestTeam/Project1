require_relative './lib/shell'

include CustomShell
run

## run calls the shell, from which you can enter any of the following commands:
## replacing arguments <arg> as neccessary

# ls
# pwd
# cd <path>
# mkdir <path>
# rm <path>
# touch <filename>

# delayedMessage <time> "<message>"
# eg. delayedMessage 2 "hi there"

# delayedAction <time> "<ruby code>"
# eg. delayedAction 0 "puts 'hi'; puts 'bye'"

# filewatch <mode> <optional time> <filename(s)> "<command>"
# Note: command is required
# eg. filewatch create 3 testfile “puts ‘hello testfile’”
# mode can be create/alter/destroy

