# Generate AI images for blog posts based on their categories
# Uses Pollinations.ai
# Set POLLINATIONS_API_KEY environment variable or use -ApiKey parameter for authenticated access

param(
    [string]$PostsPath = "..\jekyll-src\_posts",
    [string]$AssetsPath = "..\jekyll-src\assets\images",
    [string]$ImageWidth = 1200,
    [string]$ImageHeight = 200,
    [string]$ApiKey = "",
    [switch]$DryRun,
    [switch]$OverwriteExisting
)

# Get absolute paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PostsPath = Join-Path $ScriptDir $PostsPath | Resolve-Path
$AssetsBasePath = Join-Path $ScriptDir $AssetsPath | Resolve-Path

# Check for API key from environment if not provided
if ([string]::IsNullOrEmpty($ApiKey)) {
    $ApiKey = $env:POLLINATIONS_API_KEY
}

$hasApiKey = -not [string]::IsNullOrEmpty($ApiKey)

Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "AI Blog Post Image Generator" -ForegroundColor Cyan
if ($hasApiKey) {
    Write-Host "Using: Pollinations.ai (Authenticated)" -ForegroundColor Green
}
else {
    Write-Host "Using: Pollinations.ai (Anonymous - Rate Limited)" -ForegroundColor Yellow
}
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "Posts directory: $PostsPath" -ForegroundColor Gray
Write-Host "Assets directory: $AssetsBasePath" -ForegroundColor Gray
Write-Host ""

# Function to extract front matter from markdown file
function Get-FrontMatter {
    param([string]$FilePath)

    $content = Get-Content $FilePath -Raw
    if ($content -match '(?s)^---\s*\n(.*?)\n---') {
        return $matches[1]
    }
    return $null
}

# Function to parse YAML-like front matter
function Parse-FrontMatter {
    param([string]$FrontMatter)

    $result = @{}
    $lines = $FrontMatter -split "`n"
    $i = 0

    while ($i -lt $lines.Count) {
        $line = $lines[$i]

        # Match key: value pattern
        if ($line -match '^(\w+):\s*(.*)$') {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()

            # Handle inline array format [item1, item2, item3]
            if ($value -match '^\[(.*)\]$') {
                $items = $matches[1] -split ',' | ForEach-Object { $_.Trim().Trim('"').Trim("'") }
                $result[$key] = $items
            }
            # Handle multi-line array format that starts with [
            elseif ($value -eq '[' -or $value -eq '') {
                # Look ahead for array items
                $arrayItems = @()
                $i++

                # Continue reading lines until we find the closing bracket or end
                while ($i -lt $lines.Count) {
                    $arrayLine = $lines[$i].Trim()

                    # Skip empty lines
                    if ([string]::IsNullOrWhiteSpace($arrayLine)) {
                        $i++
                        continue
                    }

                    # Check if this is the closing bracket
                    if ($arrayLine -eq ']') {
                        break
                    }

                    # Check if line contains opening bracket (multi-line format)
                    if ($arrayLine -eq '[') {
                        $i++
                        continue
                    }

                    # Extract array item (remove trailing comma)
                    $item = $arrayLine.TrimEnd(',').Trim().Trim('"').Trim("'")
                    if (-not [string]::IsNullOrWhiteSpace($item)) {
                        $arrayItems += $item
                    }

                    $i++
                }

                $result[$key] = $arrayItems
            }
            # Handle simple string value
            else {
                $result[$key] = $value.Trim('"').Trim("'")
            }
        }

        $i++
    }

    return $result
}

