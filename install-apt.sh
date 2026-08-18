#!/usr/bin/env bash

# APT Package Installation Script for Debian/Ubuntu
# Installs DevOps tools with necessary repositories

set -e

DRY_RUN=false
DOWNLOAD_DIR=""

cleanup() {
  if [ -n "$DOWNLOAD_DIR" ]; then
    rm -rf -- "$DOWNLOAD_DIR"
  fi
}

ensure_download_dir() {
  if [ -z "$DOWNLOAD_DIR" ]; then
    DOWNLOAD_DIR=$(mktemp -d)
  fi
}

trap cleanup EXIT

download_verified_release_asset() {
  local release_json="$1"
  local asset_name="$2"
  local destination="$3"
  local asset_url
  local digest

  asset_url=$(jq -r --arg name "$asset_name" '.assets[] | select(.name == $name) | .browser_download_url' <<< "$release_json")
  digest=$(jq -r --arg name "$asset_name" '.assets[] | select(.name == $name) | .digest' <<< "$release_json")

  if [ -z "$asset_url" ] || [ "$asset_url" = "null" ]; then
    echo "Release asset not found: $asset_name" >&2
    return 1
  fi
  if [[ "$digest" != sha256:* ]]; then
    echo "No SHA-256 digest published for: $asset_name" >&2
    return 1
  fi

  curl -fsSL "$asset_url" -o "$destination"
  echo "${digest#sha256:}  $destination" | sha256sum --check --status
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run|-n)
      DRY_RUN=true
      shift
      ;;
    --help|-h)
      echo "Usage: ./install-apt.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --dry-run, -n    Show what would be installed without making changes"
      echo "  --help, -h       Show this help message"
      echo ""
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

if [ "$DRY_RUN" = true ]; then
  echo "🔍 DRY RUN MODE - No packages will be installed"
  echo ""
fi

echo "📦 Installing packages for Debian/Ubuntu..."
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "⚠️  Please run this script as a normal user (with sudo privileges)"
   echo "   Usage: ./install-apt.sh [--dry-run]"
   exit 1
fi

# Update package list
if [ "$DRY_RUN" = false ]; then
  echo "🔄 Updating package list..."
  sudo apt update
else
  echo "🔄 Would update package list (apt update)"
fi

# Install basic packages from standard repos
echo ""
if [ "$DRY_RUN" = false ]; then
  echo "📥 Installing core packages..."
  sudo apt install -y \
    git curl wget jq tree \
    fzf bat fd-find ripgrep tig \
    htop zsh shellcheck gnupg nano
else
  echo "📥 Would install core packages:"
  echo "   git, curl, wget, jq, tree, fzf, bat, fd-find, ripgrep,"
  echo "   tig, htop, zsh, shellcheck, gnupg, nano"
fi

# === GitHub CLI ===
if ! command -v gh &> /dev/null; then
  echo ""
  if [ "$DRY_RUN" = false ]; then
    echo "📥 Installing GitHub CLI..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install -y gh
  else
    echo "📥 Would install: GitHub CLI (gh)"
  fi
else
  echo "✅ GitHub CLI already installed"
fi

# === kubectl ===
if ! command -v kubectl &> /dev/null; then
  echo ""
  if [ "$DRY_RUN" = false ]; then
    read -p "📥 Install kubectl? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
      echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
      sudo apt update
      sudo apt install -y kubectl
    fi
  else
    echo "📥 Would prompt to install: kubectl"
  fi
else
  echo "✅ kubectl already installed"
fi

# === Helm ===
if ! command -v helm &> /dev/null; then
  echo ""
  if [ "$DRY_RUN" = false ]; then
    read -p "📥 Install Helm? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
      sudo apt update
      sudo apt install -y helm
    fi
  else
    echo "📥 Would prompt to install: Helm"
  fi
else
  echo "✅ Helm already installed"
fi

# === Terraform ===
if ! command -v terraform &> /dev/null; then
  echo ""
  if [ "$DRY_RUN" = false ]; then
    read -p "📥 Install Terraform? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
      echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
      sudo apt update
      sudo apt install -y terraform
    fi
  else
    echo "📥 Would prompt to install: Terraform"
  fi
else
  echo "✅ Terraform already installed"
fi

# === Ansible ===
if ! command -v ansible &> /dev/null; then
  echo ""
  if [ "$DRY_RUN" = false ]; then
    read -p "📥 Install Ansible? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      sudo apt install -y ansible
    fi
  else
    echo "📥 Would prompt to install: Ansible"
  fi
