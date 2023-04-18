#!/usr/bin/env sh

cmake_version=${1}
cmake_hash=${2}
cmake_url="https://github.com/Kitware/CMake/releases/download/v${cmake_version}/cmake-${cmake_version}-linux-x86_64.sh"

temp_dir=$(mktemp --dir) || exit 1
curl -sSLo "${temp_dir}/cmake.sh" "${cmake_url}" || exit 1
echo "${cmake_hash} *${temp_dir}/cmake.sh" > "${temp_dir}/cmake.sh.hash" || exit 1
shasum --check "${temp_dir}/cmake.sh.hash" || exit 1
chmod +x "${temp_dir}/cmake.sh" || exit 1
"${temp_dir}/cmake.sh" --prefix=/usr/local --exclude-subdir --skip-license || exit 1
rm --recursive --dir "${temp_dir}" || exit 1
