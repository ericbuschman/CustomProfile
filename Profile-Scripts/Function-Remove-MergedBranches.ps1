function Remove-MergedBranches {
    git fetch origin --prune
    git branch --merged |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -NotMatch "^\*" } |
    Where-Object { -not ( $_ -Like "*master" -or $_ -Like "*main" -or $_ -Like "*dev" ) } |
    ForEach-Object { git branch -d $_ }
}