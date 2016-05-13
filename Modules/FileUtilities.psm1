function Remove-VimTempFiles {
  Get-ChildItem -Recurse -Include "*~" | Remove-Item
}