# Function to generate image prompt from categories
function Get-ImagePrompt {
    param([array]$Categories, [string]$Title)

    $categoryText = if ($Categories -and $Categories.Count -gt 0) {
        $Categories -join ", "
    }
    else {
        "technology, software development"
    }

    # Extract significant words from title (remove common words)
    $commonWords = @("a", "an", "and", "are", "as", "at", "be", "by", "for", "from", "has", "he", "in", "is", "it", "its", "of", "on", "that", "the", "to", "was", "will", "with", "how", "what", "when", "where", "why", "your", "you")
    $titleWords = if ($Title) {
        ($Title -split '\s+' | Where-Object { $_.Length -gt 2 -and $_ -notin $commonWords }) -join " "
    }
    else {
        ""
    }

    # Create theme-based visual descriptors from categories
    $visualTheme = if ($Categories -and $Categories.Count -gt 0) {
        $themeWords = @()
        foreach ($cat in $Categories) {
            switch -Regex ($cat) {
                'ai|artificial|intelligence|machine|learning' { $themeWords += 'neural network patterns, interconnected nodes, data flow visualization' }
                'github|git|copilot|code|programming|development' { $themeWords += 'code-inspired geometric lines, digital connectivity, circuit board aesthetics' }
                'test|testing|automation' { $themeWords += 'structured grids, precision geometry, systematic patterns' }
                'ui|user.*interface|design|ux' { $themeWords += 'smooth flowing curves, interface-inspired layers, interactive elements' }
                'productivity|workflow|devops' { $themeWords += 'dynamic arrows, process flow, efficiency symbols' }
                'dependency|architecture|software.*engineering' { $themeWords += 'modular blocks, architectural structures, connected components' }
                'blog|writing|content' { $themeWords += 'flowing typography-inspired shapes, editorial layout elements' }
                default { $themeWords += 'tech-inspired geometric forms, modern digital elements' }
            }
        }
        ($themeWords | Select-Object -Unique | Select-Object -First 3) -join ', '
    }
    else {
        'tech-inspired geometric forms, modern digital elements, flowing data streams'
    }

    $prompt = "Abstract geometric art composition with $visualTheme, flowing gradient waves from blue to purple to teal, floating 3D crystalline shapes, minimalist aesthetic, depth of field bokeh, smooth color transitions, modern digital artwork, wide panoramic banner"

    return $prompt
}

# Function to generate image using Pollinations.ai
function New-AIImage {
    param(
        [string]$Prompt,
        [int]$Width = 1200,
        [int]$Height = 200,
        [string]$Model = "flux",
        [string]$ApiKey = ""
    )

    try {
        # Generate a truly random seed to ensure unique images
        $seed = Get-Random -Minimum 1 -Maximum 2147483647

        # Add timestamp to ensure uniqueness
        $timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()

        # Add a unique identifier to the prompt to prevent caching
        $uniquePrompt = "$Prompt [unique-$timestamp]"

        # Pollinations.ai CURRENT WORKING endpoint (as of Jan 2026)
        # DO NOT add width/height/seed/model params - they trigger the "moved" error image
        # The API generates images at default size then we can resize if needed
        $baseUrl = "https://image.pollinations.ai/prompt"

        # URL encode the prompt - NO query parameters to avoid "moved" error
        $encodedPrompt = [System.Web.HttpUtility]::UrlEncode($uniquePrompt)
        $url = "$baseUrl/$encodedPrompt"
        Write-Host "    Seed: $seed" -ForegroundColor DarkGray
        Write-Host "    Timestamp: $timestamp" -ForegroundColor DarkGray
        Write-Host "    Unique Prompt: $uniquePrompt" -ForegroundColor DarkGray

        return $url
    }
    catch {
        Write-Error "Failed to generate image URL: $_"
        return $null
    }
}

