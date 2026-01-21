# Move Blog Post

## Parameters

Provide values for the following (defaults shown):

- **Slug** (default: WTBD):
- **Source File** (default: "C:\git\blogs\{Slug}\{Slug}.md"):
- **Date** (default: 2025-12-01):
- **Title** (default: What's the Big Deal?):

Target: jekyll-src_posts\{Date}-{Slug}.md

## Tasks

1. Copy source file into workspace if outside workspace (use PowerShell Copy-Item)
2. Copy source file to target with date prefix
3. Replace: `john.miller@codemag.com` → `AIP@pdata.com`
4. Add YAML front matter:
   ```yaml
   layout: post
   title: { Title }
   date: { Date }
   categories: [infer from content]
   ```
5. Replace: `<small><small><small>…</small></small></small>` → `<small><small><small>Original [post](https://www.codemag.com/blog/AIPractitioner/{Slug})</small></small></small>`
6. Convert HTML images to Markdown:
   - Extract filename from src, replace `_` with `-`
   - Path: `../assets/images/{Date}/`
   - If missing: copy from source folder
   - Use alt text as caption
