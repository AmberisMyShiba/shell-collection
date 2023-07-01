#!/bin/bash

link_name="gcc"
versions_dir="/usr/bin"
link_dir="/usr/bin"

list_versions() {
  echo "Available GCC versions:"
  for file in "$versions_dir/$link_name"-*; do
    version=$(basename "$file" | cut -d- -f2)
    if [[ "$version" =~ ^[0-9]+$ ]]; then
      echo "- $version"
    fi
  done
}

switch_version() {
  local version="$1"
  local link_path="$link_dir/$link_name"
  local target_path="$versions_dir/$link_name-$version"

  if [ -e "$target_path" ]; then
    sudo ln -sf "$target_path" "$link_path"
    echo "Switched $link_name version to $version"
  else
    echo "Version $version not found"
    exit 1
  fi
}

main() {
  if [ "$1" == "-l" ]; then
    list_versions
    exit 0
  fi

  if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
  fi

  switch_version "$1"
}

main "$@"
