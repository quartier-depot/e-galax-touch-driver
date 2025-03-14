#!/bin/bash
set -e

version="eGTouch_v2.5.13219.L-x"
file="$version.7z"
url="https://www.eeti.com/touch_driver/Linux/20240510/$file"

if [ ! -f "$file" ]; then
    wget "$url"
else
    echo "File already exists. Skipping download."
fi

rm -rf $version
7z x "$file"

# set CPU arch
sed -i '' 's/cpuArch=""/cpuArch="64"/o' "$version/setup.sh"