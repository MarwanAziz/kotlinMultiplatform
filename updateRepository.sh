#!/bin/bash

NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'

REPOSITORY="git@github.com:MarwanAziz/kotlinMultiplatform.git"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
REPO_VERSION=$(grep -m 1 frameworkVersion "$DIR/../build.gradle.kts" | cut -d'"' -f 2)
TMPDIR=$(mktemp -d)
TMPFILE=$(mktemp)

trap _cleanup EXIT

function _cleanup() {
    rm -rf "$TMPDIR"
    rm "$TMPFILE"
}

function _checkTagVersion() {
    cd "$TMPDIR" || exit

    git tag >"$TMPFILE"

    if grep -q "$REPO_VERSION" "$TMPFILE"; then
        echo -e "${RED}Tag $REPO_VERSION already exists${NOCOLOR}"
        echo -e "${RED}Update the tag in 'buildSrc/src/main/java/Config.kt' and run 'create_cocoapod.sh' again.${NOCOLOR}"
        exit 1
    fi
}

function main() {
    echo "-- Cloning repository --"
    git clone "$REPOSITORY" "$TMPDIR" || { echo -e "${RED}Failed to clone repository${NOCOLOR}"; exit 1; }
    echo "-- Repository cloned successfully --"

    _checkTagVersion

    echo "-- Copy framework and podspec --"
    cd "$DIR/.." || exit
    cp -R /shared/build/bin/universal/release/*.framework "$TMPDIR" || { echo -e "${RED}Failed to copy framework${NOCOLOR}"; exit 1; }
    cp *.podspec "$TMPDIR" || { echo -e "${RED}Failed to copy podspec${NOCOLOR}"; exit 1; }

    cd "$TMPDIR" || exit

    echo "-- Add files, make commit and tag --"
    git add --all
    git commit -m "Release $REPO_VERSION" || { echo -e "${RED}Failed to commit changes${NOCOLOR}"; exit 1; }
    git tag -a "$REPO_VERSION" -m "Release $REPO_VERSION" || { echo -e "${RED}Failed to create tag${NOCOLOR}"; exit 1; }

    echo "-- Push to repository --"
    git push --atomic origin master "$REPO_VERSION" || { echo -e "${RED}Failed to push to repository${NOCOLOR}"; exit 1; }
}

main
