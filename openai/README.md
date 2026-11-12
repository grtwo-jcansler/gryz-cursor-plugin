# OpenAI ChatGPT Plugin Package

This directory contains the OpenAI ChatGPT directory submission package for Gryz.

## Structure

```
openai/
├── plugin.json              # Agent Plugins format manifest
├── mcp.json                # MCP server configuration (DCR OAuth)
├── assets/                 # Brand assets
│   ├── logo.png           # Main logo (256x256, light)
│   ├── logo-dark.png      # Dark mode logo (256x256, dark)
│   ├── composer-icon.png  # Composer icon (128x128, light)
│   └── composer-icon-dark.png  # Dark mode composer icon (128x128, dark)
├── skills/
│   └── get-started/
│       └── SKILL.md       # Onboarding skill
└── scripts/
    ├── build-openai-zip.sh       # Build reproducible ZIP
    └── validate-openai-package.sh # Validate package requirements
```

## Building

```bash
bash openai/scripts/build-openai-zip.sh
```

Produces `openai/gryz-openai-plugin.zip` with:
- Sorted file entries (reproducible)
- Fixed mtimes (2026-10-12 00:00:00 UTC)
- All required files

## Validation

```bash
bash openai/scripts/validate-openai-package.sh
```

Checks:
- ✓ Field length limits (name ≤64, displayName ≤30, etc.)
- ✓ Brand color contrast (≥2:1 vs white/#212121)
- ✓ Icon dimensions (square, ≥48x48)
- ✓ Exact test case counts (5 positive, 3 negative)
- ✓ No forbidden fields (hooks, clientSecret, headers, etc.)
- ✓ mcp.json exact format (streamable-http, no credentials)

## Placeholder Content

The following content is marked with `PLACEHOLDER` and needs real content from Product/Design/GTM:

- **Category** (line 37): Final OpenAI directory category
- **Test cases** (5 positive, 3 negative): Product's final test scenarios
- **Demo recording URL**: Final product demo video

All placeholders pass validation but must be replaced before final submission.

## Version

Package version: **1.0.0**

Based on v1.8.0 plugin manifest with Agent Plugins format extensions.

## OAuth Authentication

Uses Dynamic Client Registration (DCR) - no client credentials in package.
OAuth flow handled automatically via MCP protocol at `https://www.gryz.ai/api/mcp`.

## References

- Agent Plugins Schema: https://agent-plugins.org/schemas/1.0.0/plugin.schema.json
- MCP Schema: https://agent-plugins.org/schemas/1.0.0/mcp.schema.json
- OpenAI Plugin Guidelines: (internal)
