#!/bin/bash
clear
originalpath=$(pwd)
cd "$(dirname "$0")"
mkdir -p ./temp/
mkdir -p ./info/
mkdir -p ./data/
rm -rf ./temp/*
#pkill -f vncserver
figlet -k -W "FDAP"
echo 'https://github.com/MtFloveU/twitter_fdap'
echo ' '
sleep 2
#echo "Starting VNC Server..."
#vncserver :2 -xstartup "/usr/bin/xterm" > /dev/null 2>&1
#sleep 1
#export DISPLAY=:2
#google-chrome "https://x.com/"$(cat info/id.txt) --remote-debugging-port=9222 --no-sandbox --disable-gpu --User-Agent='TwitterAndroid/10.76.0-release.0 (310760000-r-0) CPH2609/15 (OnePlus;CPH2609;OnePlus;CPH2609;0;;1;2016)' --user-data-dir=./chromium-data --start-maximized --window-size=1920,1080 --enable-low-end-device-mode > /dev/null 2>&1 &
if [[ ! -f "./info/id.txt" ]] || [[ ! -s "./info/id.txt" ]]; then
  read -p "Enter your Twitter username (without '@'): " input
  echo $input > ./info/id.txt
fi
google-chrome "https://x.com/"$(cat info/id.txt) --remote-debugging-port=9222 --no-sandbox --disable-gpu --headless=new --User-Agent='TwitterAndroid/10.76.0-release.0 (310760000-r-0) CPH2609/15 (OnePlus;CPH2609;OnePlus;CPH2609;0;;1;2016)' --user-data-dir=./chromium-data --start-maximized --window-size=1920,1080 --enable-low-end-device-mode > /dev/null 2>&1 &
CHROMIUM_PID=$!
#cpulimit -p $CHROMIUM_PID -l 60 &
echo 'Starting Google Chrome...'
while true; do
  sleep 0.1
  if curl -s http://127.0.0.1:9222/json > /dev/null; then
    sleep 0.1
    break
  fi
done
sleep 1
./get_debug_url.sh > /dev/null
while true; do
    if [[ -s ./temp/target_number-1.txt && -s ./temp/target_number-2.txt ]]; then
        break
    fi
    python3 ./get_followers_count.py
    sleep 0.5
done
python3 ./open.py
echo "Waiting..."
sleep 3
echo "Fetching your followers list..."

while [ ! -f ./temp/fetched-followers.txt ] || [ "$(cat ./temp/fetched-followers.txt)" != "1" ]; do
    python3 ./scroll.py
done

echo "Fetching your following list..."
while [ ! -f ./temp/fetched-following.txt ] || [ "$(cat ./temp/fetched-following.txt)" != "1" ]; do
    python3 ./scroll.py --following
done
sleep 2
echo "Exporting..."
python3 ./export.py
sleep 2
pkill -9 $CHROMIUM_PID
pkill -f chrome
./sort.sh
rm -rf ./temp/*
#pkill -f cpulimit
#pkill -f vncserver
#pkill -f tigervnc
echo "Contant me on Twitter @Ak1raQ_love"
cd $originalpath
exit 0
