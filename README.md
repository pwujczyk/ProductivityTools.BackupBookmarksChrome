<!--Category:PowerShell--> 
 <p align="right">
    <a href="https://www.powershellgallery.com/packages/ProductivityTools.BackupBookmarksChrome/"><img src="Images/Header/Powershell_border_40px.png" /></a>
    <a href="http://productivitytools.tech/backup-bookmarks-chrome/"><img src="Images/Header/ProductivityTools_green_40px_2.png" /><a> 
    <a href="https://github.com/pwujczyk/ProductivityTools.BackupBookmarksChrome"><img src="Images/Header/Github_border_40px.png" /></a>
</p>
<p align="center">
    <a href="http://http://productivitytools.tech/">
        <img src="Images/Header/LogoTitle_green_500px.png" />
    </a>
</p>

# Backup Bookmarks Chrome

Chrome synchronizes the bookmarks in the clould but if you would like to have offline copy of it this module can help.

<!--more-->

Chrome bookmarks are stored in user directory in **C:\\Users\\Pawel\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\Bookmarks** file. Bookmarks are stored in the json file without extension.

<!--og-image-->
![](Images\ChromeJson.png)

Module takes bookmarks file for logged user and copy it to chosen directory.

```powershell
Backup-BookmarksChrome -Destination d:\backup
```

Module also can save file to the OneDrive directory and to the current date directory.

```powershell
Backup-BookmarksChrome -ToDateDirectory -ToPersonalOneDrive -Destination Chrome

Backup-BookmarksChrome -ToDateDirectory -DateNamePrefix p -DateNameSuffix s -ToPersonalOneDrive -Destination Chrome
```

Module allows to restore data from chosen directory and from last date directory.

```powershell
Restore-BookmarksChrome "D:\OneDrive\ChromeBackup\" -FromLastDateDirectory -verbose
```

