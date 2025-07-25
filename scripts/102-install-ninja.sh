#!/usr/bin/env sh
set -e

ninja_version=${1}
ninja_hash=${2}
ninja_url="https://github.com/ninja-build/ninja/releases/download/v${ninja_version}/ninja-linux.zip"

temp_dir=$(mktemp --dir)
curl -sSLo "${temp_dir}/ninja.zip" "${ninja_url}"
echo "${ninja_hash} *${temp_dir}/ninja.zip" > "${temp_dir}/ninja.zip.hash"
shasum --check "${temp_dir}/ninja.zip.hash"
unzip -d /usr/local/bin "${temp_dir}/ninja.zip"
rm --recursive --dir "${temp_dir}"
