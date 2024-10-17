
PowerShell Script:

A PowerShell script is a file containing a series of PowerShell commands that are executed in sequence. 
PowerShell itself is a powerful scripting language and command-line shell developed by Microsoft, designed for task automation 
and configuration management. It combines the capabilities of the command line with a scripting language that allows for more complex 
and automated operations.

Here are some key aspects of PowerShell scripts:

File Extension: PowerShell scripts typically have the .ps1 file extension.

Syntax: The syntax of PowerShell is similar to other scripting languages but is tailored for managing and automating Windows systems. It uses cmdlets (built-in functions) and can also leverage .NET classes.

Commands: PowerShell scripts can include a variety of commands, such as file manipulations, system configurations, and administrative tasks. For example, commands to get information about system processes, manage user accounts, or configure network settings.

Pipelines: PowerShell supports the concept of pipelines, where the output of one command can be passed as input to another command, allowing for powerful and flexible data processing.

Variables and Control Flow: PowerShell scripts support variables, loops, and conditional statements, making it possible to create sophisticated logic in your scripts.

Remote Management: PowerShell can execute scripts on remote computers, making it useful for managing multiple systems from a single location.

Modules: PowerShell scripts can use modules, which are packages of cmdlets, functions, and other resources that extend PowerShell's functionality.

Example of a Simple PowerShell Script
Here's a basic example of a PowerShell script that retrieves a list of all running processes on the local computer and exports it to a CSV file:

powershell

# Get a list of all running processes
$processes = Get-Process

# Export the process list to a CSV file
$processes | Export-Csv -Path "C:\Temp\RunningProcesses.csv" -NoTypeInformation


Get-Process retrieves a list of running processes.
Export-Csv exports the data to a CSV file at the specified path.


==============================================================================================

List of basic PowerShell commands that are essential for anyone starting with PowerShell. 
These commands cover a range of functionalities, including file management, system information, and process handling.

File and Directory Management:::

Get-ChildItem (gci, dir)
Lists files and directories in a specified location.
Example: Get-ChildItem -Path C:\Users

Set-Location (cd, sl)
Changes the current directory.
Example: Set-Location -Path C:\Windows

New-Item (ni)
Creates a new file or directory.
Example: New-Item -Path C:\Temp\NewFile.txt -ItemType File

Remove-Item (rm, del)
Deletes files or directories.
Example: Remove-Item -Path C:\Temp\OldFile.txt

Copy-Item (cp)
Copies files or directories.
Example: Copy-Item -Path C:\Temp\Source.txt -Destination C:\Temp\Destination.txt

Move-Item (mv)
Moves files or directories.
Example: Move-Item -Path C:\Temp\OldFile.txt -Destination C:\Temp\Archive\OldFile.txt

Rename-Item (ren)
Renames a file or directory.
Example: Rename-Item -Path C:\Temp\OldName.txt -NewName NewName.txt

Get-Content (cat, gc)
Displays the content of a file.
Example: Get-Content -Path C:\Temp\File.txt

Set-Content (sc)
Writes content to a file.
Example: Set-Content -Path C:\Temp\File.txt -Value "Hello World"

Add-Content (ac)
Appends content to a file.
Example: Add-Content -Path C:\Temp\File.txt -Value "Additional Line"



System Information:::


Get-Process (ps)
Lists all running processes.
Example: Get-Process

Stop-Process (spps)
Stops a running process by its ID.
Example: Stop-Process -Id 1234

Get-Service (gsv)
Lists all services and their status.
Example: Get-Service

Start-Service (sasv)
Starts a stopped service.
Example: Start-Service -Name "wuauserv"

Stop-Service (spsv)
Stops a running service.
Example: Stop-Service -Name "wuauserv"

Restart-Service (rsv)
Restarts a service.
Example: Restart-Service -Name "wuauserv"

Get-EventLog
Retrieves entries from event logs.
Example: Get-EventLog -LogName System -Newest 10



