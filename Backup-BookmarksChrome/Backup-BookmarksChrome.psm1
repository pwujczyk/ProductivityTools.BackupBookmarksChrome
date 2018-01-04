
function GetChromeBookMarkPath()
{
	$chromeBookmarkPath="$env:userprofile\AppData\Local\Google\Chrome\User Data\Default"
	Write-Verbose "Chrome bookmarks path: $chromeBookmarkPath"
	return $chromeBookmarkPath
}

function GetBookMarkFileName()
{
	[string]$bookmarkName="Bookmarks"
	return 	$bookmarkName
}

function WriteCheckSum($place, $path)
{
	$bookmarkJson=Get-Content  $path| ConvertFrom-Json
	Write-Verbose "Chrome json $place checksum $($bookmarkJson.checksum)"
}
function GetChromeBookmarkFilePath()
{
	[string]$bookmarkName=GetBookMarkFileName
	$chromeBookmarkPath=GetChromeBookMarkPath
	$chromeBookmarkFilePath="$chromeBookmarkPath\$bookmarkName"


	return $chromeBookmarkFilePath
}

function Backup-BookmarksChrome{
	[cmdletbinding()]
	param ([string]$Destination, [switch]$ToDateDirectory, [string]$DateNamePrefix, [string]$DateNameSuffix,
	[switch]$ToPersonalOneDrive, [switch]$ToBusinessOneDrive)	

	if (($Destination -eq $null -or $Destination -eq "") -and ($ToPersonalOneDrive.IsPresent -eq $favoritesPath -and $ToBusinessOneDrive.IsPresent -eq $false) )
	{
		throw [System.Exception] "Destination directory is required"
	}

	if ($ToPersonalOneDrive.IsPresent)
	{
		$oneDriveDir=Get-OneDriveDirectory -Personal -JustDirectory
		$Destination=Join-Path $oneDriveDir $Destination
	}

	if ($ToBusinessOneDrive.IsPresent)
	{
		$oneDriveDir=Get-OneDriveDirectory -Business -JustDirectory
		$Destination=Join-Path $oneDriveDir $Destination
	}

	Write-Verbose "Destination directory: $Destination"

	$chromeBookmarkFilePath=GetChromeBookmarkFilePath
	WriteCheckSum "source" $chromeBookmarkFilePath
	
	$destinationDirectory=$Destination
	if ($ToDateDirectory.IsPresent)
	{
		[string]$dateName=Get-DateName -Prefix $DateNamePrefix -Suffix $DateNameSuffix
		$destinationDirectory=Join-Path $Destination $dateName
		Write-Verbose "Destination directory with date directory: $destinationDirectory"
	}
	
	Copy-ItemDirectoryRepeatable -Recurse -Force -LiteralPath $chromeBookmarkFilePath -Destination $destinationDirectory #-Verbose:$VerbosePreference 
	[string]$bookmarkName=GetBookMarkFileName
	$destinationFilePath="$destinationDirectory\$bookmarkName"

	WriteCheckSum "dest" $destinationFilePath
}

function Restore-BookmarksChrome
{
	[cmdletbinding()]
	param ([string]$SourceDirectory, [switch]$FromLastDateDirectory, [string]$DateNamePrefix, [string]$DateNameSuffix)

	if($FromLastDateDirectory.IsPresent)
	{
		$path="$SourceDirectory\$DateNamePrefix*$DateNameSuffix"
		try {
			$lastDirectory=Get-ChildItem -Path $path -ErrorAction Stop |Select-Object -Last 1	
		}
		catch {
			Write-Host "Directory in the $path not exists"
			Write-Host $_.Exception.Message
			return;
		}
		
		$SourceDirectory=$lastDirectory
	}

	$chromeBookmarkFilePath=GetChromeBookmarkFilePath
	#$chromeBookmarkFilePath=$chromeBookmarkFilePath+"2"

	[string]$bookmarkName=GetBookMarkFileName
	$sourceFile="$SourceDirectory\$bookmarkName"
	WriteCheckSum "source" $sourceFile
	Copy-Item -Recurse -Force -LiteralPath $sourceFile -Destination $chromeBookmarkFilePath
	WriteCheckSum "dest" $chromeBookmarkFilePath
}

Export-ModuleMember Restore-BookmarksChrome
Export-ModuleMember Backup-BookmarksChrome