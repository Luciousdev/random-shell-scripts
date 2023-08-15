#!/bin/bash

# Wallpaper changer
# This script will change the wallpaper every 5 minutes
# You can change the time by changing the sleep time
# THIS SCRIPT ASSUMES THAT YOU HAVE SWWW INSTALLED WITH A PROPER WORKING SCRIPT TO CHANGE THE WALLPAPER
# AN EXAMPLE SCRIPT WILL ALSO BE IN THIS REPO


while true; do 
    sh $HOME/.config/hypr/scripts/Wallpaper.sh
    sleep 300
done