!#/bin/bash

./src/vpn-scripts/banner.sh

rice() {
  chmod +x ./src/vpn-scripts/*.sh
  sudo cp -R ./src/vpn-scripts/* /opt
  sudo cp -R ./src/htb-icons/ /usr/share/icons/
  sudo mv ~/.bashrc ~/bashrc_bak
  sudo cp ./src/bashrc ~/.bashrc

  unzip ./src/Material-Black-Lime-Numix-FLAT.zip
  sudo cp -R ./src/Material-Black-Lime-Numix-FLAT /usr/share/icons/
  sudo chmod 777 /usr/share/icons/Material-Black-Lime-Numix-FLAT

  sudo unzip ./src/themes.zip
  sudo mv /usr/share/themes/ themes_bak
  sudo cp -R ./src/themes /usr/share/themes
  sudo chmod 777 /usr/share/themes

  sudo cp ./src/wallpaper/* /usr/share/backgrounds/htb.jpg

  #Fonts
  [-d "~/.local/share/fonts/"] && sudo mkdir ~/.local/share/fonts
  sudo cp -r ./src/fonts/*.ttf ~/.local/share/fonts/

}

ansiinstall() {
  pip3 install ansible
  export LC_CTYPE="en_US.UTF-8"
  export LANG="en_US.UTF-8"
}

read -p "Run setup script? [Y/n] " setup
if [[ $setup =~ ^[Yy] ]]; then
  setup
else
  echo "Cancelled!!..."
fi

read -p "Install ansible?" ansi
if [[ $ansi =~ [Yy] ]]; then
  ansiinstall
else
  "Cancelled!!..."
fi
