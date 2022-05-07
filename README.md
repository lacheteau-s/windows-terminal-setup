# Windows Terminal setup

## Install WSL

### Windows 11 & Windows 10 build 19041 and higher

1. Open Powershell as an Administrator.
2. Run the following command:

    > wsl --install

    This will install WSL with Ubuntu as the default distribution.
3. Restart your computer. The installation will resume. This can take a few minutes.
4. Upon completion, enter a new Unix username and password.
    
### Manual installation (older versions)

1. Open Powershell as an Administrator.
2. Run the following commands:

    > dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

    > dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

3. Restart your computer.
4. Download and install the latest [Linux kernel update package](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi).
5. Run the following command in Powershell:

    > wsl --set-default-version 2

6. Open the Microsoft Store and download the desired distribution.
7. Upon completion, enter a new Unix username and password.

## Install Windows Terminal

1. Open the Microsoft Store.
2. Find and download Windows Terminal.

## Setup Linux as your default terminal

1. Open Windows Terminal.
2. Click the dropdown arrow on top.
3. Click on settings.
4. Click on the dropdown box under `Default profile`.
5. Select your Linux distribution.
6. Click save

## Install ZSH

> sudo apt-get update

> sudo apt upgrade -y

> sudo apt install zsh

> sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

> nano .zshrc

> ZSH_THEME="agnoster"

> source .zshrc

> git clone https://github.com/powerline/fonts.git

In Powershell:

> .\install.ps1

In Windows Terminal > Settings > Open JSON > Ubuntu

> "fontFace" : "DejaVu Sans Mono for Powerline"
