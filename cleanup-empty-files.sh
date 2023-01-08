#!/bin/bash


function _delete_invalid_jsons() {
    find db/fixtures/ -name \*json | while read JSONFILE ; do
        echo "Testing $JSONFILE.."
        validjson < "$JSONFILE" &&
            echo "👍 ok $JSONFILE" ||
                echodo mv "$JSONFILE" "$JSONFILE.deleteme"
    done
}

echo "🧹 Cleaning up EMPTY files in JSON - probably generated by some wrong gcloud command.."
find db/fixtures/ -size 0 -name \*json | xargs ls -al
find db/fixtures/ -size 0 -name \*json -print0 | xargs -0 rm

# now lets validate json :)
# npm i -g valid-json-cli

which validjson && _delete_invalid_jsons
