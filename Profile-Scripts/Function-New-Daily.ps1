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
    $notesDirectory = "$([Environment]::GetFolderPath("MyDocuments"))\Notebook\Daily Notes"
) {
    ## Helper functions to simplify the text manipulation below
        
    function Get-WorkItems($noteText) {
        # Let's carry forward the not completed tasks from yesterday
        $returnResults = ""
        foreach ($line in $noteText) {
            if ($line.startsWith("## Tasks")) {
                $inSection = $true
                continue
            }
            if ($inSection -and $line -match "^- \[ \] \w") {
                $returnResults += "`r`n" + $line 
            }
            # If we get to the next section, stop parsing
            if ($inSection -and $line.StartsWith("##")) {
                break
            }
        }
        return $returnResults
    }

    function Get-RelativePath([string]$sourcePath, [string]$filePath) {
        if (Test-Path $sourcePath -PathType Leaf) { $sourcePath = Split-Path $sourcePath }
        Push-Location $sourcePath
        $relativePath = Resolve-Path $filePath -Relative
        Pop-Location
        return $relativePath
    }

    function Get-FolderIfNotExistsCreate([string]$folder) {
        if (-Not (Test-Path -Path $folder -PathType Container)) { 
            $null = mkdir "$folder"; 
        }    
        return (get-item $folder).FullName
    }

    # Create a new notes directory if it doesn't already exist
    $null = Get-FolderIfNotExistsCreate $notesDirectory

    # Write readme file
    if (-Not (Test-Path -Path $notesDirectory\readme.md)) {
        '# Daily notes
The files are laid out in a year \ month structure to keep the root of the tree from having an overwhelming number of files

Example:
```
.\DAILY NOTES
└───2022
    ├───09
    └───10
```
'  | Set-Content -Path $notesDirectory\readme.md
    }

    # Set up variables
    $todaysPath = Get-FolderIfNotExistsCreate "$notesDirectory\$(Get-Date -f "yyyy\\MM")"
    $previousPath = Get-FolderIfNotExistsCreate "$notesDirectory\$((get-date).AddDays(-1).ToString("yyyy\\MM"))"

    $todaysFile = "$(Get-Date -f "yyyy-MM-dd").md"

    if (Test-Path $todaysPath\$todaysFile) { 
        code $todaysPath\$todaysFile
        return "Today's Note already exists" 
    }

    # Set the previous file to last/oldest [-1] returned file from $previousPath
    $previousFile = "$(((Get-ChildItem $previousPath\*.md -Exclude _template.md | Sort-Object CreationTime)[-1]).FullName)"

    #Get the contents of the previous file to carry over any tasks that aren't complete
    $catPreviousFile = (Get-Content -Path $previousFile -ErrorAction SilentlyContinue)

    # Template markdown definition
    $template = "
[Previous]($(Get-RelativePath -sourcePath $todaysPath -filePath $previousFile)) | {{Next}}

# $(Get-Date)

## Tasks
$(Get-WorkItems $catPreviousFile)
- [ ] 

## Work Log
- 

## 000 Meeting - 
- Tags: 
- Attendees: 
- Tasks:
- Notes:
"
    #Create new note file with template text
    Set-Content -Path $todaysPath\$todaysFile -Value $template

    #Update the breadcrumb in the previous file
    $catPreviousFile.replace("{{Next}}", "[Next]($(Get-RelativePath -sourcePath $previousPath -filePath "$todaysPath\$todaysFile"))") | Set-Content -Path $previousFile -Force

    #Open file in VSCode
    try {
        Code $todaysPath\$todaysFile
    }
    catch {
        #SilentlyContinue on error
    }
    
    Pop-Location
}

# TODO: This actually could fail if you had no space after Work Items?  Testing needed
function Add-WorkItem(
    [string]$text,
    [string]$notePath = "$([Environment]::GetFolderPath("MyDocuments"))\Notebook\Daily Notes\$(Get-Date -f "yyyy\\MM")\$(Get-Date -f "yyyy-MM-dd").md"
) {
    if (-not ($notepath)) {
        throw "Path to working note is invalid ($($notepath))";
    }
    $content = Get-Content $notepath
    $newcontent = ""
    $insertedItem, $skipNextBlankLink = $false
    foreach ($line in $content) {
        if ($line.startsWith("## Tasks")) {
            $inSection = $true
            $skipNextBlankLink = $true
        }
        if ($skipNextBlankLink -and $line.length -eq 0) {
            $newcontent += "$line`n"
            $skipNextBlankLink = $false
            continue
        }
        if ($inSection -and ($line -match "(\-\s\[\s\]\s+$)+")) {
            $insertedItem = $true
            $newcontent += "- [ ] $text`n"
        }
        if ($inSection -and (-not ($insertedItem)) -and (($line.length -eq 0) -or ($line.startsWith("## Work Log")))) {
            $insertedItem = $true
            $newcontent += "- [ ] $text`n"
        }
        $newcontent += "$line`n"
    }
    try {
        Set-Content -Path $notepath -Value $newcontent -Force
        Write-Output "Added task to note."
    }
    catch { Throw $_ }
}

# TODO: Do I want to do this?
function Close-WorkItem(
    [string]$notePath = "$([Environment]::GetFolderPath("MyDocuments"))\Notebook\Daily Notes\$(Get-Date -f "yyyy\\MM")\$(Get-Date -f "yyyy-MM-dd").md"
) {
    if (-not ($notepath)) {
        throw "Path to working note is invalid ($($notepath))";
    }
    $content = Get-Content $notepath
    $newcontent = ""
    $insertedItem, $skipNextBlankLink = $false
    foreach ($line in $content) {
        if ($line.startsWith("## Tasks")) {
            $inSection = $true
            $skipNextBlankLink = $true
        }
        if ($skipNextBlankLink -and $line.length -eq 0) {
            $newcontent += "$line`n"
            $skipNextBlankLink = $false
            continue
        }
        if ($inSection -and ($line -match "(\-\s\[\s\]\s+$)+")) {
            $insertedItem = $true
            $newcontent += "- [ ] $text`n"
        }
        if ($inSection -and (-not ($insertedItem)) -and (($line.length -eq 0) -or ($line.startsWith("## Work Log")))) {
            $insertedItem = $true
            $newcontent += "- [ ] $text`n"
        }
        $newcontent += "$line`n"
    }

}