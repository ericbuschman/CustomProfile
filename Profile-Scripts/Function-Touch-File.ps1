<# .SYNOPSIS
	Function to touch a file
.DESCRIPTION
	Updates the LastAccessTime and LastWriteTime of a file to current time or parameter overridden time.
.PARAMETER path
Path to the file you want to update.
.PARAMETER date
Defaults to (get-date), can be updated with any datetime value.
.NOTES
	Author     : Eric Buschman
.LINK
	https://github.com/ericbuschman/CustomProfile
#>
function touch 
{
	Param (
		[Parameter(mandatory=$true, HelpMessage = "Enter the path to the file(s) you want to touch, wildcards are accepted.")]
		[string[]]$path,
		[datetime]$date = (Get-Date)
	)
	if (Test-Path $path) {
		Get-ChildItem -Path $path | ForEach-Object {
			$_.LastAccessTime = $date
			$_.LastWriteTime = $date 
		}
	}
	else {
		Write-Error "Cannot find path: $path"
	}
} 