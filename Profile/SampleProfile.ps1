#####################
# Initialize Posh-Git
#####################
Write-Host "Initializing Posh-Git..."
# Set Posh-Git Location #

Push-Location $poshGitInstallLocation

# Load posh-git module from current directory
Import-Module .\posh-git

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
# Import-Module posh-git

# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

	Write-Host
	Write-Host("[$(Get-Date -format "HH:mm")] ") -nonewline -ForegroundColor DarkGray

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "`r`n> "
}

Pop-Location

Start-SshAgent -Quiet

######################
# Begin Custom Profile
######################

function Get-CustomModulesDirectory {
	$path = Join-Path -Path (Split-Path -Path $profile -Parent) -ChildPath 'Modules'
	if (-not (Test-Path $path)) {
		New-Item -Path $path -ItemType Directory
	}
	return $path
}

# This function allows you to add any module to your Powershell profile.
# Simply Call Add-ModuleToCustomProfile <module path> and it will be copied in
# To load the new modules, just dot-source the profile from the command line like this:
#	. $profile

function Add-ModuleToCustomProfile {
	Param(
		[Parameter(Mandatory=$True)]
		[string] $ModulePath
	)

	#Make sure the source module exists
	$resolvedSourcePath = Resolve-Path -Path $ModulePath

	$fileName = Split-Path $resolvedSourcePath -Leaf
	$profileModulesDirectory = Get-CustomModulesDirectory

	$profileModulePath = Join-Path -Path $profileModulesDirectory -ChildPath $fileName
	$sourceModuleDirectory = Split-Path $resolvedSourcePath -Parent
	Copy-Item -Path $resolvedSourcePath -Destination $profileModulePath -Force
}

function Import-ProfileModules {
	$modulesDirectory = Get-CustomModulesDirectory
	foreach($moduleFile in (Get-ChildItem -Path $modulesDirectory -Filter '*.psm1')) {
		$modulePath = $moduleFile.FullName
		Write-Host "Loading module $modulePath"
		Import-Module $modulePath
	}
}

Import-ProfileModules

# End Custom Profile (Do Not Remove This Line)
