#!/usr/bin/env bash

# This script extracts the current git commit hash and the latest tag (if any)
# and writes them to a JSON file that Hugo can read.

set -euo pipefail

# Determine the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Go up one level to the project root (assuming script is in scripts/)
THEME_ROOT="$(dirname "$SCRIPT_DIR")"
SITE_ROOT="$THEME_ROOT/../.."
# Output file path: site root is two levels above this repository root,
# so the data directory is ../../data/git_hashes.json from this repo root.
OUTPUT_FILE="$SITE_ROOT/data/git_hashes.json"

# Ensure the data directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Get the current commit hash (short)
COMMIT_HASH_THEME="$(git -C "$THEME_ROOT" rev-parse --short=7 HEAD 2>/dev/null || echo "unknown")"
# Get the latest tag (if any)
LATEST_TAG_THEME="$(git -C "$THEME_ROOT" describe --tags --abbrev=0 2>/dev/null || echo "")"

# Get the current commit hash (short)
COMMIT_HASH_SITE="$(git -C "$SITE_ROOT" rev-parse --short=7 HEAD 2>/dev/null || echo "unknown")"
# Get the latest tag (if any)
LATEST_TAG_SITE="$(git -C "$SITE_ROOT" describe --tags --abbrev=0 2>/dev/null || echo "")"

# Write JSON
cat > "$OUTPUT_FILE" <<EOF
{
    "theme": {
        "commit": "$COMMIT_HASH_THEME",
        "tag": "$LATEST_TAG_THEME"
    },
    "site": {
        "commit": "$COMMIT_HASH_SITE",
        "tag": "$LATEST_TAG_SITE"
    }
}
EOF

echo "Wrote git hashes to $OUTPUT_FILE"
