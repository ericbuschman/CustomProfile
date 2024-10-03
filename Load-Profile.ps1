<# .SYNOPSIS
     Load the custom profile environment
.DESCRIPTION
     This is the starting point for the CustomProfile project.  It will set some quality of life settings
     and load all the files in the subfolders of the project.  Please see the readme for more information about
     configuring the custom profile environment.
.NOTES
     Author     : Eric Buschman
.LINK
     https://github.com/ericbuschman/CustomProfile
#>


#Change directory to the script folder
Set-Location "$PSScriptRoot"

#Set TLS 1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

# Monitor startup time by import/function
[hashtable]$monitorScriptStartupTime = @{}

#Store title of powershell window
$title = $host.ui.rawui.WindowTitle

#Create a timer to monitor script load time
$timer = [system.diagnostics.stopwatch]::StartNew()

# Loop through all startup scripts filter by *.ps1, order of folders matter.
Get-ChildItem (".\Utilities", ".\Profile-Scripts", ".\Configure-Aliases") -Recurse -Include "*.ps1" | ForEach-Object { 
     # Start the timer
     $timer.Restart(); 

     # Update the window title to currently loading script
     $host.ui.rawui.WindowTitle = "Loading: $($_.FullName)"; 

     # Load script
     . $_.FullName; 

     # Add time to timer
     $monitorScriptStartupTime.Add("$($_.Name)", "$($timer.ElapsedMilliseconds)"); 
}

# Reset window title to original
$host.ui.rawui.WindowTitle = $title

# Check if Starship is installed
if (Get-Command starship -ErrorAction SilentlyContinue) {
     $ENV:STARSHIP_CONFIG = "$PSScriptRoot\CustomProfile\Config\startship.toml"
     function Invoke-Starship-TransientFunction {
          &starship module character
     }
     
     Invoke-Expression (&starship init powershell)
     
     Enable-TransientPrompt
}

# Clear out timer and let user know how to check all script load times
$timer = $null;
Write-Host 'To find out individual script load time: $monitorScriptStartupTime | FT -Auto'

# Preference, I like to have the window start in the powershell profile folder
Set-Location (Split-Path $profile)