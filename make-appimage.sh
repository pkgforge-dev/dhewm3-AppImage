#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q dhewm3-git | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/org.dhewm3.Dhewm3.svg
export DESKTOP=/usr/share/applications/org.dhewm3.Dhewm3.desktop
export STARTUPWMCLASS=dhewm3
export DEPLOY_OPENGL=1
export DEPLOY_PULSE=1

# Deploy dependencies
quick-sharun /usr/bin/dhewm3 /usr/bin/dhewm3ded /usr/lib/dhewm3/*

# Additional changes can be done in between here
echo 'ANYLINUX_DO_NOT_LOAD_LIBS=libpipewire-0.3.so*:${ANYLINUX_DO_NOT_LOAD_LIBS}' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage
