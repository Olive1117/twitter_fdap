# Twitter FDAP（关注变动自动推送脚本）

一个用于自动导出并追踪你在 X（原 Twitter）上的关注者与关注列表变动的 Python 脚本。

**FDAP** = Followers Diff Auto Push（关注变动自动推送）

[English](README.md) | **简体中文**

---

## 功能特点

- 导出 X（Twitter）上的关注者和关注列表  
- 自动检测并追踪每次导出之间的变化  
- 自动推送更新到 GitHub 或 Telegram，方便查看  

---

## 注意事项

本脚本为**个人使用**而设计，在其他系统上可能无法正常运行。使用前请根据自身需求阅读并修改代码。

---

## 环境要求

- Python 3.4 或更高版本  
- Twitter Web Exporter 2.1 或更高版本  
- 开启远程调试模式的 Google Chrome  
- Tampermonkey 浏览器扩展  

---

## 安装与使用

### 1. 克隆项目仓库

```bash
git clone https://github.com/your_username/twitter_fdap.git
cd twitter_fdap
```

### 2. 安装依赖

```bash
pip3 install -r requirements.txt
```

### 3. 配置脚本

在 `config.ini` 中更新以下内容：

- 你的 Twitter ID（可使用 [Twitter ID Converter](https://tweethunter.io/twitter-id-converter) 获取）
- Chrome 的远程调试URL
- Chrome 的下载目录路径


### 4. 初始化数据目录

```bash
cd data
git config --global init.defaultBranch main
git init
cd ..
```

### 5. 运行
```bash
python3 ./main.py
```

或者，克隆一个已有的 GitHub 仓库


## 联系方式

欢迎通过 [Twitter](https://x.com/P5KAban) (@P5KAban) 联系作者。

---

## 免责声明

本脚本以“原样”提供，使用风险由您自行承担。使用前请确保已了解其功能与操作方式。
