# Contributing — Gryz Cursor plugin

This repo is the **public install package** for Gryz in Cursor: `mcp.json`,
plugin manifest, and README. It does **not** implement MCP tools — Cursor
discovers tools live from `https://www.gryz.ai/api/mcp` via `tools/list`.

Application code lives in [grtwo-docs](https://github.com/grtwo-jcansler/grtwo-docs).

## Workflow

1. Branch from `main` — `fix/…`, `chore/…`, or `docs/…` (kebab-case).
2. Open a PR to `main`. Do not push directly to `main`.
3. CI must pass (`Validate plugin` workflow).
4. Merge, then reinstall or reload Gryz MCP in Cursor if `mcp.json` changed.

### Branch protection (recommended)

In GitHub **Settings → Branches**, add a rule for `main`:

- Require a pull request before merging
- Require status check: **Validate plugin**

No `develop` branch — this repo has no deploy preview.

## When Gryz adds or changes MCP tools

Tools are **not** declared in `mcp.json`. Update documentation only:

| File | Action |
|------|--------|
| `expected-tools.json` | Add/rename tool + `readmeLabel` (sync with `grtwo-docs` `lib/mcp/tool-definitions.ts`) |
| `README.md` | Document the tool under Documents or Notes; add backtick tool id; update the `gryz-mcp-tools` HTML comment |
| `.cursor-plugin/plugin.json` | Bump `version` if marketplace listing should update |

Also update [grtwo-docs](https://github.com/grtwo-jcansler/grtwo-docs):

- `lib/mcp/tool-definitions.ts` (source of truth)
- `app/docs/mcp/page.tsx` (tools table is generated from definitions)
- `server.gryz.json` version + republish to MCP registry when appropriate

## MCP URL rule

Always use **`https://www.gryz.ai/api/mcp`** — no trailing slash. Cursor OAuth
compares this against Gryz protected-resource metadata; a slash mismatch breaks
sign-in.

## Local validation

```bash
bash scripts/validate.sh
```
