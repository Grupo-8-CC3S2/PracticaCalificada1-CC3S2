#!/usr/bin/env bash
set -o errexit # -e 
set -o nounset # -u 
set -o pipefail 
set -o noclobber #>> >
umask 027
Py ="${PYTHON:-python3}"
IFS =$'\n\t'

cleanup(){
    true | true | true
    echo "exit status global" $?
}
check_deps(){
    true | false | true
    echo "exit status global" $?
}
check_dns(){

}
cleanup 
check_deps