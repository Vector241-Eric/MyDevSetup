Param(
	[switch]$ForceProfileReset,
	[string]$PoshGitRoot
)

$sourceFile = Resolve-Path(Join-Path -Path $PSScriptRoot -ChildPath '..\Profile\SampleProfile.ps1')
$destinationFileName = 'MyProfile.ps1'

if ($ForceProfileReset) {
	Write-Host
	Write-Host "***********************" -BackgroundColor Yellow -ForegroundColor Black
	Write-Host "Forcing a profile reset" -ForegroundColor Yellow -BackgroundColor Black
	Write-Host "***********************" -BackgroundColor Yellow -ForegroundColor Black
	Write-Host
}

$profileFolder = (Split-Path $profile -Parent)
$destinationFilePath = Join-Path -Path $profileFolder -ChildPath $destinationFileName

#Check for existing profile and stop unless the user requests force overwrite
if (Test-Path -Path $destinationFilePath) {
	if ($ForceProfileReset) {
		Remove-Item $destinationFilePath
	} else {
		throw "Destination file '$destinationFilePath' already exists. Use switch '-ForceProfileReset' to overwrite the existing profile."
	}
}

Write-Host "Searching for posh-git installation"


if ($PoshGitRoot) {
	$poshGitDirectory = Resolve-Path -Path $PoshGitRoot
} else {
	$baseDirectory = 'C:\tools\poshgit'
	if (-not (Test-Path $baseDirectory)) {
		throw "Could not find posh-git in the default installation location '$baseDirectory'. Use -PoshGitRoot to set installation location."
	}

	$newestInstallation = Get-ChildItem -Directory $baseDirectory | Sort-Object CreationTime -Descending | Select-Object -First 1
	$poshGitDirectory = Join-Path -Path $baseDirectory -ChildPath $newestInstallation
}

Write-Host "Found posh-git installation at '$poshGitDirectory'`r`n"

Write-Host "Writing profile to $destinationFilePath`r`n"

$sourceContents = Get-Content $sourceFile

$setPoshGitLocation = '$poshGitInstallLocation = ' + "'$poshGitDirectory'"

$destinationContents = @()
foreach ($line in $sourceContents) {
	if ($line.StartsWith('# Set Posh-Git Location') ) {
		$destinationContents += $setPoshGitLocation
	} elseif ($line.StartsWith('# Set Custom Profile Location')) {
		$destinationContents += ('$customProfilePath = ' + "'$destinationFilePath'")
	} else {
		$destinationContents += $line
	}
}

$destinationContents | Out-File $destinationFilePath