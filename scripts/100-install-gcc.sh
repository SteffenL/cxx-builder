#!/usr/bin/env sh
set -e

# References:
# https://gcc.gnu.org/wiki/InstallingGCC
# https://gcc.gnu.org/install/index.html
# https://iamsorush.com/posts/build-gcc11/

gcc_version=${1}
gcc_hash=${2}
gcc_url="https://github.com/gcc-mirror/gcc/archive/refs/tags/releases/gcc-${gcc_version}.tar.gz"
gcc_major_version=$(echo "${gcc_version}" | grep --only-matching --extended-regexp '^[0-9]+')

apt-get update
apt-get install -y \
    file \
    flex \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev
rm -rf /var/lib/apt/lists/*

temp_dir=$(mktemp --dir)
cd "${temp_dir}"

curl -sSLo "${temp_dir}/gcc.tar.gz" "${gcc_url}"
echo "${gcc_hash} *gcc.tar.gz" > "${temp_dir}/gcc.tar.gz.hash"
shasum --check "${temp_dir}/gcc.tar.gz.hash"

mkdir -p "${temp_dir}/source"
tar --extract --verbose --gunzip "--directory=${temp_dir}/source" "--file=${temp_dir}/gcc.tar.gz"

cd "${temp_dir}/source/gcc-releases-gcc-${gcc_version}"
./contrib/download_prerequisites

mkdir -p "${temp_dir}/build"
cd "${temp_dir}/build"

"${temp_dir}/source/gcc-releases-gcc-${gcc_version}/configure" -v \
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
