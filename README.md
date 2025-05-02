# Twitter FDAP

A Python script to automatically export and track changes in your X (formerly Twitter) followers and following lists.

**FDAP** = Followers Diff Auto Push

**English** | [简体中文](README.CN.md)

---

## Features

- Export followers and following lists from X (Twitter).
- Automatically detect and track changes between exports.
- Push updates to GitHub or Telegram for easy access.

---

## Warning

This script is intended for personal use and may not function as expected on other systems (besides GNU/Linux). Please review and modify the code as necessary before using it.

---

## Requirements

- Python 3.4 or higher
- Twitter Web Exporter 2.1 or higher
- Google Chrome with remote debugging enabled
- Tampermonkey browser extension

---

## Usage

### 1. Clone the Repository

```bash
git clone https://github.com/MtFloveU/twitter_fdap.git
cd twitter_fdap
```

### 2. Install Dependencies

```bash
pip3 install -r requirements.txt
```

### 3. Configure the Script

- Update `config.ini` with:
  - Your Twitter ID (use [Twitter ID Converter](https://tweethunter.io/twitter-id-converter)).
  - Chrome's debugging url.
  - Chrome's download directory.

### 4. Initialize Data Directory

```bash
cd data
git config --global init.defaultBranch main
git init
cd ..
```

Alternatively, clone an existing Git repository

### 5. Run It

```bash
python3 main.py
```


---

## Contact

Feel free to reach out on [Twitter](https://x.com/P5KAban) (@P5KAban).

---

## Disclaimer

This script is provided as-is. Use it at your own risk and ensure you understand its functionality before running it.
