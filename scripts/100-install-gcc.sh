#!/usr/bin/env sh

# References:
# https://gcc.gnu.org/wiki/InstallingGCC
# https://gcc.gnu.org/install/index.html
# https://iamsorush.com/posts/build-gcc11/

gcc_version=${1}
gcc_hash=${2}
gcc_url="https://github.com/gcc-mirror/gcc/archive/refs/tags/releases/gcc-${gcc_version}.tar.gz"
gcc_major_version=$(echo "${gcc_version}" | grep --only-matching --extended-regexp '^[0-9]+') || exit 1

apt-get update || exit 1
apt-get install -y \
    file \
    flex \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev || exit 1
rm -rf /var/lib/apt/lists/* || exit 1

temp_dir=$(mktemp --dir) || exit 1
cd "${temp_dir}" || exit 1

curl -sSLo "${temp_dir}/gcc.tar.gz" "${gcc_url}" || exit 1
echo "${gcc_hash} *gcc.tar.gz" > "${temp_dir}/gcc.tar.gz.hash" || exit 1
shasum --check "${temp_dir}/gcc.tar.gz.hash" || exit 1

mkdir -p "${temp_dir}/source" || exit 1
tar --extract --verbose --gunzip "--directory=${temp_dir}/source" "--file=${temp_dir}/gcc.tar.gz" || exit 1

cd "${temp_dir}/source/gcc-releases-gcc-${gcc_version}" || exit 1
./contrib/download_prerequisites || exit 1

mkdir -p "${temp_dir}/build" || exit 1
cd "${temp_dir}/build" || exit 1

"${temp_dir}/source/gcc-releases-gcc-${gcc_version}/configure" -v \
    --build=x86_64-linux-gnu \
    --host=x86_64-linux-gnu \
    --target=x86_64-linux-gnu \
    --enable-checking=release \
    --enable-default-pie \
    --enable-languages=c,c++ \
    --disable-multilib \
    --disable-werror || exit 1

make -j "$(nproc)" || exit 1
make install-strip || exit 1
ln --symbolic --force /usr/local/bin/gcc /usr/local/bin/cc || exit 1

rm --recursive --dir "${temp_dir}" || exit 1
