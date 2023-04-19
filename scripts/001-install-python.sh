#!/usr/bin/env sh

python_version=$(echo "${1}" | grep --only-matching --extended-regexp '^[0-9]+\.[0-9]+') || exit 1

apt-get update || exit 1
apt-get install -y \
    python3 \
    "python${python_version}" \
    python3-pip \
    python3-venv || exit 1
rm -rf /var/lib/apt/lists/* || exit 1
update-alternatives --install /usr/bin/python python /usr/bin/python3.8 308 || exit 1
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 308 || exit 1
