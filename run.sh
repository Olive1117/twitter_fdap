#!/bin/bash
clear
rm -rf ./temp/*
pkill -f vncserver
figlet -k -W "FDAP"
echo 'https://github.com/MtFloveU/twitter_fdap'
echo ' '
sleep 2
#echo "Starting VNC Server..."
#vncserver :2 -xstartup "/usr/bin/xterm" > /dev/null 2>&1
#sleep 1
#export DISPLAY=:2
#DISPLAY=:2 chromium-browser "https://x.com/"$(cat info/id.txt) --start-maximized --remote-debugging-port=9222 --no-sandbox --disable-gpu > /dev/null 2>&1 &
chromium-browser "https://x.com/"$(cat info/id.txt) --remote-debugging-port=9222 --no-sandbox --disable-gpu --headless=new --User-Agent='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36' --user-data-dir=./chromium-data --start-maximized --window-size=1920,1080 --enable-low-end-device-mode > /dev/null 2>&1 &
CHROMIUM_PID=$!
#cpulimit -p $CHROMIUM_PID -l 60 &
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
python3 ./export.py
sleep 2
pkill -9 $CHROMIUM_PID
pkill -f chrome
pkill -f chromium
./sort.sh
rm -rf ./temp/*
#pkill -f cpulimit
#pkill -f vncserver
#pkill -f tigervnc
echo "Contant me on Twitter @Ak1raQ_love"
exit 0
