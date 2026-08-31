# Gryz for Cursor

Publish, share, and manage documents on [Gryz](https://www.gryz.ai) directly
from Cursor. Jot private Notes, paste Markdown or HTML, and get shareable links
— all from inside your editor, over [MCP](https://modelcontextprotocol.io).

## What you get

Once connected, Cursor can call these tools on your behalf.

### Documents

- **Publish a document** — Markdown or HTML, public or private
- **Get a document** — retrieve content and metadata by slug
- **List your documents** — newest first
- **Update a document** — content, type, or title
- **Delete a document**

### Notes

Private scratchpad — not published to the web. Great for decisions, lists, and
drafts you are not ready to share yet.

- **List notes** — search your notes; check `agent_access` before editing
- **Create note** — start a new private note
- **Append note** — add to an existing note without overwriting
- **Update note** — rewrite a note in place
- **Delete note** — remove a note (restorable from the dashboard briefly)

Notes respect per-note **AI access** (`collaborate` vs `read_only`) set in
your Gryz dashboard.

MCP tool ids: `publish_document`, `get_document`, `list_documents`,
`update_document`, `delete_document`, `list_notes`, `create_note`,
`append_note`, `update_note`, `delete_note`.

<!-- gryz-mcp-tools: publish_document, get_document, list_documents, update_document, delete_document, list_notes, create_note, append_note, update_note, delete_note -->

## Install

### One-click

Use the **[Add to Cursor](https://www.gryz.ai/docs/mcp/)** button on the MCP
setup guide, or search **Gryz** in the Cursor plugin marketplace.

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
      "url": "https://www.gryz.ai/api/mcp"
    }
  }
}
```

Use `https://www.gryz.ai/api/mcp` exactly — **no trailing slash**. Cursor OAuth
fails if the URL does not match Gryz protected-resource metadata.

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
      "url": "https://www.gryz.ai/api/mcp",
      "headers": {
        "Authorization": "Bearer YOUR_API_KEY"
      }
    }
  }
}
```

Both OAuth and API key access are free with any Gryz account — no
subscription required.

## Example prompts

- *"Publish this markdown to Gryz as a public doc titled Q3 Roadmap"*
- *"List my Gryz documents"*
- *"Note this down in Gryz: we decided to ship Notes before the video"*
- *"What notes do I have about the launch?"*

## Already using the old URL?

`https://www.grtwo.app/api/mcp` — the previous domain — still works during the
brand transition from grtwo.app to Gryz. No need to change an existing
connection until you are ready; new setups should use the `gryz.ai` URL above.

## Links

- [Full MCP setup guide](https://www.gryz.ai/docs/mcp/)
- [Contributing](CONTRIBUTING.md)
- [Gryz](https://www.gryz.ai)
- [Report an issue](https://github.com/grtwo-jcansler/gryz-cursor-plugin/issues)

## License

MIT — see [LICENSE](LICENSE).
