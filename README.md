# MyProfile
A powershell profile with icons and quality of life basics

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