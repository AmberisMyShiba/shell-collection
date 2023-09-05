#!/bin/bash

link_name="gcc"
versions_dir="/usr/bin"
link_dir="/usr/bin"

gcc_rename() {
gcc_cur=$(which gcc)
gcc_ver=$("$gcc_cur" -dumpversion)
if [ "$gcc_cur"="/usr/bin/gcc" ]; then
        echo -e "\033[34m Found /usr/bin/gcc hasn't a version suffix. \033[0m"
        local default="y"
        read -e -p "Do you gree to rename it ?(y/n)" ac
        ac="${ac:-${default}}"
        case $ac in 
                y|Y)
                        mv "$gcc_cur" "$gcc_cur"-${gcc_ver%%.*}
                        return 0
                        ;;
                n|N)
                        echo -e "\033[32m Please rename /usr/bin/gcc to a version suffix,like /usr/bin/gcc-${gcc_ver}. \033[0m"
                        return 1
                        exit 1
                        ;;
        esac
fi
}

list_versions() {
  echo "Available GCC versions:"
  for file in "$versions_dir/$link_name"*; do
    version=$(basename "$file" | cut -d- -f2)
    if [[ "$version" =~ ^[0-9]+$ ]]; then
      echo "- $version"
    fi
  done
}

switch_version() {
  local version="$1"
  local link_path_gcc="$link_dir/gcc"
  local link_path_gxx="$link_dir/g++"
  local target_path_gcc="$versions_dir/gcc-$version"
  local target_path_gxx="$versions_dir/g++-$version"

  if [ -e "$target_path_gcc" ] && [ -e "$target_path_gxx" ]; then
    sudo ln -sf "$target_path_gcc" "$link_path_gcc"
    sudo ln -sf "$target_path_gxx" "$link_path_gxx"
    echo "Switched gcc and g++ version to $version"
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
    echo -e "\033[32mUseage:\033[0m" 
    echo -e "\tswitch gcc version:: $0 <version>"
    echo -e "\tshow gcc version avalible: $0 -l"
    exit 1
  fi

  gcc_rename
  switch_version "$1"
}

main "$@"
