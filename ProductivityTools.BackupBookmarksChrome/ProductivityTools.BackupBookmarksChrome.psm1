
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

class GenerateDirectoryParams
{
	[string]$Destination;
	[bool]$ToDateDirectory;
	[string]$DateNamePrefix;
	[string]$DateNameSuffix;
	[bool]$ToPersonalOneDrive;
	[bool]$ToBusinessOneDrive;
}

function GenerateDirectoryFromParams()
{
	[cmdletbinding()]
	param ([GenerateDirectoryParams]$params)	
	#param ([string]$Destination, [switch]$ToDateDirectory, [string]$DateNamePrefix, [string]$DateNameSuffix,
	#[switch]$ToPersonalOneDrive, [switch]$ToBusinessOneDrive)	

	if (($params.Destination -eq $null -or $params.Destination -eq "") -and ($params.ToPersonalOneDrive -eq $false -and $params.ToBusinessOneDrive -eq $false) )
	{
		throw [System.Exception] "Destination directory is required"
	}

	if ($params.ToPersonalOneDrive)
	{
		$oneDriveDir=Get-OneDriveDirectory -Personal -JustDirectory
		$params.Destination=Join-Path $oneDriveDir $params.Destination
	}

	if ($params.ToBusinessOneDrive)
	{
		$oneDriveDir=Get-OneDriveDirectory -Business -JustDirectory
		$params.Destination=Join-Path $oneDriveDir $params.Destination
	}

	if ($ToDateDirectory)
	{
		[string]$dateName=Get-DateName -Prefix $DateNamePrefix -Suffix $DateNameSuffix
		$params.Destination=Join-Path $params.Destination $dateName
		Write-Verbose "Destination directory with date directory: $params.Destination"
	}

	return $params.Destination
}

function GetLastDateDirectory()
{

}

function Backup-BookmarksChrome{
	[cmdletbinding()]
	param ([string]$Destination, [switch]$ToDateDirectory, [string]$DateNamePrefix, [string]$DateNameSuffix,
	[switch]$ToPersonalOneDrive, [switch]$ToBusinessOneDrive)	

	$generateDirectoryParams=New-Object GenerateDirectoryParams
	$generateDirectoryParams.Destination=$Destination
	$generateDirectoryParams.ToDateDirectory=$ToDateDirectory.IsPresent
	$generateDirectoryParams.DateNamePrefix=$DateNamePrefix
	$generateDirectoryParams.DateNameSuffix=$DateNameSuffix
	$generateDirectoryParams.ToPersonalOneDrive=$ToPersonalOneDrive.IsPresent
	$generateDirectoryParams.ToBusinessOneDrive=$ToBusinessOneDrive.IsPresent


	$Destination=GenerateDirectoryFromParams $generateDirectoryParams

	Write-Verbose "Destination directory: $Destination"

	$chromeBookmarkFilePath=GetChromeBookmarkFilePath
	WriteCheckSum "source" $chromeBookmarkFilePath
	

	
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