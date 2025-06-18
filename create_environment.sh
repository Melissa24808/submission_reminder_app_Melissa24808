#!/bin/bash
# We have to ask the user to input the his/her name (Will be needed to create the folder)                                             
read -p "name: " yourName

if [ -z "$yourName" ]; then
        echo "please i need your name."
        echo "---------------------------"
        echo "delete..."
        echo "--- --- --- --- --- --- ---"
        exit 1
fi

# Name not a number

if ! [[ "$yourName" =~ ^[a-zA-Z\s]+$ ]]; then
    echo "The inputed name must contain only letters."
    echo "delete..."
    exit 1
fi

Dir="submission_reminder_$yourName"

if [ -d "$Dir" ]; then
        echo "Directory  exists."
        echo "-------------------------"
        echo "delete"
        echo "-------------------------"
        exit 1
else
        mkdir -p "$Dir"
        echo " Directory  created successfully."
        echo "---------------------------------------"
        echo " Finalising of  the environment"
        
fi

mkdir -p "$Dir/app"
mkdir -p "$Dir/modules"
mkdir -p "$Dir/assets"
mkdir -p "$Dir/config"

[ ! -f "$Dir/app/reminder.sh" ] && touch "$Dir/app/reminder.sh"
[ ! -f "$Dir/modules/functions.sh" ] && touch "$Dir/modules/functions.sh"
[ ! -f "$Dir/assets/submissions.txt" ] && touch "$Dir/assets/submissions.txt"
[ ! -f "$Dir/config/config.env" ] && touch "$Dir/config/config.env"
[ ! -f "$Dir/startup.sh" ] && touch "$Dir/startup.sh"

echo '
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
' >> $Dir/app/reminder.sh

echo '
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
' >> $Dir/modules/functions.sh

echo '
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
' >> $Dir/assets/submissions.txt

echo '
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
' >> $Dir/config/config.env

cat <<EOL >> "$Dir/assets/submissions.txt"
Melissa, Git, not submitted
Axel, Shell Navigation, submitted
Arnaud, Git, not submitted
Lambert, Shell Basics, not submitted
Kenza, Shell Navigation, submitted
EOL

echo '
#!/bin/bash
cd "$(dirname "$0")"
bash ./app/reminder.sh
' >> $Dir/startup.sh

# Filtering '.sh' files to add the the execution command to it

chmod +x "$Dir/app/reminder.sh"
chmod +x "$Dir/modules/functions.sh"
chmod +x "$Dir/startup.sh"
