#!/bin/bash

# Usage: ./sync_server_files.sh [OPTION] [SERVER_IP] [FILE_LIST] [DEST]

# Check for arguments
if [[ $# -lt 2 ]]; then
    echo "Usage: ./sync_server_files.sh [OPTION] [SERVER_IP] [FILE_LIST] [DEST]"
    exit 1
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -d|--download)
            DOWNLOAD=true
            shift
            ;;
        -u|--upload)
            UPLOAD=true
            shift
            ;;
        -p|--path)
            DEST="$2"
            shift
            shift
            ;;
        *)
            if [[ -z $SERVER_IP ]]; then
                SERVER_IP=$key
                shift
            elif [[ -z $FILE_LIST ]]; then
                FILE_LIST=$key
                shift
            else
                shift
            fi
            ;;
    esac
done

# Check for either download or upload flag
if [[ -z $DOWNLOAD && -z $UPLOAD ]]; then
    echo "Please specify either --download or --upload option."
    exit 1
fi

# Check for server IP
if [[ -z $SERVER_IP ]]; then
    echo "Please provide the server IP address."
    exit 1
fi

# Check for file list
if [[ -z $FILE_LIST ]]; then
    echo "Please provide the file list path."
    exit 1
fi

# Check for destination folder
if [[ -z $DEST ]]; then
    DEST="./"
fi

# Create destination folder if it doesn't exist
if [[ ! -d $DEST ]]; then
    mkdir -p $DEST
fi

# Download files
    if [[ ! -z $DOWNLOAD ]]; then
        echo "Downloading files from the remote server..."

        # Read file list
        while read file_path; do
                        #check if line ends with "*"
                        #debug output
                        #echo "debug:FILE_PATH=$file_path;FILE_PATH:-1=${file_path%?},Last char=${file_path: -1}" 
                        if [[ "${file_path: -1}" == "*" ]]; then
                        # Remove "*" from line
                        file_path=${file_path%?}
                                # Create mirror folder if it doesn't exist
                                        mirror_path=$DEST$file_path
                                        mirror_path=${mirror_path%/*}
                                        if [[ ! -d $mirror_path ]]; then
                                        mkdir -p $mirror_path
                                        fi
                        # Copy directory recursively
                                echo "Downloading Directory $file_path recursively"
                    scp -r root@$SERVER_IP:$file_path $mirror_path/
                else
                        # Copy single file
                        scp root@$SERVER_IP:$file_path $mirror_path/
                fi
        done < $FILE_LIST

        echo "Download complete."

    # Upload files
    need to modify
    elif [[ ! -z $UPLOAD ]]; then
        echo "Uploading files to the remote server..."

        # Read file list
        while read file_path; do
            if [[ "${file_path:-1}" == "*" ]]; then
                # Remove "*" from line
                file_path=${file_path%?}
                # Copy directory recursively
                    scp -r $DEST$file_path root@$SERVER_IP:$file_path
            else
                # Copy single file
                    scp $DEST$file_path root@$SERVER_IP:$file_path
            fi
        done < $FILE_LIST
        echo "Upload complete."
    fi
