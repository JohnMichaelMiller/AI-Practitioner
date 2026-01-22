# SSH Agent Setup Script for Windows
# This script ensures SSH agent is running and keys are loaded

param(
    [switch]$Force
)

Write-Host "Setting up SSH Agent..." -ForegroundColor Green

# Ensure SSH Agent service is running
$service = Get-Service ssh-agent
if ($service.Status -ne 'Running') {
    Write-Host "Starting SSH Agent service..." -ForegroundColor Yellow
    Start-Service ssh-agent
}

# Check if key is already loaded (unless Force is specified)
if (-not $Force) {
    $keyLoaded = ssh-add -l 2>$null | Select-String "id_ed25519"
    if ($keyLoaded) {
        Write-Host "SSH key already loaded in agent" -ForegroundColor Green
        exit 0
    }
}

# Add SSH key
Write-Host "Adding SSH key to agent..." -ForegroundColor Yellow
ssh-add "C:\Users\JohnM\.ssh\id_ed25519"

if ($LASTEXITCODE -eq 0) {
    Write-Host "SSH key successfully added to agent!" -ForegroundColor Green
    Write-Host "You should now be able to use Git without repeated passphrase prompts" -ForegroundColor Cyan
}
else {
    Write-Host "Failed to add SSH key to agent" -ForegroundColor Red
    exit 1
}

# Test connection
Write-Host "`nTesting SSH connection to GitHub..." -ForegroundColor Yellow
ssh -T git@github.com 2>&1 | Out-Host

Write-Host "`nSSH setup complete!" -ForegroundColor Green
Write-Host "Tip: Run this script again with -Force to reload your key" -ForegroundColor Cyan
