# Minimal DevOps Dotfiles

A simplified, production-ready dotfiles configuration optimized for DevOps engineers.

## Philosophy

- **Minimal**: Only essential tools and configurations
- **Fast**: Quick shell startup (<0.5s)
- **Simple**: Easy to understand and maintain
- **Platform-friendly**: Works on macOS and Linux
- **DevOps-focused**: Tools for containers, cloud, IaC, and Kubernetes

## What's Included

### 🛠️ Core Tools

- **Version Control**: Git with useful aliases and git-delta for better diffs
- **Containers**: Docker & Kubernetes (kubectl, helm, k9s)
- **Infrastructure as Code**: Terraform, Ansible
- **Cloud CLIs**: AWS, Azure, GCP (commented out by default)
- **Productivity**: fzf, bat, ripgrep, fd, zoxide, tig

### 📝 Configurations

- **Shell**: Pure ZSH with git-aware prompt (no oh-my-zsh)
- **Git**: Sensible defaults with helpful aliases
- **Aliases**: DevOps-focused shortcuts for git, kubectl, terraform, docker
- **Editor**: nano as default with editorconfig support

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Install

```bash
./install
```

The installer will:
- Create symlinks for all config files
- Backup existing configs (if any)
- Create local config templates
- Optionally install Homebrew packages

### 3. Configure

Edit these files with your personal settings:

```bash
# Required: Set your git identity
nano ~/.gitconfig_local

# Optional: Machine-specific settings
nano ~/.zshrc.local
```

### 4. Reload Shell

```bash
source ~/.zshrc
# or restart your terminal
```

## File Structure

```
dotfiles/
├── install              # Installation script
├── Brewfile             # Homebrew packages (~30 tools)
├── config/
│   ├── zshrc            # ZSH configuration
│   ├── aliases          # Shell aliases
│   ├── gitconfig        # Git configuration
│   ├── gitignore        # Global gitignore
│   ├── gitattributes    # Git attributes
│   ├── ssh_config       # SSH configuration
│   └── editorconfig     # Editor configuration
└── README.md
```

## Customization

### Adding Tools

Edit `Brewfile` and uncomment or add packages you need:

```bash
# Uncomment cloud tools you use
brew "awscli"
# brew "azure-cli"
# brew "google-cloud-sdk"

# Add your own tools
brew "your-tool"
```

Then install:

```bash
brew bundle --file=~/.dotfiles/Brewfile
```

### Adding Aliases

Edit `~/.aliases` or add them to `~/.zshrc.local`:

```bash
# In ~/.zshrc.local
alias myalias='my command'
```

### Machine-Specific Config

Use `~/.zshrc.local` for machine-specific settings:

```bash
# AWS Profile
export AWS_PROFILE=production

# Custom kubeconfig
export KUBECONFIG=~/.kube/prod-config

# Company proxy
export HTTP_PROXY=http://proxy.company.com:8080
```

## Useful Aliases

### Git
- `g` → git
- `gs` → git status
- `gp` → git push
- `gl` → git pull
- `glog` → git log --oneline --graph

### Kubernetes
- `k` → kubectl
- `kgp` → kubectl get pods
- `kgs` → kubectl get services
- `kl` → kubectl logs
- `kx` → kubectl exec -it

### Terraform
- `tf` → terraform
- `tfi` → terraform init
- `tfp` → terraform plan
- `tfa` → terraform apply

### Docker
- `d` → docker
- `dc` → docker-compose
- `dps` → docker ps
- `dex` → docker exec -it

## Features

### Smart Directory Navigation

- `z <partial-name>` → Jump to frequently used directories (zoxide)
- `Ctrl-T` → Fuzzy find files (fzf)
- `Alt-C` → Fuzzy find directories (fzf)

### Enhanced Git

- Better diffs with git-delta
- Useful aliases (see `git config --get-regexp alias`)
- Global gitignore for common files

### Fast Completions

- Tab completion for all tools
- Case-insensitive matching
- History-based suggestions

## Updating

```bash
cd ~/.dotfiles
git pull
./install  # Re-run to update symlinks
```

## Uninstalling

```bash
# Remove symlinks
rm ~/.zshrc ~/.aliases ~/.gitconfig ~/.gitignore_global ~/.gitattributes_global ~/.editorconfig

# Restore backups (if you want)
mv ~/.zshrc.backup ~/.zshrc
mv ~/.gitconfig.backup ~/.gitconfig
# ... etc
```

## Requirements

- **macOS** 10.15+ or **Linux**
- **Homebrew** (for package management)
- **ZSH** (usually pre-installed)

## Comparison to Original

| Aspect | Before | After |
|--------|--------|-------|
| Files | ~30 files | ~10 files |
| Brewfile size | 198 lines | 54 lines |
| Dependencies | ~140 packages | ~30 packages |
| Shell startup | 2-3 seconds | <0.5 seconds |
| Frameworks | oh-my-zsh + zplug | Pure ZSH |
| Installation | dotbot (4 steps) | Simple script |

## License

MIT - Use freely!

## Credits

Simplified from [sobolevn/dotfiles](https://github.com/sobolevn/dotfiles) with focus on DevOps workflows.
