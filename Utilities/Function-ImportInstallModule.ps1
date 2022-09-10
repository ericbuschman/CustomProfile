<# .SYNOPSIS
    Function to Import or Install a module
.DESCRIPTION
    Will attempt to import a module, if that module is not currently installed will attempt to install
    the module from the Powershell Gallery to the current user scope, not requiring administrative permissions.
.PARAMETER Name
    Name of the module to be imported / installed
.NOTES
    Author     : Eric Buschman
.LINK
    https://github.com/ericbuschman/CustomProfile
#>
function Invoke-ImportInstallModule (
    [Parameter(Mandatory = $true, HelpMessage = "Enter the name of the module you wish to import/install.")]
    [string]$Name
) {
    try {
        Import-Module -Name $Name -ErrorAction Stop
    }
    catch {
        Write-Host "Module not found {$Name}, will be installed and imported"
        Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
        Install-Module -Name $Name -Scope CurrentUser -AcceptLicense -AllowClobber
        Set-PSRepository -Name 'PSGallery' -InstallationPolicy Untrusted
        Import-Module -Name $Name
    }
}