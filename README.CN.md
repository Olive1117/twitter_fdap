# Twitter FDAP

一个用于自动导出和检查你的 X(Twitter) 关注者和正在关注列表差异的 Linux 脚本。

[English](README.md) | 简体中文

# 联系方式

在 [Twitter](https://x.com/Ak1raQ_love) 上联系我 @Ak1raQ_love。

# 警告

此脚本仅供个人使用。在你的计算机上运行时可能会出现错误。请确保你理解代码并根据需要进行修改。

**对于中国用户：请将脚本语言切换为English，否则无法正常运行！**

# 环境要求

- GNU/Linux 操作系统
- Python3 和 pip3
- Google Chrome
- 端口 9992 可用
- jq 版本 1.7.1

# 使用方法

克隆仓库并运行 `run.sh` 脚本。

## 首次运行

你必须先获取关注列表的初始版本才能使用此脚本。

1. 切换到脚本所在目录

2. 运行`pip3 install ./requirements.txt`

3. 使用 `--user-data-dir=./chromium-data` 参数启动 Google Chrome

4. 安装 tampermonkey 和我修改过的 twitter-web-exporter

5. 将下载目录设置为 `./temp`

6. 登录你的 Twitter 账号并访问 [https://x.com/[你的Twitter-ID]/followers/](https://x.com/%5B你的Twitter-ID%5D/followers/)

7. 允许 `x.com` 的pop-ups权限

8. 滚动到列表底部

9. 点击左侧的猫咪图标展开菜单

10. 点击相应行的箭头，勾选顶部复选框，然后点击 `Export Data` 再点击 `Start Export`

11. 使用相同方法导出"正在关注"列表

12. 频繁点击`Start Export`来触发Chrome询问是否允许多次下载的弹窗，然后点击`允许`

13. 删除多余的文件

14. 在脚本目录下运行以下命令：
    
    ```bash
    cd data
    git config --global init.defaultBranch main
    git init
    cd ..
    ```
    
    （或者在 GitHub 上创建仓库并运行 `git clone [Your repository URL]`）
    
    然后运行：
    
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

15. 在`info/acknowledgment.txt`中输入`I have followed the above steps`   

## 参数

**这些参数只是为了方便我个人开发。请在判断后使用。**

### run.sh

- `--link`: 将 chromium-data 创建为指向 ~/.config/google-chrome 的符号链接。这个参数使你能够使用原来的 Chrome 数据，但如果操作不当可能导致数据丢失。

- `--download=[path]`: 指定下载文件夹。

- `--dd`: 将下载文件夹设置为 ~/Downloads。

- `--kill`: 在运行前关闭 Google Chrome。

- `--custom-count`: 自定义目标数字。

- `--username=[username]`: 更改 Twitter 用户名。

### sort.sh

- `--disable-git-push`: 暂时禁用推送到远程 Git 仓库。

- `--disable-tg-push`: 暂时禁用推送到 Telegram Bot。

# 配置

创建 `info` 文件夹

在 `info/id.txt` 中输入你的 Twitter ID。

## 推送到 Telegram 机器人

在 `info/tgapi.txt` 中输入你的 Telegram 机器人 API 密钥。

在 `info/tguserid.txt` 中输入你的 Telegram 用户 ID（一个数字）。

## 推送到 GitHub 仓库

切换到 `data` 文件夹并运行：

```bash
git remote set-url origin https://your_username:your_token@[Your repository URL]
```

# 视频教程

https://youtu.be/RRp5NUd1Jrg
