#!/bin/bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$script_dir/http.sh"

function updatepdx() {
    sed -i "$1s/></>$2</" $postdata
}

function request_soap() {
    postxml @$postdata $1
}

function after_response() {
    ischanged "$RESULT" "$postdata_"
}

function onChanged() {
    echo "isChange:$1,$2"
}
