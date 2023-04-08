#!/bin/bash

# Usage: ./sync_server_files.sh [OPTION] [SERVER_IP] [FILE_LIST] [DEST]

# Check for arguments
if [[ $# -lt 2 ]]; then
    echo "Usage: ./sync_server_files.sh [OPTION:-d|-u] -h [SERVER_IP] -f [FILE_LIST] -p [DEST]"
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
        -h|--host)
            SERVER_IP="$2"
            shift
            shift
            ;;
        -f|--file)
            if [[ $UPLOAD == true ]]; then
                echo "Error: -f or --file can not be used with -u or --upload."
                echo "Error: please remove the -f parameter to upload."
                echo "Info: Please use with -p [DEST] to specify the file path to be uploaded."
                exit 1
            fi
            FILE_LIST="$2"
            shift
            shift
            ;;
        -p|--path)
            DEST="$2"
            shift
            shift
            ;;
        *)
            if [[ -z $FILE_LIST ]]; then
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

# Check for download or upload flag
if [[ $DOWNLOAD == true && $UPLOAD == true ]]; then
    echo "Error: Cannot specify both download and upload."
    exit 1
fi

# Check for upload flag,prohibit -f parameter
if [[ -z $DOWNLOAD && $UPLOAD==ture ]]; then
    if [[ -n $FILE_LIST ]]; then
        echo "Error: -f or --file option cannot be used with -u or --upload option."
        exit 1
    fi
fi

# Check for server IP
if [[ -z $SERVER_IP ]]; then
    echo "Please provide the server IP address."
    exit 1
fi

# Check for file list
if [[ $DOWNLOAD==true ]]; then
   if [[ -n $FILE_LIST ]]; then
     echo "Please provide the file list path."
     exit 1
   fi
fi

# Check for destination folder
if [[ -z $DEST ]]; then
    DEST=$(pwd)
fi

if [[ ! -d $DEST ]]; then
    mkdir $DEST
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
    elif [[ ! -z $UPLOAD ]]; then
        echo "Uploading files to the remote server..."
        for dir in $DEST/*; do
          # Check if subdirectory is a directory
          dir_remote=$(basename $dir)
            if [[ -d $dir ]]; then
              #Get subdirectory name
              # Copy directory recursively
                #echo "debug:scp -r $dir root@$SERVER_IP:/$dir_remote"
                scp -r $dir root@$SERVER_IP:/$dir_remote
            else
              # Copy single file
              #echo "debug: scp $dir_remote root@$SERVER_IP:root/$dir_remote"
              scp $dir_remote root@$SERVER_IP:/root/$dir_remote
            fi
        done
    echo "Upload complete."
    fi
