#!/usr/bin/env bash
set -euo pipefail

GO_VERSION="${GO_VERSION:-1.24.4}"

if command -v go >/dev/null 2>&1; then
    echo "go already installed: $(go version)"
    exit 0
fi

case "$(uname -s)" in
    Linux) os=linux ;;
    Darwin) os=darwin ;;
    *) echo "unsupported Go OS: $(uname -s)" >&2; exit 0 ;;
esac

case "$(uname -m)" in
    x86_64|amd64) arch=amd64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) echo "unsupported Go arch: $(uname -m)" >&2; exit 0 ;;
esac

archive="go${GO_VERSION}.${os}-${arch}.tar.gz"
tmp="${TMPDIR:-/tmp}/$archive"

curl -fsSL "https://go.dev/dl/$archive" -o "$tmp"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "$tmp"
rm -f "$tmp"
