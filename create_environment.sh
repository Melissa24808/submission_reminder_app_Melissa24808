#!/bin/bash
# We have to ask the user to input the his/her name (Will be needed to create the folder)                                             
read -p "Enter your name: " yourName
DIR="submission_reminder_$yourName"
mkdir -p "$DIR"
mkdir -p "$DIR/app"
mkdir -p "$DIR/modules"
mkdir -p "$DIR/assets"
mkdir -p "$DIR/config"
touch "$DIR/app/reminder.sh"
touch "$DIR/modules/functions.sh"
touch "$DIR/assets/submissions.txt"
touch "$DIR/config/config.env"
touch "$DIR/startup.sh"