# Function to download image
function Save-ImageFromUrl {
    param(
        [string]$Url,
        [string]$OutputPath,
        [string]$ApiKey = "",
        [int]$MaxRetries = 3
    )

    $retryCount = 0
    $success = $false

    while (-not $success -and $retryCount -lt $MaxRetries) {
        try {
            if ($retryCount -gt 0) {
                Write-Host "    Retry attempt $retryCount of $MaxRetries..." -ForegroundColor Yellow
            }

            # Use Invoke-WebRequest with proper headers and wait longer for generation
            # Pollinations API needs time to generate - minimum 15 seconds
            $waitTime = 15 + ($retryCount * 10)  # Increase wait time on retries: 15s, 25s, 35s
            Write-Host "    Waiting for image generation ($waitTime seconds)..." -ForegroundColor Gray
            Start-Sleep -Seconds $waitTime

            $headers = @{
                "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
                "Accept"     = "image/png,image/webp,image/*,*/*"
            }

            # Add API key header if provided (alternative to query param)
            if (-not [string]::IsNullOrEmpty($ApiKey)) {
                $headers["X-API-Key"] = $ApiKey
            }

            $timeout = 90 + ($retryCount * 30)  # Increase timeout on retries
            $response = Invoke-WebRequest -Uri $Url -OutFile $OutputPath -UseBasicParsing -TimeoutSec $timeout -Headers $headers

            # Verify file was created and has content (valid images should be > 10KB for 1200x200)
            if (Test-Path $OutputPath) {
                $fileSize = (Get-Item $OutputPath).Length
                Write-Host "    Downloaded file size: $fileSize bytes" -ForegroundColor Gray

                # Check if file is actually an image by reading header
                $bytes = [System.IO.File]::ReadAllBytes($OutputPath)
                if ($bytes.Length -gt 8) {
                    # Check for PNG signature (89 50 4E 47)
                    $isPNG = ($bytes[0] -eq 0x89) -and ($bytes[1] -eq 0x50) -and ($bytes[2] -eq 0x4E) -and ($bytes[3] -eq 0x47)
                    # Check for JPEG signature (FF D8 FF)
                    $isJPEG = ($bytes[0] -eq 0xFF) -and ($bytes[1] -eq 0xD8) -and ($bytes[2] -eq 0xFF)

                    if (($isPNG -or $isJPEG) -and $fileSize -gt 10000) {
                        $format = if ($isPNG) { "PNG" } else { "JPEG" }
                        Write-Host "    Valid $format image confirmed" -ForegroundColor Green
                        $success = $true
                        return $true
                    }
                    else {
                        Write-Warning "    File is not a valid image or too small ($fileSize bytes)"
                        # Delete invalid file
                        Remove-Item $OutputPath -Force -ErrorAction SilentlyContinue
                        $retryCount++
                    }
                }
            }
            else {
                $retryCount++
            }
        }
        catch {
            Write-Warning "Failed to download image (attempt $($retryCount + 1)): $_"
            if (Test-Path $OutputPath) {
                Remove-Item $OutputPath -Force -ErrorAction SilentlyContinue
            }
            $retryCount++
        }
    }

    if (-not $success) {
        Write-Error "Failed to download image after $MaxRetries attempts"
    }
    return $success
}

# Function to check if post already has an image
function Test-PostHasImage {
    param([string]$FilePath, [string]$ImagePath)

    $content = Get-Content $FilePath -Raw
    $relativePath = $ImagePath -replace '\\', '/'
    return $content -match [regex]::Escape($relativePath)
}

# Function to add image to post
function Add-ImageToPost {
    param(
        [string]$FilePath,
        [string]$ImageRelativePath
    )

    $content = Get-Content $FilePath -Raw

    # Check if image is already in the post
    $imageMarkdown = "![Header Image]($ImageRelativePath)"
    if ($content -match [regex]::Escape($imageMarkdown)) {
        Write-Host "    Image already exists in post, skipping insertion" -ForegroundColor Gray
        return $true
    }

    # Find the end of front matter and beginning of content
    if ($content -match '(?s)(^---.*?---\s*\n)(.*)') {
        $frontMatter = $matches[1]
        $postContent = $matches[2]

        # Add image before the first heading or at the start of content
        $imageMarkdownWithNewlines = "$imageMarkdown`n`n"
        $newContent = $frontMatter + $imageMarkdownWithNewlines + $postContent

        Set-Content -Path $FilePath -Value $newContent -NoNewline
        return $true
    }

    return $false
}

# Load System.Web for URL encoding
Add-Type -AssemblyName System.Web

# Main processing
$posts = Get-ChildItem -Path $PostsPath -Filter "*.md"
$processedCount = 0
$skippedCount = 0
$errorCount = 0

