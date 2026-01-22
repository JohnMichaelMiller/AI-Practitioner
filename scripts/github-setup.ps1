# GitHub Multi-Account Management Script
# This script helps manage SSH keys and test connections for multiple GitHub accounts

param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("show-keys", "test-connections", "setup-git-configs", "help")]
    [string]$Action = "help"
)

function Show-PublicKeys {
    Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                    GITHUB SSH PUBLIC KEYS                   ║" -ForegroundColor Green
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Green

    Write-Host "`n🔑 PERSONAL ACCOUNT (JohnMichaelMiller)" -ForegroundColor Cyan
    Write-Host "───────────────────────────────────────────────────────────" -ForegroundColor Gray
    Write-Host "Add this key to: https://github.com/settings/keys" -ForegroundColor Yellow
    Write-Host "Title: Windows PC - Personal Account" -ForegroundColor Yellow
    Write-Host ""
    if (Test-Path "~/.ssh/github_personal.pub") {
        Get-Content "~/.ssh/github_personal.pub" | Write-Host -ForegroundColor White
    }
    else {
        Write-Host "❌ Key file not found: ~/.ssh/github_personal.pub" -ForegroundColor Red
    }

    Write-Host "`n🔑 CODESTAFFING ACCOUNT (john.miller@codestaffing.com)" -ForegroundColor Cyan
    Write-Host "───────────────────────────────────────────────────────────" -ForegroundColor Gray
    Write-Host "Add this key to: https://github.com/settings/keys (logged in as john.miller@codestaffing.com)" -ForegroundColor Yellow
    Write-Host "Title: Windows PC - CodeStaffing" -ForegroundColor Yellow
    Write-Host ""
    if (Test-Path "~/.ssh/github_codestaffing.pub") {
        Get-Content "~/.ssh/github_codestaffing.pub" | Write-Host -ForegroundColor White
    }
    else {
        Write-Host "❌ Key file not found: ~/.ssh/github_codestaffing.pub" -ForegroundColor Red
    }

    Write-Host "`n🔑 CODEMAG ACCOUNT (johnmillerATcodemag-com)" -ForegroundColor Cyan
    Write-Host "───────────────────────────────────────────────────────────" -ForegroundColor Gray
    Write-Host "Add this key to: https://github.com/settings/keys (logged in as johnmillerATcodemag-com)" -ForegroundColor Yellow
    Write-Host "Title: Windows PC - CodeMag" -ForegroundColor Yellow
    Write-Host ""
    if (Test-Path "~/.ssh/github_work.pub") {
        Get-Content "~/.ssh/github_work.pub" | Write-Host -ForegroundColor White
    }
    else {
        Write-Host "❌ Key file not found: ~/.ssh/github_work.pub" -ForegroundColor Red
    }

    Write-Host "`n📋 INSTRUCTIONS:" -ForegroundColor Green
    Write-Host "1. Copy each public key above" -ForegroundColor White
    Write-Host "2. Open the GitHub settings link for each account" -ForegroundColor White
    Write-Host "3. Click 'New SSH key'" -ForegroundColor White
    Write-Host "4. Paste the key and use the suggested title" -ForegroundColor White
    Write-Host "5. Run this script with -Action test-connections to verify" -ForegroundColor White
}

