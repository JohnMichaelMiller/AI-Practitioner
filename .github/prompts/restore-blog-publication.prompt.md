---
mode: agent
model: "anthropic/claude-3.5-sonnet@2024-10-22"
tools: ["read", "create", "edit"]
description: Restore CODE Magazine posts back to AI Practitioner blog format by reversing URL and email transformations, appending -CODE to filename
prompt_metadata:
  id: restore-blog-publication
  title: AI Practitioner Blog Restoration
  owner: john.miller@codemag.com
  version: 1.0.0
  created: 2026-02-03
  updated: 2026-02-03
  output_path: jekyll-src/_posts/
  output_format: markdown
  category: content-preparation
  tags: [publication, content-transformation, blog-restoration, url-replacement]
---

# AI Practitioner Blog Restoration

Restore CODE Magazine published posts back to AI Practitioner blog format by reversing URL and email transformations and organizing files in the jekyll-src/\_posts/ folder structure with -CODE appended to the filename.

## Context

Posts prepared for CODE Magazine publication at www.codemag.com/blog/AIPractitioner/ need to be restored to their original AI Practitioner blog format at blog.pdata.com. This reverse transformation maintains content integrity while restoring original branding and contact information for the blog.pdata.com audience. The restored file is saved with -CODE appended to preserve both versions.

## Target Audience

- Blog post authors maintaining original blog content
- Content management workflow automation
- Editorial team syncing content between platforms

## Requirements

### URL Transformation

- Replace all instances of `www.codemag.com/blog/AIPractitioner/` with `blog.pdata.com/`
- Maintain relative paths and anchors in URL structure
- Preserve link functionality and accessibility

### Email Address Updates

- Replace all instances of `john.miller@codemag.com` with `AIP@pdata.com`
- Update contact information throughout the post
- Maintain professional communication channels

### File Organization

- Create a copy of the CODE post in the jekyll-src/\_posts/ folder
- Append -CODE before the file extension (e.g., 2026-01-26-AIAGSD4.md → 2026-01-26-AIAGSD4-CODE.md)
- Maintain markdown formatting and front matter

### Content Restoration

- Keep all content, formatting, and structure
- Preserve code blocks, tables, and lists
- Maintain image references and assets
- Keep front matter metadata intact
- Restore the main H1 heading (single #) at the beginning of content body if missing

## Technical Requirements

### Input Processing

- Accept source post file path as parameter (from CODE folder)
- Read complete file content including front matter
- Parse and identify all URL and email instances

### Transformation Rules

1. **URL Pattern Matching**: Identify `www.codemag.com/blog/AIPractitioner/` in:
   - Inline links: `[text](www.codemag.com/blog/AIPractitioner/...)`
   - Reference links: `[ref]: www.codemag.com/blog/AIPractitioner/...`
   - Plain URLs in text
   - HTML anchor tags

2. **Email Pattern Matching**: Identify `john.miller@codemag.com` in:
   - Plain text mentions
   - Mailto links: `mailto:john.miller@codemag.com`
   - Contact sections

3. **Replacement Strategy**:
   - Perform case-sensitive exact matching
   - Replace complete URL paths
   - Maintain URL structure and parameters

### File Operations

- Ensure jekyll-src/\_posts/ folder exists
- Extract base filename and extension
- Append -CODE before the extension
- Copy transformed content to jekyll-src/\_posts/{base-filename}-CODE.{extension}
- Preserve file permissions and timestamps
- Handle duplicate filename conflicts

## Output Format

The output should be a restored markdown file with:

### Front Matter

```yaml
---
layout: post
title: "[Original Title]"
date: [Original Date]
categories: [Original Categories]
image: [Original Image]
---
```

### Content Structure

- Main H1 heading restored at beginning if missing
- Original heading hierarchy maintained
- All URLs updated to blog.pdata.com format
- All email addresses updated to AIP@pdata.com
- Links tested for functionality
- Formatting preserved exactly

## Quality Standards

### Validation Checks

- [ ] All `www.codemag.com/blog/AIPractitioner/` instances replaced
- [ ] All `john.miller@codemag.com` instances replaced
- [ ] No broken link references
- [ ] Front matter preserved correctly
- [ ] Main H1 heading restored if missing
- [ ] Filename correctly appended with -CODE

### Content Integrity

- [ ] No content loss during transformation
- [ ] Code blocks remain intact
- [ ] Tables and lists properly formatted
- [ ] Image references functional
- [ ] Cross-references updated appropriately

## Usage Example

To restore a CODE Magazine post back to blog format, submit this prompt with the specific file you want to convert:

### Example Submission

```
@.github/prompts/restore-blog-publication.prompt.md

Please restore the CODE Magazine post from CODE/2026-01-26-AIAGSD4.md back to blog format.
```

### What This Does

1. Reads `CODE/2026-01-26-AIAGSD4.md`
2. Replaces all CODE Magazine URLs with blog.pdata.com URLs
3. Replaces john.miller@codemag.com with AIP@pdata.com
4. Restores the main H1 heading if it was removed
5. Saves the result as `jekyll-src/_posts/2026-01-26-AIAGSD4-CODE.md`
6. Reports statistics on changes made

### Alternative: Restore All Files

```
@.github/prompts/restore-blog-publication.prompt.md

Restore all CODE Magazine posts from the CODE/ folder back to blog format.
```

This will process all .md files in the CODE/ folder and create corresponding -CODE versions in jekyll-src/\_posts/.

## Deliverable

Transform the specified CODE Magazine post by:

1. Reading the complete source file from CODE/
2. Performing URL and email replacements as specified
3. Restoring the main H1 heading at the beginning of content if missing
4. Creating the transformed file in jekyll-src/\_posts/ with -CODE appended to filename
5. Validating all transformations completed successfully
6. Reporting transformation statistics (URLs changed, emails updated, H1 restored, filename)

**Expected Output**: A blog-ready markdown file in jekyll-src/\_posts/ with -CODE appended to the filename and all necessary transformations applied while preserving content quality and formatting.
