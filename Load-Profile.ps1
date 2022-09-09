### Autorun all startup scripts

#Change directory to the script folder
Set-Location "$PSScriptRoot"

# Load helpful import module function to install modules if not installed
. $PSScriptRoot\Utilities\Function-ImportInstallModule.ps1

#Set TLS 1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

# Monitor startup time by import/function
[hashtable]$monitorScriptStartupTime = @{}

#Store title of powershell window
$title=$host.ui.rawui.WindowTitle

#Create a timer to monitor script load time
$timer = [system.diagnostics.stopwatch]::StartNew()

# Loop through all startup scripts in .\Profile-Scripts, filter by *.ps1
Get-ChildItem ".\Profile-Scripts" -r -i *.ps1 | ForEach-Object { 
  # Start the timer
  $timer.Restart(); 

  # Update the window title to currently loading script
  $host.ui.rawui.WindowTitle="Loading: $($_.FullName)"; 

  # Load script
  . $_.FullName; 

  # Add time to timer
  $monitorScriptStartupTime.Add("$($_.Name)", "$($timer.ElapsedMilliseconds)"); 
}

# Reset window title to original
$host.ui.rawui.WindowTitle=$title

# Clear out timer and let user know how to check all script load times
$timer = $null;
Write-Host 'To find out individual script load time: $monitorScriptStartupTime | FT -Auto'

# Preference, I like to have the window start in the powershell folder
Set-Location (Split-Path $profile)