#!/usr/bin/env sh
set -e

toolchain_version=${1}
toolchain_os=${2}
toolchain_hash=${3}
toolchain_prefix=${4}
toolchain_filename=toolchain-${toolchain_os}-${toolchain_prefix}.tar.xz
toolchain_res_dir="/res/toolchain"
toolchain_pkg_local_path="${toolchain_res_dir}/${toolchain_filename}"

echo "${toolchain_hash} *${toolchain_pkg_local_path}" | sha256sum -c -

install_dir=/opt/toolchains/${toolchain_prefix}
mkdir -p "${install_dir}"
tar --extract --directory "${install_dir}" --strip-components 1 --file "${toolchain_pkg_local_path}"

export PATH=${PATH}:${install_dir}/bin
"${toolchain_prefix}-cc" --version | grep --fixed-strings "${toolchain_version}"
"${toolchain_prefix}-c++" --version | grep --fixed-strings "${toolchain_version}"
"${toolchain_prefix}-gcc" --version | grep --fixed-strings "${toolchain_version}"
"${toolchain_prefix}-g++" --version | grep --fixed-strings "${toolchain_version}"
echo "${toolchain_prefix} toolchain installed at \"${install_dir}\"."
