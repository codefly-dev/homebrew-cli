#!/usr/bin/env bash
# Exit if any command fails
set -e

# Check if the version tag is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <version-tag>"
    exit 1
fi

VERSION="${1#v}"
REPO_NAME="codefly-dev/cli-releases" # Replace with your GitHub repository name
FORMULA="codefly.rb" # Replace with your formula file name

# Check if the formula file exists
if [ ! -f "$FORMULA" ]; then
    echo "Error: Formula file $FORMULA does not exist."
    exit 1
fi

# Determine OS and set sed in-place edit command accordingly
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS, use BSD sed
    SED_CMD="sed -i ''"
else
    # Assume Linux, use GNU sed
    SED_CMD="sed -i"
fi

# Update the version
$SED_CMD "s/version \".*\"/version \"$VERSION\"/" "$FORMULA"

# Update the URLs
$SED_CMD "s|/v[0-9]*\.[0-9]*\.[0-9]*/|/v$VERSION/|g" "$FORMULA"

# Define URLs and binary names for both architectures
declare -A urls
urls["amd64"]="https://github.com/${REPO_NAME}/releases/download/v${VERSION}/codefly-darwin-amd64"
urls["arm64"]="https://github.com/${REPO_NAME}/releases/download/v${VERSION}/codefly-darwin-arm64"
#
## Loop over architectures and update the formula
#for arch in "${!urls[@]}"; do
#    binary_name="codefly-darwin-${arch}"
#    echo "Downloading ${urls[$arch]}..."
#    curl -L -o "${binary_name}" "${urls[$arch]}" || { echo "Failed to download ${binary_name}"; exit 1; }
#
#    sha256=$(shasum -a 256 "${binary_name}" | awk '{ print $1 }') || { echo "Failed to compute SHA256 for ${binary_name}"; exit 1; }
#
#    # Update the formula file with the new sha256 for each architecture
#    echo "Updating formula ${FORMULA} for ${arch}..."
#    $SED_CMD "s|sha256 \".*${arch}\"|sha256 \"${sha256}\" # ${arch}|" "$FORMULA"
#
#    # Clean up downloaded binary
#    rm "${binary_name}"
#done

echo "Formula ${FORMULA} updated to version ${VERSION}"