foreach ($post in $posts) {
    Write-Host "Processing: $($post.Name)" -ForegroundColor Yellow

    # Extract date from filename (YYYY-MM-DD format)
    if ($post.Name -match '^(\d{4})-(\d{2})-(\d{2})-(.+)\.md$') {
        $year = $matches[1]
        $month = $matches[2]
        $day = $matches[3]
        $slug = $matches[4]

        # Create image directory path
        $imageDir = Join-Path $AssetsBasePath "$year-$month-$day"
        if (-not (Test-Path $imageDir)) {
            New-Item -ItemType Directory -Path $imageDir -Force | Out-Null
            Write-Host "  Created directory: $imageDir" -ForegroundColor Green
        }

        # Define image filename and paths
        $imageFilename = "header-$slug.jpg"
        $imageFullPath = Join-Path $imageDir $imageFilename
        $imageRelativePath = "/assets/images/$year-$month-$day/$imageFilename"

        # Check if image already exists
        if ((Test-Path $imageFullPath) -and -not $OverwriteExisting) {
            Write-Host "  Image already exists, skipping..." -ForegroundColor Gray
            $skippedCount++
            continue
        }

        # Check if post already references an image
        if ((Test-PostHasImage -FilePath $post.FullName -ImagePath $imageRelativePath) -and -not $OverwriteExisting) {
            Write-Host "  Post already has this image reference, skipping..." -ForegroundColor Gray
            $skippedCount++
            continue
        }

        # Parse front matter
        $frontMatterText = Get-FrontMatter -FilePath $post.FullName
        if (-not $frontMatterText) {
            Write-Warning "  Could not extract front matter, skipping..."
            $errorCount++
            continue
        }

        $frontMatter = Parse-FrontMatter -FrontMatter $frontMatterText
        $categories = $frontMatter['categories']
        $title = $frontMatter['title']

        Write-Host "  Title: $title" -ForegroundColor Cyan
        Write-Host "  Categories: $($categories -join ', ')" -ForegroundColor Cyan

        # Generate prompt
        $prompt = Get-ImagePrompt -Categories $categories -Title $title
        Write-Host "  Prompt: $prompt" -ForegroundColor DarkGray

        if ($DryRun) {
            Write-Host "  [DRY RUN] Would generate image and save to: $imageFullPath" -ForegroundColor Magenta
            $processedCount++
            continue
        }

        # Generate image URL
        Write-Host "  Generating image..." -ForegroundColor Yellow
        $imageUrl = New-AIImage -Prompt $prompt -Width $ImageWidth -Height $ImageHeight -ApiKey $ApiKey

        if (-not $imageUrl) {
            Write-Error "  Failed to generate image URL"
            $errorCount++
            continue
        }

        Write-Host "  Downloading image..." -ForegroundColor Yellow
        if (Save-ImageFromUrl -Url $imageUrl -OutputPath $imageFullPath -ApiKey $ApiKey) {
            Write-Host "  Image saved: $imageFullPath" -ForegroundColor Green

            # Add image to post
            Write-Host "  Adding image to post..." -ForegroundColor Yellow
            if (Add-ImageToPost -FilePath $post.FullName -ImageRelativePath $imageRelativePath) {
                Write-Host "  Post updated successfully!" -ForegroundColor Green
                $processedCount++
            }
            else {
                Write-Warning "  Failed to update post content"
                $errorCount++
            }
        }
        else {
            Write-Error "  Failed to download or verify image"
            $errorCount++
        }

        # Rate limiting - be nice to the free API
        Write-Host "  Waiting 3 seconds before next request..." -ForegroundColor Gray
        Start-Sleep -Seconds 3
    }
    else {
        Write-Warning "  Filename doesn't match expected format, skipping..."
        $errorCount++
    }

    Write-Host ""
}

# Summary
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Processed: $processedCount" -ForegroundColor Green
Write-Host "  Skipped: $skippedCount" -ForegroundColor Yellow
Write-Host "  Errors: $errorCount" -ForegroundColor Red
Write-Host "=" * 60 -ForegroundColor Cyan

if (-not $DryRun -and $processedCount -gt 0) {
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Review generated images in: $AssetsBasePath" -ForegroundColor White
    Write-Host "  2. Rebuild Jekyll site:" -ForegroundColor White
    Write-Host "     cd jekyll-src" -ForegroundColor Gray
    Write-Host "     bundle exec jekyll build --destination ../docs" -ForegroundColor Gray
    Write-Host "  3. Commit and push changes" -ForegroundColor White
}
