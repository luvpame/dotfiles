---
name: linear-docs
description: LINEAR-DOCS documentation assistant
metadata:
  target_agent: claude
---

# LINEAR-DOCS Skill

This skill provides access to LINEAR-DOCS documentation.

## Documentation

All documentation files are in the `references/` directory as Markdown files.
For legacy skills, documentation may live in `docs/`.

## Search Tool

```bash
# Run the search script (use python or python3)
python scripts/search_docs.py "<query>"
```

Options:
- `--json` - Output as JSON
- `--max-results N` - Limit results (default: 10)

## Usage

1. Search or read files in `references/` for relevant information (fallback to `docs/` for legacy)
2. Each file has frontmatter with `source_url` and `fetched_at`
3. Always cite the source URL in responses
4. Note the fetch date - documentation may have changed

## Response Format

```
[Answer based on documentation]

**Source:** [source_url]
**Fetched:** [fetched_at]
```
