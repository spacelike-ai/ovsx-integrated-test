#!/bin/bash

set -euo pipefail

DEVSPACES_VERSION=$1
OUTPUT_REGISTRY=$2
OUTPUT_ORG=$3
OUTPUT_TAG=$4

tempdir=devspaces
rm -rf "$tempdir"
mkdir "$tempdir"

git clone --depth=1 --branch=devspaces-$DEVSPACES_VERSION-rhel-8 \
    https://github.com/redhat-developer/devspaces.git "$tempdir"

extension_file="$tempdir/dependencies/che-plugin-registry/openvsx-sync.json"
originial_extension_file="$tempdir/orig.json"
new_extension_file="additional-extensions.json"

mv "$extension_file" "$originial_extension_file"
jq -s '.[0] + .[1]' "$extension_file" "$new_extension_file" >"$extension_file"

(
    # Suppress following question from `npx`:
    #   Need to install the following packages:
    #   @eclipse-che/plugin-registry-generator@7.92.0-dev-0a45f43
    #   Ok to proceed?
    export npm_config_yes=true

    # Explicitly set the builder, to make sure that the build script uses the correct builder.
    export BUILDER=podman

    cd "$tempdir/dependencies/che-plugin-registry"

    ./build.sh -r "$OUTPUT_REGISTRY" -o "$OUTPUT_ORG" -t "$OUTPUT_TAG"
)
