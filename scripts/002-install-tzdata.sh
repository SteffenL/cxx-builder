#!/usr/bin/env sh
set -e

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tzdata
rm -rf /var/lib/apt/lists/*
