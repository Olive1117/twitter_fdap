#!/bin/bash
clear
rm -rf ./temp/*
pkill -f vncserver
figlet -k -W "FDAP"
echo 'https://github.com/MtFloveU/twitter_fdap'
echo ' '
sleep 2
echo "Starting VNC Server..."
vncserver :2 -xstartup "/usr/bin/xterm" > /dev/null 2>&1
sleep 1
export DISPLAY=:2
DISPLAY=:2 chromium-browser "https://x.com/"$(cat info/id.txt) --start-maximized --remote-debugging-port=9222 --no-sandbox --disable-gpu > /dev/null 2>&1 &
CHROMIUM_PID=$!
echo 'Starting Chromium browser...'
while true; do
  sleep 0.1
  if curl -s http://127.0.0.1:9222/json > /dev/null; then
    sleep 0.1
    break
  fi
done
echo "Opening your Twitter profile..."
sleep 1
./get_debug_url.sh > /dev/null
while true; do
    if [[ -s ./temp/target_number-1.txt && -s ./temp/target_number-2.txt ]]; then
        break
    fi
    python3 ./get_followers_count.py
    sleep 0.5
done
echo "The number was loaded."
python3 ./open.py
echo "Waiting for the website fully loaded..."
sleep 3
echo "Fetching your follower lists..."

while [ ! -f ./temp/fetched-followers.txt ] || [ "$(cat ./temp/fetched-followers.txt)" != "1" ]; do
    python3 ./scroll.py
done

echo "Fetching your following lists..."
while [ ! -f ./temp/fetched-following.txt ] || [ "$(cat ./temp/fetched-following.txt)" != "1" ]; do
    python3 ./scroll-2.py
done
echo "Exporting..."
./get_debug_url.sh | xargs -I {} python3 ./export.py {}
sleep 0.5
./sort.sh
rm -rf ./temp/*
rm -f ~/Downloads/twitter-Follower*.json
rm -f ~/Downloads/twitter-Following*.json
pkill -f $CHROMIUM_PID
pkill -f vncserver
pkill -f tigervnc
echo "Contant me on Twitter @Ak1raQ_love"
exit 0
