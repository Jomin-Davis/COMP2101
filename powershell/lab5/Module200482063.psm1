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

function Get-ComputerSystem {
   Write-Output "Title: Computer system details"
   Get-CimInstance -ClassName Win32_ComputerSystem | Select Description | Format-List
}

function Get-OperatingSystem {
   Write-Output "Title: Operating system details"
   Get-CimInstance -ClassName Win32_OperatingSystem | Select Name, Version | Format-List
}

function Get-Processor {
   Write-Output "Title: Processor details"
   Get-CimInstance -ClassName Win32_Processor | Select Description, MaxClockSpeed, NumberOfCores, L1CacheSize, L2CacheSize, L3CacheSize | Format-List
}

function Get-PhysicalMemory {
   Write-Output "Title: Physical memory details"
   $physicalmemories = Get-CimInstance -ClassName Win32_PhysicalMemory | Select Manufacturer, Description, Capacity, BankLabel, DeviceLocator
   $physicalmemories | Format-Table
   $totalRamSize = 0
   foreach($memorySize in $physicalmemories) {
      $totalRamSize += $memorySize.Capacity
   }
   $totalRam = $totalRamSize / 1gb
   Write-Output "Total RAM Size : $totalRam GB"
}

function Get-PhysicalDisk {
   Write-Output "Title: Physical disk drive details"
   $diskdrives = Get-CimInstance CIM_DiskDrive
   foreach($disk in $diskdrives) {
      $partitions = $disk | Get-CimAssociatedInstance -ResultClassName CIM_diskpartition
      foreach($partition in $partitions) {
         $logicaldisks = $partition | Get-CimAssociatedInstance -ResultClassName CIM_logicaldisk
         foreach($logicaldisk in $logicaldisks) {
            New-Object -TypeName psobject -Property @{Vendor=$disk.Manufacturer
                                                      Model=$disk.Model
                                                      "Size(GB)"=$logicaldisk.Size / 1gb -as [int]
                                                      "Free Space(GB)"=$logicaldisk.FreeSpace / 1gb -as [int]
                                                      "Percentage Free(GB)"=( $logicaldisk.FreeSpace / $logicaldisk.Size ) * 100 -as [float]
            }
         }
      }
   }
}

function Get-NetworkAdapter {
   Write-Output "Title: Network adapter configuration report"
   Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "True"} | Select Description, Index, IPAddress, IPSubnet, DNSDomain | Format-Table
}

function Get-VideoController {
   Write-Output "Title: Video card details"
   $tempResult = Get-CimInstance -ClassName Win32_VideoController | Select Description, Caption, CurrentHorizontalResolution, CurrentVerticalResolution
   $HorizontalResolution = $tempResult.CurrentHorizontalResolution
   $VerticalResolution = $tempResult.CurrentVerticalResolution
   $result = "$HorizontalResolution x $VerticalResolution"
   New-Object -Typename psobject -Property @{Vendor=$tempResult.Caption
                                             Description=$tempResult.Description
                                             "Current Screen Resolution"=$result
   }
}

function systemreport {
   Param ($System, $Disks, $Network)
   if ( !($System) -and !($Disks) -and !($Network)) {
      Get-ComputerSystem
      Get-OperatingSystem
      Get-Processor
      Get-PhysicalMemory
      Get-VideoController
      Get-NetworkAdapter
      Get-PhysicalDisk
   }
   elseif ($System) {
      Get-ComputerSystem
      Get-OperatingSystem
      Get-Processor
      Get-PhysicalMemory
      Get-VideoController
   }
   elseif ($Disks) {
      Get-PhysicalDisk
   }
   elseif ($Network) {
      Get-NetworkAdapter
   }
}