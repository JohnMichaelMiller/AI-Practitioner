# Enhanced SSH Agent Setup for Windows Git Integration

Write-Host "Setting up SSH environment for Git..." -ForegroundColor Green

# Kill any existing SSH agent processes to start fresh
Get-Process ssh-agent -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# Start a new SSH agent and capture the environment variables
$sshAgentOutput = & ssh-agent -c | ForEach-Object { $_ -replace 'setenv ', '' -replace ';', '' }

# Parse and set environment variables
foreach ($line in $sshAgentOutput) {
    if ($line -match '(\w+)\s+(.+)') {
        $varName = $matches[1]
        $varValue = $matches[2]
        Set-Item -Path "env:$varName" -Value $varValue
        Write-Host "Set environment variable: $varName = $varValue" -ForegroundColor Yellow
    }
}

# Verify environment is set
if ($env:SSH_AUTH_SOCK) {
    Write-Host "SSH_AUTH_SOCK is set to: $env:SSH_AUTH_SOCK" -ForegroundColor Green

    # Add SSH key
    Write-Host "Adding SSH key..." -ForegroundColor Yellow
    ssh-add "C:\Users\JohnM\.ssh\id_ed25519"

    if ($LASTEXITCODE -eq 0) {
        Write-Host "SSH key added successfully!" -ForegroundColor Green

        # Test connection
        Write-Host "Testing Git connection..." -ForegroundColor Yellow
        git ls-remote origin | Out-Host
    }
} else {
    Write-Host "Failed to set up SSH agent environment" -ForegroundColor Red
}
