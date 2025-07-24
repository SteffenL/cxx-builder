# Linux C++ Build Environment

See `Dockerfile` for the list of installed software and versions.

## Build Docker Image

```
docker build --target local --tag cxx-builder .
```

## Build Example C++ Project

```
mkdir example-build
docker run --rm --interactive \
    --mount type=bind,readonly,source=./example,target=/source \
    --mount type=bind,source=./example-build,target=/build \
    cxx-builder sh << EOF
set -e
cmake -G Ninja -B /build -S /source -DCMAKE_BUILD_TYPE=Release
cmake --build /build
EOF
./example-build/example
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
