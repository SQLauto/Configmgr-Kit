$ScheduleID='{00000000-0000-0000-0000-000000000101}'
#$computers =GC "C:\Users\SGKONETIE\Desktop\computers.txt"
$Computer="SINW11078136"
#foreach ($computer in $computers)
{
Invoke-WmiMethod -Namespace root\CCM -Class SMS_Client -Name TriggerSchedule -ArgumentList $ScheduleID -computername $computer
}
