#!/usr/bin/env sh

# References:
# https://gcc.gnu.org/wiki/InstallingGCC
# https://gcc.gnu.org/install/index.html
# https://iamsorush.com/posts/build-gcc11/

gcc_version=${1}
gcc_hash=${2}
gcc_url="https://github.com/gcc-mirror/gcc/archive/refs/tags/releases/gcc-${gcc_version}.tar.gz"

apt-get update || exit 1
apt-get install -y \
    build-essential \
    curl \
    file \
    flex \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev || exit 1
rm -rf /var/lib/apt/lists/* || exit 1

mkdir -p /gcc-source || exit 1
cd /gcc-source || exit 1
curl -sSLo gcc.tar.gz "${gcc_url}" || exit 1
echo "${gcc_hash} *gcc.tar.gz" > gcc.tar.gz.hash || exit 1
shasum --check gcc.tar.gz.hash
tar --extract --verbose --gunzip --file=gcc.tar.gz || exit 1
cd gcc-releases-gcc-* || exit 1

./contrib/download_prerequisites || exit 1

mkdir -p /gcc-build || exit 1
cd /gcc-build || exit 1

"/gcc-source/gcc-releases-gcc-${gcc_version}/configure" -v \
    --build=x86_64-linux-gnu \
    --host=x86_64-linux-gnu \
    --target=x86_64-linux-gnu \
    --enable-checking=release \
    --enable-languages=c,c++ \
    --disable-multilib || exit 1

make -j "$(nproc)" || exit 1
make install-strip || exit 1

rm --recursive --dir /gcc-build /gcc-source || exit 1
