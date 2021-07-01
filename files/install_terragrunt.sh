#!/bin/bash
set -o nounset
set -o errexit
#set -o xtrace

VERSION=$1

REPO_NAME="gruntwork-io/terragrunt"


error() {
  echo "ERROR: $@" 1>&2
  echo "Exiting installer" 1>&2
  exit 1
}

# Get latest release from GitHub API
get_latest_version_tag() {
  local REPO_NAME=$1
  local LATEST_VERSION_URL="https://api.github.com/repos/$REPO_NAME/releases/latest"
  local latest_payload

  if [[ $(command -v wget) ]]; then
    latest_payload=$(wget -q -O - "$LATEST_VERSION_URL")
  elif [[ $(command -v curl) ]]; then
    latest_payload=$(curl --fail -sSL "$LATEST_VERSION_URL")
  else
    error "Could not find wget or curl"
  fi

  echo "$latest_payload" |
    grep '"tag_name":' | # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/' # Pluck JSON value
}

if [ $VERSION == "latest" ]; then
  VERSION_TAG=$(get_latest_version_tag $REPO_NAME)
  VERSION=${VERSION_TAG##v}
fi

curl -sSLO "https://github.com/$REPO_NAME/releases/download/${VERSION_TAG}/terragrunt_linux_amd64"
mv -fT terragrunt_linux_amd64 /usr/local/bin/terragrunt
chmod 775 /usr/local/bin/terragrunt
