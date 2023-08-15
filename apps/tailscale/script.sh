#!/bin/bash

# Set some colors
CNT=$(tput setaf 7)$(tput bold)"["$(tput sgr0)$(tput setaf 6)$(tput bold)NOTE$(tput sgr0)$(tput setaf 7)$(tput bold)"]"$(tput sgr0)
COK=$(tput setaf 7)$(tput bold)"["$(tput sgr0)$(tput setaf 2)$(tput bold)OK$(tput sgr0)$(tput setaf 7)$(tput bold)"]"$(tput sgr0)
CER=$(tput setaf 7)$(tput bold)"["$(tput sgr0)$(tput setaf 1)$(tput bold)ERROR$(tput sgr0)$(tput setaf 7)$(tput bold)"]"$(tput sgr0)
CAT=$(tput setaf 7)$(tput bold)"["$(tput sgr0)$(tput setaf 7)$(tput bold)ATTENTION$(tput sgr0)$(tput setaf 7)$(tput bold)"]"$(tput sgr0)
CWR=$(tput setaf 7)$(tput bold)"["$(tput sgr0)$(tput setaf 5)$(tput bold)WARNING$(tput sgr0)$(tput setaf 7)$(tput bold)"]"$(tput sgr0)
CAC=$(tput setaf 7)$(tput bold)"["$(tput sgr0)$(tput setaf 3)$(tput bold)ACTION$(tput sgr0)$(tput setaf 7)$(tput bold)"]"$(tput sgr0)
CIN=$(tput setaf 7)$(tput bold)"["$(tput sgr0)$(tput setaf 4)$(tput bold)INPUT$(tput sgr0)$(tput setaf 7)$(tput bold)"]"$(tput sgr0)
CDE=$(tput setaf 7)$(tput bold)"["$(tput sgr0)$(tput setaf 7)$(tput bold)DEBUG$(tput sgr0)$(tput setaf 7)$(tput bold)"]"$(tput sgr0)
CPR=$(tput setaf 7)$(tput bold)"["$(tput sgr0)$(tput setaf 7)$(tput bold)PROGRESS$(tput sgr0)$(tput setaf 7)$(tput bold)"]"$(tput sgr0)

# Set some variables
log_file="tailscale-install.log"


echo "##########################################################"
echo "###              TAILSCALE INSTALL SCRIPT              ###"
echo "###                                                    ###"
echo "###           MADE WITH LOVE BY 'Luciousdev'           ###"
echo "###                    luciousdev.nl                   ###"
echo "##########################################################"

if [ "$EUID" -ne 0 ]; then
    echo -e "$CWR - This script requires root privileges!"
    log "$CER - Please run this script as root!"
    exit 1
fi

# Function to log output to the log file
log() {
  echo -e "$1" | tee -a "$log_file"
}

# Function to handle errors
handle_error() {
  log "$CER - An error occurred. Exiting..."
  exit 1
}

# check if it is an arch based distro
if ! command -v pacman &> /dev/null; then
    log "$CIN YOU'RE RUNNING AN ARCH BASED DISTRO."
    if ! command -v yay &> /dev/null; then
        log "$CAT - yay is not installed. Installing..."

        # Install yay using yay's official installation command
        sudo pacman -Syu --noconfirm yay || handle_error
        log "$COK - successfully installed yay. Continuing with the script."
    fi

    clear

    log "$CIN - Would you like to install TailScale admin client? [y/n]"
    read admin

    if [[ $admin =~ ^[Yy]$ ]]; then
        log "$CWR - Installing TailScale admin client..."
        yay -Syu --noconfirm tailscaledesktop || handle_error
    fi    
fi

clear

echo "##########################################################"
echo "###                                                    ###"
echo "###                INSTALLING TAILSCALE NOW            ###"
echo "###                                                    ###"
echo "##########################################################"


if ! command -v tailscale &> /dev/null; then
    log "$CAT - tailscale is not installed. Installing..."

    # Install tailscale using yay
    curl -fsSL https://tailscale.com/install.sh | sh || handle_error
    log "$COK - successfully installed tailscale. Continuing with the script."
fi

clear

log "$CIN - Would you like to run tailscale? [y/n]"
read run

if [[ $run =~ ^[Yy]$ ]]; then
    log "$CWR - Starting tailscale..."
    sudo tailscale up --accept-routes || handle_error
    log "$COK - Sucessfully started tailscale, it will run in the background"
    exit 1
else
    log "$CIN - Not running tailscale. Exiting..."
    exit 1
fi