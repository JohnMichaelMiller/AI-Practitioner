# Script to add image field to Jekyll post front matter
param(
    [string]$PostsPath = "C:\git\ai-practitioner\ai-practitioner-blog\jekyll-src\_posts"
)

$posts = Get-ChildItem -Path $PostsPath -Filter "*.md"

foreach ($post in $posts) {
    Write-Host "Processing: $($post.Name)" -ForegroundColor Cyan

    # Extract the date and slug from filename (YYYY-MM-DD-SLUG.md)
    if ($post.Name -match '^(\d{4}-\d{2}-\d{2})-(.+)\.md$') {
        $date = $Matches[1]
        $slug = $Matches[2]
        $imagePath = "/assets/images/$date/header-$slug.jpg"

        # Read the file content
        $lines = Get-Content $post.FullName

        # Find the front matter section
        $inFrontMatter = $false
        $frontMatterEndLine = -1
        $hasImageField = $false

        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -eq '---') {
                if (-not $inFrontMatter) {
                    $inFrontMatter = $true
                }
                else {
                    $frontMatterEndLine = $i
                    break
                }
            }
            elseif ($inFrontMatter -and $lines[$i] -match '^image:') {
                $hasImageField = $true
                break
            }
        }

        if ($hasImageField) {
            Write-Host "  Skipped (already has image field)" -ForegroundColor Yellow
            continue
        }

        if ($frontMatterEndLine -gt 0) {
            # Insert the image field before the closing ---
            $newLines = @()
            $newLines += $lines[0..($frontMatterEndLine - 1)]
            $newLines += "image: $imagePath"
            $newLines += $lines[$frontMatterEndLine..($lines.Count - 1)]

            # Write back to file
            $newLines | Set-Content -Path $post.FullName -Encoding UTF8
            Write-Host "  Added image field: $imagePath" -ForegroundColor Green
        }
        else {
            Write-Host "  ERROR: Could not find front matter end marker" -ForegroundColor Red
        }
    }
    else {
        Write-Host "  ERROR: Filename does not match expected pattern" -ForegroundColor Red
    }
}

Write-Host "`nDone!" -ForegroundColor Green
