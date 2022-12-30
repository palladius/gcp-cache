#!/bin/bash

DIR="${1:-.}"

# https://stackoverflow.com/questions/42385036/validate-json-file-syntax-in-shell-script-without-installing-any-package
find "$DIR" -name \*.json | while read F; do 
    python -mjson.tool "$F"  > /dev/null; 
    echo "$? -- $F"; 
done | egrep -v ^0