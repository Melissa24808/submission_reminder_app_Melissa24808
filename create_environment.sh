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
' >> $DIR/app/reminder.sh

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
' >> $DIR/modules/functions.sh

echo '
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
' >> $DIR/assets/submissions.txt

echo '
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
' >> $DIR/config/config.env
echo '
#!/bin/bash

bash ./app/reminder.sh
' >> $DIR/startup.sh

# Filtering '.sh' files to add the the execution command to it

chmod +x "$DIR/app/reminder.sh"
chmod +x "$DIR/modules/functions.sh"
chmod +x "$DIR/startup.sh"
