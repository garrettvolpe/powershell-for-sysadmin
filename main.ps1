### Add user to local administrators group ###
Add-LocalGroupMember -Group "Administrators" -Member "<domain>/<user>"

### Find boot time of device ###
$computername = Read-Host "<computer name or IP>"
SystemInfo /S $Computername | find /i "Boot Time"

### Look up user info (password expiring/last changed, group memberships, last login, etc.) ###
Net user “<user>” /<DOMAIN>

### Get a list of software installed from a device ###
$ComputerName = Read-Host "Enter the computer name or IP for a list of installed software"
$remove_from_list = "<List of software you would like removed pipe delimited>" # example "Google|Zoom|Teams"
$software_list = Get-WmiObject -ComputerName $ComputerName win32_product | Select-Object Name
foreach ($item in $remove_from_list) {
$new_software_list = $software_list -notmatch $item
}
$new_software_list | Out-File "<Path to location>\<text.txt>"

### Get logged in user ###
Get-WmiObject -Class win32_computersystem -ComputerName <Computer name or IP> | select username

### Remove and install HP local printer ###
$portname = "USB001"
$checkPortExists = Get-Printerport -Name $portname -ErrorAction SilentlyContinue
if (-not $checkPortExists)
{
exit 1
}
else {
stop-Service -name spooler
Remove-Printer -Name HP
Remove-Printerdriver -Name HP
start-Service -name spooler
.\pnputil.exe -a "<path to driver inf file>"
Add-PrinterDriver -Name "<new name of printer driver>" -InfPath "C:\Windows\System32\DriverStore\FileRepository\<path to inf file>"
Add-Printer -Name "<name of new printer>" -DriverName "<name of printer driver above>" -PortName $portname
}

