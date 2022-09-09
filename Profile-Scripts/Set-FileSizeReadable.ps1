# I find the default file size implementation in the prompt
# difficult to parse.  This file implements a simple FileSize
# column in Get-ChildItem which shows the size in human readable
# format.  Original source unknown.

#Specify full file names for the new format styles
$mytypes="$(split-path $profile)\MyTypes.ps1xml"
$myformat="$(split-path $profile)\MyFileFormat.format.ps1xml"

#Write out the type information if it doesn't exist
if (-not (Test-Path $mytypes)) {
    '<?xml version="1.0" encoding="utf-8" ?>
    <Types>
        <Type>
            <Name>System.IO.FileInfo</Name>
            <Members>
                <ScriptProperty>
                    <!-- Filesize converts the length to a human readable
                        format (kb, mb, gb, tb) -->
                    <Name>FileSize</Name>
                    <GetScriptBlock>
                        switch($this.length) {
                            { $_ -gt 1tb } 
                                { "{0:n2} TB" -f ($_ / 1tb) ; break }
                            { $_ -gt 1gb } 
                                { "{0:n2} GB" -f ($_ / 1gb) ; break }
                            { $_ -gt 1mb } 
                                { "{0:n2} MB " -f ($_ / 1mb) ; break }
                            { $_ -gt 1kb } 
                                { "{0:n2} KB " -f ($_ / 1Kb) ; break }
                            default
                                { "{0}  B " -f $_}
                        }
                    </GetScriptBlock>
                </ScriptProperty>
            </Members>
        </Type>
    </Types>' > $mytypes
}

