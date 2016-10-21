$Global:ErrorActionPreference = "SilentlyContinue"

stop-Transcript | out-null
Start-Transcript -path C:\Temp\Logs\CleanSCCMSCLogs.txt -append
$startdate = Get-Date
Get-ChildItem c:\windows\ccm\logs | Where-Object {$_.Name -like 'SCNotify*' -or $_.Name -like 'SCClient*' -or $_.Name -like '_SCNotify*' -or $_.Name -like '_SCClient*'} | Foreach-object {
$difference = New-TimeSpan -Start $startdate -End $_.LastWriteTime
  "Log: $($_.Name)"
  "Day difference: $($difference.Days)"
 if ($difference.Days -lt -2) # We delete this file if it is older than 2 days
{
     del $_.FullName
}
}