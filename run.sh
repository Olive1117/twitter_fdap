#!/bin/bash
clear
originalpath=$(pwd)
cd "$(dirname "$0")"
mkdir -p ./temp/
mkdir -p ./info/
rm -rf ./temp/*
#pkill -f vncserver
figlet -k -W "FDAP"
echo 'https://github.com/MtFloveU/twitter_fdap'
echo "Contant me on Twitter @Ak1raQ_love"
echo ' '

for arg in "$@"; do
  if [[ "$arg" == --download=* ]]; then
    download="${arg#--download=}"
  fi
done

if [[ "$@" == *"dd"* ]]; then
    download="/home/akira/Downloads"
fi

for arg in "$@"; do
  if [[ "$arg" == --username=* ]]; then
    echo "${arg#--username=}" > ./info/id.txt
  fi
done

if [[ -n "$download" ]]; then
  echo "Download directory set to $download"
  rm -f $download/twitter-Follow*.json
fi

echo "Checking the environment..."
bash ./checkenv.sh
if [[ $(cat ./temp/checkenv-status.txt) == "1" ]]; then
    exit 1
fi

if [[ "$@" == *"link"* ]]; then
    if [[ -e ./chromium-data ]];then
      rm ./chromium-data
      sleep 1
    fi
    ln -s ~/.config/google-chrome ./chromium-data
    sleep 1
fi

if [[ "$@" == *"kill"* ]]; then
    pkill -f chrom
fi

sleep 2
#echo "Starting VNC Server..."
#vncserver :2 -xstartup "/usr/bin/xterm" > /dev/null 2>&1
#sleep 1
#export DISPLAY=:2

if [[ ! -f "./info/id.txt" ]] || [[ ! -s "./info/id.txt" ]]; then
  read -p "Enter your Twitter username (without '@'): " input
  echo $input > ./info/id.txt
fi

echo "Current username: "$(cat ./info/id.txt)

if [[ ! -e "./chromium-data" ]]; then
  echo "The chromium-data directory does not exist. Check the README file for more details."
  exit 1
fi
echo 'Starting Google Chrome...'
#google-chrome "https://x.com/"$(cat info/id.txt) --remote-debugging-port=9222 --no-sandbox --disable-gpu --User-Agent='TwitterAndroid/10.76.0-release.0 (310760000-r-0) CPH2609/15 (OnePlus;CPH2609;OnePlus;CPH2609;0;;1;2016)' --user-data-dir=./chromium-data --start-maximized --window-size=1920,1080 --enable-low-end-device-mode > /dev/null 2>&1 &
google-chrome "https://x.com/"$(cat info/id.txt) --remote-debugging-port=9222 --no-sandbox --disable-gpu --headless=new --User-Agent='TwitterAndroid/10.76.0-release.0 (310760000-r-0) CPH2609/15 (OnePlus;CPH2609;OnePlus;CPH2609;0;;1;2016)' --user-data-dir=./chromium-data --start-maximized --window-size=1920,1080 --enable-low-end-device-mode > /dev/null 2>&1 &
CHROMIUM_PID=$!
#cpulimit -p $CHROMIUM_PID -l 60 &
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
    if [[ "$@" == *"custom-count"* ]]; then
      read -p "Enter your Followers and Following count in order, separated by space: " num1 num2
      echo "$num1" > ./temp/target_number-1.txt
      echo "$num2" > ./temp/target_number-2.txt
    fi
    sleep 0.5
done
python3 ./open.py
echo "Waiting..."
sleep 3
if [[ "$(curl -s http://127.0.0.1:9222/json | jq -r ".[] | select(.webSocketDebuggerUrl == \"$(cat ./temp/debug_url.txt | tr -d '\n')\") | .url")" != "https://x.com/$(cat info/id.txt)/followers" ]]; then
  echo "You haven't signed in to your Twitter account."
  pkill -f chrom
  exit 1
fi
echo "Fetching your followers list..."

while [ ! -f ./temp/fetched-followers.txt ] || [ "$(cat ./temp/fetched-followers.txt)" != "1" ]; do
    python3 ./fetch.py
done

echo "Fetching your following list..."
while [ ! -f ./temp/fetched-following.txt ] || [ "$(cat ./temp/fetched-following.txt)" != "1" ]; do
    python3 ./fetch.py --following
done
sleep 2
echo "Exporting..."
python3 ./export.py
sleep 2
pkill -9 $CHROMIUM_PID
pkill -f chrome
if [[ -n "$download" ]]; then
  cp $download/twitter-Followers*.json ./temp
  cp $download/twitter-Following*.json ./temp
fi
if [[ "$@" == *"proxychains"* ]]; then
  ./sort.sh --proxychains
else
  ./sort.sh
fi
rm -rf ./temp/*
#pkill -f cpulimit
#pkill -f vncserver
#pkill -f tigervnc
if [[ "$@" == *"link"* ]]; then
    rm ./chromium-data
fi
cd $originalpath
exit 0
