$env:path += ";C:/Users/Jomin/Documents/GitHub/COMP2101/powershell"

# To create notepad alias
new-item -path alias:np -value notepad

# Welcome script for profile
function welcome {
   write-output "Welcome to planet $env:computername Overlord $env:username"
   $now = get-date -format 'HH:MM tt on dddd'
   write-output "It is $now."
}
welcome

# Fetching CPU information with the help of Get-CimInstance CIM_Processor
function get-cpuinfo {
   Get-CimInstance CIM_Processor | Select Caption, Manufacturer, NumberOfCores, CurrentClockSpeed, MaxClockSpeed | Format-List
}

# Fetching disk information with the help of WMIC DiskDrive
function get-mydisks {
   WMIC DiskDrive Get Model,Manufacturer,SerialNumber,FirmwareRevision,Size | Format-Table -autosize
}