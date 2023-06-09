#!/usr/bin/env sh

apt-get update || exit 1
apt-get install -y \
    gettext \
    jq \
    libgtk-3-dev \
    uuid-dev \
    || exit 1
rm -rf /var/lib/apt/lists/* || exit 1
