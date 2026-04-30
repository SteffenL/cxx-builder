#!/usr/bin/env sh
set -e

python_version="${1}"
python_version_major=$(echo "${python_version}" | cut --delimiter . --field 1)
python_version_minor=$(echo "${python_version}" | cut --delimiter . --field 2)
python_version_int=$(printf '%d%02d' "${python_version_major}" "${python_version_minor}")
python_hash=${2}
python_subdir_name="Python-${python_version}"
python_filename="Python-${python_version}.tar.xz"
python_url="https://www.python.org/ftp/python/${python_version}/${python_filename}"
python_res_dir="/res/python/${python_version}"

apt-get update
# Omitted packages: build-essential gdb lcov
apt-get install -y pkg-config \
    libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
    libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
    lzma lzma-dev tk-dev uuid-dev zlib1g-dev libmpdec-dev libzstd-dev
rm -rf /var/lib/apt/lists/*

python_pkg_local_path="${python_res_dir}/${python_filename}"
if [ ! -f "${python_pkg_local_path}" ]; then
    curl -sSLo "${python_pkg_local_path}" "${python_url}"
fi

echo "${python_hash} *${python_pkg_local_path}" | sha256sum -c -

temp_dir=$(mktemp --dir)
tar --extract --directory "${temp_dir}" --strip-components 1 --file "${python_pkg_local_path}"
cd "${temp_dir}"
./configure --enable-optimizations --with-lto
make -s -j "$(nproc)"
make install
rm --recursive --dir "${temp_dir}"

python3 --version | grep --fixed-strings "${python_version}" || (echo "Wrong Python version detected"; exit 1)
