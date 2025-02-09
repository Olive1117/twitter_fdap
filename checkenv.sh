touch ./temp/checkenv-status.txt
sleep 0.3
if [[ ! -e info/acknowledgment.txt || "$(cat info/acknowledgment.txt)" != "I have followed the above steps" ]]; then
    echo "1" > ./temp/checkenv-status.txt
    sleep 0.1
    echo "Error: You haven't completed the pre-running steps. Check the README.md for more details."
    exit 1
fi
if [[ $(which google-chrome) == "" ]]; then
	echo "1" > ./temp/checkenv-status.txt
	sleep 0.1
	echo "Error: google-chrome is not installed."
	exit 1
fi
if [[ $(which jq) == "" ]]; then
	echo "1" > ./temp/checkenv-status.txt
	sleep 0.1
	echo "Error: jq is not installed."
	exit 1
fi
if [[ "$(jq --version | tr -d '\n')" != "jq-1.7.1" ]]; then
    echo "1" > ./temp/checkenv-status.txt
    sleep 0.1
    echo "Error: jq version is not 1.7.1"
    exit 1
fi
if [[ $(which python3) == "" ]]; then
	echo "1" > ./temp/checkenv-status.txt
	sleep 0.1
	echo "Error: Python3 is not installed."
	exit 1
fi
if [[ $(which pip3) == "" ]]; then
	echo "1" > ./temp/checkenv-status.txt
	sleep 0.1
	echo "Error: pip3 is not installed."
	exit 1
fi
if [[ $(which curl) == "" ]]; then
	echo "1" > ./temp/checkenv-status.txt
	sleep 0.1
	echo "Error: curl is not installed."
	exit 1
fi
if [[ $(netstat -tuln | grep ":9222 ") != "" ]]; then
	echo "1" > ./temp/checkenv-status.txt
	sleep 0.1
	echo "Error: Port 9222 is alreay in use."
	exit 1
fi
if [[ $(ps aux | grep chrome | grep -v grep) != "" ]]; then
	echo "1" > ./temp/checkenv-status.txt
	sleep 0.1
	echo "Error: Google Chrome is already running. Close it first."
	exit 1
fi
if [[ -z "$(pip3 freeze | grep python-telegram-bot)" || -z "$(pip3 freeze | grep websockets)" ]]; then
    echo "1" > ./temp/checkenv-status.txt
    sleep 0.1
    echo "Some Python modules are missing. Run 'pip3 install -r ./requirements.txt' to install them."
    exit 1
fi
echo "0" > ./temp/checkenv-status.txt
