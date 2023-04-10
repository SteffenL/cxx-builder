# Linux C++ Build Environment

See `Dockerfile` for the list of installed software and versions.

## Build Docker Image

```
docker build --tag ghcr.io/steffenl/cxx-builder .
```

## Build Example C++ Project

```
mkdir example-build
docker run --rm --interactive \
    --mount type=bind,readonly,source="${PWD}/example",target=/source \
    --mount type=bind,source="${PWD}/example-build",target=/build \
    ghcr.io/steffenl/cxx-builder sh << EOF
cmake -G Ninja -B /build -S /source -DCMAKE_BUILD_TYPE=Release || exit 1
cmake --build /build || exit 1
EOF
./example-build/example
```

## Tag Release

```
git tag --sign --annotate --message='Release 1.0.0' v1.0.0
```

## Deploy to GitHub

```
docker tag ghcr.io/steffenl/cxx-builder ghcr.io/steffenl/cxx-builder:1.0.0
docker tag ghcr.io/steffenl/cxx-builder ghcr.io/steffenl/cxx-builder:1.0
docker push --all-tags ghcr.io/steffenl/cxx-builder
```
