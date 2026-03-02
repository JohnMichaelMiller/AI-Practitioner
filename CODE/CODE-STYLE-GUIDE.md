# CODE Style Guide

This guide captures the writing and structure patterns so future CODE drafts stay consistent.

## 1) Post Skeleton

Use this baseline structure for long-form technical posts:

1. YAML front matter (`layout`, `title`, `date`, `categories`, `image`)
2. Series-context introduction (links to prior posts)
3. Problem framing section (`## Why ... Matters`). Make this section SEO friendly to improve discoverability by search engines
4. Prompt-driven workflow sections (prompt block + explanation)
5. Artifact deep dives (one subsection per generated file/instruction)
6. Spell out acronyms on first use.
7. Include links to original source websites.
8. Governance/validation checkpoint section
9. Forward-looking closing (`## What's Next?`)
10. Feedback + Disclaimer + Prompts log

## 2) Narrative Voice

- Write in first person singular for execution narrative ("I ran", "I submitted").
- Use first person plural when discussing team outcomes ("we can now").
- Keep tone implementation-focused, not promotional.
- Explain _why_ before _how_ when introducing each process.
- Follow AP Styleguide rules for sentence structure, headlines, lists style, punctuation conventions.
- Minimize passive voice
- For product and technology terms, follow the capitalization style used by the original source owner and spell out product names. For example, Microsoft Copilot, not CoPilot or co-pilot. GitHub not Github or github. ChatGPT not chatGPT or GPT.

## 3) Section Design Rules

- Prefer `##` for major phases and `###` for concrete artifacts/files.
- Section titles should be action-oriented, explicit and SEO friendly:
  - `## Updating the {product name} Project Overview to do {xyz}`
  - `## Executing the Technology Instructions Generation for {outcome}`
- An H2 heading should always have body copy that follows it before an H3. Do not have an H2 immediately followed by an H3.


## 4) Prompt Documentation Pattern

For each prompt execution, follow this exact rhythm:

1. One setup paragraph explaining intent.
2. A fenced code block containing the full prompt text (publish prompts as-is, including verbose or multi-turn iterations).
3. A short bullet list of what the prompt produces.
4. A paragraph connecting output to architecture/workflow impact.

## 5) Artifact Summary Pattern

When describing generated instruction files:

- Start with one high-signal thesis sentence.
- Add 1-2 supporting paragraphs covering:
  - enforced patterns,
  - anti-patterns,
  - validation/checklist behavior,
  - stack integration points.
- Include concrete framework/tool names and version expectations where known.

## 6) List and Table Conventions

- Use bullets for capability and output lists.
- Use numbered lists for sequential process execution.
- Use compact two-column tables (`File | Purpose`) for file inventories.
- Use bold lead-ins in bullets when category labels improve scanability.

## 7) Linking Conventions

- Link series references near the top of the post.
- Link repository artifacts by exact filename.
- Keep external links purposeful: documentation, generated artifacts, prior parts.
- Avoid redundant links to the same target within a short span.

## 8) Quality and Consistency Rules

- Keep terminology stable across the post (`instruction files`, `technology stack`, `CQRS`).
- Prefer parallel phrasing across sibling bullet lists.
- Keep paragraph length moderate; split long blocks when topic shifts.
- Avoid duplicated sections unless they add new depth.

## 9) Mechanics and Copyediting

Apply these corrections consistently:

- Use spaced em dash style in prose: `word — word` (or standard punctuation), avoid mashed hyphen joins like `code-ensuring`.
- Fix accidental capitalization drift (e.g., `Vision` mid-sentence).
- Keep technology names consistent (`lifecycle`, `re-renders`, `.NET 8+`).
- Ensure wildcard/glob examples render correctly in markdown code blocks.

## 10) Closing Block Standard

End posts with:

1. `## What's Next?` with a concrete preview of the next part.
2. `## Feedback Loop` with contact method.
3. `## Disclaimer` with human-review statement.
4. `Prompts:` log listing the prompt operations used to shape the draft (publish prompts as-is, including verbose or multi-turn iterations).

## 11) Reusable Authoring Checklist

Before finalizing a CODE post, verify:

- [ ] Intro links prior series parts.
- [ ] Every major prompt appears in a fenced code block.
- [ ] Output impact is explained after each prompt.
- [ ] Artifact summaries include standards + anti-patterns + integration points.
- [ ] At least one inventory table or structured list improves scanability.
- [ ] Governance/context-check section is present when instructions changed.
- [ ] "What's Next" aligns with the next actual post topic.
- [ ] Feedback/disclaimer/prompts footer is present and current.
