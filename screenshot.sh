wscat -c $(cat temp/debug_url.txt) -x '{"id": 1, "method": "Page.captureScreenshot"}' > base64.js
cat base64.js | jq -r '.result.data' > base64.txt
cat base64.txt | base64 -d > screenshot.png
rm base64.js base64.txt
