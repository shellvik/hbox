#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")

bash $SCRIPT_DIR/src/vpn-scripts/banner.sh

rice() {
  chmod +x "$SCRIPT_DIR/src/htb-vpn-config/"*.sh
  sudo cp -R "$SCRIPT_DIR/src/htb-vpn-config/" /etc/htb-vpn-config
  sudo cp $SCRIPT_DIR/src/htb-vpn-config/defau /etc/openvpn/config.conf
  sudo ln -sf /etc/htb-vpn-config/shvpn.sh /usr/bin/shvpn
  sudo cp -R "$SCRIPT_DIR/src/htb-icons/" /usr/share/icons/

  [ -f "$HOME/.bashrc" ] && mv "$HOME/.bashrc" "$HOME/.bashrc_bak"
  cp "$SCRIPT_DIR/src/bashrc" "$HOME/.bashrc"

  if [ -f "$SCRIPT_DIR/src/Material-Black-Lime-Numix-FLAT.zip" ]; then
    unzip -d "$SCRIPT_DIR/src/" "$SCRIPT_DIR/src/Material-Black-Lime-Numix-FLAT.zip"
    sudo cp -R "$SCRIPT_DIR/src/Material-Black-Lime-Numix-FLAT" /usr/share/icons/
    sudo chmod 777 /usr/share/icons/Material-Black-Lime-Numix-FLAT
  fi

  if [ -f "$SCRIPT_DIR/src/themes.zip" ]; then
    unzip -d "$SCRIPT_DIR/src/" "$SCRIPT_DIR/src/themes.zip"
    [ ! -d "/usr/share/themes_bak" ] && sudo mv /usr/share/themes /usr/share/themes_bak
    sudo cp -R "$SCRIPT_DIR/src/themes" /usr/share/
    sudo chmod 777 /usr/share/themes
  fi

  if [ -d "$SCRIPT_DIR/src/wallpaper" ]; then
    sudo cp -R "$SCRIPT_DIR/src/wallpaper/" /usr/share/backgrounds/
  fi

  if [ -d "$SCRIPT_DIR/src/fonts" ]; then
    sudo mkdir -p "$HOME/.local/share/fonts"
    unzip -d "$SCRIPT_DIR/src/fonts/" "$SCRIPT_DIR/src/fonts/*.zip"
    sudo cp -R "$SCRIPT_DIR/src/fonts/" "${HOME}/.local/share/"
  fi
}

ansiinstall() {
  sudo apt install -y pipx
  pipx ensurepath
  pipx install ansible-core
  export LC_CTYPE="en_US.UTF-8"
  export LANG="en_US.UTF-8"
}

read -p "Run setup script? [Y/n] " setup
if [[ $setup =~ ^[Yy]$ ]]; then
  echo "Follow the README to compelte ricing after installation..."
  rice
else
  echo "Rice setup cancelled."
fi

#----Fixing Locale to be UTF-8 Else ansible will not work:
fix_locale() {
    echo "Checking current locale settings..."
    locale
    # Check if the current LANG or LC_ALL uses a non-UTF-8 encoding
    if [[ "$(locale | grep 'LANG=')" != *".UTF-8"* ]] || [[ "$(locale | grep 'LC_ALL=')" != *".UTF-8"* ]]; then
        echo "Current locale encoding is not UTF-8. Fixing now..."

        # Set the default locale to UTF-8
        echo "Setting LANG and LC_ALL to UTF-8..."
        echo 'LANG="en_US.UTF-8"' | sudo tee /etc/default/locale >/dev/null
        echo 'LC_ALL="en_US.UTF-8"' | sudo tee -a /etc/default/locale >/dev/null

        # Generate the new locale
        echo "Generating locale..."
        sudo locale-gen en_US.UTF-8

        # Apply changes
        echo "Applying new locale settings..."
        sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
    else
        echo "Locale is already set to UTF-8. No changes needed."
    fi

    echo "Locale settings updated successfully. Restart your terminal or run 'source /etc/default/locale' to apply immediately."
}


read -p "Install Ansible? [Y/n] " ansi
if [[ $ansi =~ ^[Yy]$ ]]; then
  echo "Installing ansible with pipx..."
  ansiinstall
  ansible-galaxy collection install community.general
  fix_locale
else
  echo "Ansible installation cancelled."
fi


#-- Getting Seclist, Payloadallthethings, obsidian,
getw(){
  echo "Downloading SecLists, PayloadAllTheThings, Obsidian, Sublime..."

  #-- Create directories for SecLists and PayloadAllTheThings
  sudo mkdir -p /usr/share/SecLists
  sudo mkdir -p /usr/share/PayloadAllTheThings

  #-- Download and unzip SecLists
  sudo wget -c https://github.com/danielmiessler/SecLists/archive/master.zip -O /usr/share/SecLists.zip \
  && sudo unzip /usr/share/SecLists.zip -d /usr/share/SecLists \
  && sudo rm -f /usr/share/SecLists.zip

  #-- Download and unzip PayloadAllTheThings
  sudo wget -c https://github.com/swisskyrepo/PayloadsAllTheThings/archive/refs/heads/master.zip -O /usr/share/PayloadAllTheThings.zip \
  && sudo unzip /usr/share/PayloadAllTheThings.zip -d /usr/share/PayloadAllTheThings \
  && sudo rm -f /usr/share/PayloadAllTheThings.zip

  #-- Download and install Obsidian
  wget -c https://github.com/obsidianmd/obsidian-releases/releases/download/v1.7.7/obsidian_1.7.7_amd64.deb -O /tmp/obsidian.deb \
  && sudo dpkg -i /tmp/obsidian.deb \
  && rm -f /tmp/obsidian.deb

  #-- Get Sublime Text
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  sudo apt-get update
  sudo apt-get install -y sublime-text
}


read -p "Install Payloads, Wordlists, Obsidian, Sublime-text? [Y/n] " ess
if [[ $ess =~ ^[Yy]$ ]]; then
  echo "Installing ansible with pipx..."
  getw
else
  echo "Installation cancelled."
fi

run_ansible_scripts(){
  sudo whoami && 
  ansible-playbook ./src/ansi/main.yml
}
run_ansible_scripts
