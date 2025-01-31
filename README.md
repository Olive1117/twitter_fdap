# Twitter FDAP

A Linux script for exporting and checking the diff in your X(Twitter) follower and following lists automatically.

English | [简体中文](README.CN.md)

# Contact Me

Contact me on [Twitter](https://x.com/Ak1raQ_love) @Ak1raQ_love.

# Warning

The script is intended for my personal use. It may cause bugs or errors when run on your computer. Make sure you understand the code and modify it as necessary.

**For Chinese users: 请将脚本语言切换为English,否则无法正常运行！**

# Requirements

- A Linux computer
- Python3 with the websockets module
- Google Chrome with Tampermonkey installed
- Signed in to your Twitter account in Google Chrome
- Install and enable [twitter-web-exporter](https://github.com/prinsss/twitter-web-exporter) v1.2.0 in Tampermonkey (Note: Please use my modified `twitter-web-exporter.js` in this FDAP script)
- Expand the menu in twitter-web-exporter
- Port 9992 should be available
- 7-zip, jq(1.7.1), xterm, and git installed
- Enter your Twitter ID in `id.txt`

# Usage

Clone the repository and run the script `run.sh`.

## First Run

You must obtain an initial version of the follow list to use this script.

1. Change your dir to the script

2. Start Google Chrome with `--user-data-dir=./chromium-data`

3. Install tampermonkey and my modified twitter-web-exporter

4. Set the download dictionary to `./temp`

5. Sign in your Twitter Account and visit [https://x.com/[Your-Twitter-ID]/followers/](https://x.com/%5BYour-Twitter-ID%5D/followers/)

6. Allow `x.com` pop-ups and Automatic downloads

7. Scroll to the bottom of the list.

8. Click the cat icon on the left to expand the menu.

9. Click the arrowhead in the corresponding row, check the checkbox at the top, and click `Export Data` then `Start Export`.

10. Use the same method to export the 'following' list.

11. Run the following commands in the directory of this script:
    
    ```bash
    cd data
    git config --global init.defaultBranch main
    git init
    ```
    
    (Alternatively, create a repository on GitHub and run `git clone [Your repo URL]`)
    
    Then run:
    
    ```bash
    jq -c '.[]' ./temp/twitter-Followers-*.json | while read -r item; do
      id=$(echo "$item" | jq -r '.id')
      echo "$item" | jq . > "./data/${id}.json"
    done
    jq -c '.[]' ./temp/twitter-Following-*.json | while read -r item; do
      id=$(echo "$item" | jq -r '.id')
      echo "$item" | jq . > "./data/${id}.json"
    done
    ```

# Configuration

Create a folder `info`

Enter your Twitter ID in `info/id.txt`.

## Push to Telegram bot

Enter your Telegram bot API key in `info/tgapi.txt`.

Enter your Telegram User ID (a number) in `info/tguserid.txt`.

### Push to GitHub repository

 Change to the `data` folder and run:

```bash
git remote set-url origin https://your_username:your_token@[Your repo URL]
```
