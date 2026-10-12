#!/usr/bin/env bash
#
# Validator for OpenAI plugin package
# Checks lengths, contrast, icon dimensions, test case counts, and forbidden content
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(dirname "$SCRIPT_DIR")"
PLUGIN_JSON="${PACKAGE_DIR}/plugin.json"
MCP_JSON="${PACKAGE_DIR}/mcp.json"

ERRORS=0
WARNINGS=0

error() {
    echo "❌ ERROR: $1"
    ERRORS=$((ERRORS + 1))
}

warning() {
    echo "⚠️  WARNING: $1"
    WARNINGS=$((WARNINGS + 1))
}

info() {
    echo "ℹ️  $1"
}

check_file_exists() {
    if [ ! -f "$1" ]; then
        error "Missing required file: $1"
        return 1
    fi
    return 0
}

check_json_field_length() {
    local file=$1
    local field=$2
    local max_length=$3
    local value=$(jq -r "$field // empty" "$file")
    
    if [ -n "$value" ]; then
        local length=${#value}
        if [ $length -gt $max_length ]; then
            error "$field exceeds max length $max_length (got $length)"
        else
            info "$field length: $length/$max_length ✓"
        fi
    fi
}

check_array_length_range() {
    local file=$1
    local field=$2
    local min=$3
    local max=$4
    local count=$(jq "$field | length" "$file")
    
    if [ "$count" -lt "$min" ] || [ "$count" -gt "$max" ]; then
        error "$field count must be between $min and $max (got $count)"
    else
        info "$field count: $count (within $min-$max range) ✓"
    fi
}

check_array_length() {
    local file=$1
    local field=$2
    local expected=$3
    local count=$(jq "$field | length" "$file")
    
    if [ "$count" != "$expected" ]; then
        error "$field count must be exactly $expected (got $count)"
    else
        info "$field count: $count/$expected ✓"
    fi
}

check_contrast() {
    local color=$1
    local bg=$2
    local name=$3
    
    # Use Python for contrast calculation
    python3 << EOF
import sys

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def relative_luminance(rgb):
    r, g, b = [x / 255.0 for x in rgb]
    r = r / 12.92 if r <= 0.03928 else ((r + 0.055) / 1.055) ** 2.4
    g = g / 12.92 if g <= 0.03928 else ((g + 0.055) / 1.055) ** 2.4
    b = b / 12.92 if b <= 0.03928 else ((b + 0.055) / 1.055) ** 2.4
    return 0.2126 * r + 0.7152 * g + 0.0722 * b

def contrast_ratio(color1, color2):
    lum1 = relative_luminance(hex_to_rgb(color1))
    lum2 = relative_luminance(hex_to_rgb(color2))
    lighter = max(lum1, lum2)
    darker = min(lum1, lum2)
    return (lighter + 0.05) / (darker + 0.05)

ratio = contrast_ratio("$color", "$bg")
if ratio >= 2.0:
    print(f"ℹ️  $name contrast: {ratio:.2f}:1 ✓")
    sys.exit(0)
else:
    print(f"❌ ERROR: $name contrast ratio {ratio:.2f}:1 is less than required 2:1")
    sys.exit(1)
EOF
    if [ $? -ne 0 ]; then
        ERRORS=$((ERRORS + 1))
    fi
}

check_image_dimensions() {
    local file=$1
    local name=$2
    
    if [ ! -f "$file" ]; then
        error "Image file not found: $file"
        return
    fi
    
    # Use file command to check if it's a PNG
    if ! file "$file" | grep -q PNG; then
        error "$name is not a PNG file"
        return
    fi
    
    # Read PNG dimensions using od
    local width=$(od -An -t u4 -j 16 -N 4 "$file" | tr -d ' ')
    local height=$(od -An -t u4 -j 20 -N 4 "$file" | tr -d ' ')
    
    # Swap bytes for big-endian PNG format
    width=$((((width & 0xFF) << 24) | ((width & 0xFF00) << 8) | ((width & 0xFF0000) >> 8) | ((width & 0xFF000000) >> 24)))
    height=$((((height & 0xFF) << 24) | ((height & 0xFF00) << 8) | ((height & 0xFF0000) >> 8) | ((height & 0xFF000000) >> 24)))
    
    if [ $width -ne $height ]; then
        error "$name is not square (${width}x${height})"
    else
        info "$name dimensions: ${width}x${height} (square) ✓"
    fi
    
    if [ $width -lt 48 ]; then
        error "$name dimensions ${width}x${height} are below minimum 48x48"
    fi
}

check_forbidden_content() {
    local forbidden=("hooks" "apps" "test_credentials" "reviewer_instructions" "clientSecret" "headers" "secrets")
    
    for term in "${forbidden[@]}"; do
        if grep -q "\"$term\"" "$PLUGIN_JSON" "$MCP_JSON" 2>/dev/null; then
            error "Forbidden field '$term' found in package files"
        fi
    done
}

echo "========================================="
echo "OpenAI Plugin Package Validator"
echo "========================================="
echo ""

# Check required files exist
echo "Checking required files..."
check_file_exists "$PLUGIN_JSON" || exit 1
check_file_exists "$MCP_JSON" || exit 1
check_file_exists "${PACKAGE_DIR}/assets/logo.png" || exit 1
check_file_exists "${PACKAGE_DIR}/assets/logo-dark.png" || exit 1
check_file_exists "${PACKAGE_DIR}/assets/composer-icon.png" || exit 1
check_file_exists "${PACKAGE_DIR}/assets/composer-icon-dark.png" || exit 1
check_file_exists "${PACKAGE_DIR}/skills/get-started/SKILL.md" || exit 1
echo ""

# Check JSON schema
echo "Checking JSON schemas..."
jq empty "$PLUGIN_JSON" 2>/dev/null || error "plugin.json is not valid JSON"
jq empty "$MCP_JSON" 2>/dev/null || error "mcp.json is not valid JSON"
echo ""

# Check field lengths
echo "Checking field lengths..."
check_json_field_length "$PLUGIN_JSON" '.name' 64
check_json_field_length "$PLUGIN_JSON" '.description' 4000
check_json_field_length "$PLUGIN_JSON" '.extensions."com.openai.interface".displayName' 30
check_json_field_length "$PLUGIN_JSON" '.extensions."com.openai.interface".shortDescription' 30
check_json_field_length "$PLUGIN_JSON" '.extensions."com.openai.interface".longDescription' 4000
check_json_field_length "$PLUGIN_JSON" '.extensions."com.openai.interface".developerName' 80
echo ""

# Check array lengths
echo "Checking test case counts..."
check_array_length "$PLUGIN_JSON" '.extensions."com.openai.review".test_cases.positive' 5
check_array_length "$PLUGIN_JSON" '.extensions."com.openai.review".test_cases.negative' 3
check_array_length_range "$PLUGIN_JSON" '.extensions."com.openai.interface".capabilities' 1 20
check_array_length "$PLUGIN_JSON" '.extensions."com.openai.interface".defaultPrompt' 3
echo ""

# Check contrast ratios
echo "Checking brand color contrast..."
brand_color=$(jq -r '.extensions."com.openai.interface".brandColor' "$PLUGIN_JSON")
brand_color_dark=$(jq -r '.extensions."com.openai.interface".brandColorDark' "$PLUGIN_JSON")
check_contrast "$brand_color" "ffffff" "brandColor vs white"
check_contrast "$brand_color_dark" "212121" "brandColorDark vs #212121"
echo ""

# Check image dimensions
echo "Checking icon dimensions..."
check_image_dimensions "${PACKAGE_DIR}/assets/logo.png" "logo.png"
check_image_dimensions "${PACKAGE_DIR}/assets/logo-dark.png" "logo-dark.png"
check_image_dimensions "${PACKAGE_DIR}/assets/composer-icon.png" "composer-icon.png"
check_image_dimensions "${PACKAGE_DIR}/assets/composer-icon-dark.png" "composer-icon-dark.png"
echo ""

# Check forbidden content
echo "Checking for forbidden content..."
check_forbidden_content
info "No forbidden fields found ✓"
echo ""

# Check for placeholders
echo "Checking for placeholder content..."
placeholder_count=$(grep -r "PLACEHOLDER" "$PLUGIN_JSON" | wc -l)
if [ $placeholder_count -gt 0 ]; then
    warning "Found $placeholder_count instances of 'PLACEHOLDER' that need real content"
    echo ""
    echo "Placeholder locations:"
    grep -n "PLACEHOLDER" "$PLUGIN_JSON" | head -20
else
    info "No placeholders found ✓"
fi
echo ""

# Check mcp.json exact format
echo "Checking mcp.json format..."
expected_schema="https://agent-plugins.org/schemas/1.0.0/mcp.schema.json"
actual_schema=$(jq -r '."$schema"' "$MCP_JSON")
if [ "$actual_schema" != "$expected_schema" ]; then
    error "mcp.json \$schema doesn't match expected value"
fi

mcp_type=$(jq -r '.mcpServers.gryz.type' "$MCP_JSON")
if [ "$mcp_type" != "streamable-http" ]; then
    error "mcp.json type must be 'streamable-http' (got '$mcp_type')"
fi

mcp_url=$(jq -r '.mcpServers.gryz.url' "$MCP_JSON")
if [ "$mcp_url" != "https://www.gryz.ai/api/mcp" ]; then
    error "mcp.json url must be 'https://www.gryz.ai/api/mcp' (got '$mcp_url')"
fi

if jq -e '.mcpServers.gryz.headers' "$MCP_JSON" > /dev/null 2>&1; then
    error "mcp.json must NOT contain 'headers' field"
fi

if jq -e '.mcpServers.gryz.secrets' "$MCP_JSON" > /dev/null 2>&1; then
    error "mcp.json must NOT contain 'secrets' field"
fi

info "mcp.json format is correct ✓"
echo ""

# Summary
echo "========================================="
echo "Validation Summary"
echo "========================================="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ All checks passed!"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo "✅ All checks passed (with $WARNINGS warnings)"
    exit 0
else
    echo "❌ Validation failed with $ERRORS errors and $WARNINGS warnings"
    exit 1
fi
