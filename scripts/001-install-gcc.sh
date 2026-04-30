#!/usr/bin/env sh
set -e

# References:
# https://gcc.gnu.org/wiki/InstallingGCC
# https://gcc.gnu.org/install/index.html
# https://iamsorush.com/posts/build-gcc11/

gcc_version=${1}
gcc_hash=${2}
gcc_filename="gcc-releases-gcc-${gcc_version}.tar.gz"
gcc_url="https://github.com/gcc-mirror/gcc/archive/refs/tags/releases/gcc-${gcc_version}.tar.gz"
gcc_res_dir="/res/gcc/${gcc_version}"
gcc_major_version=$(echo "${gcc_version}" | grep --only-matching --extended-regexp '^[0-9]+')

gcc_pkg_local_path="${gcc_res_dir}/${gcc_filename}"
if [ ! -f "${gcc_pkg_local_path}" ]; then
    curl -sSLo "${gcc_pkg_local_path}" "${gcc_url}"
fi

echo "${gcc_hash} *${gcc_pkg_local_path}" | sha256sum -c -

apt-get update
apt-get install -y \
    file \
    flex \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev
rm -rf /var/lib/apt/lists/*

temp_dir=$(mktemp --dir)

mkdir -p "${temp_dir}/source"
tar --extract --directory "${temp_dir}/source" --strip-components 1 --file "${gcc_pkg_local_path}"
cd "${temp_dir}/source"

./contrib/download_prerequisites

mkdir -p "${temp_dir}/gcc-build"
cd "${temp_dir}/gcc-build"

"${temp_dir}/source/configure" -v \
    --build=x86_64-linux-gnu \
    --host=x86_64-linux-gnu \
    --target=x86_64-linux-gnu \
    --enable-checking=release \
    --enable-default-pie \
    --enable-languages=c,c++ \
    --disable-multilib \
    --disable-werror

make -j "$(nproc)"
make install-strip
ln --symbolic --force /usr/local/bin/gcc /usr/local/bin/cc

rm --recursive --dir "${temp_dir}"
