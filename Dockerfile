ARG BASE_IMAGE=docker.io/ubuntu:16.04

FROM ${BASE_IMAGE}
WORKDIR /builder

# GCC
ARG GCC_HASH=ef29a97a0f635e7bb7d41a575129cced1800641df00803cf29f04dc407985df0
ARG GCC_VERSION=12.2.0
COPY scripts/001-install-gcc.sh scripts/
RUN scripts/001-install-gcc.sh "${GCC_VERSION}" "${GCC_HASH}"

# CMake
ARG CMAKE_HASH=8ec0ef24375a1d0e78de2f790b4545d0718acc55fd7e2322ecb8e135696c77fe
ARG CMAKE_VERSION=3.26.3
COPY scripts/002-install-cmake.sh scripts/
RUN scripts/002-install-cmake.sh "${CMAKE_VERSION}" "${CMAKE_HASH}"

# Ninja
ARG NINJA_HASH=b901ba96e486dce377f9a070ed4ef3f79deb45f4ffe2938f8e7ddc69cfb3df77
ARG NINJA_VERSION=1.11.1
COPY scripts/003-install-ninja.sh scripts/
RUN scripts/003-install-ninja.sh "${NINJA_VERSION}" "${NINJA_HASH}"

# Initial directory
WORKDIR /source

# User/Group
ARG USERNAME=user
ARG USER_ID=1000
ARG GROUP_ID=${USER_ID}

RUN groupadd --gid "${GROUP_ID}" "${USERNAME}" \
    && useradd --uid "${USER_ID}" --gid "${GROUP_ID}" --create-home "${USERNAME}"
USER ${USERNAME}

# Labels
ARG BASE_IMAGE

LABEL langnes.cxx-builder.versions.cmake="${CMAKE_VERSION}"
LABEL langnes.cxx-builder.versions.gcc="${GCC_VERSION}"
LABEL langnes.cxx-builder.versions.ninja="${NINJA_VERSION}"

LABEL org.opencontainers.image.base.name="${BASE_IMAGE}"
LABEL org.opencontainers.image.description="C++ build environment with GCC, CMake and Ninja pre-installed."
LABEL org.opencontainers.image.licenses=UNLICENSED
LABEL org.opencontainers.image.source="https://github.com/SteffenL/cxx-builder"
LABEL org.opencontainers.image.title="C++ Build Environment"
LABEL org.opencontainers.image.vendor="Steffen André Langnes"
