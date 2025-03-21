# Solana Environment Archlinux Install
 Installer of dependencies for Solana desolsolution environment on Archlinux and derivatives 

How to use:
```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
```
Close your terminal and open again
```sh
git clone https://github.com/nour-hikmah/solana-environment-archlinux-install
cd solana-environment-archlinux-install
chmod +x install.sh
./install.sh
```

In the bash terminal
```sh
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

In the zsh terminal
```sh
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```
