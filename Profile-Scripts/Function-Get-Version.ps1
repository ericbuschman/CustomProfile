<# .SYNOPSIS
     Function to output the powershell version
.DESCRIPTION
     Function to output the powershell version
.NOTES
     Author     : Eric Buschman
.LINK
     https://github.com/ericbuschman/CustomProfile
#>
function ver 
{ 
	Write-Host "Powershell version: $((get-host).Version.ToString())" 
}