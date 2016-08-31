function Remove-VimTempFiles {
  Get-ChildItem -Recurse -Include "*~" | Remove-Item
}

function Expand-ZIPFile() {
  Param(
    [Parameter(Mandatory=$True)]
    [string]$File,

    [Parameter()]
    [string]$Destination
  )

  $filePath = (Resolve-Path -Path $File).Path
  if (-not $Destination) {
    $Destination = Split-Path -Path $filePath -Parent
  }

  Write-Host "Unzipping [$filePath] to [$Destination]"

  $shell = new-object -com shell.application
  $zip = $shell.NameSpace($filePath) 
  foreach($item in $zip.items()) { 
    $shell.Namespace($Destination).copyhere($item) 
  } 
}
