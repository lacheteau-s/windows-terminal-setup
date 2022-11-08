# Windows Terminal setup

## Install WSL

### Windows 11 & Windows 10 build 19041 and higher

1. Open Powershell as an Administrator.
2. Run the following command:

    > wsl --install -d Ubuntu

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
3. Open Windows Terminal
4. Click the dropdown arrow on top.
5. Click on settings.
6. Click on `Open JSON file` on the bottom left corner.
7. Replace the content of the file with that of `terminal_settings.json` and save.

## Setup Linux as your default terminal

1. Open Windows Terminal.
2. Click the dropdown arrow on top.
3. Click on settings.
4. Click on the dropdown box under `Default profile`.
5. Select your Linux distribution.
6. Click save

## Install ZSH

1. Open Powershell as an Administrator
2. Run the following command:

    > Set-ExecutionPolicy -ExecutionPolicy Unrestricted
3. Open Windows Terminal.
4. Run the following command in Ubuntu:

    > sh -c "$(sudo curl -fsSL https://raw.githubusercontent.com/lacheteau-s/windows-terminal-setup/main/setup.sh)"

    This will update existing packages and install required packages (git, curl), install and configure ZSH with Powerline fonts.

5. Reset the Powershell execution policy:

    > Set-ExecutionPolicy -ExecutionPolicy Restricted

## Improvements

* Configure Ubuntu settings to use a Powerline font.
* Accept user email and name as optional input parameters to configure Git.
* Include VS Code config.
* Include profile settings.
* Symbolic links to /mnt/*.
