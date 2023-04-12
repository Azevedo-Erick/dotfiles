#!/bin/bash

# Detectar a distribuição
if [[ $(uname) == "Linux" ]]; then
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
  else
    OS=$(uname -s)
    VER=$(uname -r)
  fi
else
  echo "Este script só pode ser executado em sistemas Linux."
  exit 1
fi

# Instalações
if [[ $OS == "Ubuntu" || $OS == "Debian" ]]; then
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io

  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo apt-get install zsh

elif [[ $OS == "Fedora" || $OS == "CentOS" || $OS == "Red Hat Enterprise Linux" ]]; then
  sudo yum install -y docker docker-compose
  sudo dnf install zsh

elif [[ $OS == "Arch Linux" || $OS == "Manjaro Linux" ]]; then
  sudo pacman -S --noconfirm docker docker-compose
  sudo pacman -S zsh

else
  echo "Não foi possível detectar o gerenciador de pacotes apropriado para a distribuição $OS."
  exit 1
fi

sudo systemctl start docker

# Instalar o Discord e o Telegram Desktop
sudo snap install discord
sudo snap install telegram-desktop

# Instalar o Visual Studio Code
sudo snap install code --classic

# Instalar o Android Studio
sudo snap install android-studio --classic

# Definir o zsh como o shell padrão
chsh -s $(which zsh)

# Baixar e instalar o Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Baixar e instalar o tema Spaceship
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# Copiar e colar seu arquivo .zshrc das suas dotfiles
cp ~zsh/.zshrc ~/.zshrc

# Baixar e instalar o asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc

# Instalar o Flutter, Node.js e .NET Core usando o asdf
asdf plugin-add flutter #https://github.com/oae/asdf-flutter.git
asdf plugin-add nodejs #https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin-add dotnet-core #https://github.com/emersonsoares/asdf-dotnet-core.git

asdf install flutter latest
asdf global flutter $(asdf latest flutter)
asdf install nodejs latest
asdf global nodejs $(asdf latest nodejs)
asdf install dotnet-core latest
asdf global dotnet-core $(asdf latest dotnet-core)
