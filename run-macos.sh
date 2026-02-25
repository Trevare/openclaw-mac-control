#!/usr/bin/env bash
set -euo pipefail

if ! command -v swift >/dev/null 2>&1; then
  echo "Swift not found. Install Xcode first." >&2
  exit 1
fi

swift run OpenClawControl
