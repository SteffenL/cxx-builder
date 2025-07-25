#!/usr/bin/env sh
set -e

apt-get update
apt-get install -y \
    gettext \
    jq \
    libgtk-3-dev \
    uuid-dev
rm -rf /var/lib/apt/lists/*
