 $SUPS = (Get-WmiObject -Namespace "root\ccm\clientSDK" -Class CCM_SoftwareUpdate -ComputerName localhost)
 foreach ($SUP in $SUPS)
 {
 write-host "$($SUP.Name) Status $($SUP.EvaluationState)"
  }