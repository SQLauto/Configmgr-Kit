$CompName=read-host "Enter the Computer Name to Open CCM logs"
#test-connection "SINW11078136"
$wshell = New-Object -ComObject Wscript.Shell
if (Test-Connection $CompName -Count 1 -ea 0 -Quiet)
  { 
  start "\\$CompName\C$\Windows\syswow64\ccm\logs\"
  }
else
  {
 $wshell.Popup("Client is NOT up or cannot Communicate")
  }
  
 