else
  echo "✅ Ansible already installed"
fi

# === k9s ===
if ! command -v k9s &> /dev/null; then
  echo ""
  if [ "$DRY_RUN" = false ]; then
    read -p "📥 Install k9s? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      K9S_ARCH=$(dpkg --print-architecture)
      case "$K9S_ARCH" in
        amd64|arm64) ;;
        *)
          echo "Unsupported k9s architecture: $K9S_ARCH" >&2
          exit 1
          ;;
      esac
      K9S_RELEASE=$(curl -fsSL https://api.github.com/repos/derailed/k9s/releases/latest)
      K9S_ASSET="k9s_Linux_${K9S_ARCH}.tar.gz"
      ensure_download_dir
      download_verified_release_asset "$K9S_RELEASE" "$K9S_ASSET" "$DOWNLOAD_DIR/k9s.tar.gz"
      sudo tar -C /usr/local/bin -xzf "$DOWNLOAD_DIR/k9s.tar.gz" k9s
      echo "✅ k9s installed"
    fi
  else
    echo "📥 Would prompt to install: k9s (latest from GitHub)"
  fi
else
  echo "✅ k9s already installed"
fi

# === zoxide ===
if ! command -v zoxide &> /dev/null; then
  echo ""
  if [ "$DRY_RUN" = false ]; then
    read -p "📥 Install zoxide? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi
  else
    echo "📥 Would prompt to install: zoxide"
  fi
else
  echo "✅ zoxide already installed"
fi

# === git-delta ===
if ! command -v delta &> /dev/null; then
  echo ""
  if [ "$DRY_RUN" = false ]; then
    read -p "📥 Install git-delta? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      DELTA_ARCH=$(dpkg --print-architecture)
      case "$DELTA_ARCH" in
        amd64|arm64|armhf) ;;
        *)
          echo "Unsupported git-delta architecture: $DELTA_ARCH" >&2
          exit 1
          ;;
      esac
      DELTA_RELEASE=$(curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest)
      DELTA_VERSION=$(jq -r '.tag_name' <<< "$DELTA_RELEASE")
      DELTA_ASSET="git-delta_${DELTA_VERSION}_${DELTA_ARCH}.deb"
      ensure_download_dir
      download_verified_release_asset "$DELTA_RELEASE" "$DELTA_ASSET" "$DOWNLOAD_DIR/git-delta.deb"
      sudo dpkg -i "$DOWNLOAD_DIR/git-delta.deb"
      echo "✅ git-delta installed"
    fi
  else
    echo "📥 Would prompt to install: git-delta (latest .deb from GitHub)"
  fi
else
  echo "✅ git-delta already installed"
fi

# === uv (Python package manager) ===
if ! command -v uv &> /dev/null; then
  echo ""
  if [ "$DRY_RUN" = false ]; then
    read -p "📥 Install uv (Python package manager)? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
  else
    echo "📥 Would prompt to install: uv (Python package manager)"
  fi
else
  echo "✅ uv already installed"
fi

# Fix bat and fd command names on Ubuntu
echo ""
if [ "$DRY_RUN" = false ]; then
  if [ -f /usr/bin/batcat ] && [ ! -f /usr/local/bin/bat ]; then
    echo "🔧 Creating bat symlink (Ubuntu uses 'batcat')..."
    sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
  fi

  if [ -f /usr/bin/fdfind ] && [ ! -f /usr/local/bin/fd ]; then
    echo "🔧 Creating fd symlink (Ubuntu uses 'fdfind')..."
    sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
  fi
else
  if [ -f /usr/bin/batcat ]; then
    echo "🔧 Would create bat symlink (/usr/bin/batcat -> /usr/local/bin/bat)"
  fi
  if [ -f /usr/bin/fdfind ]; then
    echo "🔧 Would create fd symlink (/usr/bin/fdfind -> /usr/local/bin/fd)"
  fi
fi

echo ""
if [ "$DRY_RUN" = true ]; then
  echo "✨ Dry run complete - no packages were installed!"
  echo ""
  echo "📌 To actually install, run:"
  echo "   ./install-apt.sh"
else
  echo "✨ Package installation complete!"
  echo ""
  echo "📌 Note: You may need to restart your shell or run 'source ~/.zshrc'"
fi
