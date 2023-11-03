#!/bin/bash

# Check if the user is root or using sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo." 
   exit 1
fi

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "No argument provided. Please provide an argument in the format xxx/yyy."
    exit 1
fi

# Extract the part after the slash
FILENAME=$(echo "$1" | cut -d '/' -f 2)

# Check if the filename is empty
if [ -z "$FILENAME" ]; then
    echo "The argument is not in the expected format 'xxx/yyy'."
    exit 1
fi

# Define the target path
TARGET_PATH="/etc/portage/package.accept_keywords"

# Create the file with the extracted name in the target path
FILE_PATH="${TARGET_PATH}/${FILENAME}"

# Check if the target directory exists
if [ ! -d "$TARGET_PATH" ]; then
    echo "The target directory ${TARGET_PATH} does not exist."
    exit 1
fi

# Write the content to the file
echo "$1 ~amd64" > "$FILE_PATH"

# Check if the file was created and written to successfully
if [ $? -eq 0 ]; then
    echo "File created successfully with the content: $1 ~amd64"
else
    echo "Failed to create the file. Please check your permissions and try again."
    exit 1
fi
