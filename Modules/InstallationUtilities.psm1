function Add-PathToEnvironment {
  Param(
    [Parameter(Mandatory=$True)]
    [string] $addedPath
  )

  Resolve-Path $addedPath

  Write-Host "Adding the path '$addedPath' to the existing system path" -ForegroundColor Yellow

  $currentPath = [Environment]::GetEnvironmentVariable('Path', 'User')
  $newPath = $currentPath
  if (-not $newPath.EndsWith(';')) {
	$newPath += ';'
  }

  $newPath += $addedPath;

  [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
}
