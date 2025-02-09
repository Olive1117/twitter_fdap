#!/bin/bash
ID=$(cat info/id.txt)
while true
do
JSON_DATA=$(curl -s http://localhost:9222/json)
MATCHED_BLOCK=$(echo "$JSON_DATA" | jq -r --arg id "$ID" '.[] | select(.url | contains($id))')
if [ -n "$MATCHED_BLOCK" ]; then
    DEBUG_URL_ORIGINAL=$(echo "$MATCHED_BLOCK" | jq -r '.webSocketDebuggerUrl')
    DEBUG_URL="${DEBUG_URL_ORIGINAL/localhost/127.0.0.1}"
    echo "$DEBUG_URL" > ./temp/debug_url.txt
    cat ./temp/debug_url.txt
    break
else
    echo "$ID not found."
    sleep 1
fi
done
