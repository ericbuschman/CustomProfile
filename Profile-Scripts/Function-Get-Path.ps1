<# .SYNOPSIS
     Function to output the path environment variable
.DESCRIPTION
     Outputs to the screen the path environment variable and provides a sorted list of paths.
.NOTES
     Author     : Eric Buschman
.LINK
     https://github.com/ericbuschman/CustomProfile
#>
Function Get-Path()
{
	Write-Output "============================FULL PATH==================================`n"
	$env:path
	Write-Output "`n============================SORTED PATH=============================="
	$($env:path).split(";") | Sort-Object
}