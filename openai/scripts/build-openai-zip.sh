#!/usr/bin/env bash
#
# Build script for OpenAI plugin package
# Produces a reproducible ZIP with sorted entries and fixed mtimes
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_ZIP="${PACKAGE_DIR}/gryz-openai-plugin.zip"

# Fixed mtime for reproducibility (2026-10-12 00:00:00 UTC)
FIXED_MTIME="202610120000.00"

echo "Building OpenAI plugin package..."
echo "Package dir: $PACKAGE_DIR"
echo "Output: $OUTPUT_ZIP"

# Clean up old ZIP if it exists
rm -f "$OUTPUT_ZIP"

# Create a temporary directory for staging
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo "Staging files..."

# Copy files to temp dir
cp "$PACKAGE_DIR/plugin.json" "$TEMP_DIR/"
cp "$PACKAGE_DIR/mcp.json" "$TEMP_DIR/"
cp -r "$PACKAGE_DIR/assets" "$TEMP_DIR/"
cp -r "$PACKAGE_DIR/skills" "$TEMP_DIR/"

# Set fixed mtime on all files for reproducibility
find "$TEMP_DIR" -exec touch -t "$FIXED_MTIME" {} \;

# Create ZIP with sorted entries
# Use -X to exclude extra file attributes for reproducibility
cd "$TEMP_DIR"
TEMP_ZIP="$TEMP_DIR/package.zip"
find . -type f | LC_ALL=C sort | zip -X -q -@ "$TEMP_ZIP"
cd - > /dev/null

# Move ZIP to package directory
mv "$TEMP_ZIP" "$OUTPUT_ZIP"

echo "✓ Built: $OUTPUT_ZIP"
ls -lh "$PACKAGE_DIR/gryz-openai-plugin.zip"

echo ""
echo "Next steps:"
echo "1. Run validation: $SCRIPT_DIR/validate-openai-package.sh"
echo "2. Review placeholder content marked with 'PLACEHOLDER' in plugin.json"
echo "3. Upload ZIP to OpenAI plugin directory when ready"
