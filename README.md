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
- **Get a note** — fetch one note's full text by its id
- **Create note** — start a new private note
- **Append note** — add to an existing note without overwriting
- **Update note** — rewrite a note in place
- **Delete note** — remove a note (restorable from the dashboard briefly)

Notes respect per-note **AI access** (`collaborate` vs `read_only`) set in
your Gryz dashboard.

MCP tool ids: `list_notes`, `get_note`, `create_note`, `append_note`,
`update_note`, `delete_note`.

### Documents

Turn editor content into a link you can send someone, and keep long documents
current without resending them.

- **Publish a document** — Markdown or HTML, public or private
- **Get a document** — retrieve content and metadata by slug. For a long
  document it can return just an outline, one section, a slice, or search
  results instead of the whole thing
- **List your documents** — newest first
- **Update a document** — replace the content, type, or title
- **Add to a document** — add text to the end or start without resending the
  rest (Markdown, CSV, Mermaid)
- **Edit part of a document** — up to 25 precise changes applied together as
  one new version: replace exact text, insert near a heading, replace or delete
  a section, add a table row, tick a checklist item. Preview with `dry_run`
- **See a document's history** — every saved version and who made it
- **Restore an earlier version** — brings it back as a new version, so
  nothing is rewritten and a restore can be undone
- **Suggest a change** — if the owner only allows suggestions, the edit waits
  for approval in the dashboard
- **List suggestions** — see what is waiting, accepted, or rejected
- **Delete a document**

Every document has a version such as `r12`. Pass it back as `if_match` and a
write is refused if the document changed since you read it. Owners choose per
document whether assistants may edit directly, only suggest, or only read.

MCP tool ids: `publish_document`, `get_document`, `list_documents`,
`update_document`, `append_to_document`, `edit_document`,
`list_document_revisions`, `restore_document_revision`,
`suggest_document_edit`, `list_document_suggestions`, `delete_document`.

### Projects

Views of the Project hubs you organize in the dashboard, plus filing documents
into them.

- **List projects** — id, name, adopted key, and link types
- **Get a project** — one hub with typed links and document/note summaries
- **Add a document to a project** — file a document you own into a Project
  (needs the projects write permission)
- **Remove a document from a project** — does not delete the document

MCP tool ids: `list_projects`, `get_project`, `associate_document`,
`disassociate_document`.

### Skills

Reusable instructions your assistants can load by name.

- **List skills** — your active set, names and descriptions only
- **Get a skill** — the current text, with its version and where it came from
- **Fork a skill** — copy a library skill into your own editable version
  (Pro or higher)
- **Create a skill** — write one from scratch (Pro Plus)
- **Update a skill** — saves a new version; earlier versions are kept
- **Delete a skill** — soft delete; history is kept

MCP tool ids: `list_skills`, `get_skill`, `fork_skill`, `create_skill`,
`update_skill`, `delete_skill`.

### Tasks

Owned units of work with a status, priority, and optional assignee.

- **Create a task** — for you or for the calling agent, with optional subtasks
  and Project
- **List tasks** — newest first, filter to what is on you or on an agent
- **Get a task** — one task with its history and linked documents and notes
- **Update a task** — status, priority, assignee, description, due date, links

MCP tool ids: `create_task`, `list_tasks`, `get_task`, `update_task`.

### Connected tools

Use tools from other MCP servers you connect in the Gryz dashboard (for example
GitHub, Jira, or Slack), through one place.

- **Find tools on connected servers** — search by what you want to do
- **Call a connected tool** — Gryz checks it is enabled, validates the
  arguments, applies rate limits, and returns the result

MCP tool ids: `broker_list_tools`, `broker_call_tool`.

### Comments

Comments on documents, written by an agent on your behalf and labelled as such.
These need the comments permission, which is opt-in when you connect.

- **List comments** — on your documents, or private documents shared with you
- **Add a comment** — plain text or a one-level reply
- **Delete a comment** — only comments an agent posted for you

MCP tool ids: `list_comments`, `add_comment`, `delete_comment`.

### Setup

- **Agent onboarding** — after you connect and sign in, `agent_onboarding`
  configures this editor for Gryz and answers "how do I use X?". It is
  read-only on Gryz; any change to a local instruction file is shown to you
  and needs your explicit approval first.

<!-- gryz-mcp-tools: remember, recall, list_memories, forget, list_notes, create_note, append_note, update_note, delete_note, publish_document, get_document, list_documents, update_document, delete_document, list_projects, get_project, agent_onboarding, append_to_document, edit_document, list_document_revisions, restore_document_revision, suggest_document_edit, list_document_suggestions, get_note, associate_document, disassociate_document, list_skills, get_skill, create_skill, update_skill, fork_skill, delete_skill, create_task, list_tasks, get_task, update_task, broker_list_tools, broker_call_tool, list_comments, add_comment, delete_comment -->

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
- *"Add today's entry to the end of my release tracker doc without rewriting it"*
- *"Show me what changed in that doc since yesterday, then restore the old version of the Plan section"*

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
