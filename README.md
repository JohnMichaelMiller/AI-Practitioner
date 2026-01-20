# AI-Practitioner

jMM's AI Practitioner Blog

## Maintaining the Blog

### Structure

- **jekyll-src/**: Jekyll source files (edit here)
  - `_posts/`: Blog posts in Markdown format
  - `_config.yml`: Site configuration
  - `index.md`, `about.md`: Page content
- **docs/**: Generated static HTML (served via GitHub Pages)

### Creating a New Post

1. Create a new Markdown file in `jekyll-src/_posts/` with the naming format:

   ```
   YYYY-MM-DD-your-post-title.md
   ```

2. Add front matter at the top of the file:

   ```yaml
   ---
   layout: post
   title: "Your Post Title"
   date: YYYY-MM-DD HH:MM:SS +0000
   categories: [category1, category2]
   ---
   ```

3. Write your content in Markdown below the front matter.

### Building the Site

1. Navigate to the Jekyll source directory:

   ```powershell
   cd jekyll-src
   ```

2. Install dependencies (first time only):

   ```powershell
   bundle install
   ```

3. Build the site:

   ```powershell
   bundle exec jekyll build --destination ../docs
   ```

4. Preview locally (optional):
   ```powershell
   bundle exec jekyll serve
   ```
   Visit http://localhost:4000 in your browser.

### Publishing Changes

1. Build the site using the command above
2. Commit both source and generated files:

   ```powershell
   git add jekyll-src/ docs/
   git commit -m "Add new post: [post title]"
   git push origin main
   ```

3. GitHub Pages will automatically serve the updated content from the `docs/` folder.

### Editing Existing Content

- **Posts**: Edit files in `jekyll-src/_posts/`
- **Pages**: Edit `index.md`, `about.md`, etc. in `jekyll-src/`
- **Styles**: Edit `jekyll-src/assets/css/style.css` (or theme-specific CSS)
- **Configuration**: Edit `jekyll-src/_config.yml`

After making changes, rebuild the site and commit both source and generated files.

### Tips

- Always edit source files in `jekyll-src/`, never directly in `docs/`
- Test locally before pushing to ensure everything looks correct
- Keep the Jekyll version and dependencies up to date with `bundle update`
