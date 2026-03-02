---
description: "Generate or revise a single technical blog section in AIAGSD style"
model: "anthropic/claude-3.5-sonnet@2024-10-22"
tools: ["read", "search", "edit"]
mode: agent
---

# Create Blog Section

Create or revise one section in a blog post for this repository, following the AIAGSD writing style.

## Inputs

Provide:

- `post_file`: Target markdown file path (for example: `jekyll-src/_posts/2026-03-01-AIAGSD6.md`)
- `section_title`: Section heading to create or update
- `objective`: What this section must accomplish
- `sources`: Optional list of files/URLs that must be reflected
- `constraints`: Optional boundaries (length, tone, exclusions)

## Required Workflow

1. Read the target post and locate the best insertion point for the section.
2. If `section_title` already exists, revise that section only unless told otherwise.
3. If it does not exist, insert the new section in the most logical position.
4. Ground claims in the provided `sources` (if any) and avoid unsupported assertions.
5. Keep language concise, implementation-focused, and consistent with adjacent content.

## Style Requirements

- Use first-person narrative where appropriate ("I'll", "we").
- Explain **why** before **how** when introducing a practice.
- Use short paragraphs and scannable bullets.
- Prefer concrete examples over generic guidance.
- Preserve existing markdown conventions in the target file.

## Output Requirements

When writing the section:

- Use a clear heading (`##` or `###`) that matches document hierarchy.
- Include actionable explanation and practical next-step guidance.
- Avoid adding unrelated sections or broad rewrites.
- Do not modify front matter unless explicitly requested.

After editing, provide:

- A brief summary of what changed.
- The file path edited.
- Any assumptions made due to missing context.

## Guardrails

- Do not fabricate file contents or source facts.
- Do not make legal/compliance approvals.
- Do not run shell commands unless explicitly requested.
- If requirements conflict, flag the conflict and apply the safer, narrower interpretation.
