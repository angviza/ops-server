#!/bin/bash

./yq --xml-keep-namespace=false --xml-raw-token=false -o=json '.' test.xml | ./yq '.Envelope.Body'
