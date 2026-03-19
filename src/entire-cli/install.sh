#!/usr/bin/env bash
set -euo pipefail

VERSION="${VERSION:-latest}"

# Detect architecture
ARCH="$(uname -m)"
case "${ARCH}" in
  x86_64)  ARCH="amd64" ;;
  aarch64) ARCH="arm64" ;;
  arm64)   ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: ${ARCH}" >&2
    exit 1
    ;;
esac

# Detect OS
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "${OS}" in
  linux)  OS="linux" ;;
  darwin) OS="darwin" ;;
  *)
    echo "Unsupported OS: ${OS}" >&2
    exit 1
    ;;
esac

# Resolve latest version
if [ "${VERSION}" = "latest" ]; then
  VERSION="$(curl -fsSL https://api.github.com/repos/entireio/cli/releases/latest | grep '"tag_name"' | sed -E 's/.*"v?([^"]+)".*/\1/')"
fi

# Strip leading 'v' if present
VERSION="${VERSION#v}"

TARBALL="entire_${OS}_${ARCH}.tar.gz"
DOWNLOAD_URL="https://github.com/entireio/cli/releases/download/v${VERSION}/${TARBALL}"

echo "Installing Entire CLI v${VERSION} (${OS}/${ARCH})..."

# Download and extract
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

curl -fsSL "${DOWNLOAD_URL}" -o "${TMP_DIR}/${TARBALL}"
tar -xzf "${TMP_DIR}/${TARBALL}" -C "${TMP_DIR}"

# Install binary
install -m 755 "${TMP_DIR}/entire" /usr/local/bin/entire

# Install shell completions if available
if [ -d "${TMP_DIR}/completions" ]; then
  if [ -f "${TMP_DIR}/completions/entire.bash" ]; then
    mkdir -p /etc/bash_completion.d
    cp "${TMP_DIR}/completions/entire.bash" /etc/bash_completion.d/entire
  fi
  if [ -f "${TMP_DIR}/completions/entire.zsh" ]; then
    mkdir -p /usr/local/share/zsh/site-functions
    cp "${TMP_DIR}/completions/entire.zsh" /usr/local/share/zsh/site-functions/_entire
  fi
  if [ -f "${TMP_DIR}/completions/entire.fish" ]; then
    mkdir -p /usr/share/fish/vendor_completions.d
    cp "${TMP_DIR}/completions/entire.fish" /usr/share/fish/vendor_completions.d/entire.fish
  fi
fi

echo "Entire CLI v${VERSION} installed successfully."
