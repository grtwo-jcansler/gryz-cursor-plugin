# Gryz for Cursor

Publish, share, and manage documents on [Gryz](https://www.gryz.ai) directly
from Cursor. Paste Markdown or HTML and get a shareable link in seconds —
now from inside your editor, over [MCP](https://modelcontextprotocol.io).

## What you get

Once connected, Cursor can call these tools on your behalf:

- **Publish a document** — Markdown or HTML, public or private
- **Get a document** — retrieve content and metadata by slug
- **List your documents** — newest first
- **Update a document** — content, type, or title
- **Delete a document**

## Install

### One-click (Cursor Marketplace)

Search **Gryz** in the Cursor plugin marketplace and install.

### Manual

1. Clone or download this repo.
2. Copy `mcp.json` into your Cursor MCP config (`~/.cursor/mcp.json` for a
   server available across all workspaces, or `.cursor/mcp.json` in a single
   project).
3. Restart Cursor, or reload the MCP servers list.

```json
{
  "mcpServers": {
    "gryz": {
      "url": "https://www.gryz.ai/api/mcp/"
    }
  }
}
```

## Signing in

The first tool call opens a browser window to authorize Gryz via OAuth —
sign in with Google, GitHub, a magic link, or a password. No API key needed
for this flow, and no secrets live in this plugin's manifest.

**Prefer an API key instead?** Generate one at
[gryz.ai/account/api-keys](https://www.gryz.ai/account/api-keys/) and add it
as a header in your own `mcp.json`:

```json
{
  "mcpServers": {
    "gryz": {
      "url": "https://www.gryz.ai/api/mcp/",
      "headers": {
        "Authorization": "Bearer YOUR_API_KEY"
      }
    }
  }
}
```

Both OAuth and API key access are free with any Gryz account — no
subscription required.

## Already using the old URL?

`https://www.grtwo.app/api/mcp/` — the previous domain — still works during
the brand transition from grtwo.app to Gryz. No need to change an existing
connection until you're ready; new setups should use the `gryz.ai` URL above.

## Links

- [Full MCP setup guide](https://www.gryz.ai/docs/mcp/)
- [Gryz](https://www.gryz.ai)
- [Report an issue](https://github.com/grtwo-jcansler/gryz-cursor-plugin/issues)

## License

MIT — see [LICENSE](LICENSE).
