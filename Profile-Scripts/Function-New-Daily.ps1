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

Function New-DailyNote (
    $notesDirectory = "$([Environment]::GetFolderPath("MyDocuments"))\Daily Notes"
) {
    if (-Not (Test-Path -Path $notesDirectory)) { mkdir $notesDirectory }
    Push-Location $notesDirectory

    $todaysFile = ".\$(Get-Date -f "yyyy-MM-dd").md"
    $previousFile = ".\$(Split-Path ((Get-ChildItem .\*.md -Exclude _template.md | Sort-Object CreationTime)[-1]) -Leaf)"
    $catPreviousFile = (Get-Content -Path $previousFile)

    # Template markdown definition
    $template = "
[Previous]($($previousFile)) | {{Next}}

# $(Get-Date)

## Tasks
"

    # Let's carry forward the not completed tasks from yesterday
    foreach ($line in $catPreviousFile) {
        if ($line.startsWith("## Tasks")) {
            $inSection = $true
        }
        if ($inSection -and $line.startsWith("- [ ]")) {
            $template += $line
        }
        # If we get to the next section, stop parsing
        if ($inSection -and $line.StartsWith("##")) {
            break
        }
    }

    $template += "
- [ ] 

## Work Log
- 

## 0000 Meeting
- Tags: 
- Attendees: 
- Tasks:
- Notes:

## Communication Log
"

    if (-Not (Test-Path $todaysFile)) {
        Set-Content -Path $todaysFile -Value $template
    }

    $catPreviousFile.replace("{{Next}}", "[Next]($todaysFile)") | Set-Content -Path $previousFile -Force

    # TODO: build out an archival process for old notes
    # Archiving with updating breadcrumbs

    

    Code $todaysFile

    Pop-Location
}