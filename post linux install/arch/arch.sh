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

yay_packages=(
    "visual-studio-code-bin" 
    "google-chrome"
    "git"
    "discord"
    "nodejs"
    "npm"
    "steam"
    "obs-studio"
    "nano"
    "zsh"
    "vlc"
    "spotify"
    "xampp"
)

log_file="arch-install.log"

echo "##########################################################"
echo "###           ARCH BASED POST INSTALL SCRIPT           ###"
echo "###                                                    ###"
echo "###           MADE WITH LOVE BY 'Luciousdev'           ###"
echo "###                    luciousdev.nl                   ###"
echo "##########################################################"

echo -e "$CWR - This script requires root privileges!"
# Function to log output to the log file
log() {
  echo -e "$1" | tee -a "$log_file"
}

# Function to handle errors
handle_error() {
  log "$CER - An error occurred. Exiting..."
  exit 1
}

# Function to install packages with error handling
install_packages() {
  local packages=("$@")
  yay -S --answerdiff=None --noconfirm "${packages[@]}" | tee -a "$log_file" || {
    log "$CER - Failed to install packages."
    handle_error
  }
  log "$COK - Successfully installed packages."
}

sleep 1

if ! command -v yay &> /dev/null; then
    log "$CAT - yay is not installed. Installing..."
  
    # Install yay using yay's official installation command
    sudo pacman -S --noconfirm yay || handle_error
    log "$COK - successfully installed yay. Continuing with the script."
fi
log "$CNT - yay is already installed"

log "$CNT - The script will install the following packages:"
for package in "${yay_packages[@]}"; do
  log "- $package"
done
log "Do you accept these changes? [y/n/c]"
read accept_changes

if [[ $accept_changes =~ ^[Yy]$ ]]; then
  log "$CPR - Installing packages..."
  install_packages "${yay_packages[@]}"
elif [[ $accept_changes =~ ^[Nn]$ ]]; then
  log "$CER - User did not accept changes. Exiting..."
  exit 1
else 
  log "$CWE - Continuing script. Note that this can cause bugs..."
fi

clear

echo "#############################################"
echo "###           GIT CONFIGURATION           ###"
echo "#############################################"

echo "Would you like to configure git? [y/n]"
read configure_git

if [[ $configure_git =~ ^[Yy]$ ]]; then
    echo -e "$CIN Please enter your github username:"
    read git_username
    echo -e "$CIN Please enter your github email:"
    read git_email

    # Git configuration
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"

    log "$COK - Successfully configured git"
elif [[ $configure_git =~ ^[Nn]$ ]]; then
    clear
    log "$CWE - Skipped git configuration"
else 
    log "$CER - Option doesn't exist. Exiting..."
    exit 1
fi

clear

echo "#############################################"
echo "###           ZSH CONFIGURATION           ###"
echo "#############################################"

echo "Would you like to configure and install ohmyzsh? [y/n]"
read zsh_config

if [[ $zsh_config =~ ^[Yy]$ ]]; then
    log "$CNT - Starting ohmyzsh install"
    zsh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    log "$COK - Completed ohmyzsh install"
    echo -e "$CNT - You can find built-in ohmyzsh themes here: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes"
    log "$CNT - Starting ohmyzsh theme configuration"
    echo -e "$CIN - Which theme would you like to use?"
    read new_theme

    log "$CNT - Loading default config now"
    # Update the Zsh configuration file
    sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"$new_theme\"/" ~/.zshrc || handle_error

    log "$COK - Successfully configured ohmyzsh"
    exec zsh
elif [[ $zsh_config =~ ^[Nn]$ ]]; then
    clear
    log "$CWE - Skipped zsh configuration"
else 
    log "$CER - Option doesn't exist. Exiting..."
    exit 1
fi

clear


echo "#############################################"
echo "###          FSTAB CONFIGURATION          ###"
echo "#############################################"

echo "Would you like to setup any SMB shares? [y/n]"
read fstab_config

if [[ $fstab_config =~ ^[Yy]$ ]]; then
  # Retrieve info about the SMB share
  read -p "${CIN} What is the address of your SMB share? (e.g. 192.168.0.10/server) " addres 
  read -p "${CIN} What is the username of your SMB share? (e.g. user) " username
  read -p "${CIN} What is the password of your SMB share? (e.g. password123) " password
  read -p "${CIN} Where would you like to mount the SMB share? (e.g. /home/lucy/mounts/server) " mountpoint

  # Get the group and user id of the current user.
  uid=$(id -u)
  gid=$(id -g)

  # Create the mountpoint if it doesn't exist
  mkdir -p "$mountpoint"

  # Add the mount to fstab
  fstabline="//$addres $mountpoint cifs username=$username,password=$password,uid=$uid,gid=$gid,noauto,x-systemd.automount,x-systemd.device-timeout=10,rw,file_mode=0755,dir_mode=0755"  
  echo "$fstabline" | sudo tee -a /etc/fstab >/dev/null

  if [ $? -eq 0 ]; then
      log "$COK - Added the line to /etc/fstab"
  else
      log "$CER - Failed to add the line to /etc/fstab"
      sleep 2
      exit 1
  fi

  # Mount the SMB share using sudo
  log "$CNT - Attempting to mount all shares"
  sudo mount -a

  if [ $? -eq 0 ]; then
      log "$COK - Successfully mounted the SMB share"
      log "$CWR - Sometimes you might need to restart before you can access your share."
      sleep 2
  else
      log "$COK - Failed to mount the SMB share"
      sleep 2
      exit 1
  fi
elif [[ $fstab_config =~ ^[Nn]$ ]]; then
    clear
    log "$CWE - Skipped fstab configuration"
else 
    log "$CER - Option doesn't exist. Exiting..."
    exit 1
fi

clear
log "$COK - Script finished successfully. Exiting..."
echo -e "$CNT - You can support the project on github https://github.com/Luciousdev/random-shell-scripts
For questions you can add me on discord 'luciousdev'
Made with love <3"

exit 0