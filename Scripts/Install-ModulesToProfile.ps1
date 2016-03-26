#Add the modules to the profile directory
$sourceModules = Get-ChildItem (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\Modules')) -Filter *.psm1

foreach ($module in $sourceModules) {
	Add-ModuleToCustomProfile -ModulePath ($module.FullName)
}

