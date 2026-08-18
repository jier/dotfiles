# Minimal DevOps-focused Brewfile

# === Core Utilities ===
brew "git"
brew "gh"                     # GitHub CLI
brew "curl"
brew "wget"
brew "jq"                     # JSON processor
brew "yq"                     # YAML processor
brew "tree"

# === Container & Orchestration ===
brew "kubectl"
brew "helm"
brew "k9s"                    # Kubernetes TUI

# === Infrastructure as Code ===
brew "terraform"
brew "ansible"

# === Cloud CLIs (uncomment what you need) ===
# brew "awscli"               # AWS CLI
# brew "azure-cli"            # Azure CLI
# brew "google-cloud-sdk"     # GCP SDK

# === Productivity Tools ===
brew "fzf"                    # Fuzzy finder
brew "bat"                    # Better cat with syntax highlighting
brew "fd"                     # Better find
brew "ripgrep"                # Better grep (rg)
brew "zoxide"                 # Smart cd
brew "tig"                    # Git TUI
brew "git-delta"              # Better git diff

# === Monitoring & Debugging ===
brew "htop"                   # Process viewer

# === Shell ===
brew "zsh"
brew "shellcheck"             # Shell script linting

# === Security ===
brew "gnupg"                  # For signing commits

# === Editor ===
brew "nano"                   # Simple terminal editor

# === Python Development ===
brew "uv"                     # Fast Python package installer and resolver

# === Optional Applications ===
# These casks are macOS-only; Linux installations keep using the formulae above.
if OS.mac?
  cask "docker"               # Docker Desktop
  cask "iterm2"               # Better terminal for macOS
  cask "rectangle"            # Window management for macOS
  # cask "visual-studio-code"  # VS Code
end