System Configuration and Information:::


Get-ComputerInfo
Provides detailed information about the computer system.
Example: Get-ComputerInfo

Get-Help
Provides help information for cmdlets.
Example: Get-Help Get-Process

Get-Command (gcm)
Lists all cmdlets, functions, workflows, aliases installed.
Example: Get-Command

Get-Module
Lists modules that are imported or available.
Example: Get-Module -ListAvailable

Import-Module
Imports a module into the current session.
Example: Import-Module -Name Az


Scripting and Automation:::

Write-Output (write)
Sends output to the pipeline.
Example: Write-Output "Hello World"

Read-Host
Reads input from the user.
Example: $name = Read-Host "Enter your name"

If / ElseIf / Else Statements
Conditional statements for logic.
Example:

if ($age -ge 18) {
    Write-Output "Adult"
} else {
    Write-Output "Minor"
}


ForEach-Object (%)

Iterates over a collection of items.
Example: 1..5 | ForEach-Object { Write-Output $_ }



For / While / Do Loops

For looping and conditional execution.
Example:

$i = 0
while ($i -lt 5) {
    Write-Output $i
    $i++
}




Try / Catch / Finally

Error handling in scripts.

Example:

try {
    # Code that might throw an exception
} catch {
    Write-Output "An error occurred: $_"
} finally {
    Write-Output "Cleanup code"
}



==============================================================================================================

# PowerShell Script for validating Apparenet Deadlock state in PingFederate


Creat a file Apparent_deadlock.ps1


# Get-Content
# The Get-Content cmdlet gets the content of the item at the location specified by the path, such as the text in a file or the content of a function. 
For files, the content is read one line at a time and returns a collection of objects, each of which represents a line of content.

# Select-String
# The Select-String cmdlet uses regular expression matching to search for text patterns in input strings and files. 
You can use Select-String similar to grep in UNIX or findstr.exe in Windows.

# Finding APPARENT DEADLOCK error in PingFederate server log.

# Taking a variable x and assigning the Get-Content value.

# Searching Apparent Deadlock error message in server.log file for last 10 minutes.

$StartTimeStamp = (get-date).AddMinutes(-10)

$EndTimeStamp = get-date



$x = Get-Content E:\pingfederate-10.3.6-engine\pingfederate\log\server.log | Where-Object  $StartTimeStamp -lt $EndTimeStamp | Select-String -Pattern "APPARENT DEADLOCK" 


# using If Else condition

#PowerShell -Like operator is similar to -Eq operator but it use the wildcard character to match the input string.
# When a keyword is added between the two wildcard characters (*), it checks if the keyword is part of the input string. 

# <string[]> -like    <wildcard-expression>

#The Where-Object cmdlet selects objects that have particular property values from the collection of objects that are passed to it. 
For example, you can use the Where-Object cmdlet to select files that were created after a certain date, events with a particular ID, 
or computers that use a particular version of Windows.


if($x -like "*APPARENT DEADLOCK*")


#if($x -like "*APPARENT DEADLOCK*")
#Cmdlet
# New-Item cmdlet is used to create a text file and Set-Content cmdlet to put content into it.
# The Copy-Item cmdlet copies an item from one location to another location in the same namespace. For instance, it can 
copy a file to a folder, but it can't copy a file to a certificate drive.



{

   New-Item E:\scripts\Apparent_Deadlock\test.txt

   Set-Content E:\scripts\Apparent_Deadlock\test.txt 'Apparent Deadlock Error found' 
   
   copy-Item -path E:\scripts\Apparent_Deadlock\test.txt -Force 
}

else 

{
   New-Item E:\scripts\Apparent_Deadlock\test.txt

   Set-Content E:\scripts\Apparent_Deadlock\test.txt 'Apparent Deadlock Error not found' 
  
   copy-Item -path E:\scripts\Apparent_Deadlock\test.txt -Force 
   
}



# End




Create a file Apparent_deadlock.bat


