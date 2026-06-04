# Mac Bootstrap Agent Guide

## Machine Role

This repository describes how to configure a company-provided macOS work machine for Sean.

Treat the target computer as a clean work device. Do not migrate this user's personal Mac, personal accounts, private project paths, browser profiles, iCloud data, keychains, SSH keys, API tokens, or local application state.

The expected workflow is:

1. Install Codex on the new Mac.
2. Let Codex inspect this repository.
3. Ask Codex to configure the machine according to this guide and the install profiles.
4. Keep all company-specific and machine-specific secrets local to that machine.

## Configuration Philosophy

- Prefer a small, auditable setup over a full clone of the current personal Mac.
- Keep work and personal life separated.
- Use this repository to describe reusable habits, tools, and defaults.
- Use local override files for anything private, company-specific, or path-specific.
- Do not add credentials, tokens, auth files, private SSH keys, or browser/session data to this repository.
- If company MDM or IT policy blocks a tool, skip it and report what was skipped.

## Install Profiles

`minimal` is the default profile. It is meant to make the machine usable for terminal work, GitHub, Codex, and common development tasks.

Use:

```bash
./install.sh minimal
```

`dev` adds more development conveniences and a few GUI tools.

Use only when company policy allows:

```bash
./install.sh dev
```

## Tool Preferences

Core command-line tools:

- Homebrew
- git
- gh
- ripgrep
- fd
- jq
- fzf
- bat
- eza
- zoxide
- starship
- git-delta
- lazygit
- tmux
- uv
- yazi

Development tools:

- Node.js
- npm
- pnpm if needed by active projects
- uv for Python environments
- OrbStack only if company policy allows containers and virtualization

AI and agent tools:

- Codex
- oh-my-codex
- Gemini CLI
- ccusage
- agent-browser

Terminal habits:

- zsh as the default shell
- starship prompt
- zoxide for directory jumping
- yazi file manager helper function
- git diffs through delta
- `main` as the default Git branch name

## Explicit Exclusions

Do not install or migrate these by default:

- Lark
- Microsoft Teams
- Zotero
- AweSun
- RustDesk
- UURemote
- Surge
- Tailscale
- Nutstore
- BaiduNetdisk
- QQ
- WeChat
- NeteaseMusic
- MacTeX
- XQuartz
- SUMO-related paths or settings
- Obsidian vault paths
- Personal project paths
- SSH keys
- API tokens
- Codex `auth.json`
- GitHub CLI `hosts.yml`
- Browser profiles, cookies, or history
- Keychain items

If one of these becomes necessary for work, ask before adding it to an install profile.

## Local Overrides

The dotfiles intentionally load local override files:

- `~/.zshrc.local`
- `~/.zprofile.local`
- `~/.gitconfig.local`

Use those files for local paths, company-specific configuration, machine-specific aliases, and private settings.

These files should not be committed to this repository.

## Git Identity

Do not hard-code a Git user name or email in the shared template.

After the new machine has a company email, put work identity in `~/.gitconfig.local`, for example:

```gitconfig
[user]
	name = Sean
	email = sean@example-company.com
```

If personal and work repositories both exist on the same machine, use directory-scoped Git config instead of one global identity.

## New Repository Clones

Do not guess which repositories to clone.

When setting up a new company Mac, ask the user which repositories should be cloned and where they should live. Prefer a neutral workspace root such as:

```text
~/Work
```

Only clone repositories the user explicitly names.

## macOS Defaults

`mac-defaults.sh` contains lightweight personal preferences:

- faster key repeat
- press-and-hold disabled for normal key repeat behavior
- Finder path bar enabled
- Finder status bar enabled

Run it only after confirming these preferences still match the user's desired setup.

## Safety Checklist For Codex

Before committing changes to this repository, check that no excluded software, private paths, credentials, tokens, auth files, SSH keys, or browser data were added.

Useful checks:

```bash
rg -n "auth.json|hosts.yml|/Users/sean|gho_|token|BEGIN OPENSSH|BEGIN RSA|Obsidian|SUMO|Lark|Teams|Zotero|AweSun|RustDesk|UURemote|Surge|Tailscale|Nutstore|BaiduNetdisk|QQ|WeChat|NeteaseMusic|MacTeX|XQuartz" .
```

