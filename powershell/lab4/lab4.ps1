function Get-ComputerSystem {
   Write-Output "Title: Computer system details"
   Get-CimInstance -ClassName Win32_ComputerSystem | Select Description | Format-List
}
Get-ComputerSystem

function Get-OperatingSystem {
   Write-Output "Title: Operating system details"
   Get-CimInstance -ClassName Win32_OperatingSystem | Select Name, Version | Format-List
}
Get-OperatingSystem

function Get-Processor {
   Write-Output "Title: Processor details"
   Get-CimInstance -ClassName Win32_Processor | Select Description, MaxClockSpeed, NumberOfCores, L1CacheSize, L2CacheSize, L3CacheSize | Format-List
}
Get-Processor

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
Get-PhysicalMemory

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
$result = Get-PhysicalDisk
$result | Format-Table

function Get-NetworkAdapter {
   Write-Output "Title: Network adapter configuration report"
   Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "True"} | Select Description, Index, IPAddress, IPSubnet, DNSDomain | Format-Table
}
Get-NetworkAdapter

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
$result = Get-VideoController
$result | Format-List
