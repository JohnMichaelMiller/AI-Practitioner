---
mode: agent
model: "anthropic/claude-3.5-sonnet@2024-10-22"
tools: ["read", "create", "edit"]
description: Prepare blog posts for CODE Magazine publication by updating URLs, email addresses, and moving files to the CODE folder
prompt_metadata:
  id: prepare-code-publication
  title: CODE Magazine Publication Preparation
  owner: john.miller@codemag.com
  version: 1.0.0
  created: 2026-01-27
  updated: 2026-01-27
  output_path: CODE/
  output_format: markdown
  category: content-preparation
  tags: [publication, content-transformation, code-magazine, url-replacement]
---

# CODE Magazine Publication Preparation

Prepare AI Practitioner blog posts for publication in CODE Magazine by updating URLs, email addresses, and organizing files in the CODE folder structure.

## Context

The AI Practitioner blog posts are originally published at blog.pdata.com and need to be adapted for CODE Magazine publication at www.codemag.com/blog/AIPractitioner/. This transformation maintains content integrity while updating branding and contact information for the CODE Magazine audience.

## Target Audience

- Blog post authors preparing content for CODE Magazine
- Editorial team reviewing publication-ready content
- Content management workflow automation

## Requirements

### URL Transformation

- Replace all instances of `blog.pdata.com/` with `www.codemag.com/blog/AIPractitioner/`
- Maintain relative paths and anchors in URL structure
- Preserve link functionality and accessibility

### Email Address Updates

- Replace all instances of `AIP@pdata.com` with `john.miller@codemag.com`
- Update contact information throughout the post
- Maintain professional communication channels

### File Organization

- Create a copy of the source post in the CODE folder at repository root
- Preserve original filename structure
- Maintain markdown formatting and front matter

### Content Preservation

- Keep all original content, formatting, and structure
- Preserve code blocks, tables, and lists
- Maintain image references and assets
- Keep front matter metadata intact
- Remove the main H1 heading (single #) from the content body

## Technical Requirements

### Input Processing

- Accept source post file path as parameter
- Read complete file content including front matter
- Parse and identify all URL and email instances

### Transformation Rules

1. **URL Pattern Matching**: Identify `blog.pdata.com/` in:
   - Inline links: `[text](blog.pdata.com/...)`
   - Reference links: `[ref]: blog.pdata.com/...`
   - Plain URLs in text
   - HTML anchor tags

2. **Email Pattern Matching**: Identify `AIP@pdata.com` in:
   - Plain text mentions
   - Mailto links: `mailto:AIP@pdata.com`
   - Contact sections

3. **Replacement Strategy**:
   - Perform case-sensitive exact matching
   - Replace complete URL paths
   - Maintain URL structure and parameters

**Important**: Do not modify the original post file in the jekyll-src/_posts/ directory.

### File Operations

- Create CODE folder if it doesn't exist
- Copy transformed content to CODE/{original-filename}
- Preserve file permissions and timestamps
- Handle duplicate filename conflicts

## Output Format

The output should be a transformed markdown file with:

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

- Original heading hierarchy maintained
- All URLs updated to CODE Magazine format
- All email addresses updated to john.miller@codemag.com
- Links tested for functionality
- Formatting preserved exactly

## Quality Standards

### Validation Checks

- [ ] All `blog.pdata.com/` instances replaced
- [ ] All `AIP@pdata.com` instances replaced
- [ ] No broken link references
- [ ] Front matter preserved correctly
- [ ] Main H1 heading removed from content body

### Content Integrity

- [ ] No content loss during transformation
- [ ] Code blocks remain intact
- [ ] Tables and lists properly formatted
- [ ] Image references functional
- [ ] Cross-references updated appropriately

## Deliverable

Transform the specified blog post file by:

1. Reading the complete source file from jekyll-src/\_posts/
2. Performing URL and email replacements as specified
3. Removing the main H1 heading from the content body
4. Creating the transformed file in the CODE/ folder
5. Validating all transformations completed successfully
6. Reporting transformation statistics (URLs changed, emails updated, H1 removed)

**Expected Output**: A publication-ready markdown file in the CODE folder with all necessary transformations applied while preserving content quality and formatting.
