#!/usr/bin/env sh
set -e

apt-get update
apt-get upgrade -y
apt-get install -y \
    build-essential \
    curl \
    git \
    pkg-config \
    tar \
    unzip \
    wget \
    zip
rm -rf /var/lib/apt/lists/*
