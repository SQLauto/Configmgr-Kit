﻿Add-Type -Path "C:\Program Files\Update Services\API\Microsoft.UpdateServices.Administration.dll"

$UseSSL = $False

$PortNumber = 8530

$Server = "VSGRHOWPSCM02"

$ReportLocation = "D:\Sources\Tools\WSUS\WSUS_CleanUpTaskReport.html"

$SMTPServer = "smtp.eskonr.com"

$SMTPPort = 25

$To = "Eswar Koneti <eswar.koneti@eskonr.com>"

$From = "ConfigMgr <configmgr@eskonr.com>"

$WSUSConnection = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($Server,$UseSSL,$PortNumber)

#Clean Up Scope

$CleanupScopeObject = New-Object Microsoft.UpdateServices.Administration.CleanupScope

$CleanupScopeObject.CleanupObsoleteComputers = $True

$CleanupScopeObject.CleanupObsoleteUpdates = $True

$CleanupScopeObject.CleanupUnneededContentFiles = $True

$CleanupScopeObject.CompressUpdates = $True

$CleanupScopeObject.DeclineExpiredUpdates = $True

$CleanupScopeObject.DeclineSupersededUpdates = $True

$CleanupTASK = $WSUSConnection.GetCleanupManager()

$Results = $CleanupTASK.PerformCleanup($CleanupScopeObject)

$DObject = New-Object PSObject

$DObject | Add-Member -MemberType NoteProperty -Name "SupersededUpdatesDeclined" -Value $Results.SupersededUpdatesDeclined

$DObject | Add-Member -MemberType NoteProperty -Name "ExpiredUpdatesDeclined" -Value $Results.ExpiredUpdatesDeclined

$DObject | Add-Member -MemberType NoteProperty -Name "ObsoleteUpdatesDeleted" -Value $Results.ObsoleteUpdatesDeleted

$DObject | Add-Member -MemberType NoteProperty -Name "UpdatesCompressed" -Value $Results.UpdatesCompressed

$DObject | Add-Member -MemberType NoteProperty -Name "ObsoleteComputersDeleted" -Value $Results.ObsoleteComputersDeleted

$DObject | Add-Member -MemberType NoteProperty -Name "DiskSpaceFreed" -Value $Results.DiskSpaceFreed

#HTML style

$HeadStyle = "<style>"

$HeadStyle = $HeadStyle + "BODY{background-color:peachpuff;}"

$HeadStyle = $HeadStyle + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"

$HeadStyle = $HeadStyle + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:thistle}"

$HeadStyle = $HeadStyle + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:palegoldenrod}"

$HeadStyle = $HeadStyle + "</style>"

$Date = Get-Date

$DObject | ConvertTo-Html -Head $HeadStyle -Body "<h2>$($ENV:ComputerName) WSUS Report: $date</h2>" | Out-File $ReportLocation -Force

#Send-MailMessage -To $To -from $FROM -subject "WSUS Clean Up Report" -smtpServer $SMTPServer -Attachments $ReportLocation -Port $SMTPPort

#To Create Task Schedule to run the job every week ,use the following 3 lines of code to automate it

#$A = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument '-ExecutionPolicy ByPass -File D:\Sources\Tools\WSUS\WSUSCleanupTask.ps1'
#$T = New-ScheduledTaskTrigger -WeeksInterval 1 -DaysOfWeek Sunday -At "01:00" -Weekly
#Register-ScheduledTask -User "NT AUTHORITY\SYSTEM" -TaskName 'WSUS CleanUP TASK' -Trigger $T -Action $A