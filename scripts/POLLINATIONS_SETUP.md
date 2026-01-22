# Pollinations API Setup

## Quick Setup

To avoid rate limits, set your Pollinations API key before running the image generation script.

**Note:** You need to obtain your own API key from [Pollinations.ai](https://pollinations.ai). Visit their website to sign up and get your API key.

### Option 1: Set for Current PowerShell Session

```powershell
$env:POLLINATIONS_API_KEY = "your-api-key-here"
```

### Option 2: Set Permanently for Your User Account

```powershell
[System.Environment]::SetEnvironmentVariable('POLLINATIONS_API_KEY', 'your-api-key-here', 'User')
```

**Note:** After setting permanently, you must **restart PowerShell** or **restart VS Code** for the change to take effect.

### Option 3: Pass as Command Parameter

```powershell
.\generate-post-images.ps1 -ApiKey $env:POLLINATIONS_API_KEY -OverwriteExisting
```

## Running the Script

Once the API key is set:

```powershell
cd scripts
.\generate-post-images.ps1 -OverwriteExisting
```

## Verification

To verify your API key is set correctly:

```powershell
if ($env:POLLINATIONS_API_KEY) {
    Write-Host "✓ API Key is set" -ForegroundColor Green
} else {
    Write-Host "✗ API Key is NOT set" -ForegroundColor Red
}
```

## Troubleshooting

### Still seeing "Anonymous - Rate Limited"?

1. **Restart your terminal/VS Code** if you used Option 2
2. Use **Option 3** (command parameter) as a temporary workaround
3. Check if the key is visible: `$env:POLLINATIONS_API_KEY`

### Timeout Errors?

The script has retry logic built-in with progressive timeouts:

- First attempt: 15 seconds
- Retry 1: 25 seconds
- Retry 2: 35 seconds

Images typically take 15-35 seconds to generate. The script will retry up to 3 times automatically.
