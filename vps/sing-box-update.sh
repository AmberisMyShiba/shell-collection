#!/bin/bash

# Replace with the path to the cloned repository
REPO_PATH="github/sing-box"

# Move to the repository directory
cd $REPO_PATH || { echo "Failed to change directory to $REPO_PATH"; exit 1; }

# Fetch the latest changes from the remote repository
git fetch || { echo "Failed to fetch latest changes"; exit 1; }

# Get the latest tag
TAG=$(git describe --tags $(git rev-list --tags --max-count=1)) || { echo "Failed to get latest tag"; exit 1; }

# Checkout the latest tag
git checkout $TAG || { echo "Failed to checkout latest tag: $TAG"; exit 1; }

# Print the checkout message
echo "Checked out the latest tag: $TAG"

# Ask the user if they want to continue compiling
read -p "Do you want to continue compiling? [y/n] " choice
case "$choice" in 
  y|Y ) 
    # Run the release/local/reintall.sh script
    ./release/local/reinstall.sh
    ;;
  * ) 
    echo "Aborted."
    ;;
esac
