#!/usr/bin/env sh

apt-get update || exit 1
apt-get install -y \
    gettext \
    git \
    libboost-dev \
    libgtk-3-dev \
    '^libwxgtk3.0*-dev$' \
    uuid-dev || exit 1
rm -rf /var/lib/apt/lists/* || exit 1
