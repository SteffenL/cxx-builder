#!/usr/bin/env sh

python_version=$(echo "${1}" | grep --only-matching --extended-regexp '^[0-9]+\.[0-9]+') || exit 1

apt-get update || exit 1
apt-get install -y \
    "python${python_version}" || exit 1
rm -rf /var/lib/apt/lists/* || exit 1
update-alternatives --set python3 "/usr/bin/python${python_version}" || exit 1