set PWD=%~dp0
cd %PWD%
powershell -noninteractive -command "%PWD%\Apparent_Deadlock.ps1


set: This command sets an environment variable in a batch script.
PWD: This is the name of the environment variable being set.
%~dp0: This is a special batch parameter that refers to the drive and path of the batch file itself.
%0: Represents the batch script's name.
%~dp0: Expands to the drive letter (d) and path (p) of the batch script (0). This means that %~dp0 gives the full directory path where the batch file is located.
Effect: This line sets the PWD environment variable to the directory path where the batch script is running.

cd %PWD%

cd: This command changes the current directory.
%PWD%: This is the environment variable we just set, so it expands to the directory path where the batch script is located.
Effect: This command changes the current directory to the directory where the batch script is located.

powershell -noninteractive -command "%PWD%\Apparent_Deadlock.ps1"

powershell: This starts a new instance of PowerShell.
-noninteractive: This switch tells PowerShell to run in a non-interactive mode, meaning it will not prompt the user for input.
-command: This switch specifies that the following argument is a command to be executed by PowerShell.
"%PWD%\Apparent_Deadlock.ps1": This is the command that PowerShell will execute. It is the path to a PowerShell script 
(Apparent_Deadlock.ps1) located in the same directory as the batch script.



Scheduled Tasks and Automation
Task Scheduler: Windows Task Scheduler can run both batch files and PowerShell scripts. However, if you're managing 
legacy systems that are set up to use batch files, converting a PowerShell script to a batch file ensures compatibility with these systems.






=======================================================================================================================================================

# PowerShell Script for Network Packet Capture


#Network Packet Capture

#netsh utility

#specify a destination address of Server and tracefile location
netsh trace start capture=yes IPv4.Address=10.128.0.4 tracefile=C:\scripts\NetTraces\NetTrace.etl overwrite=yes
                                                                                                 

#Capturing the Network data for 120 seconds
Start-Sleep -Seconds 120

#Stopping the Packet Capture
netsh trace stop

#Correlating traces ... done
#Merging traces ... done
#Generating data collection ... done
#The trace file and additional troubleshooting information have been compiled as "
#File location = C:\scripts\NetTraces\NetTrace.etl
#Tracing session was successfully stopped


#convert the etl file to a pcapng file for opening with Wireshark
#etl2pcapng
#Utility that converts an .etl file containing a Windows network packet capture into .pcapng format
#https://github.com/microsoft/etl2pcapng
#Downloaded v1.10.0 etl2pcapng.exe

cd C:\scripts\NetTraces 

#Run the below command for conversion of etl to pcapng
.\etl2pcapng.exe NetTrace.etl NetTrace_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).pcapng

#NetTrace.pcapng can be open in Wireshark for Network packet analysis

#Task completed




=======================================================================================================================================================



# PowerShell Script for validating Windows server Health



# Define parameters for the script
param (
    [int]$CpuAlertThreshold = 80,       # CPU usage threshold in percentage
    [int]$MemAlertThreshold = 80,        # Memory usage threshold in percentage
    [int]$DiskAlertThreshold = 80,       # Disk usage threshold in percentage
    [string]$ServerName = "localhost"    # Server name or IP address to check
)

# Function to get CPU usage
function Get-CpuUsage {
    param ([string]$ComputerName)

    $cpuUsage = (Get-WmiObject -Class Win32_Processor -ComputerName $ComputerName |
                 Measure-Object -Property LoadPercentage -Average).Average
    return [Math]::Round($cpuUsage, 2)
}

# Function to get memory usage
function Get-MemoryUsage {
    param ([string]$ComputerName)

    $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ComputerName
    $totalMemory = $os.TotalVisibleMemorySize
    $freeMemory = $os.FreePhysicalMemory
    $usedMemory = $totalMemory - $freeMemory
    $memoryUsagePercent = [Math]::Round((($usedMemory * 100) / $totalMemory), 2)
    return $memoryUsagePercent
}

