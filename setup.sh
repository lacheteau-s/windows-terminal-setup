#!/bin/sh

# Stop execution upon first non-zero return
set -e

# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}

# $HOME is defined at the time of login, but it could be unset.
# If it is unset a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"

command_exists()
{
    # command -v [command]: prints a description of [command]
    #   * returns 0 if [command] exists
    #   * returns 1 if [command] doesn't exist
    # > /dev/null: discards the standard output from the previous command
    # 2>&1: discards stderr (sends it to where stdout was redirected)
    command -v "$@" >/dev/null 2>&1
}

can_sudo()
{
    # Check if sudo is installed
    command_exists sudo || return 1

    # LANG= : run command in the default locale
    #
    # sudo -n: do not prompt for password
    #   * if password is not required: command will finish with exit code 0
    #   * if password is required: command will exit with error code 1 + error message
    #
    # sudo -v:
    #   * user has sudo privileges: prompts for password
    #   * user doesn't have sudo privileges: exits with error code 1 + prints: "Sorry, user <username> may not run sudo on <hostname>"
    #
    # 2>&1: redirect stderr to stdout
    #
    # grep -q [string]: checks for [string] in the output to determine whether the user has sudo privileges or not
    #   * returns 0 if found
    #   * returns 1 if not found
    ! LANG= sudo -n -v 2>&1 | grep -q "may not run sudo"
}

try_sudo()
{
    local prefix=""

    if [ can_sudo ]
        then prefix="sudo"
    fi

    $prefix $@
}

get_uuid()
{
    if command_exists uuidgen
        then uuidgen
    else
        cat /proc/sys/kernel/random/uuid
    fi
}

setup_prerequisites()
{
    #ln -s /mnt/

    try_sudo apt-get update && try_sudo apt upgrade -y

    if ! command_exists git
        then try_sudo apt install git -y
    fi

    if ! command_exists curl
        then try_sudo apt install curl -y
    fi
}

setup_zsh()
{
    try_sudo apt install zsh -y

    # pass the output of `yes` to the next command
    # this will automatically answer 'y' whenever user input is required
    yes | sh -c "$(sudo curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    yes | sudo apt-get install powerline fonts-powerline

    # set default theme to agnoster
    sed -i -E 's/(ZSH_THEME=)(.*)/\1\"agnoster\"/g' .zshrc

    # get zsh command path
    zsh=$(grep '^/.*/zsh$' /etc/shells | tail -n 1)

    # set shell to zsh
    if [ can_sudo ]
        then sudo -k chsh -s "$zsh" "$USER"
    else
        chsh -s "$zsh" "$USER"
    fi
}

setup_powerline()
{
    # retrieve the path to the Downloads folder on the Windows file system
    local downloads=$(powershell.exe -Command "(New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path")

    # 1. Build the Unix-style path
    #   * Capture the drive segment of the path
    #   * Capture the drive letter
    #   * Capture the rest of the path
    #   * Prepend /mnt/[lowercase drive letter]
    #
    # 2. Replace backslashes with slashes
    #
    # 3. Remove carriage return
    downloads=$(echo $downloads | sed -r 's/(([A-Z]{1}):)(\\.*)/\/mnt\/\l\2\3/g' | sed 's/\\/\//g' | sed 's/\r$//')

    local folder=$(get_uuid)
    while [ -d $downloads/$folder ]
    do
        folder=$(get_uuid)
    done

    git clone https://github.com/powerline/fonts.git ./$folder

    # copy the repository to the Windows file system
    # mv would try to retain permissions and ownership across file systems which would fail
    cp -R ./$folder $downloads
    rm -rf ./$folder

    cd $downloads/$folder

    powershell.exe -File .\\install.ps1

    cd ..
    rm -rf $downloads/$folder
}

main()
{
    cd $HOME

    setup_prerequisites
    setup_zsh
    setup_powerline

    # TODO: git config

    exec zsh -l
}

# Invoke main with all the parameters passed to the script
main "$@"
