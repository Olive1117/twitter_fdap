# Twitter FDAP

一个用于自动导出和检查你的 X(Twitter) 关注者和正在关注列表差异的 Linux 脚本。

[English](README.md) | 简体中文

# 联系方式

在 [Twitter](https://x.com/Ak1raQ_love) 上联系我 @Ak1raQ_love。

# 警告

此脚本仅供个人使用。在你的计算机上运行时可能会出现错误。请确保你理解代码并根据需要进行修改。

**对于中国用户：请将脚本语言切换为English，否则无法正常运行！**

# 环境要求

- Linux 计算机
- Python3 及 websockets 模块
- 安装了 Tampermonkey 的 Google Chrome
- 在 Google Chrome 中登录你的 Twitter 账号
- 在 Tampermonkey 中安装并启用 [twitter-web-exporter](https://github.com/prinsss/twitter-web-exporter) v1.2.0（注意：请使用本 FDAP 脚本中我修改过的 `twitter-web-exporter.js`）
- 展开 twitter-web-exporter 中的菜单
- 端口 9992 可用
- 已安装 7-zip、jq(1.7.1)、xterm 和 git
- 在 `id.txt` 中输入你的 Twitter ID

# 使用方法

克隆仓库并运行 `run.sh` 脚本。

## 首次运行

你必须先获取关注列表的初始版本才能使用此脚本。

1. 切换到脚本所在目录

2. 使用 `--user-data-dir=./chromium-data` 参数启动 Google Chrome

3. 安装 tampermonkey 和我修改过的 twitter-web-exporter

4. 将下载目录设置为 `./temp`

5. 登录你的 Twitter 账号并访问 [https://x.com/[你的Twitter-ID]/followers/](https://x.com/%5B你的Twitter-ID%5D/followers/)

6. 允许 `x.com` 的弹窗和自动下载

7. 滚动到列表底部

8. 点击左侧的猫咪图标展开菜单

9. 点击相应行的箭头，勾选顶部复选框，然后点击 `Export Data` 再点击 `Start Export`

10. 使用相同方法导出"正在关注"列表

11. 在脚本目录下运行以下命令：
    
    ```bash
    cd data
    git config --global init.defaultBranch main
    git init
    ```
    
    （或者在 GitHub 上创建仓库并运行 `git clone [你的仓库URL]`）
    
    然后运行：
    
    ```bash
    jq -c '.[]' ~/Downloads/twitter-Followers-*.json | while read -r item; do
      id=$(echo "$item" | jq -r '.id')
      echo "$item" | jq . > "$source_dir/${id}.json"
    done
    jq -c '.[]' ~/Downloads/twitter-Following-*.json | while read -r item; do
      id=$(echo "$item" | jq -r '.id')
      echo "$item" | jq . > "$source_dir/${id}.json"
    done
    ```

# 配置

创建 `info` 文件夹

在 `info/id.txt` 中输入你的 Twitter ID。

## 推送到 Telegram 机器人

在 `info/tgapi.txt` 中输入你的 Telegram 机器人 API 密钥。

在 `info/tguserid.txt` 中输入你的 Telegram 用户 ID（一个数字）。

## 推送到 GitHub 仓库

切换到 `data` 文件夹并运行：

```bash
git remote set-url origin https://your_username:your_token@[你的仓库URL]
```
