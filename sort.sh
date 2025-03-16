#!/bin/bash
username=$(cat info/id.txt)
source_dir="./temp/data"
target_dir="./data/$username"
origin_dir=$(realpath .)
mkdir -p "$source_dir"

if [[ ! -d "$(dirname $(realpath $target_dir))/.git" ]]; then
  echo "The data directory is not a Git repository. Initializing..."
  git init $target_dir
fi

if [[ ! -e $target_dir && -e $(dirname $(realpath $target_dir)) ]]; then
  echo "Upgrading to a newer version of the FDAP database..."
  mkdir -p "$target_dir"
  mv -f $(dirname $(realpath $target_dir))/*.json "$target_dir"
  mv -f $(dirname $(realpath $target_dir))/*.txt "$target_dir"
  mv -f $(dirname $(realpath $target_dir))/removed "$target_dir"/removed
fi

if [[ -n $(ls -A "$source_dir") ]]; then
  rm "$source_dir"/*
fi

if [[ -f "$target_dir/.json" ]]; then
  rm "$target_dir/.json"
fi

if [[ ! -f "$target_dir/single-unfollower.txt" ]]; then
  touch $target_dir/single-unfollower.txt
fi

mkdir -p "$target_dir/removed"

> "$source_dir/mutual_unfollow.txt"
> "$source_dir/single-unfollower.txt"
> "$source_dir/single-unfollowing.txt"
echo "Processing JSON files, this may take a while..."

python3 sort/unique.py

python3 sort/split.py --target_dir=$target_dir

echo "🕒Time: \`$(date +"%Y-%m-%d %H:%M:%S") $(date +%Z)\`" > ./diff.md
echo "Username: @\`"$username"\`" >> ./diff.md
echo '*'$(jq 'length' ./temp/twitter-Following.json)' Following, '$(jq 'length' ./temp/twitter-Followers.json)' Followers*' >> ./diff.md

python3 sort/step1.py --target-dir $target_dir

python3 sort/step2.py --target-dir $target_dir

python3 sort/step3.py --target-dir $target_dir

if [[ -s "$source_dir/mutual_unfollow.txt" ]]; then
  echo "*Mutual Unfollow or Removal:*" >> ./diff.md
  while IFS= read -r id; do
    target_file="$target_dir/$id.json"

    if [[ -f "$target_file" ]]; then
      name=$(jq -r '.name' "$target_file")
      screen_name=$(jq -r '.screen_name' "$target_file")
      echo "\`$(echo "$name" | sed 's/`//g')\` @\`$screen_name\`" >> ./diff.md
      mv "$target_file" "$target_dir/removed/$(basename "$target_file")"
      echo "$id" >> "$target_dir/removed_list.txt"
    fi
  done < "$source_dir/mutual_unfollow.txt"
  echo "" >> ./diff.md
fi

if [[ -s "$source_dir/single-unfollower.txt" ]]; then
  echo "*One-Way Unfollowers:*" >> ./diff.md
  while IFS= read -r id; do
    target_file="$target_dir/$id.json"

    if [[ -f "$target_file" ]]; then
      name=$(jq -r '.name' "$target_file")
      screen_name=$(jq -r '.screen_name' "$target_file")
      echo "\`$(echo "$name" | sed 's/`//g')\` @\`$screen_name\`" >> ./diff.md
    fi
  done < "$source_dir/single-unfollower.txt"
  echo "" >> ./diff.md
fi

if [[ -s "$source_dir/single-unfollowing.txt" ]]; then
  echo "*One-Way Unfollowing:*" >> ./diff.md
  while IFS= read -r id; do
    target_file="$target_dir/$id.json"

    if [[ -f "$target_file" ]]; then
      name=$(jq -r '.name' "$target_file")
      screen_name=$(jq -r '.screen_name' "$target_file")
      echo "\`$(echo "$name" | sed 's/`//g')\` @\`$screen_name\`" >> ./diff.md
    fi
  done < "$source_dir/single-unfollowing.txt"
  echo "" >> ./diff.md
fi

while read -r id; do
  if grep -q "^$id$" "$source_dir/mutual_unfollow.txt"; then
    sed -i "/^$id$/d" "$target_dir/single-unfollower.txt"
    sort -u "$target_dir/single-unfollower.txt" | grep -v '^\s*$' > "$target_dir/single-unfollower_temp.txt"
    mv "$target_dir/single-unfollower_temp.txt" "$target_dir/single-unfollower.txt"
  fi
done < "$target_dir/single-unfollower.txt"

python3 sort/step4.py --target-dir $target_dir

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
      echo "\`$(echo "$name" | sed 's/`//g')\` @\`$screen_name\`" >> "$source_dir/returners.txt"
      rm -f "$target_file"
      removed_list=("${removed_list[@]/$id}")
    fi
  fi
done

if [[ -s "$source_dir/single-unfollower-return.txt" ]]; then
    while IFS= read -r id; do
    source_file="$source_dir/$id.json"

    if [[ -f "$source_file" ]]; then
      name=$(jq -r '.name' "$source_file")
      screen_name=$(jq -r '.screen_name' "$source_file")
      echo "\`$(echo "$name" | sed 's/`//g')\` @\`$screen_name\`" >> "$source_dir/single-unfollower-returner-name.txt"
    fi
  done < "$source_dir/single-unfollower-return.txt"
fi

if [[ -s "$source_dir/returners.txt" || -s "$source_dir/single-unfollower-returner-name.txt" ]]; then
  echo "*Returning Follows:*" >> ./diff.md

  if [[ -s "$source_dir/returners.txt" ]]; then
    cat "$source_dir/returners.txt" >> ./diff.md
  fi

  if [[ -s "$source_dir/single-unfollower-returner-name.txt" ]]; then
    cat "$source_dir/single-unfollower-returner-name.txt" >> ./diff.md
  fi
fi

echo "Updating data..."

printf "%s\n" "${removed_list[@]}" > "$target_dir/removed_list.txt"
sort -u "$target_dir/removed_list.txt" | grep -v '^\s*$' > "$target_dir/removed_list_temp.txt"
mv "$target_dir/removed_list_temp.txt" "$target_dir/removed_list.txt"

while read -r id; do
  if grep -q "^$id$" "$source_dir/single-unfollower-return.txt"; then
    sed -i "/^$id$/d" "$target_dir/single-unfollower.txt"
    sort -u "$target_dir/single-unfollower.txt" | grep -v '^\s*$' > "$target_dir/single-unfollower_temp.txt"
    mv "$target_dir/single-unfollower_temp.txt" "$target_dir/single-unfollower.txt"
  fi
done < "$target_dir/single-unfollower.txt"
cat "$source_dir/single-unfollower.txt" >> "$target_dir/single-unfollower.txt"
sort -u "$target_dir/single-unfollower.txt" | grep -v '^\s*$' > "$target_dir/single-unfollower_temp.txt"
mv "$target_dir/single-unfollower_temp.txt" "$target_dir/single-unfollower.txt"

if jq -e '.metadata' "$target_dir"/*.json > /dev/null 2>&1; then
    python3 sort/upd.py --target-dir $target_dir
else
    mv -f $source_dir/*.json $target_dir
fi

cp ./diff.md "$target_dir/diff.md"
cd "$target_dir"
git add --all > /dev/null
git commit -m "$(date +"%Y-%m-%d %H:%M:%S")" > /dev/null
cd $origin_dir
if [[ ! "$@" == *"disable-tg-push"* ]]; then
  if [[ -s "info/tguserid.txt" ]] && [[ -s "info/tgapikey.txt" ]]; then
    echo "Pushing to your Telegram bot..."
    if [[ "$@" == *"proxychains"* ]]; then
      proxychains python3 tgbot.py
    else
      python3 tgbot.py
    fi
    rm ./diff.md
  fi
fi
cd "$target_dir"
if [[ ! "$@" == *"disable-git-push"* ]]; then
  if [[ -n $(git remote) ]]; then
    echo "Pushing to your GitHub repository..."
    if [[ "$@" == *"proxychains"* ]]; then
      proxychains git push --force
    else
      git push --force
    fi
  fi
fi
cd $origin_dir
sleep 0.5
echo "-----BEGIN DIFF.TXT-----"
cat "$target_dir/diff.md"
echo "-----END DIFF.TXT-----"
