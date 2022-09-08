# Import the Posh-git prompt module and set default theme
Invoke-ImportInstallModule -Name Posh-git
$GLOBAL:GitPromptSettings.DefaultPromptWriteStatusFirst = $true
$GLOBAL:GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [System.ConsoleColor]::Red
$GLOBAL:GitPromptSettings.DefaultPromptBeforeSuffix.ForegroundColor = [ConsoleColor]::Green
$GLOBAL:GitPromptSettings.BeforePath.Text = "`n@ "
$GLOBAL:GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n[$(Get-Date -f "yyyy-MM-dd HH:mm:ss")] '
$GLOBAL:GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
