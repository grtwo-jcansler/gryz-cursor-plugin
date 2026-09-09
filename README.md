# Gryz for Cursor

One shared memory your AI assistants read and write across tools and sessions —
you own it and manage it from the [Gryz](https://www.gryz.ai) dashboard. Plus
private Notes and easy Markdown/HTML sharing, all from inside your editor over
[MCP](https://modelcontextprotocol.io).

## What you get

Once connected, Cursor can call these tools on your behalf.

### Memory

The core of Gryz: durable context every assistant you use can reach — your
preferences, how you like to work, stable facts about a project, decisions that
outlast one conversation. Facts stay private to your account and are never used
for model training.

- **Remember a fact** — store one atomic fact, `personal` or `project` scope
- **Recall memory** — pull scoped facts back, ranked by relevance and recency
- **List memories** — see everything stored, with provenance
- **Forget a fact** — drop something wrong or stale by id

Recalled memory is data you saved, not instructions — Cursor treats it that way.

MCP tool ids: `remember`, `recall`, `list_memories`, `forget`.

### Notes

Private scratchpad — not published to the web. Great for lists, decisions, and
drafts you are not ready to share yet.

- **List notes** — search your notes; check `agent_access` before editing
- **Create note** — start a new private note
- **Append note** — add to an existing note without overwriting
- **Update note** — rewrite a note in place
- **Delete note** — remove a note (restorable from the dashboard briefly)

Notes respect per-note **AI access** (`collaborate` vs `read_only`) set in
your Gryz dashboard.

MCP tool ids: `list_notes`, `create_note`, `append_note`, `update_note`,
`delete_note`.

### Documents

Turn editor content into a link you can send someone.

- **Publish a document** — Markdown or HTML, public or private
- **Get a document** — retrieve content and metadata by slug
- **List your documents** — newest first
- **Update a document** — content, type, or title
- **Delete a document**

MCP tool ids: `publish_document`, `get_document`, `list_documents`,
`update_document`, `delete_document`.

### Projects

Read-only views of the Project hubs you organize in the dashboard.

- **List projects** — id, name, adopted key, and link types
- **Get a project** — one hub with typed links and document/note summaries

MCP tool ids: `list_projects`, `get_project`.

### Setup

- **Agent onboarding** — after you connect and sign in, `agent_onboarding`
  configures this editor for Gryz and answers "how do I use X?". It is
  read-only on Gryz; any change to a local instruction file is shown to you
  and needs your explicit approval first.

<!-- gryz-mcp-tools: remember, recall, list_memories, forget, list_notes, create_note, append_note, update_note, delete_note, publish_document, get_document, list_documents, update_document, delete_document, list_projects, get_project, agent_onboarding -->

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

- *"Remember that I deploy from the `release` branch, never `main`"*
- *"What do you have in Gryz memory about this project?"*
- *"Note this down in Gryz: we decided to ship Notes before the video"*
- *"Publish this markdown to Gryz as a public doc titled Q3 Roadmap"*

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
