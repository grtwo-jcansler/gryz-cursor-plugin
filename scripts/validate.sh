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
import re
from pathlib import Path

readme = Path("README.md").read_text()
expected = json.loads(Path("expected-tools.json").read_text())
tools = expected.get("tools")
if not isinstance(tools, list) or not tools:
    raise SystemExit("expected-tools.json must contain a non-empty tools array")

names = [t.get("name") for t in tools]
if any(not isinstance(n, str) or not n for n in names):
    raise SystemExit("each tool must have a non-empty name")
if len(names) != len(set(names)):
    raise SystemExit("expected-tools.json has duplicate tool names")

comment_match = re.search(
    r"<!--\s*gryz-mcp-tools:\s*([^\s-][^>]*?)\s*-->",
    readme,
)
if not comment_match:
    raise SystemExit("README.md missing gryz-mcp-tools HTML comment (see CONTRIBUTING.md)")
comment_names = [n.strip() for n in comment_match.group(1).split(",") if n.strip()]
if set(comment_names) != set(names):
    missing = set(names) - set(comment_names)
    extra = set(comment_names) - set(names)
    msg = []
    if missing:
        msg.append(f"missing from comment: {sorted(missing)}")
    if extra:
        msg.append(f"extra in comment: {sorted(extra)}")
    raise SystemExit("; ".join(msg))

for entry in tools:
    label = entry["readmeLabel"]
    if label not in readme:
        raise SystemExit(f"README.md missing tool label: {label!r} ({entry['name']})")
    if f"`{entry['name']}`" not in readme:
        raise SystemExit(
            f"README.md must document MCP tool id `{entry['name']}` in backticks"
        )
PY

# ── README MCP URLs must not use a trailing slash on /api/mcp ───────────────
python3 - <<'PY' || fail 'README MCP URL trailing slash'
import re
from pathlib import Path

readme = Path("README.md").read_text()
bad = re.findall(r"https?://[^\s)>\"']+/api/mcp/", readme)
if bad:
    raise SystemExit(
        "README.md must not use MCP URLs ending in /api/mcp/ "
        f"(trailing slash breaks Cursor OAuth): {bad}"
    )
PY

if ! grep -q "$MCP_URL" README.md; then
  fail "README.md must include primary MCP URL $MCP_URL"
fi

echo 'validate: OK'
