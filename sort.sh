#!/bin/bash
mkdir -p "./temp/data"
if [[ -n $(ls -A ./temp/data) ]]; then
  rm ./temp/data/*
fi
if [[ -f ./data/.json ]]; then
  rm ./data/.json
fi
source_dir="./temp/data"  # 源目录路径
target_dir="./data"  # 目标目录路径

# 清空所有txt文件
> "$source_dir/mutual_unfollow.txt"
> "$source_dir/single-unfollower.txt"
> "$source_dir/single-unfollowing.txt"
echo "Processing JSON files, this may take a while..."
python3 sort/split.py

echo "🕒Time: "$(date +"%Y-%m-%d %H:%M:%S")" "$(date +%Z)"" > ./diff.txt
echo '*'$(jq 'length' ~/Downloads/twitter-Followers*.json)' Followers, '$(jq 'length' ~/Downloads/twitter-Following*.json)' Following*' >> ./diff.txt

# Step 1: Checking for mutual unfollow
python3 sort/step1.py

# Step 2: Checking followed_by status
python3 sort/step2.py

# Step 3: Checking following status
python3 sort/step3.py

# Output Mutual Unfollow, Single Unfollower and Single Unfollowing lists
echo "*Mutual Unfollow or removed:*" >> ./diff.txt
while IFS= read -r id; do
  target_file="$target_dir/$id.json"

  if [[ -f "$target_file" ]]; then
    name=$(jq -r '.name' "$target_file")
    screen_name=$(jq -r '.screen_name' "$target_file")
    echo "\`$name\` @\`$screen_name\`" >> ./diff.txt
    mv $target_file $target_dir/removed/$(basename $target_file)
    echo $id >> ./data/removed_list.txt
  fi
done < "$source_dir/mutual_unfollow.txt"

echo "" >> ./diff.txt

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

echo "*Returners:*" >> ./diff.txt

mapfile -t removed_list < ./data/removed_list.txt

for source_file in "$source_dir"/*.json; do
  id=$(jq -r '.id' "$source_file")

  if [[ " ${removed_list[@]} " =~ " $id " ]]; then
    target_file="$target_dir/removed/$id.json"

    if [[ -f "$target_file" ]]; then
      name=$(jq -r '.name' "$source_file")
      screen_name=$(jq -r '.screen_name' "$source_file")
      echo "\`$name\` @\`$screen_name\`" >> ./diff.txt
      rm -f "$target_file"
      removed_list=("${removed_list[@]/$id}")
    fi
  fi
done

printf "%s\n" "${removed_list[@]}" > ./data/removed_list.txt
sort -u $target_dir/removed_list.txt | grep -v '^\s*$' > $target_dir/removed_list_temp.txt
mv $target_dir/removed_list_temp.txt $target_dir/removed_list.txt
echo "Updating data..."
python3 sort/upd.py
mv ./diff.txt ./data/diff.txt
  cd ./data
  git add --all
  git commit -m "$(date +"%Y-%m-%d %H:%M:%S")"
  cd ..
if [[ -s "info/tguserid.txt" ]] && [[ -s "info/tgapikey.txt" ]]; then
  echo "Pushing to your Telegram bot..."
  python3 tgbot.py
fi

if [[ -s "info/githubrepo.txt" ]]; then
  echo "Pushing to your GitHub repository..."
  cd ./data
  git push --force
  cd ..
fi

cat ./diff.txt
