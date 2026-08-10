#!/usr/bin/env bash

# This script extracts the current git commit hash and the latest tag (if any)
# and writes them to a JSON file that Hugo can read.

set -euo pipefail

# Determine the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Go up one level to the project root (assuming script is in scripts/)
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Output file path: site root is two levels above this repository root,
# so the data directory is ../../data/git_hashes.json from this repo root.
OUTPUT_FILE="$PROJECT_ROOT/../../data/git_hashes.json"

# Ensure the data directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Get the current commit hash (short)
COMMIT_HASH="$(git -C "$PROJECT_ROOT" rev-parse --short HEAD 2>/dev/null || echo "unknown")"

# Get the latest tag (if any)
LATEST_TAG="$(git -C "$PROJECT_ROOT" describe --tags --abbrev=0 2>/dev/null || echo "")"

# Write JSON
cat > "$OUTPUT_FILE" <<EOF
{
  "commit": "$COMMIT_HASH",
  "tag": "$LATEST_TAG"
}
EOF

echo "Wrote git hashes to $OUTPUT_FILE"
