<# .SYNOPSIS
    Function to generate a new daily notes file in markdown format
.DESCRIPTION
    Function to generate a new daily notes file in markdown format
    - Create new file with current date/time
    - Copy template into new file
    - Replace breadcrumb with links to files
    - Open new file in code

.NOTES
    Author     : Eric Buschman
.LINK
    https://github.com/ericbuschman/CustomProfile
#>

Function New-Daily (
    $notesDirectory = "$([Environment]::GetFolderPath("MyDocuments"))\Daily Notes"
) {
    if (-Not (Test-Path -Path $notesDirectory)) { mkdir $notesDirectory }
    Push-Location $notesDirectory

    $todaysFile = ".\$(Get-Date -f "yyyy-MM-dd").md"
    $previousFile = ".\$(Split-Path ((Get-ChildItem .\*.md -Exclude _template.md | Sort-Object CreationTime)[-1]) -Leaf)"

    # Template markdown definition
    $template = "
[Previous]($($previousFile)) | {{Next}}

# $(Get-Date)

## Tasks
- [ ] 

## Work Log
- 

## 0000 Meeting
- Tags: 
- Meeting Link: 
- Attendees: 
- Tasks:
- Notes:

## Communication Log
"

    if (-Not (Test-Path $todaysFile)) {
        Set-Content -Path $todaysFile -Value $template
    }

(Get-Content -Path $previousFile).replace("{{Next}}", "[Next]($todaysFile)") | Set-Content -Path $previousFile -Force

    Code $todaysFile

    Pop-Location
}