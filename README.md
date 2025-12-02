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

### 2. Test First (Optional)

Preview what will be installed without making changes:

```bash
./install --dry-run
```

### 3. Install

```bash
./install
```

The installer will:
- Create symlinks for all config files
- Backup existing configs (if any)
- Create local config templates
- Optionally install Homebrew packages

**Install Options:**
- `./install` - Normal installation
- `./install --dry-run` or `./install -n` - Preview changes without installing
- `./install --help` or `./install -h` - Show help message

### 4. Configure

Edit these files with your personal settings:

```bash
# Required: Set your git identity
nano ~/.gitconfig_local

# Optional: Machine-specific settings
nano ~/.zshrc.local
```

### 5. Reload Shell

```bash
source ~/.zshrc
# or restart your terminal
```

## File Structure

```
dotfiles/
├── install              # Smart installer with OS detection
├── install-apt.sh       # APT installer for Debian/Ubuntu
├── Brewfile             # Homebrew packages (macOS/Linux)
├── packages.apt         # APT package reference (Debian/Ubuntu)
├── config/
│   ├── zshrc            # ZSH configuration
│   ├── aliases          # Shell aliases
│   ├── gitconfig        # Git configuration
│   ├── gitignore        # Global gitignore
│   ├── gitattributes    # Git attributes
│   ├── ssh_config       # SSH configuration
│   └── editorconfig     # Editor configuration
└── README.md            # This file
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
- **ZSH** (usually pre-installed)
- **Package manager**: Homebrew (macOS/Linux) or APT (Debian/Ubuntu)

## Platform Support

This dotfiles setup supports multiple platforms with automatic detection:

### macOS

**Recommended**: Use Homebrew (installed by default on modern macOS)

```bash
# If Homebrew is not installed:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then run the installer:
./install
```

The installer will use the `Brewfile` to install packages.

### Linux with Homebrew

**Option 1**: Install Homebrew on Linux (works on most distributions)

```bash
# Install Homebrew for Linux:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then run the installer:
./install
```

The installer will use the `Brewfile` to install packages.

### Debian/Ubuntu (without Homebrew)

**Option 2**: Use the native APT installer

```bash
# Run the installer:
./install

# When prompted, choose to install via APT
# Or run directly:
./install-apt.sh
```

The `install-apt.sh` script will:
- Install packages from Ubuntu/Debian repositories
- Add necessary third-party repositories (GitHub CLI, Kubernetes, HashiCorp, etc.)
- Download and install binary releases where needed (k9s, git-delta, etc.)
- Create proper symlinks for Ubuntu package names (batcat → bat, fdfind → fd)

### Other Linux Distributions

For other distributions (Fedora, Arch, etc.):

1. **Recommended**: Install Homebrew for Linux (easiest)
2. **Manual**: Use `packages.apt` as a reference for package names
3. **Adapt**: Create your own package list for your package manager

## Package Files

- **Brewfile**: Homebrew packages (macOS and Linux with Homebrew)
- **packages.apt**: Reference list for Debian/Ubuntu packages
- **install-apt.sh**: Automated installer for Debian/Ubuntu systems

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
