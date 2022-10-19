# BITS script for heavy traffic low speed network transfers.

$JobName = Read-Host -Prompt 'Input Job Name'
$Cred = Get-Credential

# Don't include quotes in file path names.
$SourceLocation = Read-Host -Prompt 'Path to Source File or Folder'
$DestinationLocation = Read-Host -Prompt 'Path to Destination File Folder'

$DownUp = Read-Host -Prompt 'Type <Download> or <Upload>'

Start-BitsTransfer -DisplayName  $JobName -Credential $Cred -Source $SourceLocation -Destination $DestinationLocation -Asynchronous -TransferType $DownUp -RetryInterval 90

# = Future Goals =
# Add a Progress Bar
# Add 2 Choices for $DownUp
# Remove Quotes if they exist in the File Paths.
# Cleaner Output for what transferred, how long it took, and when.