!#/bin/bash

$(pwd)/src/vpn-scripts/banner.sh

rice() {
  chmod +x $(pwd)/src/vpn-scripts/*.sh
  sudo cp -R $(pwd)/src/vpn-scripts/* /opt
  sudo cp -R $(pwd)/src/htb-icons/ /usr/share/icons/
  [-f "~/.bashrc" ] && sudo mv ~/.bashrc ~/.bashrc_bak
  sudo cp $(pwd)/src/bashrc ~/.bashrc

  unzip $(pwd)/src/Material-Black-Lime-Numix-FLAT.zip
  sudo cp -R $(pwd)/src/Material-Black-Lime-Numix-FLAT /usr/share/icons/
  sudo chmod 777 /usr/share/icons/Material-Black-Lime-Numix-FLAT

  sudo unzip $(pwd)/src/themes.zip
  sudo mv /usr/share/themes/ themes_bak
  sudo cp -R $(pwd)/src/themes /usr/share/themes
  sudo chmod 777 /usr/share/themes

  sudo cp $(pwd)/src/wallpaper/* /usr/share/backgrounds/htb.jpg

  #Fonts
  [-d "~/.local/share/fonts/"] && sudo mkdir ~/.local/share/fonts
  sudo cp -r $(pwd)/src/fonts/*.ttf ~/.local/share/fonts/

}

ansiinstall() {
  sudo apt install pipx
  pipx install ansible
  export LC_CTYPE="en_US.UTF-8"
  export LANG="en_US.UTF-8"
}

read -p "Run setup script? [Y/n] " setup
if [[ $setup =~ ^[Yy] ]]; then
  rice
else
  echo "Cancelled!!..."
fi

read -p "Install ansible? [Y/n] " ansi
if [[ $ansi =~ [Yy] ]]; then
  ansiinstall
else
  "Cancelled!!..."
fi
