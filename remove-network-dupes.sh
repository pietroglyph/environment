#!/bin/bash

nmcli con | gawk '
BEGIN {
    actuallyDelFlag = "dryRun=false"
    if (ARGV[1] != actuallyDelFlag) {
        printf "Running in dry run mode. Pass %s to actually delete connections. \n", actuallyDelFlag
    }
}

match($0, /(^.* [0-9]+)( .*)/, capture) {
    if (ARGV[1] == actuallyDelFlag) {
        system("nmcli con delete \""capture[1]"\"")
    } else {
        printf capture[1]"\n"
    }
}

END {
    printf "Done.\n"
}
' $@
