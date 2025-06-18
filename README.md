Absolutely! Here's a simpler version of your text with the same meaning:

---

**Submission Reminder App (Bash-based)**  
This app helps teachers and students keep track of assignment submissions using the terminal. It reminds users about pending assignments and checks who hasn’t submitted yet.

### What the App Does:
- Creates a folder with all necessary files and setup
- Tracks which students have submitted assignments
- Shows who hasn't submitted yet
- Lets you choose which assignment to monitor
- Runs a script to display reminders in the terminal

### How to Get Started:
1. **Download the project** (use `git clone` or download the folder).
2. **Run `create_environment.sh`**  
   - Enter your name when asked  
   - A folder named `submission_reminder_yourname` will be created with everything you need
3. **Run `copilot_shell_script.sh` to set up the assignment**  
   - Enter the folder you want to check  
   - Choose the assignment name (e.g., Git, Shell Navigation)  
   - Enter how many days are left before the deadline
4. **Run the app**  
   - It usually starts after setup, but you can also start it manually with `./submission_reminder_yourname/startup.sh`  
   - The script reads the assignment, checks the `submissions.txt`, and shows who hasn’t submitted

### Rules:
- Names must have only letters and spaces  
- Assignment names must also have only letters and spaces (e.g., Shell Basics)  
- Days remaining must be a number  
- The assignment name must already exist in `submissions.txt`