# Function to get disk usage
function Get-DiskUsage {
    param ([string]$ComputerName)

    $diskUsage = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $ComputerName |
                 Where-Object { $_.DriveType -eq 3 } |  # Only fixed drives
                 ForEach-Object {
                     $usedSpace = [Math]::Round((($_.Size - $_.FreeSpace) * 100) / $_.Size, 2)
                     [PSCustomObject]@{
                         Drive = $_.DeviceID
                         UsedSpacePercentage = $usedSpace
                     }
                 }
    return $diskUsage
}

# Check CPU usage
$cpuUsage = Get-CpuUsage -ComputerName $ServerName
if ($cpuUsage -ge $CpuAlertThreshold) {
    Write-Output "WARNING: CPU usage is high. Current usage: $cpuUsage%"
} else {
    Write-Output "CPU usage is normal. Current usage: $cpuUsage%"
}

# Check Memory usage
$memoryUsage = Get-MemoryUsage -ComputerName $ServerName
if ($memoryUsage -ge $MemAlertThreshold) {
    Write-Output "WARNING: Memory usage is high. Current usage: $memoryUsage%"
} else {
    Write-Output "Memory usage is normal. Current usage: $memoryUsage%"
}

# Check Disk usage
$diskUsage = Get-DiskUsage -ComputerName $ServerName
foreach ($disk in $diskUsage) {
    if ($disk.UsedSpacePercentage -ge $DiskAlertThreshold) {
        Write-Output "WARNING: Disk usage is high on drive $($disk.Drive). Current usage: $($disk.UsedSpacePercentage)%"
    } else {
        Write-Output "Disk usage is normal on drive $($disk.Drive). Current usage: $($disk.UsedSpacePercentage)%"
    }
}





=======================================================================================================================================================

PowerShell script for PingFederate connectivity status with Database/Directory Server


$Output = "C:\scripts\ResponseTime\Output_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).txt"

#The netstat command generates displays that show network status and protocol statistics
#Netstat:

Write-output "Netstat:" | out-file -Append $Output
netstat -t | out-file -Append $Output
Write-output "Task has completed:"`n | out-file -Append $Output

#Oracle/MySQL DB

Write-output "Database hostname:"`n | out-file -Append $Output

PING server hostname -a | out-file -Append $Output
PING server b histname -a | out-file -Append $Output
PING server c hostname -a | out-file -Append $Output
PING server d hostname -a | out-file -Append $Output

Write-output "Task has completed:"`n | out-file -Append $Output

#Directory Server Hostname:

Write-output "Directory Server Hostname:"`n | out-file -Append $Output

PING Directory server hostbnamea -a | out-file -Append $Output
PING Directory server hostnameb -a | out-file -Append $Output
PING Directoryserver hostnamec -a | out-file -Append $Output
PING Directoryserver hostnamed -a | out-file -Append $Output


Write-output "Task has completed:"`n | out-file -Append $Output

#Pingone Server hostname:
Write-output "Pingone Server hostname:"`n | out-file -Append $Output
PING authenticator.pingone.com -a | out-file -Append $Output
Write-output "Task has completed:"`n | out-file -Append $Outpu




=================================================================================================================================


# PowerShell script for Java thread dump generation


## Java_Threaddump_$

## using below command to get the Pid of java process

$a = ((Get-Process java | Select-Object -Property Id).ID)


Download PSTools

PsTools is a free and open-source utility created for Windows, allowing users to execute processes on remote machines.

cd C:\PSTools

$Procs = .\psexec -s jstack $a

Out-File -FilePath C:\scripts\ThreadDump\Java_Threaddump_$((Get-Date).ToString('MM-dd-yyyy_hh-mm-ss')).log -InputObject $Procs -Encoding ASCII -
Width 50 | Format-Table -AutoSize

cd C:\scripts\ThreadDump

## End



=============================================================================================================================================================

































































