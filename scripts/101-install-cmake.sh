#!/usr/bin/env sh
set -e

cmake_version=${1}
cmake_hash=${2}
cmake_filename="cmake-${cmake_version}-linux-x86_64.sh"
cmake_url="https://github.com/Kitware/CMake/releases/download/v${cmake_version}/${cmake_filename}"
cmake_res_dir="/res/cmake/${cmake_version}"

cmake_pkg_local_path="${cmake_res_dir}/${cmake_filename}"
if [ ! -f "${cmake_pkg_local_path}" ]; then
    curl -sSLo "${cmake_pkg_local_path}" "${cmake_url}"
    chmod +x "${cmake_pkg_local_path}"
fi

echo "${cmake_hash} *${cmake_pkg_local_path}" | sha256sum -c -

"${cmake_pkg_local_path}" --prefix=/usr/local --exclude-subdir --skip-license