if (-not (Test-Path $myformat)) {
    '<?xml version="1.0" encoding="utf-8" ?>

    <!-- Based on the format.ps1xml file from DirColors
    https://github.com/DHowett/DirColors -->
    <Configuration>
        <SelectionSets>
            <SelectionSet>
                <Name>FileSystemTypes</Name>
                <Types>
                    <TypeName>System.IO.DirectoryInfo</TypeName>
                    <TypeName>System.IO.FileInfo</TypeName>
                </Types>
            </SelectionSet>
        </SelectionSets>
    
        <Controls>
            <Control>
                <Name>FileSystemTypes-GroupingFormat</Name>
                <CustomControl>
                    <CustomEntries>
                        <CustomEntry>
                            <CustomItem>
                                <Frame>
                                    <LeftIndent>4</LeftIndent>
                                    <CustomItem>
                                        <Text AssemblyName="System.Management.Automation" BaseName="FileSystemProviderStrings" ResourceId="DirectoryDisplayGrouping"/>
                                        <ExpressionBinding>
                                            <ScriptBlock>
                                                      $_.PSParentPath.Replace("Microsoft.PowerShell.Core\FileSystem::", "")
                                            </ScriptBlock>
                                        </ExpressionBinding>
                                        <NewLine/>
                                    </CustomItem>
                                </Frame>
                            </CustomItem>
                        </CustomEntry>
                    </CustomEntries>
                </CustomControl>
            </Control>
        </Controls>
    
        <ViewDefinitions>
            <View>
                <Name>children</Name>
                <ViewSelectedBy>
                    <SelectionSetName>FileSystemTypes</SelectionSetName>
                </ViewSelectedBy>
                <GroupBy>
                    <PropertyName>PSParentPath</PropertyName>
                    <CustomControlName>FileSystemTypes-GroupingFormat</CustomControlName>
                </GroupBy>
                <TableControl>
                    <TableHeaders>
                        <TableColumnHeader>
                            <Label>Mode</Label>
                            <Width>7</Width>
                            <Alignment>left</Alignment>
                        </TableColumnHeader>
                        <TableColumnHeader>
                            <Label>LastWriteTime</Label>
                            <Width>25</Width>
                            <Alignment>right</Alignment>
                        </TableColumnHeader>
                        <TableColumnHeader>
                                <Label>FileSize</Label>
                            <Width>14</Width>
                            <Alignment>right</Alignment>
                        </TableColumnHeader>
                        <TableColumnHeader>
                            <Label>Name</Label>
                        </TableColumnHeader>
                    </TableHeaders>
                    <TableRowEntries>
                        <TableRowEntry>
                            <Wrap/>
                            <TableColumnItems>
                                <TableColumnItem>
                                    <PropertyName>Mode</PropertyName>
                                </TableColumnItem>
                                <TableColumnItem>
                                    <ScriptBlock>
                                        [String]::Format("{0,10}  {1,8}", $_.LastWriteTime.ToString("d"), $_.LastWriteTime.ToString("t"))
                                    </ScriptBlock>
                                </TableColumnItem>
                                <TableColumnItem>
                                        <PropertyName>FileSize</PropertyName>
                                </TableColumnItem>
                                <TableColumnItem>
                                    <ScriptBlock>
                                        Terminal-Icons\Format-TerminalIcons $_
                                    </ScriptBlock>
                                </TableColumnItem>
                            </TableColumnItems>
                        </TableRowEntry>
                    </TableRowEntries>
                </TableControl>
            </View>
            <View>
                <Name>children</Name>
                <ViewSelectedBy>
                    <SelectionSetName>FileSystemTypes</SelectionSetName>
                </ViewSelectedBy>
                <GroupBy>
                    <PropertyName>PSParentPath</PropertyName>
                    <CustomControlName>FileSystemTypes-GroupingFormat</CustomControlName>
                </GroupBy>
                <ListControl>
                    <ListEntries>
                        <ListEntry>
                            <EntrySelectedBy>
                                <TypeName>System.IO.FileInfo</TypeName>
                            </EntrySelectedBy>
                            <ListItems>
                                <ListItem>
                                    <Label>Name</Label>
                                    <ScriptBlock>
                                        Terminal-Icons\Format-TerminalIcons $_
                                    </ScriptBlock>
                                </ListItem>
                                <ListItem>
                                        <PropertyName>FileSize</PropertyName>
                                </ListItem>
                                <ListItem>
                                    <PropertyName>CreationTime</PropertyName>
                                </ListItem>
                                <ListItem>
                                    <PropertyName>LastWriteTime</PropertyName>
                                </ListItem>
                                <ListItem>
                                    <PropertyName>LastAccessTime</PropertyName>
                                </ListItem>
                                <ListItem>
                                    <PropertyName>Mode</PropertyName>
                                </ListItem>
                                <ListItem>
                                    <PropertyName>LinkType</PropertyName>
                                </ListItem>
                                <ListItem>
                                    <Label>Target</Label>
                                    <ScriptBlock>
                                        Terminal-Icons\Format-TerminalIcons $_
                                    </ScriptBlock>
                                </ListItem>
                                <!-- <ListItem>
                                    <PropertyName>VersionInfo</PropertyName>
                                </ListItem> -->
                            </ListItems>
                        </ListEntry>
                        <ListEntry>
                            <ListItems>
                                <ListItem>
                                    <Label>Name</Label>
                                    <ScriptBlock>
                                        Terminal-Icons\Format-TerminalIcons $_
                                    </ScriptBlock>
                                </ListItem>
                                <ListItem>
                                    <PropertyName>CreationTime</PropertyName>
                                </ListItem>
                                <ListItem>
                                    <PropertyName>LastWriteTime</PropertyName>
                                </ListItem>
                                <ListItem>
                                    <PropertyName>LastAccessTime</PropertyName>
                                </ListItem>
                                <ListItem>
                                    <PropertyName>Mode</PropertyName>
                                </ListItem>
                                <ListItem>
                                    <PropertyName>LinkType</PropertyName>
                                </ListItem>
                                <ListItem>
                                    <Label>Target</Label>
                                    <ScriptBlock>
                                    Terminal-Icons\Format-TerminalIcons $_
                                    </ScriptBlock>
                                </ListItem>
                            </ListItems>
                        </ListEntry>
                    </ListEntries>
                </ListControl>
            </View>
            <View>
                <Name>children</Name>
                <ViewSelectedBy>
                    <SelectionSetName>FileSystemTypes</SelectionSetName>
                </ViewSelectedBy>
                <GroupBy>
                    <PropertyName>PSParentPath</PropertyName>
                    <CustomControlName>FileSystemTypes-GroupingFormat</CustomControlName>
                </GroupBy>
                <WideControl>
                    <WideEntries>
                        <WideEntry>
                            <WideItem>
                                <ScriptBlock>
                                    Terminal-Icons\Format-TerminalIcons $_
                                </ScriptBlock>
                            </WideItem>
                        </WideEntry>
                        <WideEntry>
                            <EntrySelectedBy>
                                <TypeName>System.IO.DirectoryInfo</TypeName>
                            </EntrySelectedBy>
                            <WideItem>
                                <ScriptBlock>
                                    Terminal-Icons\Format-TerminalIcons $_
                                </ScriptBlock>
                            </WideItem>
                        </WideEntry>
                    </WideEntries>
                </WideControl>
            </View>
        </ViewDefinitions>
    </Configuration>
    ' > $myformat
}

Update-TypeData -PrependPath $mytypes
Update-FormatData -PrependPath $myformat