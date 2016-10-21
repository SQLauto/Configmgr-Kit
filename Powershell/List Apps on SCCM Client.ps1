 $Apps = (Get-WmiObject -Namespace "root\ccm\clientSDK" -Class CCM_Application -ComputerName localhost)
 foreach ($App in $Apps)
 {
 write-host "$($App.Name) Status $($App.InstallState)"
  }
