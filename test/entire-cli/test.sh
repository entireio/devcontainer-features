#!/usr/bin/env bash
set -euo pipefail

# Check that the binary exists and is executable
if ! command -v entire &>/dev/null; then
  echo "FAIL: entire binary not found in PATH"
  exit 1
fi

echo "PASS: entire binary exists at $(command -v entire)"

# Check that it runs and returns version info
if ! entire --version &>/dev/null; then
  echo "FAIL: entire --version returned non-zero exit code"
  exit 1
fi

echo "PASS: entire --version returned: $(entire --version)"
