# Lab 3 - IP Configuration report

Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "True"} | Select Description, Index, IPAddress, IPSubnet, DNSDomain | Format-Table