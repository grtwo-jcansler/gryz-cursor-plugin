#!/usr/bin/env bash
# Validates plugin manifest + README stay aligned with Gryz MCP conventions.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

MCP_URL='https://www.gryz.ai/api/mcp'

fail() {
  echo "validate: $*" >&2
  exit 1
}

# ── mcp.json ─────────────────────────────────────────────────────────────────
[[ -f mcp.json ]] || fail 'missing mcp.json'

python3 - <<'PY' || fail 'mcp.json is not valid JSON'
import json
from pathlib import Path

data = json.loads(Path("mcp.json").read_text())
servers = data.get("mcpServers")
if not isinstance(servers, dict) or "gryz" not in servers:
    raise SystemExit("mcpServers.gryz missing")
url = servers["gryz"].get("url")
if url != "https://www.gryz.ai/api/mcp":
    raise SystemExit(f"url must be https://www.gryz.ai/api/mcp (no trailing slash), got {url!r}")
PY

# ── plugin manifest ──────────────────────────────────────────────────────────
[[ -f .cursor-plugin/plugin.json ]] || fail 'missing .cursor-plugin/plugin.json'

python3 - <<'PY' || fail 'plugin.json validation failed'
import json
import re
from pathlib import Path

plugin = json.loads(Path(".cursor-plugin/plugin.json").read_text())
if plugin.get("mcpServers") != "mcp.json":
    raise SystemExit('plugin.json mcpServers must be "mcp.json"')
version = plugin.get("version", "")
if not re.fullmatch(r"\d+\.\d+\.\d+", version):
    raise SystemExit(f"version must be semver x.y.z, got {version!r}")
PY

# ── README documents every tool ──────────────────────────────────────────────
[[ -f README.md ]] || fail 'missing README.md'
[[ -f expected-tools.json ]] || fail 'missing expected-tools.json'

python3 - <<'PY' || fail 'README tool list drift'
import json
from pathlib import Path

readme = Path("README.md").read_text()
expected = json.loads(Path("expected-tools.json").read_text())
for entry in expected["tools"]:
    label = entry["readmeLabel"]
    if label not in readme:
        raise SystemExit(f"README.md missing tool label: {label!r} ({entry['name']})")
PY

# ── README + mcp.json use slashless URL in examples ────────────────────────
if grep -q 'api/mcp/' README.md; then
  fail 'README.md must not use https://…/api/mcp/ (trailing slash breaks Cursor OAuth)'
fi

if ! grep -q "$MCP_URL" README.md; then
  fail "README.md must include primary MCP URL $MCP_URL"
fi

echo 'validate: OK'
