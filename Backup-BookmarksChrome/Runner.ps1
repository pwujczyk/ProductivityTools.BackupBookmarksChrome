clear
cd $PSScriptRoot
Import-Module D:\GitHub\PSGet-DateName\Get-DateName\Get-DateName.psm1 -Force
Import-Module .\Backup-BookmarksChrome.psm1 -Force
#Backup-BookmarksChrome  "D:\trash\chrome1" -verbose  -ToDateDirectory

Restore-BookmarksChrome  "D:\OneDrive\ChromeBackup\" -FromLastDateDirectory -verbose