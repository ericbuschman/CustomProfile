# Chocolatey profile
$host.ui.rawui.WindowTitle="Loading: Chocolatey"
$timer.Restart();
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
$monitorScriptStartupTime.Add("ChocolateyProfile", "$($timer.ElapsedMilliseconds)");
