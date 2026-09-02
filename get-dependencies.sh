#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake               \
    hicolor-icon-theme  \
    openal              \
    sdl3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
#make-aur-package dhewm3-git

# If the application needs to be manually built that has to be done down here
echo "Building dhewm3..."
echo "---------------------------------------------------------------"
REPO="https://github.com/dhewm/dhewm3"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./dhewm3
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./dhewm3/neo
cmake -S ./ -B build \
		-D CMAKE_BUILD_TYPE=Release \
		-D DEDICATED=ON \
		-D REPRODUCIBLE_BUILD=ON \
		-D SDL2=OFF \
		-D SDL3=ON
cmake --build build -j$(nproc)
mv -v build/dhewm3 build/dhewm3ded build/base.so build/d3xp.so ../../AppDir/bin
