#!/bin/bash

# Set some colors
CNT="[\033[1;36mNOTE\033[0m]"
COK="[\033[1;32mOK\033[0m]"
CER="[\033[1;31mERROR\033[0m]"
CAT="[\033[1;37mATTENTION\033[0m]"
CWR="[\033[1;35mWARNING\033[0m]"
CAC="[\033[1;33mACTION\033[0m]"
CIN="[\033[1;34mINPUT\033[0m]"
CDE="[\033[1;37mDEBUG\033[0m]"
CPR="[\033[1;37mPROGRESS\033[0m]"

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
)

log_file="arch-install.log"

# Function to log output to the log file
log() {
  echo -e "$1" | tee -a "$log_file"
}

clear

if ! command -v yay &> /dev/null; then
    log "$CAT - yay is not installed. Installing..."
  
    # Install yay using yay's official installation command
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
    log "$COK - successfully installed yay. Continuing with the script."
fi
log "$CNT - yay is already installed"

log "$CNT - The script will install the following packages:"
for package in "${yay_packages[@]}"; do
  log "- $package"
done
log "Do you accept these changes? [y/n/c]"
read accept_changes

if [[ $accept_changes == "y" || $accept_changes == "Y" ]]; then
  log "$CPR - Installing packages..."
  yay -S --answerdiff=None --noconfirm "${yay_packages[@]}" | tee -a "$log_file"
  log "$COK - Successfully installed packages."
elif [ $accept_changes == "n"]; then
  log "$CER - User did not accept changes. Exiting..."
  exit 1
else 
    log "$CWE - Continuining script. Not this can cause bugs..."
fi

clear

echo "#############################################"
echo "###           GIT CONFIGURATION           ###"
echo "#############################################"

echo "Would you like to configure git? [y/n/c]"
read configure_git

if [[ $configure_git == "y" || $configure_git == "Y" ]]; then
    echo -e "$CIN Please enter your github username:"
    read git_username
    echo -e "$CIN Please enter your github email:"
    read git_email

    # Git configuration
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"

    log "$COK - Successfully configured git"
elif [[ $accept_changes == "n" || $configure_git == "N" ]]; then
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

if [[ $zsh_config == "y" || $zsh_config == "Y" ]]; then
    log "$CNT - Starting ohmyzsh install"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    log "$COK - Completed ohmyzsh install"
    echo -e "$CNT - You can find built-in ohmyzsh themes here: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes"
    echo -e "$CIN - Which theme would you like to use?"
    read new_theme

    log "$CNT - Loading default config now"
    # Update the Zsh configuration file
    sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"$new_theme\"/" ~/.zshrc

    # Reload the Zsh configuration
    source ~/.zshrc

    log "$COK - Successfully configured ohmyzsh"
elif [[ $zsh_config == "n" || $zsh_config == "N" ]]; then
    clear
    log "$CWE - Skipped zsh configuration"
else 
    log "$CER - Option doesn't exist. Exiting..."
    exit 1
fi

log "$COK - Script finished successfully. Exiting..."