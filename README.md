# Linux C++ Build Environment

See `Dockerfile` for the list of installed software and versions.

## Build Docker Image

```
docker build --target local --tag cxx-builder .
```

## Build Example C++ Project w/glibc

```
mkdir -p example-build
docker run --rm --interactive \
    --mount type=bind,readonly,source=./example,target=/source \
    --mount type=bind,source=./example-build,target=/build \
    cxx-builder sh << EOF
g++ -std=c++23 -static -o /build/example main.cpp
EOF
./example-build/example
```

You can check that glibc is used:

```
objdump --dynamic-syms example-build/example | grep --fixed-strings GLIBC_
```

## Build Example C++ Project w/musl

```
mkdir -p example-build
docker run --rm --interactive \
    --mount type=bind,readonly,source=./example,target=/source \
    --mount type=bind,source=./example-build,target=/build \
    cxx-builder sh << EOF
set -e
export PATH=${PATH}:/opt/toolchains/x86_64-pc-linux-musl/bin
x86_64-pc-linux-musl-g++ -std=c++23 -static -o /build/example main.cpp
EOF
./example-build/example
```

The example above uses `-static` so that you can run it without installing musl on the target system.

Next we'll check that glibc is not used.

```
mkdir -p example-build
docker run --rm --interactive \
    --mount type=bind,readonly,source=./example,target=/source \
    --mount type=bind,source=./example-build,target=/build \
    cxx-builder sh << EOF
set -e
export PATH=${PATH}:/opt/toolchains/x86_64-pc-linux-musl/bin
x86_64-pc-linux-musl-g++ -std=c++23 -o /build/example main.cpp
EOF
objdump --dynamic-syms example-build/example | grep --fixed-strings GLIBC_
```

## Tag Release

```
git tag --sign --annotate --message='Release 1.0.0' v1.0.0
```

## Deploy to GitHub

```
docker build --target github --tag ghcr.io/steffenl/cxx-builder .
docker tag ghcr.io/steffenl/cxx-builder ghcr.io/steffenl/cxx-builder:1.0.0
docker tag ghcr.io/steffenl/cxx-builder ghcr.io/steffenl/cxx-builder:1.0
docker push --all-tags ghcr.io/steffenl/cxx-builder
```
