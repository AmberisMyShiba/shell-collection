#!/bin/bash

# Get the current kernel version
current_kernel_version=$(uname -r)

# Get a list of all installed kernels (excluding the current one)
old_kernel_versions=$(dpkg --list | grep 'linux-image' | awk '{print $2}' | grep -v $current_kernel_version)

# Remove all old kernels and their modules
for kernel_version in $old_kernel_versions; do
  echo "Removing kernel version $kernel_version..."
  sudo apt-get remove -y $kernel_version
  sudo apt-get remove -y --purge $(dpkg -l | grep $kernel_version | awk '{print $2}' | grep -v '^ii')
done

# Clean up any remaining dependencies
sudo apt-get autoremove -y

# Ensure that the current kernel is the latest version
sudo apt-get update
sudo apt-get upgrade -y

# Confirm that the current kernel is the latest version
latest_kernel_version=$(apt list --installed | grep linux-image | awk -F '/' '{print $1}' | awk -F '-' '{print $3}' | sort -r | head -n 1)
if [ $current_kernel_version = $latest_kernel_version ]; then
  echo "Kernel version $current_kernel_version is the latest version."
else
  echo "Kernel version $current_kernel_version is not the latest version."
  echo "The latest version is $latest_kernel_version."
fi
