#!/bin/bash

# Asking the user to enter his/her name

read -p "Enter the same name as entered in the environment folder name: " userName
if [ -z "$userName" ]; then
        echo "Name please"
        echo "-------------------------"
        echo "delete..."
        exit 1
fi
if ! [[ "$userName" =~ ^[a-zA-Z\s]+$ ]]; then
    echo " name must contain."
    echo "only letters and spaces"
    echo "delete..."
    exit 1
fi
# Adding the variable to the directory and declaring variables

Dir="submission_reminder_$userName"
submissions_file="$Dir/assets/submissions.txt"

# Checking if the directory exists
if [ ! -d "$Dir" ]; then
        echo "Directory '$Dir' not found"
        echo "Please run create_environment.sh."
        echo "delete..."
        exit 1
fi

# Prompt for the assignment and the days remaining
read -p " Assignment: " summative
read -p "Day: " day

# Sanitazing the variables input
summative=$(echo "$summative" | sed "s/$(echo -e '\u00a0')/ /g" | tr -cd '[:alnum:] [:space:]' | xargs)

day=$(echo "$day" | xargs)

echo "DEBUG: [$summative]"

# Input validation

# Checking if the Assignment name ain't empty and that the Days are numbers
if [ -z "$summative" ] || ! [[ "$day" =~ ^[0-9]+$ ]]; then
    echo "The Assignment empty."
    echo "and"
    echo "No number for days."
    echo "------------------------------"
    echo "delete..."
    exit 1
fi

# Checking if the Assignment name ain't numerical
if ! echo "$summative" | grep -qE '^[A-Za-z ]+$'; then
    echo "The Assignment name must contain."
    echo "only letters and spaces"
    echo "delete..."
    exit 1
fi

# Checking if the assignment exists in submissions.txt

matched_assignment=$(grep -i ", *$summative," "$submissions_file" | awk -F',' '{print $2}' | head -n1 | xargs)

if [ -z "$matched_assignment" ]; then
    echo "Assignment '$summative' isn't found in submissions.txt"
    echo "Try again"
    echo "delete.."
    exit 1
fi

# Update config.env

echo "Updating config.env in $Dir/config/"
echo "ASSIGNMENT=\"$matched_assignment\"" > "$Dir/config/config.env"
echo "DAYS_REMAINING=$day" >> "$Dir/config/config.env"

echo "Configuration updated:"
cat "$Dir/config/config.env"

# Ask if they want to start the app
read -p "run the reminder app now? (y/n): " on_you

if [[ "$on_you" =~ ^[Yy]$ ]]; then
    echo "Starting the app."
    bash "$Dir/startup.sh"
    echo " app  running"
    
else
    echo "Reminder app not started."
    echo "You can run it later using: bash $Dir/startup.sh"
    
fi