function Test-Connections {
    Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                 TESTING GITHUB CONNECTIONS                  ║" -ForegroundColor Green
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Green

    # Test Personal Account
    Write-Host "`n🔍 Testing Personal Account (github.com)..." -ForegroundColor Yellow
    try {
        $result = ssh -o ConnectTimeout=10 -T git@github.com 2>&1
        if ($result -like "*successfully authenticated*") {
            Write-Host "✅ Personal Account: Connected successfully" -ForegroundColor Green
            Write-Host "   $result" -ForegroundColor Gray
        }
        else {
            Write-Host "❌ Personal Account: Connection failed" -ForegroundColor Red
            Write-Host "   $result" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "❌ Personal Account: Connection error" -ForegroundColor Red
    }

    # Test CodeStaffing Account
    Write-Host "`n🔍 Testing CodeStaffing Account (github-codestaffing)..." -ForegroundColor Yellow
    try {
        $result = ssh -o ConnectTimeout=10 -T git@github-codestaffing 2>&1
        if ($result -like "*successfully authenticated*") {
            Write-Host "✅ CodeStaffing Account: Connected successfully" -ForegroundColor Green
            Write-Host "   $result" -ForegroundColor Gray
        }
        else {
            Write-Host "❌ CodeStaffing Account: Connection failed" -ForegroundColor Red
            Write-Host "   $result" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "❌ CodeStaffing Account: Connection error" -ForegroundColor Red
    }

    # Test CodeMag Account
    Write-Host "`n🔍 Testing CodeMag Account (github-codemag)..." -ForegroundColor Yellow
    try {
        $result = ssh -o ConnectTimeout=10 -T git@github-codemag 2>&1
        if ($result -like "*successfully authenticated*") {
            Write-Host "✅ CodeMag Account: Connected successfully" -ForegroundColor Green
            Write-Host "   $result" -ForegroundColor Gray
        }
        else {
            Write-Host "❌ CodeMag Account: Connection failed" -ForegroundColor Red
            Write-Host "   $result" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "❌ CodeMag Account: Connection error" -ForegroundColor Red
    }

    Write-Host "`n📝 Next Steps:" -ForegroundColor Green
    Write-Host "• If connections failed, ensure public keys are added to GitHub accounts" -ForegroundColor White
    Write-Host "• Run: ./github-setup.ps1 -Action show-keys to see keys to add" -ForegroundColor White
}

function Setup-GitConfigs {
    Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                   SETUP GIT CONFIGURATIONS                  ║" -ForegroundColor Green
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Green

    # Check current directory and suggest appropriate git config
    $currentPath = Get-Location
    $repoName = Split-Path -Leaf $currentPath

    Write-Host "`n📂 Current Repository: $repoName" -ForegroundColor Cyan
    Write-Host "📍 Path: $currentPath" -ForegroundColor Gray

    Write-Host "`n🔧 Choose the appropriate account for this repository:" -ForegroundColor Yellow
    Write-Host "1. Personal (JohnMichaelMiller)" -ForegroundColor White
    Write-Host "2. CodeStaffing (john.miller@codestaffing.com)" -ForegroundColor White
    Write-Host "3. CodeMag (johnmillerATcodemag-com)" -ForegroundColor White

    $choice = Read-Host "`nEnter choice (1-3)"

    switch ($choice) {
        "1" {
            Write-Host "`n⚙️  Configuring for Personal Account..." -ForegroundColor Yellow
            git config user.name "John Michael Miller"
            git config user.email "JohnMichaelMiller@users.noreply.github.com"
            Write-Host "✅ Configured for Personal Account" -ForegroundColor Green
            Write-Host "   Name: John Michael Miller" -ForegroundColor Gray
            Write-Host "   Email: JohnMichaelMiller@users.noreply.github.com" -ForegroundColor Gray
        }
        "2" {
            Write-Host "`n⚙️  Configuring for CodeStaffing Account..." -ForegroundColor Yellow
            git config user.name "John Miller"
            git config user.email "john.miller@codestaffing.com"
            Write-Host "✅ Configured for CodeStaffing Account" -ForegroundColor Green
            Write-Host "   Name: John Miller" -ForegroundColor Gray
            Write-Host "   Email: john.miller@codestaffing.com" -ForegroundColor Gray
        }
        "3" {
            Write-Host "`n⚙️  Configuring for CodeMag Account..." -ForegroundColor Yellow
            git config user.name "John Miller"
            git config user.email "johnmillerATcodemag-com"
            Write-Host "✅ Configured for CodeMag Account" -ForegroundColor Green
            Write-Host "   Name: John Miller" -ForegroundColor Gray
            Write-Host "   Email: johnmillerATcodemag-com" -ForegroundColor Gray
        }
        default {
            Write-Host "❌ Invalid choice. Please run the script again." -ForegroundColor Red
            return
        }
    }

    # Show current git config
    Write-Host "`n📋 Current Repository Git Configuration:" -ForegroundColor Cyan
    git config user.name
    git config user.email
}

function Show-Help {
    Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║              GITHUB MULTI-ACCOUNT SETUP SCRIPT              ║" -ForegroundColor Green
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Green

    Write-Host "`n📖 USAGE:" -ForegroundColor Yellow
    Write-Host "  ./github-setup.ps1 -Action <command>" -ForegroundColor White

    Write-Host "`n🔧 AVAILABLE COMMANDS:" -ForegroundColor Yellow
    Write-Host "  show-keys         Display public keys to add to GitHub accounts" -ForegroundColor White
    Write-Host "  test-connections  Test SSH connections to all GitHub accounts" -ForegroundColor White
    Write-Host "  setup-git-configs Configure git user settings for current repo" -ForegroundColor White
    Write-Host "  help             Show this help message" -ForegroundColor White

    Write-Host "`n📋 SETUP PROCESS:" -ForegroundColor Yellow
    Write-Host "1. Run: ./github-setup.ps1 -Action show-keys" -ForegroundColor White
    Write-Host "2. Add the displayed public keys to your GitHub accounts" -ForegroundColor White
    Write-Host "3. Run: ./github-setup.ps1 -Action test-connections" -ForegroundColor White
    Write-Host "4. Run: ./github-setup.ps1 -Action setup-git-configs (in each repo)" -ForegroundColor White

    Write-Host "`n🔗 CLONE COMMANDS:" -ForegroundColor Yellow
    Write-Host "  Personal:     git clone git@github.com:JohnMichaelMiller/repo.git" -ForegroundColor White
    Write-Host "  CodeStaffing: git clone git@github-codestaffing:org/repo.git" -ForegroundColor White
    Write-Host "  CodeMag:      git clone git@github-codemag:org/repo.git" -ForegroundColor White
}

# Main script execution
switch ($Action) {
    "show-keys" { Show-PublicKeys }
    "test-connections" { Test-Connections }
    "setup-git-configs" { Setup-GitConfigs }
    "help" { Show-Help }
    default { Show-Help }
}
