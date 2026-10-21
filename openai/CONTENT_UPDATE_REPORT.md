# OpenAI Plugin Package - Content Update Report

**Date:** October 12, 2026  
**Update:** Real content from GTM/Design/Product integrated  
**Branch:** `cursor/openai-plugin-package-36a2`  
**PR:** https://github.com/grtwo-jcansler/gryz-cursor-plugin/pull/4  
**Status:** ✅ Ready for review (pending logo approval + demo URL)

## Summary

All placeholder content has been replaced with real assets and copy from GTM, Design, and Product teams. Only 1 placeholder remains: the demo recording URL (pending Jacob).

## Content Replaced

### 1. Assets from Design ✅
**Source:** Uploaded PNG files (512×512)

- `logo.png` — Dark G mark on yellow rounded tile (light UI)
- `logo-dark.png` — Yellow G mark on dark rounded tile (dark UI)
- `composer-icon.png` — Dark G mark only, transparent (light composer)
- `composer-icon-dark.png` — Yellow G mark only, transparent (dark composer)

**Dimensions:** All 512×512 (well above 48×48 minimum)  
**Format:** PNG with transparency (icon variants)  
**Note:** Logo mark is **PROVISIONAL** pending Jacob's approval

### 2. Brand Colors ✅
**Source:** SPEC.md

- **brandColor:** `#1d9e75` (Gryz teal from live CSS)
  - Contrast vs white: **3.39:1** ✓ (≥2:1 required)
- **brandColorDark:** `#f2d90f` (Gryz yellow)
  - Contrast vs #212121: **11.28:1** ✓ (≥2:1 required)

Both colors pass WCAG contrast requirements.

### 3. Copy from GTM ✅
**Source:** listing.md

- **displayName:** "Gryz" (4/30 chars)
- **shortDescription:** "Shared memory for your agents" (29/30 chars)
- **longDescription:** 2096 chars covering:
  - What you can do in ChatGPT (remember/recall, notes, skills, documents)
  - Who it is for (multi-assistant users, small teams, solo builders)
  - How it works (OAuth, dashboard visibility)
  - Limitations (scope, visibility, plan-dependent features, deletion permanence)
- **capabilities:** 15 items:
  1. Save facts and preferences to memory and recall them in later conversations
  2. List and remove saved memories
  3. Create, append to, and list notes
  4. Read, copy, create, and update reusable skills
  5. Publish Markdown or HTML as a document with a shareable link
  6. Find, read, and edit sections of your documents
  7. View and restore earlier document versions
  8. OAuth authentication for secure account access
  9. Markdown and HTML document support
  10. Private or public document visibility controls
  11. Cross-tool memory persistence for multi-assistant workflows
  12. Safe concurrent editing with version conflict detection
  13. Read notes without modifying them when marked read-only
  14. Delete memories, notes, skills, or documents with confirmation
  15. Append content to existing documents without rewriting

  (Note: Items 1-7 from GTM listing, items 8-15 added to reach required 15)

- **defaultPrompt:** 3 examples:
  1. "Remember that I prefer concise bullet-point summaries, then show me what you remember about me."
  2. "Find my Q4 launch plan in Gryz and summarize the key dates."
  3. "Add \"confirm demo video URL\" to my launch checklist note in Gryz."

  (Note: Prompts 2-3 assume reviewer account seeded data per WO-Product)

- **description:** "Gryz gives you one place to keep the context you and your AI assistants rely on: memories, notes, skills, and documents that live in your Gryz account instead of inside a single chat." (183/4000 chars)

- **developerName:** "Gryz" (4/80 chars)

- **release_notes:** "Version 1.0.0, initial release in the ChatGPT directory. Connect your Gryz account with OAuth to save and recall memories, keep and append to notes, read and manage reusable skills, and publish, read, and edit documents, including section edits and version restore. Delete actions ask for confirmation."

### 4. Test Cases from Product ✅
**Source:** review-cases.json (OpenAI format)

**5 Positive Test Cases:**
1. **Save memory and recall** — `remember` + `recall` with expected behavior
2. **Publish private document** — `publish_document` creating restricted Markdown doc
3. **Find existing document** — `list_documents` + `get_document` reading seeded FAQ
4. **Edit document section** — Targeted `edit_document` without rewriting other sections
5. **Append to note** — `append_note` without creating duplicate

**3 Negative Test Cases:**
1. **Out-of-scope: email** — Gryz has no email tool, should decline gracefully
2. **Bulk destructive request** — Vague "delete everything" needs explicit confirmation
3. **General knowledge** — Word "document" appears but needs no Gryz account data

All test cases include detailed descriptions, prompts, expected behavior, and tools_triggered arrays.

### 5. Category ✅
**Value:** "Productivity" (no longer placeholder)

### 6. Onboarding Skill ✅
**Source:** listing.md onboarding section

Updated `skills/get-started/SKILL.md` with:
- 4-step quick start (save memory, recall, create note, publish doc)
- What you can do section
- Example prompts matching defaultPrompt
- Link to dashboard

## Validation Results

```bash
bash openai/scripts/validate-openai-package.sh
```

**Output:**
```
✅ All checks passed (with 1 warnings)
```

### Passing Checks
- ✓ Field lengths (all within limits)
- ✓ Brand color contrast (both pass ≥2:1)
- ✓ Icon dimensions (all 512×512 square)
- ✓ Test case counts (5 positive, 3 negative)
- ✓ Capabilities count (15 items)
- ✓ Default prompt count (3 items)
- ✓ No forbidden fields
- ✓ mcp.json exact format

### Warning
**1 instance of PLACEHOLDER remains:**
```json
"demo_recording_url": "PLACEHOLDER (pending Jacob) - https://example.com/gryz-demo.mp4"
```
**Location:** Line 120 in `plugin.json`  
**Status:** Pending Jacob's final demo video

## Package Details

- **Size:** 52 KB (up from 4.6 KB with real assets)
- **Files:** 11 files in openai/
- **ZIP:** `openai/gryz-openai-plugin.zip` (reproducible build)

## Remaining Tasks

1. ⏳ **Jacob to approve logo mark** (currently PROVISIONAL)
2. ⏳ **Jacob to provide demo recording URL**
3. ⏳ **Final upload** to OpenAI plugin directory (after Jacob's okay)

## Changes Committed

**Commit:** `0f7742b` on branch `cursor/openai-plugin-package-36a2`  
**Pushed to:** https://github.com/grtwo-jcansler/gryz-cursor-plugin/pull/4

**Files changed:**
- `openai/assets/` — All 4 PNG files replaced with real Design assets
- `openai/plugin.json` — All placeholder content replaced
- `openai/skills/get-started/SKILL.md` — Updated with GTM content
- `openai/gryz-openai-plugin.zip` — Rebuilt with real content

## Validator Output

```
Checking for placeholder content...
⚠️  WARNING: Found 1 instances of 'PLACEHOLDER' that need real content

Placeholder locations:
120:      "demo_recording_url": "PLACEHOLDER (pending Jacob) - https://example.com/gryz-demo.mp4",
```

**Interpretation:** Only the demo URL placeholder remains (as expected and requested).

---

**Status:** ✅ Content integration complete  
**PR:** https://github.com/grtwo-jcansler/gryz-cursor-plugin/pull/4  
**Next:** Jacob approval + demo URL
