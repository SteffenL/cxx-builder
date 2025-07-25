#!/usr/bin/env sh
set -e

cmake_version=${1}
cmake_hash=${2}
cmake_url="https://github.com/Kitware/CMake/releases/download/v${cmake_version}/cmake-${cmake_version}-linux-x86_64.sh"

temp_dir=$(mktemp --dir)
curl -sSLo "${temp_dir}/cmake.sh" "${cmake_url}"
echo "${cmake_hash} *${temp_dir}/cmake.sh" > "${temp_dir}/cmake.sh.hash"
shasum --check "${temp_dir}/cmake.sh.hash"
chmod +x "${temp_dir}/cmake.sh"
"${temp_dir}/cmake.sh" --prefix=/usr/local --exclude-subdir --skip-license
rm --recursive --dir "${temp_dir}"
