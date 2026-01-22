# Blog Scripts

## Image Generation Script

### generate-post-images.ps1

Automatically generates AI-powered header images for blog posts using Pollinations.ai's free service.

**Features:**
- ✅ **100% Free** - No API keys required (anonymous usage supported)
- ✅ **Optional Authentication** - Set `POLLINATIONS_API_KEY` for higher rate limits
- ✅ **High quality** - Generates professional tech-themed images
- ✅ **Automatic** - Reads categories from post metadata
- ✅ **Smart** - Skips posts that already have images

---

## generate-post-images.ps1

Automatically generates AI-powered header images using Pollinations.ai's free service.

### Prerequisites

- **PowerShell**: Windows PowerShell or PowerShell Core
- **Internet connection**: That's it! No API keys needed.

### Usage

#### Generate images for all posts:

```powershell
cd scripts
.\generate-post-images.ps1
```

#### Dry run (preview without generating):

```powershell
.\generate-post-images.ps1 -DryRun
```

#### Regenerate existing images:

```powershell
.\generate-post-images.ps1 -OverwriteExisting
```

#### Use with API key (optional, for higher rate limits):

```powershell
# Set environment variable
$env:POLLINATIONS_API_KEY = "your-api-key-here"
.\generate-post-images.ps1

# Or pass directly
.\generate-post-images.ps1 -ApiKey "your-api-key-here"
```

### Features

- ✅ **100% Free** - No API keys required for basic usage
- ✅ **Optional Authentication** - Use API key for higher rate limits
- ✅ **High quality** - Generates professional tech-themed images  
- ✅ **Automatic** - Reads categories from post metadata
- ✅ **Smart** - Skips posts that already have images
- ⚠️ **Rate limited** - 3-second delay between requests (anonymous mode)

### How It Works

1. Reads post categories from YAML front matter
2. Generates an optimized prompt
3. Creates image via Pollinations.ai API
4. Downloads to `assets/images/YYYY-MM-DD/header-[slug].jpg`
5. Adds reference to post markdown

### Image Naming Convention

Images are saved as: `assets/images/YYYY-MM-DD/header-[post-slug].jpg`

Example:

- Post: `2024-11-11-UPGHC.md`
- Image: `assets/images/2024-11-11/header-UPGHC.jpg`
- Reference in post: `![Header Image](/assets/images/2024-11-11/header-UPGHC.jpg)`

### Customizing Image Style

To change the image style, edit the `Get-ImagePrompt` function in the script. Current style:

- Modern, professional tech design
- Minimalist with subtle gradients
- Blue/purple/teal color scheme
- No text overlay
- Wide banner format

### Troubleshooting

**Images are identical / "WE HAVE MOVED" error**

- This was a known issue with the old API endpoint (now fixed)
- The script now uses the correct Pollinations endpoint without query parameters

**Slow image generation**

- Images take 15-35 seconds to generate (this is normal)
- The script waits appropriately and retries if needed

**Categories not parsing correctly**

- The script supports both inline arrays: `categories: [item1, item2]`
- And multi-line arrays:
  ```yaml
  categories:
    [
      item1,
      item2
    ]
  ```

### Examples

Generate images for all posts (preview first):

```powershell
# See what would happen
.\generate-post-images.ps1 -DryRun

# Actually generate
.\generate-post-images.ps1

# Rebuild site
cd ..\jekyll-src
bundle exec jekyll build --destination ..\docs
```

Regenerate a specific post's image:

```powershell
# Delete the existing image first
Remove-Item ..\jekyll-src\assets\images\2024-11-11\header-UPGHC.jpg

# Regenerate
.\generate-post-images.ps1
```

### After Running

1. Review the generated images in `jekyll-src/assets/images/`
2. Rebuild your Jekyll site:
   ```powershell
   cd jekyll-src
   bundle exec jekyll build --destination ../docs
   ```
3. Commit the changes:
   ```powershell
   git add jekyll-src/ docs/
   git commit -m "Add AI-generated header images to blog posts"
   git push
   ```

---

## Legacy Information

Previously, this directory contained two scripts: `generate-post-images-free.ps1` (using Pollinations) and a paid version using OpenAI's DALL-E. The scripts have been consolidated into a single free solution using Pollinations.ai.
