function Add-PathToEnvironment {
  Param(
    [Parameter(Mandatory=$True)]
    [string] $addedPath
  )

  $cleanedPath = (Resolve-Path $addedPath -ErrorAction Stop).Path.TrimEnd('\')

  Write-Host "Adding the path '$cleanedPath' to the existing system path" -ForegroundColor Yellow

  $currentPath = [Environment]::GetEnvironmentVariable('Path', 'User')
  $newPath = $currentPath
  if (-not $newPath.EndsWith(';')) {
	$newPath += ';'
  }

  $newPath += $cleanedPath;

  [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
}
