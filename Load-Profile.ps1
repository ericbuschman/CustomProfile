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

#Set TLS 1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

# Monitor startup time by import/function
[hashtable]$monitorScriptStartupTime = @{}

#Store title of powershell window
$title = $host.ui.rawui.WindowTitle

#Create a timer to monitor script load time
$timer = [system.diagnostics.stopwatch]::StartNew()

# Loop through all startup scripts filter by *.ps1, order of folders matter.
Get-ChildItem ("$PSScriptRoot\Utilities", "$PSScriptRoot\Profile-Scripts", "$PSScriptRoot\Configure-Aliases") -Recurse -Include "*.ps1" | ForEach-Object { 
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
     Write-Host "Starship is installed, loading configuration"
     $ENV:STARSHIP_CONFIG = "$PSScriptRoot\Config\startship.toml"
     function Invoke-Starship-TransientFunction {
          &starship module character
     }
     
     Invoke-Expression (&starship init powershell)
     
     Enable-TransientPrompt
}

if (Get-Command carapace -ErrorAction SilentlyContinue) {
     # ~/.config/powershell/Microsoft.PowerShell_profile.ps1
     Write-Host "Carapace is installed, loading configuration"
     $env:CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
     Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
     Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
     carapace _carapace | Out-String | Invoke-Expression
}

# Clear out timer and let user know how to check all script load times
$timer = $null;
Write-Host 'To find out individual script load time: $monitorScriptStartupTime | FT -Auto'
