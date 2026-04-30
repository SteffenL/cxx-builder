#!/usr/bin/env sh
set -e

ninja_version=${1}
ninja_hash=${2}
ninja_filename=ninja-linux.zip
ninja_url="https://github.com/ninja-build/ninja/releases/download/v${ninja_version}/${ninja_filename}"
ninja_res_dir="/res/ninja/${ninja_version}"

ninja_pkg_local_path="${ninja_res_dir}/${ninja_filename}"
if [ ! -f "${ninja_pkg_local_path}" ]; then
    curl -sSLo "${ninja_pkg_local_path}" "${ninja_url}"
fi

echo "${ninja_hash} *${ninja_pkg_local_path}" | sha256sum -c -

temp_dir=$(mktemp --dir)
unzip -d /usr/local/bin "${ninja_pkg_local_path}"
rm --recursive --dir "${temp_dir}"
