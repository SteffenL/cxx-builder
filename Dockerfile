# This file is intended to be used with  GitHub Actions but should support being used locally.
# The "github" stage should be last (and default) stage.
# The "local" stage is more suitable for local use.

ARG BASE_IMAGE=docker.io/ubuntu:18.04

FROM ${BASE_IMAGE} AS base

# Essential
COPY scripts/000-essential.sh scripts/
RUN scripts/000-essential.sh

# Python
# This version must be the available in the package repository.
ARG PYTHON_VERSION=3.8
COPY scripts/001-install-python.sh scripts/
RUN scripts/001-install-python.sh "${PYTHON_VERSION}"

# GCC
ARG GCC_HASH=f96f6dd42443b9920478c9e4de49d3d5609fff36c67d5b490ded2e0101bfc053
ARG GCC_VERSION=14.3.0
COPY scripts/100-install-gcc.sh scripts/
RUN scripts/100-install-gcc.sh "${GCC_VERSION}" "${GCC_HASH}"

# CMake
ARG CMAKE_HASH=6b1cf99c8cfe5f9c256dc9be5f20a44d07af6149d98c8ca6bb2534c440ce0681
ARG CMAKE_VERSION=3.31.8
COPY scripts/101-install-cmake.sh scripts/
RUN scripts/101-install-cmake.sh "${CMAKE_VERSION}" "${CMAKE_HASH}"

# Ninja
ARG NINJA_HASH=0830252db77884957a1a4b87b05a1e2d9b5f658b8367f82999a941884cbe0238
ARG NINJA_VERSION=1.13.1
COPY scripts/102-install-ninja.sh scripts/
RUN scripts/102-install-ninja.sh "${NINJA_VERSION}" "${NINJA_HASH}"

# Extra
COPY scripts/200-extra.sh scripts/
RUN scripts/200-extra.sh

# Labels
ARG BASE_IMAGE

LABEL langnes.cxx-builder.versions.cmake="${CMAKE_VERSION}"
LABEL langnes.cxx-builder.versions.gcc="${GCC_VERSION}"
LABEL langnes.cxx-builder.versions.ninja="${NINJA_VERSION}"
LABEL langnes.cxx-builder.versions.python="${PYTHON_VERSION}"

LABEL org.opencontainers.image.base.name="${BASE_IMAGE}"
LABEL org.opencontainers.image.description="C++ build environment with pre-installed software."
LABEL org.opencontainers.image.licenses=UNLICENSED
LABEL org.opencontainers.image.source="https://github.com/SteffenL/cxx-builder"
LABEL org.opencontainers.image.title="C++ Build Environment"
LABEL org.opencontainers.image.vendor="Steffen André Langnes"

# Use this stage when running a container locally
FROM base AS local

# Initial directory
WORKDIR /source

# User/Group
ARG USERNAME=user
ARG USER_ID=1000
ARG GROUP_ID=${USER_ID}

RUN groupadd --gid "${GROUP_ID}" "${USERNAME}" \
    && useradd --uid "${USER_ID}" --gid "${GROUP_ID}" --create-home "${USERNAME}"
USER ${USERNAME}

# Use this stage with GitHub Actions
FROM base AS github
