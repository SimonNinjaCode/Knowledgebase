#Separate folders containing VC_redist.x64.exe

# Install all C++ exefiles
$ExeFiles = Get-ChildItem $PSScriptRoot -Filter *.exe -Recurse
foreach($Exe in $ExeFiles.fullname){
Start-Process $Exe -ArgumentList "/q" -Wait
}