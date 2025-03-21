#!/usr/bin/env bash
set -euo pipefail

########################################
# Logging Functions
########################################
log_info() {
    printf "[INFO] %s\n" "$1"
}

log_error() {
    printf "[ERROR] %s\n" "$1" >&2
}

########################################
# Install OS-Specific Dependencies
########################################
install_dependencies() {
    log_info "Updating package list and installing dependencies for Arch..."
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm base-devel git curl clang llvm protobuf openssl

    if ! command -v paru >/dev/null 2>&1; then
        log_info "Installing paru (AUR helper)..."
        git clone https://aur.archlinux.org/paru.git ~/paru && cd ~/paru
        makepkg -si --noconfirm
        cd ~ && rm -rf paru
    fi
    log_info "Dependencies installed."
    echo ""
}

########################################
# Install Rust via rustup
########################################
install_rust() {
    if command -v rustc >/dev/null 2>&1; then
        log_info "Rust is already installed. Updating..."
        rustup update
    else
        log_info "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi

    # Carregar o ambiente do Rust no shell atual
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    else
        log_error "Rust environment not found. Please restart your terminal."
        exit 1
    fi

    rustc --version || log_error "Rust installation failed."
    echo ""
}

########################################
# Install Solana CLI
########################################
install_solana_cli() {
    if command -v solana >/dev/null 2>&1; then
        log_info "Solana CLI is already installed. Updating..."
        agave-install update
    else
        log_info "Installing Solana CLI..."
        sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
    fi
    solana --version || log_error "Solana CLI installation failed."
    echo ""
}

########################################
# Install Anchor CLI
########################################
install_anchor_cli() {
    if command -v anchor >/dev/null 2>&1; then
        log_info "Anchor CLI is already installed. Updating..."
        avm update
    else
        log_info "Installing Anchor CLI..."
        cargo install --git https://github.com/coral-xyz/anchor avm
        avm install latest
        avm use latest
    fi
    anchor --version || log_error "Anchor CLI installation failed."
    echo ""
}

########################################
# Install nvm and Node.js
########################################
install_nvm_and_node() {
    if [ ! -d "$HOME/.nvm" ]; then
        log_info "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    fi
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm alias default node
    node --version || log_error "Node.js installation failed."
    echo ""
}

########################################
# Install Yarn
########################################
install_yarn() {
    if ! command -v yarn >/dev/null 2>&1; then
        log_info "Installing Yarn..."
        npm install --global yarn
    fi
    yarn --version || log_error "Yarn installation failed."
    echo ""
}

########################################
# Print Installed Versions
########################################
print_versions() {
    echo ""
    echo "Installed Versions:"
    echo "Rust: $(rustc --version 2>/dev/null || echo 'Not installed')"
    echo "Solana CLI: $(solana --version 2>/dev/null || echo 'Not installed')"
    echo "Anchor CLI: $(anchor --version 2>/dev/null || echo 'Not installed')"
    echo "Node.js: $(node --version 2>/dev/null || echo 'Not installed')"
    echo "Yarn: $(yarn --version 2>/dev/null || echo 'Not installed')"
    echo ""
    export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
}

########################################
# Main Execution Flow
########################################
main() {
    install_dependencies
    install_rust
    install_solana_cli
    install_anchor_cli
    install_nvm_and_node
    install_yarn
    print_versions
    echo "Installation complete. Please restart your terminal to apply all changes."
}

main "$@"
