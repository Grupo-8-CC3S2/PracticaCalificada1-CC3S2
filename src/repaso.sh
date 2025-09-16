#!/usr/bin/env bash
set -o errexit # -e 
set -o nounset # -u 
set -o pipefail 
set -o noclobber #>> >
umask 027 
IFS=$'\n\t'

cleanup(){
    false | true | true
    echo "exit status global" $?
}
check_deps(){
    false | true | true
    echo "exit status global" $?
}

cleanup 
check_deps