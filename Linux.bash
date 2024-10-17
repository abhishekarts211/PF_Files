
Shell Script::::

A Shell script is a text file containing a series of commands that are executed by a Unix-like operating system’s shell, 
such as Bash, Zsh, or Sh. It’s essentially a way to automate tasks and manage system operations through command-line instructions.

Here are some key points about Shell scripts:

Purpose: Shell scripts are used to automate repetitive tasks, manage system operations, perform batch processing, 
and execute complex sequences of commands. They can be used for anything from simple file manipulations to complex system administration tasks.

Syntax: Shell scripts use the syntax of the shell they are written for. For instance, a script written for Bash will use Bash syntax. 
Common commands include file operations (ls, cp, rm), text processing (grep, awk, sed), and program execution (./myprogram).

Shebang Line: A Shell script usually starts with a shebang line (e.g., #!/bin/bash), which tells the operating system which interpreter 
to use to execute the script. This line is optional but recommended for clarity.

Execution: To run a Shell script, you typically need to make it executable with chmod +x scriptname.sh and then execute it with ./scriptname.sh.

Variables and Control Structures: Shell scripts can use variables, control structures (like if, for, and while loops), and functions to perform 
complex logic and calculations.

Error Handling: Good Shell scripts include error handling to manage and respond to issues that may arise during execution.

Portability: While many Shell scripts are written for specific shells like Bash or Zsh, they can often be made portable across different 
Unix-like systems if they adhere to standard commands and practices.

Shell scripts are a powerful tool for system administrators, developers, and anyone who needs to automate tasks in a Unix-like environment.


**************************************************************************************************************************************************************

List of basic Linux commands that are very useful for managing and navigating a Linux system:

File and Directory Operations
ls - Lists files and directories.

ls -l - Long listing format.
ls -a - Includes hidden files.
cd - Changes the current directory.

cd /path/to/directory - Navigate to the specified directory.
cd .. - Move up one directory level.
pwd - Prints the current working directory.

cp - Copies files or directories.

cp source destination - Copies a file.
cp -r source_directory destination_directory - Copies a directory recursively.
mv - Moves or renames files or directories.

mv source destination - Moves or renames a file or directory.
rm - Removes files or directories.

rm file - Deletes a file.
rm -r directory - Recursively deletes a directory and its contents.
mkdir - Creates a new directory.

mkdir directory_name - Creates a new directory.
rmdir - Removes an empty directory.

rmdir directory_name - Deletes an empty directory.

File Viewing and Editing
cat - Concatenates and displays file content.

cat file - Shows the content of a file.
less - Views file content one screen at a time.

less file - Opens a file for paginated viewing.
head - Displays the first few lines of a file.

head file - Shows the first 10 lines by default.
tail - Displays the last few lines of a file.

tail file - Shows the last 10 lines by default.
nano or vim - Text editors for editing files.

nano file - Opens the file in the Nano editor.
vim file - Opens the file in the Vim editor.

System Information
df - Displays disk space usage.

df -h - Shows disk usage in a human-readable format.
du - Displays disk usage of files and directories.

du -h - Shows sizes in a human-readable format.
top - Displays real-time system processes and resource usage.

ps - Shows current processes.

ps aux - Displays detailed information about running processes.
free - Shows memory usage.

free -h - Displays memory usage in a human-readable format.
uname - Displays system information.

uname -a - Shows all available system information.
whoami - Displays the current user’s username.

File Permissions and Ownership
chmod - Changes file permissions.

chmod 755 file - Sets read, write, and execute permissions for the owner, and read and execute permissions for others.
chown - Changes file owner and group.

chown user:group file - Changes the owner and group of a file.
chmod - Changes file permissions.

chmod +x script.sh - Adds execute permission to a file.

Networking
ping - Checks network connectivity.

ping host - Pings the specified host to check connectivity.
ifconfig or ip - Displays or configures network interfaces.

ifconfig - Shows network interfaces (older command).
ip a - Shows network interfaces (newer command).
netstat - Displays network connections, routing tables, and interface statistics.

File Search and Find
find - Searches for files and directories.

find /path -name filename - Searches for files with the specified name.
grep - Searches for patterns in files.

grep pattern file - Searches for the specified pattern in a file.
locate - Quickly finds files by name (requires an updated database).

locate filename - Finds files by name.

These commands form the basis of many tasks you might perform in a Linux environment and are fundamental for effective system management.


*********************************************************************************************************************************************************

awk command in Linux is a powerful text-processing tool used for pattern scanning and reporting. It's commonly employed to process 
and analyze text files and data streams. awk operates on files line by line and can perform various tasks such as filtering lines, 
extracting fields, and performing calculations.

Basic Syntax
The basic syntax for awk is:

awk 'pattern { action }' file

pattern: The condition or pattern to match in each line of the file.
action: The operation to perform on lines that match the pattern.
file: The file to process (if omitted, awk reads from standard input).

Common Examples

Print Specific Columns

To print specific columns from a file, you can use:

awk '{ print $1, $3 }' filename
This prints the first and third columns of each line in filename.

Print Lines Matching a Pattern
To print lines that contain a specific string:

awk '/pattern/' filename
This prints all lines from filename that contain pattern.

Field Separator
By default, awk uses whitespace as the field separator. To use a different delimiter, specify it with the -F option:

awk -F ',' '{ print $1, $2 }' filename
This uses a comma as the field separator and prints the first and second fields.

Sum a Column
To sum the values in a specific column:

awk '{ sum += $1 } END { print sum }' filename
This sums up all values in the first column and prints the result.

Print Line Numbers
To print each line with its line number:

awk '{ print NR, $0 }' filename
NR is a built-in variable that holds the current record number (line number).

Conditional Statements
To print lines where the value in a specific column is greater than a threshold:

awk '$3 > 50 { print $1, $3 }' filename
This prints the first and third columns where the value in the third column is greater than 50.

Formatted Output
To format output with specific widths:

awk '{ printf "%-10s %-5s\n", $1, $2 }' filename
This prints the first and second columns with specified widths.

Using awk with Pipes
You can also use awk with output from other commands:

ls -l | awk '{ print $9 }'
This lists file names (the ninth field) from the output of ls -l.


How to extract logs for any time duration
awk '$0>=from && $0<=to' from="2024-09-04 10:00:00" to="2024-09-04 10:10:00" /opt/SSO/pingfederate-12.1.1/pingfederate/log/audit.2024-09-04.log

If you want to store the extracted  log in any file
awk '$0>=from && $0<=to' from="2024-09-04 09:30:00" to="2024-09-04 12:30:00" /opt/SSO/pingfederate-12.1.1/pingfederate/log/audit.2024-09-04.log >> /tmp/auditfile.txt


How to extract logs for particular application in any time duration
awk '$0>=from && $0<=to' from="2024-09-04 10:00:00" to="2024-09-04 10:10:00" /opt/SSO/pingfederate-12.1.1/pingfederate/log/audit.2024-09-04.log |grep –i “ConnectionID"


How to get the Application hits for a Particular Application for Any time duration
awk '$0>=from && $0<=to' from="2024-09-04 10:00:00" to="2024-09-04 10:10:00" /opt/SSO/pingfederate-12.1.1/pingfederate/log/audit.2024-09-04.log | grep -i "connectionID" |wc -l

How to find the RHEL version or linux version installed in your system
less /etc/os-release

======================================================================================================

In Linux, the $? variable is used to check the exit status of the last executed command. The exit status is a numerical 
value returned by a command to indicate whether it succeeded or failed. This value is crucial for scripting and troubleshooting, 
as it helps determine if the previous command executed correctly or if there was an error.


Understanding $?

Success (0): An exit status of 0 generally indicates that the command completed successfully without any errors.

Failure (non-zero): Any non-zero exit status indicates that an error occurred. The specific non-zero value can provide more details about the type of error.


Common Exit Status Codes

0: Success
1: General error (e.g., command not found)
2: Misuse of shell builtins (e.g., syntax errors)
126: Command found but not executable
127: Command not found
128: Invalid argument to exit

By checking the $? variable, you can make your scripts more robust and handle errors more gracefully.


#!/bin/bash

# Run a command
cp file1.txt /some/directory/

# Check if the command succeeded
if [ $? -eq 0 ]; then
    echo "File copied successfully."
else
    echo "Failed to copy file."
fi






===================================================================================================================

Key Concepts in Shell Scripting

Shebang (#!/bin/bash): Specifies the script interpreter.

Variables: Store and use data within scripts (VAR=value).

Conditional Statements: Control flow based on conditions (if [ condition ]; then ... fi).

Loops: Repeat actions (for ...; do ... done, while ...; do ... done).

Functions: Group commands into reusable blocks.

File Operations: Perform tasks on files (e.g., mv, tar, ls).



===============================================================================================================


Hello World Script
This is the simplest example of a Shell script that prints "Hello, World!" to the terminal.

#!/bin/bash
# This is a simple Shell script that prints "Hello, World!"

echo "Hello, World!"

================================================================================================================
Script to Check Disk Usage
This script checks and reports the disk usage of the root filesystem.

#!/bin/bash
# This script reports disk usage for the root filesystem

echo "Disk usage for the root filesystem:"
df -h /

=====================================================================================

Script to Backup Files
This script creates a backup of a specified directory.

#!/bin/bash
# This script creates a backup of a specified directory

# Check if exactly 2 arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_directory> <backup_directory>"
    exit 1
fi

SOURCE_DIR=$1
BACKUP_DIR=$2
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
BACKUP_FILE="$BACKUP_DIR/backup_$DATE.tar.gz"

# Create a tar.gz archive of the source directory
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

echo "Backup of $SOURCE_DIR created at $BACKUP_FILE"


=============================================================================================

Script to Print System Information
This script prints some basic system information.

#!/bin/bash
# This script prints basic system information

echo "System Information:"
echo "------------------"
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime -p)"
echo "Current Date and Time: $(date)"
echo "Current User: $(whoami)"
echo "Memory Usage:"
free -h
echo "Disk Usage:"
df -h

===================================================================================================



Hourly Data Monitoring Shell Script



#!/bin/bash

# Check if exactly 2 arguments are provided
if [ $# -ne 2 ]
then
    # Print usage message and exit if the number of arguments is not 2
    echo 'usage: sh `basename $0` <date> <application ID>'
    exit 1
fi

# Print the first and second arguments
echo "$1 $2"

# Assign the second argument (Entity ID) to the variable `EntityID`
EntityID=$2

# Convert the first argument (date) to the format 'YYYY-MM-DD'
date_0=$(date -d "$1" +'%Y-%m-%d')

# Create a filename based on the formatted date
file_name="audit."$date_0".log"

# Append ' 09:00:00' to the date string and convert it to seconds since epoch
date_0=$date_0" 05:00:00"
date_0=$(date -d "$date_0" '+%s')

# Print the generated filename and the converted date in epoch seconds
echo "$file_name :: $date_0"

# Initialize a counter for hours (1 to 24)
i=1

# Loop through each hour of the day (1 to 24)
while [ $i -le 24 ]
do
    # Convert the current epoch time back to a human-readable date format for the 'from' time
    from_0=$(date -d @"$date_0" '+%F %T')
    
    # Increment the epoch time by 3600 seconds (1 hour)
    date_0=$((date_0+3600))
    
    # Convert the updated epoch time back to a human-readable date format for the 'to' time
    to_0=$(date -d @"$date_0" '+%F %T')
    
    # Use `awk` to filter the log file based on the 'from' and 'to' times, and count occurrences of `EntityID`
    value=$(awk '$0>=from && $0<=to' from="$from_0" to="$to_0" /opt/SSO/pingfederate-12.1.1/pingfederate/log/"$file_name" | grep -i "$EntityID" | wc -l)
    
    # Print the hour counter, 'from' and 'to' times, and the count of occurrences
    echo "$i :: $from_0 :: $to_0 :: $value"
    
    # Increment the hour counter
    i=$(($i+1))
done


Mail Trigger																																																																																																																							
echo -e "Hi Team,\n\n\nPlease find the attached Hourly Application count report which needs to be send to client after 
proper analysis.\n\n\n\nBest Regards,\nSSO Team" | mailx -s "Hourly Application count report" -a HourlyAppCount.csv abc@company.com


																																																																																																																							
																																																																																																																							
==================================================================================================================================================																																																																																																																							

																																																																																																																							
																																																																																																																							

Crontab is a utility in Unix-like operating systems used to schedule and automate the execution of scripts or commands at specified times and intervals. It's particularly useful for automating repetitive tasks such as backups,
system monitoring, and regular maintenance.


Basic Concepts
Cron Daemon: A background service that executes scheduled tasks.
Crontab File: A file that contains a list of commands and their schedules. Each user can have their own crontab file.


Crontab Syntax
The syntax of a crontab file is as follows:

* * * * * command_to_execute
- - - - -
| | | | |
| | | | +---- Day of the week (0 - 7) (Sunday is both 0 and 7)
| | | +------ Month (1 - 12)
| | +-------- Day of the month (1 - 31)
| +---------- Hour (0 - 23)
+------------ Minute (0 - 59)


Common Crontab Commands:


View/Edit Crontab File
To view or edit the crontab file for the current user:

crontab -e
This opens the crontab file in the default text editor.


List Crontab Entries
To list the current crontab entries for the user:

crontab -l


Remove Crontab
To remove the current crontab file:

crontab -r


Backup and Restore Crontab

Backup: Save the crontab to a file:
crontab -l > my_crontab_backup.txt

Restore: Load the crontab from a file:
crontab my_crontab_backup.txt





Examples of Cron Jobs:


Run a Script Every Day at Midnight

0 0 * * * /path/to/your/script.sh

This entry runs script.sh every day at midnight.



Run a Command Every Hour

0 * * * * /path/to/your/command

This runs the command at the start of every hour.




Run a Script Every Monday at 5 AM

0 5 * * 1 /path/to/your/script.sh

This runs script.sh every Monday at 5 AM.




Run a Command Every 15 Minutes

*/15 * * * * /path/to/your/command

This runs the command every 15 minutes.




Run a Script on the 1st of Every Month at 3 AM

0 3 1 * * /path/to/your/script.sh

This runs script.sh on the 1st of every month at 3 AM.





Run a Command Every 5 Minutes Between 9 AM and 5 PM

*/5 9-17 * * * /path/to/your/command

This runs the command every 5 minutes during working hours (9 AM to 5 PM).



Special Strings

Crontab also supports special strings for common scheduling scenarios:

@reboot: Run once at system startup.
@daily or @midnight: Run once a day at midnight.
@hourly: Run once an hour.
@daily: Same as 0 0 * * *.
@weekly: Run once a week (Sunday at midnight).
@monthly: Run once a month (first day of the month at midnight).
@yearly or @annually: Run once a year (January 1st at midnight).


Example Using Special Strings

To run a script at system startup:

@reboot /path/to/your/script.sh


Error Handling and Logging
To capture the output and errors from a cron job, redirect them to a log file:

0 0 * * * /path/to/your/script.sh >> /path/to/logfile.log 2>&1

>> /path/to/logfile.log appends standard output to the log file.
2>&1 redirects standard error to the same location as standard output.










