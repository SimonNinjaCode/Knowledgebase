#Creates new folder based on filexetension utilising parameter BaseName for not expressing the extension on the folder name.
$directory = "C:\SoftPaqDownloadDirectory\HP 800 G1 SFF"
Set-Location "C:\SoftPaqDownloadDirectory\HP 800 G1 SFF"
Get-ChildItem -File -Path $directory -Filter "*.exe" | 
ForEach-Object {
New-Item -ItemType Directory "$($_.BaseName.Split("_")[0])" -Force;   
Move-Item -Path $_.Name -Destination  "$($_.BaseName.Split("_")[0])\$($_.Name)"      
}