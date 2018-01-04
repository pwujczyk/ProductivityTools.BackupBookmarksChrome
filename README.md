Chrome bookmarks are stored in user directory in \AppData\Local\Google\Chrome\User Data\Default\Bookmarks file. Bookmarks is the json file without extension.

Module takes bookmarks file for logged user and copy it to chosen directory.

`Backup-BookmarksChrome -Destination d:\backup`

`Backup-BookmarksChrome -ToDateDirectory -ToPersonalOneDrive -Destination Chrome`

`Backup-BookmarksChrome -ToDateDirectory -DateNamePrefix p -DateNameSuffix s -ToPersonalOneDrive -Destination Chrome`

Module also can save file to the OneDrive directory and to the current date directory.



Module allows to restore data from chosen directory and from last date directory.

`Restore-BookmarksChrome "D:\OneDrive\ChromeBackup\" -FromLastDateDirectory -verbose`



Module can be installed with the command

`Install-Module Backup-BookmarksChrome`

More information can be found: 
[http://www.productivitytools.tech/backup-bookmarkschrome/](http://www.productivitytools.tech/backup-bookmarkschrome/)
