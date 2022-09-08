function Invoke-ImportInstallModule ([string]$Name) {
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