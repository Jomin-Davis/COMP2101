function systemreport {
   Param ($System, $Disk, $Network)
   if ( !($System) -and !($Disk) -and !($Network)) {
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
   elseif ($Disk) {
      Get-PhysicalDisk
   }
   elseif ($Network) {
      Get-NetworkAdapter
   }
}