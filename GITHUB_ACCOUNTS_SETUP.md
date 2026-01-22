# GitHub Multiple Accounts Setup Guide

## Overview

This guide sets up access for three GitHub accounts:

1. **Personal**: JohnMichaelMiller@github.com
2. **CodeStaffing**: john.miller@codestaffing.com
3. **CodeMag**: johnmillerATcodemag-com

## SSH Keys and Public Keys to Add

### 1. Personal Account (JohnMichaelMiller)

**SSH Host**: `github.com`
**Key File**: `~/.ssh/github_personal`
**Public Key**:

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdQTAqzQryK6S4Dc3QUiNwK0TVxT0a4NQsY0NOjEQYe JohnMichaelMiller@github.com
```

**Add to**: https://github.com/settings/keys
**Title**: "Windows PC - Personal Account"

### 2. CodeStaffing Account

**SSH Host**: `github-codestaffing`
**Key File**: `~/.ssh/github_codestaffing`
**Public Key**:

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfsxQLdUQgFASTbjjS4eLXIKPu6vE/7u3kFLXCJI7Mj john.miller@codestaffing.com
```

**Add to**: https://github.com/settings/keys (while logged into john.miller@codestaffing.com account)
**Title**: "Windows PC - CodeStaffing"

### 3. CodeMag Account

**SSH Host**: `github-codemag`
**Key File**: `~/.ssh/github_work`
**Public Key**:

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJV7FDMzwgLIvq96HIP68TNwBQjCejAsnbSw5ImgWxR john.miller@work-account.com
```

**Add to**: https://github.com/settings/keys (while logged into johnmillerATcodemag-com account)
**Title**: "Windows PC - CodeMag"

## SSH Configuration

The SSH config file (`~/.ssh/config`) is set up as follows:

```ssh
# GitHub Personal Account (JohnMichaelMiller)
Host github.com
    HostName github.com
    User git
    IdentityFile C:\Users\JohnM\.ssh\github_personal
    IdentitiesOnly yes
    PreferredAuthentications publickey

# GitHub CodeStaffing Account
Host github-codestaffing
    HostName github.com
    User git
    IdentityFile C:\Users\JohnM\.ssh\github_codestaffing
    IdentitiesOnly yes
    PreferredAuthentications publickey

# GitHub CodeMag Account
Host github-codemag
    HostName github.com
    User git
    IdentityFile C:\Users\JohnM\.ssh\github_work
    IdentitiesOnly yes
    PreferredAuthentications publickey
```

## Usage Instructions

### Cloning Repositories

**Personal repositories (JohnMichaelMiller):**

```bash
git clone git@github.com:JohnMichaelMiller/repo-name.git
```

**CodeStaffing repositories:**

```bash
git clone git@github-codestaffing:organization/repo-name.git
```

**CodeMag repositories:**

```bash
git clone git@github-codemag:organization/repo-name.git
```

### Setting Git User Config Per Repository

After cloning, configure the appropriate user for each repository:

**For Personal repositories:**

```bash
git config user.name "John Michael Miller"
git config user.email "JohnMichaelMiller@users.noreply.github.com"
```

**For CodeStaffing repositories:**

```bash
git config user.name "John Miller"
git config user.email "john.miller@codestaffing.com"
```

**For CodeMag repositories:**

```bash
git config user.name "John Miller"
git config user.email "johnmillerATcodemag-com"
```

### Testing Connections

Test each account connection:

```powershell
# Test Personal Account
ssh -T git@github.com

# Test CodeStaffing Account
ssh -T git@github-codestaffing

# Test CodeMag Account
ssh -T git@github-codemag
```

Expected responses:

- `Hi JohnMichaelMiller! You've successfully authenticated...`
- `Hi [CodeStaffing-Username]! You've successfully authenticated...`
- `Hi [CodeMag-Username]! You've successfully authenticated...`

## Repository-Specific Git Configuration

For automatic user configuration per repository location, you can set up conditional git configs:

Add to `~/.gitconfig`:

```gitconfig
[includeIf "gitdir:C:/git/personal/"]
    path = ~/.gitconfig-personal

[includeIf "gitdir:C:/git/codestaffing/"]
    path = ~/.gitconfig-codestaffing

[includeIf "gitdir:C:/git/codemag/"]
    path = ~/.gitconfig-codemag
```

Create separate config files:

**`~/.gitconfig-personal`:**

```gitconfig
[user]
    name = John Michael Miller
    email = JohnMichaelMiller@users.noreply.github.com
```

**`~/.gitconfig-codestaffing`:**

```gitconfig
[user]
    name = John Miller
    email = john.miller@codestaffing.com
```

**`~/.gitconfig-codemag`:**

```gitconfig
[user]
    name = John Miller
    email = johnmillerATcodemag-com
```

## Troubleshooting

### Permission Issues

If you get permission errors, ensure:

1. SSH keys have correct permissions: `chmod 600 ~/.ssh/id_*`
2. SSH agent is running: `ssh-add -l`
3. Keys are added to agent if needed: `ssh-add ~/.ssh/github_personal`

### Wrong Account Connected

If git pushes to wrong account:

1. Check remote URL: `git remote -v`
2. Update remote URL to use correct host:
   ```bash
   git remote set-url origin git@github-codestaffing:org/repo.git
   ```

### SSH Connection Test Failures

1. Verify public key is added to correct GitHub account
2. Check SSH config syntax
3. Test with verbose output: `ssh -Tv git@github-codestaffing`
