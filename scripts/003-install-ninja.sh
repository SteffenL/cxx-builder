#!/usr/bin/env sh

ninja_version=${1}
ninja_hash=${2}
ninja_url="https://github.com/ninja-build/ninja/releases/download/v${ninja_version}/ninja-linux.zip"

apt-get update || exit 1
apt-get install -y \
    curl \
    unzip || exit 1
rm -rf /var/lib/apt/lists/* || exit 1

temp_dir=$(mktemp --dir)
curl -sSLo "${temp_dir}/ninja.zip" "${ninja_url}" || exit 1
echo "${cmake_hash} *${temp_dir}/ninja.zip" > "${temp_dir}/ninja.zip.hash" || exit 1
shasum --check "${temp_dir}/ninja.zip.hash"
unzip -d /usr/local/bin "${temp_dir}/ninja.zip" || exit 1
rm --recursive --dir "${temp_dir}" || exit 1
