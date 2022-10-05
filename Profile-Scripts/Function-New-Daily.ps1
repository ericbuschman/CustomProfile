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
    $currentPwd = $PWD
    if (-Not (Test-Path -Path $notesDirectory)) { mkdir $notesDirectory }
    Set-Location $notesDirectory

    # Write readme file
    if (-Not (Test-Path -Path .\readme.md)) {
        '# Daily notes
The files are laid out in a year \ month structure to keep the root of the tree from having an overwhelming number of files

Example:
```
.\DAILY NOTES
└───2022
    ├───09
    └───10
```
'  | Set-Content -Path .\readme.md
    }

    # Set up variables

    $todaysPath = ".\$(Get-Date -f "yyyy\\MM")"
    $previousPath = ".\$((get-date).AddDays(-1).ToString("yyyy\\MM"))"

    $todaysFile = "$(Get-Date -f "yyyy-MM-dd").md"

    Push-Location $previousPath

    $previousFile = "$(((Get-ChildItem .\*.md -Exclude _template.md | Sort-Object CreationTime)[-1]).FullName)"
    $catPreviousFile = (Get-Content -Path $previousFile)

    Pop-Location

    Push-Location $todaysPath

    # Template markdown definition
    $template = "
[Previous]($(Resolve-Path -Path $previousFile -Relative)) | {{Next}}

# $(Get-Date)

## Tasks"

    # Let's carry forward the not completed tasks from yesterday
    foreach ($line in $catPreviousFile) {
        if ($line.startsWith("## Tasks")) {
            $inSection = $true
            Write-Host "Found Tasks"
            continue
        }
        if ($inSection -and $line -match "^- \[ \] \w") {
            $template += "`r`n" + $line 
            Write-Host "Adding Line"
        }
        # If we get to the next section, stop parsing
        if ($inSection -and $line.StartsWith("##")) {
            Write-Host "All done"
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
"

    if (-Not (Test-Path .\$todaysFile)) {
        Set-Content -Path .\$todaysFile -Value $template
    }
    $todaysFileLoc = (Get-ChildItem -Path .\$todaysFile).Fullname

    Pop-Location
    Push-Location $previousPath

    $catPreviousFile.replace("{{Next}}", "[Next]($(Resolve-Path -Path $todaysFileLoc -Relative))") | Set-Content -Path $previousFile -Force

    Pop-Location

    Code $todaysFileLoc

    Set-Location $currentPwd
}