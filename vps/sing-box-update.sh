#!/bin/bash

# Replace with the path to the cloned repository
REPO_PATH="sing-box"

# Move to the repository directory
cd $REPO_PATH || { echo "Failed to change directory to $REPO_PATH"; exit 1; }

# Fetch the latest changes from the remote repository
git fetch || { echo "Failed to fetch latest changes"; exit 1; }

# Get the latest tag
#TAG=$(git describe --tags $(git rev-list --tags --max-count=1)) || { echo "Failed to get latest tag"; exit 1; }
TAGS=$(git rev-list --tags --max-count=2 | xargs -I@ git describe --tags @) || { echo "Failed to get latest tag"; exit 1; }

# 列出TAGS的值，每行显示一个tag，并在每个tag前加入数字编号echo "Available tags:"
i=1
while IFS= read -r tag; do
    echo "$i. $tag"
    tags_array+=("$tag")
    i=$((i+1))
done <<< "$TAGS"

# 询问切换到哪一个tag
read -p "Which tag (by number or full name) do you want to checkout? " selected_tag

# 如果用户没有输入任何值，设置默认值为 1
if [ -z "$selected_tag" ]; then
    selected_tag="1"
fi

# 检查选择的是编号还是全文，并设置正确的标签值
if [[ "$selected_tag" =~ ^[0-9]+$ ]] && [ "$selected_tag" -le ${#tags_array[@]} ]; then
    selected_tag=${tags_array[$selected_tag-1]}
fi

# 使用git checkout 切换到选择的那个tag
if echo "$TAGS" | grep -q "^$selected_tag$"; then
    git checkout "$selected_tag"
    echo "Switched to tag $selected_tag"
else
    echo "Tag $selected_tag not found in the list."
fi

# Print the checkout message
echo "Checked out the latest tag: $selected_tag"

# Ask the user if you want to continue compiling
read -rp "Do you want to continue compiling? [y/n] " choice
case "${choice,,}" in
  y|"" )
    # Run the release/local/reintall.sh script
                # kill sing-box process and reserve sing-box-update's self
                my_pid=$(pgrep -f $0)
                kill -9 $(pgrep sing-box|grep -v "$my_pid")
    ./release/local/reinstall.sh
    # add following 2 lines to above 
    #sudo systemctl stop sing-box.service
    #sudo kill $(pgrep -x sing-box) 2>/dev/null || true
    sing-box version
    ;;
  * )
    echo "Aborted."
    ;;
esac

# Ask user if you want to upload new version to remote 
read -rp "Do you want to upload the latest version to remote? [y/n] " choice
case "${choice,,}" in
  y|"" )
    # upload to remote 
                scp -O ~/go/bin/sing-box bandwagon:/root/go/bin/    
                [ $? -eq 0 ] && echo "uploded to bandwagon sucess"
                scp ~/go/bin/sing-box plan:/root/go/bin/    
                [ $? -eq 0 ] && echo "uploded to plan sucess"
    ;;
  * )
    echo "Cancled uploading to Remote."
    ;;
esac

