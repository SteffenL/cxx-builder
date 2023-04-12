#!/usr/bin/env sh

apt-get update || exit 1
apt-get install -y \
    git || exit 1
rm -rf /var/lib/apt/lists/* || exit 1
