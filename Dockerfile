# This file is intended to be used with  GitHub Actions but should support being used locally.
# The "github" stage should be last (and default) stage.
# The "local" stage is more suitable for local use.

ARG BASE_IMAGE=docker.io/ubuntu:18.04

FROM ${BASE_IMAGE} AS base

# Essential
COPY scripts/000-essential.sh scripts/
RUN scripts/000-essential.sh

# GCC
ARG GCC_HASH=c1ec5cb4ed8031c93fb602cd7bc5117c66b4f9ef18f7d4cd788e5eb9b9b3e7c9
ARG GCC_VERSION=15.2.0
COPY scripts/001-install-gcc.sh scripts/
RUN --mount=type=bind,source=resources/gcc/${GCC_VERSION},target=/res/gcc/${GCC_VERSION} scripts/001-install-gcc.sh "${GCC_VERSION}" "${GCC_HASH}"

# tzdata
COPY scripts/002-install-tzdata.sh scripts/
RUN scripts/002-install-tzdata.sh

# Python
ARG PYTHON_HASH=d923c51303e38e249136fc1bdf3568d56ecb03214efdef48516176d3d7faaef8
ARG PYTHON_VERSION=3.14.4
COPY scripts/100-install-python.sh scripts/
RUN --mount=type=bind,source=resources/python/${PYTHON_VERSION},target=/res/python/${PYTHON_VERSION} scripts/100-install-python.sh "${PYTHON_VERSION}" "${PYTHON_HASH}"

# CMake
ARG CMAKE_HASH=ee0b34a9a55a0d6220eceed0eab44047bbdbdc40fae0a89ba41635548a673fac
ARG CMAKE_VERSION=4.3.2
COPY scripts/101-install-cmake.sh scripts/
RUN --mount=type=bind,source=resources/cmake/${CMAKE_VERSION},target=/res/cmake/${CMAKE_VERSION} scripts/101-install-cmake.sh "${CMAKE_VERSION}" "${CMAKE_HASH}"

# Ninja
ARG NINJA_HASH=5749cbc4e668273514150a80e387a957f933c6ed3f5f11e03fb30955e2bbead6
ARG NINJA_VERSION=1.13.2
COPY scripts/102-install-ninja.sh scripts/
RUN --mount=type=bind,source=resources/ninja/${NINJA_VERSION},target=/res/ninja/${NINJA_VERSION} scripts/102-install-ninja.sh "${NINJA_VERSION}" "${NINJA_HASH}"

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

# Use this stage with GitHub Actions
FROM base AS github
