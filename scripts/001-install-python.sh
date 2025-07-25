#!/usr/bin/env sh
set -e

python_version=$(echo "${1}" | grep --only-matching --extended-regexp '^[0-9]+\.[0-9]+')
python_version_major=$(echo "${python_version}" | cut --delimiter . --field 1)
python_version_minor=$(echo "${python_version}" | cut --delimiter . --field 2)
python_version_int=$(printf '%d%02d' "${python_version_major}" "${python_version_minor}")

apt-get update
apt-get install -y \
    "python${python_version}" \
    "python${python_version}-dev" \
    "python${python_version}-venv" \
    "python${python_major_version}-pip" \
   
rm -rf /var/lib/apt/lists/*

update-alternatives --install /usr/bin/python python "/usr/bin/python${python_version}" "${python_version_int}"
update-alternatives --install /usr/bin/python3 python3 "/usr/bin/python${python_version}" "${python_version_int}"
python3 --version | grep --fixed-strings "${python_version}" || (echo "Wrong Python version detected"; exit 1)
