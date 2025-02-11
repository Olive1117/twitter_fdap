# Twitter FDAP

A Linux script for exporting and checking the diff in your X(Twitter) followers and following list automatically.

FDAP = Followers Diff Auto Push

English | [简体中文](README.CN.md)

# Contact Me

Contact me on [Twitter](https://x.com/Ak1raQ_love) @Ak1raQ_love.

# Warning

The script is intended for my personal use. It may cause bugs or errors when run on your computer. Make sure you understand the code and modify it as necessary.

**For Chinese users: 请将脚本语言切换为English,否则无法正常运行！**

# Requirements

- GNU/Linux Operating System
- Python3 and pip3
- Google Chrome
- Port 9992 should be available
- jq version 1.7.1

# Usage

Clone the repository and run the script `run.sh`.

## First Run

You must obtain an initial version of the follow list to use this script.

1. Change your dir to the script

2. Run `pip3 install -r ./requirements.txt`

3. Start Google Chrome with `--user-data-dir=./chromium-data`

4. Install tampermonkey and my modified twitter-web-exporter

5. Set the download dictionary to `./temp`

6. Sign in your Twitter Account and visit [https://x.com/[Your-Twitter-ID]/followers/](https://x.com/%5BYour-Twitter-ID%5D/followers/)

7. Allow `x.com` pop-ups

8. Scroll to the bottom of the list.

9. Click the cat icon on the left to expand the menu.

10. Click the arrowhead in the corresponding row, check the checkbox at the top, and click `Export Data` then `Start Export`.

11. Use the same method to export the 'following' list.

12. Press the `Start Export` button quickly to trigger the notification requesting permission for multiple downloads, then click `Allow`.

13. Delete the extra files.

14. Run the following commands in the directory of this script:
    
    ```bash
    cd data
    git config --global init.defaultBranch main
    git init
    cd ..
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

15. Enter `I have followed the above steps` into `info/acknowledgment.txt`.

## Parameters

**These parameters are for more convenient development just for me. Use them after making a judgment.**

### run.sh

- `--link`: Create a symbolic link from chromium-data to ~/.config/google-chrome. This parameter makes it possible to use your usual Chrome data, but improper operation may lead to data loss.

- `--download=[path]`: Specify the download folder.

- `--dd`: Set the download folder to ~/Downloads.

- `--kill`: Kill Google Chrome before running.

- `--custom-count`: Customize the target numbers.

- `--username=[username]`: Change the Twitter username.

### sort.sh

- `--disable-git-push`: Temporarily disable pushing to the remote Git repository.

- `--disable-tg-push`: Temporarily disable pushing to the Telegram bot.

# Configuration

Create a folder `info`

Enter your Twitter ID in `info/id.txt`.

## Push to Telegram bot

Enter your Telegram bot API key in `info/tgapi.txt`.

Enter your Telegram User ID (a number) in `info/tguserid.txt`.

## Push to GitHub repository

 Change to the `data` folder and run:

```bash
git remote set-url origin https://your_username:your_token@[Your repo URL]
```

# Video Guide

https://youtu.be/RRp5NUd1Jrg
