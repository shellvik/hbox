#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")

rice() {
  chmod +x "$SCRIPT_DIR/src/vpn-scripts/"*.sh
  sudo cp -R "$SCRIPT_DIR/src/vpn-scripts/"* /opt
  sudo cp -R "$SCRIPT_DIR/src/htb-icons/" /usr/share/icons/

  [ -f "$HOME/.bashrc" ] && mv "$HOME/.bashrc" "$HOME/.bashrc_bak"
  cp "$SCRIPT_DIR/src/bashrc" "$HOME/.bashrc"

  if [ -f "$SCRIPT_DIR/src/Material-Black-Lime-Numix-FLAT.zip" ]; then
    unzip -d "$SCRIPT_DIR/src/Material-Black-Lime-Numix-FLAT" "$SCRIPT_DIR/src/Material-Black-Lime-Numix-FLAT.zip"
    sudo cp -R "$SCRIPT_DIR/src/Material-Black-Lime-Numix-FLAT" /usr/share/icons/
    sudo chmod 777 /usr/share/icons/Material-Black-Lime-Numix-FLAT
  fi

  if [ -f "$SCRIPT_DIR/src/themes.zip" ]; then
    unzip -d "$SCRIPT_DIR/src/themes" "$SCRIPT_DIR/src/themes.zip"
    [ ! -d "/usr/share/themes_bak" ] && sudo mv /usr/share/themes /usr/share/themes_bak
    sudo cp -R "$SCRIPT_DIR/src/themes" /usr/share/
    sudo chmod 777 /usr/share/themes
  fi

  if [ -d "$SCRIPT_DIR/src/wallpaper" ]; then
    sudo cp "$SCRIPT_DIR/src/wallpaper/*" /usr/share/backgrounds/
  fi

  if [ -d "$SCRIPT_DIR/src/fonts" ]; then
    [ ! -d "$HOME/.local/share/fonts/" ] && mkdir -p "$HOME/.local/share/fonts"
    unzip -d "$SCRIPT_DIR/src/fonts/" "$SCRIPT_DIR/src/fonts/*.zip"
    cp -r "$SCRIPT_DIR/src/fonts/*.ttf" "${HOME}/.local/share/fonts/"
  fi
}

ansiinstall() {
  sudo apt install -y pipx
  pipx ensurepath
  pipx install ansible
  export LC_CTYPE="en_US.UTF-8"
  export LANG="en_US.UTF-8"
}

read -p "Run setup script? [Y/n] " setup
if [[ $setup =~ ^[Yy]$ ]]; then
  rice
else
  echo "Rice setup cancelled."
fi

read -p "Install Ansible? [Y/n] " ansi
if [[ $ansi =~ ^[Yy]$ ]]; then
  ansiinstall
else
  echo "Ansible installation cancelled."
fi
