Import-Module ActiveDirectory

Get-Content C:\computers.txt | ForEach-Object {Get-ADComputer $_ -Properties Name,OperatingSystem,OperatingSystemServicePack |Select-Object Name,OperatingSystem,OperatingSystemServicePack} |-SearchBase "DC=KCL,DC=KEPPELGROUP,DC=COM" | Export-Csv C:\Output.csv
