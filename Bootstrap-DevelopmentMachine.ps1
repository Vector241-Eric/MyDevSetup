Param(
	[switch]$ForceProfileReset
)

#Force Chocolatey to be installed
if (-not (Get-Command 'choco' -ErrorAction SilentlyContinue)) {
	Write-Host
	Write-Host "=======================================" -BackgroundColor Yellow -ForegroundColor Black
	Write-Host "Chocolatey is required for this script! `r`n(https://chocolatey.org)" -ForegroundColor Yellow -BackgroundColor Black
	Write-Host "=======================================" -BackgroundColor Yellow -ForegroundColor Black
	Write-Host
	throw 'Dependency error. Chocolatey must be installed.'
}

#Install Git
choco install gitextensions
choco install poshgit

$gitExe = Resolve-Path -Path 'C:\Program Files\Git\cmd\git.exe'
& $gitExe config --global --edit

#Install the base customized Powershell profile
if ($ForceProfileReset) {
	& ("$PSScriptRoot\Scripts\Install-PoshGitProfile.ps1") -ForceProfileReset
} else {
	& ("$PSScriptRoot\Scripts\Install-PoshGitProfile.ps1")
}

#Install putty
choco install putty
