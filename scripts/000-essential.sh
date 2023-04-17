#!/usr/bin/env sh

apt-get update || exit 1
apt-get upgrade -y || exit 1
apt-get install -y \
    build-essential \
    curl \
    git \
    pkg-config \
    tar \
    unzip \
    wget \
    zip \
    || exit 1
rm -rf /var/lib/apt/lists/* || exit 1
