Param(
	[Parameter(Mandatory=$True)]
	[string]$PrivateKeyPath
)

# Other versions of Windows may have the Startup menu in a different place.
# I don't have access to anything before v10 to check this out.
$osVersion = [System.Environment]::OSVersion.Version.Major
$supportedWindowsVersions = @(10)
if (-not $supportedWindowsVersions.Contains($osVersion)) {
	throw "This script only supports these versions of Windows ($($supportedWindowsVersions -join ', ')), but you are using version '$osVersion'"
}

$resolvedPath = Resolve-Path -Path $PrivateKeyPath

$windows10RelativeStartupPath = 'Microsoft\Windows\Start Menu\Programs\Startup'
$currentUserStartupFolder = Resolve-Path (Join-Path -Path (Get-ChildItem env:AppData).Value -ChildPath $windows10RelativeStartupPath)
$shortcutPath = Join-Path -Path $currentUserStartupFolder -ChildPath 'LoadPageant.lnk'

if (Test-Path -Path $shortcutPath) {
	throw "Shortcut already exists at '$shortcutPath'. Try editing this with the Windows GUI."
}

$pathToPageant = (Get-Command 'pageant').Source

$arguments = @()
$arguments += "`"$PrivateKeyPath`""

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $pathToPageant
$Shortcut.Arguments = ($arguments -join ' ')
$Shortcut.Save()

Write-Host "Saved shortcut at '$shortcutPath'"

# Set the git SSH environment variable
$plinkExe = (Get-Command 'plink').Source
[Environment]::SetEnvironmentVariable('GIT_SSH', $plinkExe, 'Machine')