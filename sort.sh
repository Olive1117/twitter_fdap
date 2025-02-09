#!/bin/bash
source_dir="./temp/data"
target_dir="./data"
mkdir -p "$source_dir"
mkdir -p "$target_dir"

if [[ ! -d "$target_dir/.git" ]]; then
  echo "The data directory is not a Git repository. Initializing..."
  git init $target_dir
fi

if [[ -n $(ls -A "$source_dir") ]]; then
  rm "$source_dir"/*
fi

if [[ -f "$target_dir/.json" ]]; then
  rm "$target_dir/.json"
fi

mkdir -p "$target_dir/removed"

# 清空所有txt文件
> "$source_dir/mutual_unfollow.txt"
> "$source_dir/single-unfollower.txt"
> "$source_dir/single-unfollowing.txt"
echo "Processing JSON files, this may take a while..."
python3 sort/split.py

echo "🕒Time: \`$(date +"%Y-%m-%d %H:%M:%S") $(date +%Z)\`" > ./diff.txt
echo '*'$(jq 'length' ./temp/twitter-Following*.json)' Following, '$(jq 'length' ./temp/twitter-Followers*.json)' Followers*' >> ./diff.txt

# Step 1: Checking for mutual unfollow
python3 sort/step1.py

# Step 2: Checking followed_by status
python3 sort/step2.py

# Step 3: Checking following status
python3 sort/step3.py

# Output Mutual Unfollow, Single Unfollower and Single Unfollowing lists
if [[ -s "$source_dir/mutual_unfollow.txt" ]]; then
  echo "*Mutual Unfollow or removed:*" >> ./diff.txt
  while IFS= read -r id; do
    target_file="$target_dir/$id.json"

    if [[ -f "$target_file" ]]; then
      name=$(jq -r '.name' "$target_file")
      screen_name=$(jq -r '.screen_name' "$target_file")
      echo "\`$name\` @\`$screen_name\`" >> ./diff.txt
      mv "$target_file" "$target_dir/removed/$(basename "$target_file")"
      echo "$id" >> "$target_dir/removed_list.txt"
    fi
  done < "$source_dir/mutual_unfollow.txt"
  echo "" >> ./diff.txt
fi

if [[ -s "$source_dir/single-unfollower.txt" ]]; then
  echo "*Single Unfollower:*" >> ./diff.txt
  while IFS= read -r id; do
    target_file="$target_dir/$id.json"

    if [[ -f "$target_file" ]]; then
      name=$(jq -r '.name' "$target_file")
      screen_name=$(jq -r '.screen_name' "$target_file")
      echo "\`$name\` @\`$screen_name\`" >> ./diff.txt
    fi
  done < "$source_dir/single-unfollower.txt"
  echo "" >> ./diff.txt
fi

if [[ -s "$source_dir/single-unfollowing.txt" ]]; then
  echo "*Single Unfollowing:*" >> ./diff.txt
  while IFS= read -r id; do
    target_file="$target_dir/$id.json"

    if [[ -f "$target_file" ]]; then
      name=$(jq -r '.name' "$target_file")
      screen_name=$(jq -r '.screen_name' "$target_file")
      echo "\`$name\` @\`$screen_name\`" >> ./diff.txt
    fi
  done < "$source_dir/single-unfollowing.txt"
  echo "" >> ./diff.txt
fi

if [[ -f "$target_dir/removed_list.txt" ]]; then
  mapfile -t removed_list < "$target_dir/removed_list.txt"
else
  touch "$target_dir/removed_list.txt"
  removed_list=()
fi

for source_file in "$source_dir"/*.json; do
  id=$(jq -r '.id' "$source_file")

  if [[ " ${removed_list[@]} " =~ " $id " ]]; then
    target_file="$target_dir/removed/$id.json"

    if [[ -f "$target_file" ]]; then
      name=$(jq -r '.name' "$source_file")
      screen_name=$(jq -r '.screen_name' "$source_file")
      echo "\`$name\` @\`$screen_name\`" >> "$source_dir/returners.txt"
      rm -f "$target_file"
      removed_list=("${removed_list[@]/$id}")
    fi
  fi
done

if [[ -s "$source_dir/returners.txt" ]]; then
  echo "*Returners:*" >> ./diff.txt
  cat "$source_dir/returners.txt" >> ./diff.txt
fi

printf "%s\n" "${removed_list[@]}" > "$target_dir/removed_list.txt"
sort -u "$target_dir/removed_list.txt" | grep -v '^\s*$' > "$target_dir/removed_list_temp.txt"
mv "$target_dir/removed_list_temp.txt" "$target_dir/removed_list.txt"
echo "Updating data..."
python3 sort/upd.py
mv ./diff.txt "$target_dir/diff.txt"
cd "$target_dir"
git add --all > /dev/null
git commit -m "$(date +"%Y-%m-%d %H:%M:%S")" > /dev/null
cd ..
if [[ -s "info/tguserid.txt" ]] && [[ -s "info/tgapikey.txt" ]]; then
  echo "Pushing to your Telegram bot..."
  python3 tgbot.py
fi
cd "$target_dir"
if [[ -n $(git remote) ]]; then
  echo "Pushing to your GitHub repository..."
  git push --force
fi
cd ..
echo "-----BEGIN DIFF.TXT-----"
cat "$target_dir/diff.txt"
echo "-----END DIFF.TXT-----"
