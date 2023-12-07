#!/bin/bash
function update() {
    sed -i "$1s/></>$2</" $request_xml
}
