# Autorun all startup scripts
Set-Location "$PSScriptRoot"

# Monitor startup time by import/function
[hashtable]$monitorScriptStartupTime = @{}

$title=$host.ui.rawui.WindowTitle

$timer = [system.diagnostics.stopwatch]::StartNew()

# Loop through all startup scripts in .\Profile-Scripts, filter by *.ps1
Get-ChildItem ".\Profile-Scripts" -r -i *.ps1 | ForEach-Object { 
  $timer.Restart(); 
  $host.ui.rawui.WindowTitle="Loading: $($_.FullName)"; 
  . $_.FullName; 
  $monitorScriptStartupTime.Add("$($_.Name)", "$($timer.ElapsedMilliseconds)"); 
}

$host.ui.rawui.WindowTitle=$title

$timer = $null;
Write-Host 'To find out individual script load time: $monitorScriptStartupTime | FT -Auto'

Set-Location (Split-Path $profile)