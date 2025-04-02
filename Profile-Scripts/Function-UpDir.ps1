function UpDir {
    <#
    .SYNOPSIS
        Moves up one directory.

    .DESCRIPTION
        This function changes the current location to the parent directory.
        It's a simple wrapper around the Set-Location "..".

    .PARAMETER
        None

    .EXAMPLE
        UpDir
        Moves the current location to the parent directory.

    .NOTES
        This function provides a simple way to move up one level in the file system.
    #>
    Set-Location ".."
}