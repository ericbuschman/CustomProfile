# CustomProfile
A powershell profile with icons and quality of life basics

Here is an example of the visual changes this profile applies:

>![](./_readme_resources/TerminalProfile.jpg)



## Features

### Modules
- Posh-Git (customized prompt) [Link](https://github.com/dahlbyk/posh-git)
- Terminal-Icons [Link](https://github.com/devblackops/Terminal-Icons)
- Z [Link](https://github.com/badmotorfinger/z)

### Functions
- `x` - Simple alias for the `exit` command
- `Get-Path` - Pulls the environment path variable and provides a sorted list of paths
- `ver` - Gets the version of powershell
- `touch` - Updates the timestamp of a file

### Flexibility

One of the features of this custom profile is the flexibility of the loaded modules and functions in your profile.  Due to the nature of looping through files in your Profile-Scripts folder based on the extension `.ps1`, if you change that extension name it will no longer be loaded in the future.  

Let's say you don't ever want to use the simple function `x` to exit your powershell window.  Then you could either delete the file `Function-Exit.ps1` or rename it to `Function-Exit.ps1.disabled`.  The second option leaves you the flexibility of having that available to you in the future.

>![CustomProfile Files 2022-09-09](./_readme_resources/ProfileTree.jpg)

## Requirements
You should have a nerd font for the Terminal-Icons module to work properly, you can find instructions on how to install the font here: [Comments on how to get Terminal Icons font working](https://gist.github.com/markwragg/6301bfcd56ce86c3de2bd7e2f09a8839?permalink_comment_id=3528810#gistcomment-3528810)

## Installation recommendations
1. Clone the repository from github into your Powershell profile directory.

`git clone https://github.com/ericbuschman/MyProfile.git`

2. Alternatively download the zip file from GitHub and place it in your powershell directory: [Download Link](https://github.com/ericbuschman/MyProfile/archive/refs/heads/main.zip)

The project should be located in a folder something like:
> C:\Users\\{username}\Documents\Powershell\CustomProfile\

3. A simple example of a profile calling CustomProfile would be:
> C:\Users\\{username}\Documents\Powershell\Microsoft.PowerShell_profile.ps1

`. $PSScriptRoot\CustomProfile\Load-Profile.ps1`

## Issues
> If you encounter and issue relating to the `Set-PSReadLineOption` commands, this is probably due to the version of your PSReadLine module and it needs to be upgraded.  I'm not doing this automatically in the script.  Follow instructions here: [Upgrading PSReadLine](https://github.com/PowerShell/PSReadLine#upgrading)

