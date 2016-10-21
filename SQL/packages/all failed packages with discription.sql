select DPS.PackageID,p.Name, DPS.Name as [server name], StatusMessage =
CASE DPS.MessageID
WHEN '2384'THEN 'Content hash has been successfully verified'
WHEN '2330'THEN 'Content was distributed to distribution point'
WHEN '2303'THEN 'Content was successfully refreshed'
WHEN '2323'THEN 'Failed to initialize NAL'
WHEN '2324'THEN 'Failed to access or create the content share'
WHEN '2354'THEN 'Failed to validate content status file'
WHEN '2357'THEN 'Content transfer manager was instructed to send content to Distribution Point'
WHEN '2360'THEN 'Status message 2360 unknown'
WHEN '2370'THEN 'Failed to install distribution point'
WHEN '2371'THEN 'Waiting for prestaged content'
WHEN '2372'THEN 'Waiting for content'
WHEN '2380'THEN 'Content evaluation has started'
WHEN '2381'THEN 'An evaluation task is running. Content was added to Queue'
WHEN '2382'THEN 'Content hash is invalid'
WHEN '2383'THEN 'Failed to validate content hash'
WHEN '2391'THEN 'Failed to connect to remote distribution point'
WHEN '2398'THEN 'Content Status not found'
WHEN '8203'THEN 'Failed to update package'
WHEN '8204'THEN 'Content is being distributed to the distribution Point'
WHEN '8211'THEN 'Failed to update package'
ELSE 'others'
END, LastUpdateDate, Status_at_LastUpdateDate =
CASE MessageState
WHEN '1'THEN 'Success'
WHEN '2'THEN 'In Progress'
WHEN '4'THEN 'Failed'
ELSE 'others'
END,
Case P.PackageType
When 0 Then 'Package'
When 8 Then 'Application'
When 3 Then 'Driver'
When 4 Then 'Task Sequence'
When 5 Then 'software Update'
When 7 Then 'Virtual'
When 257 Then 'Image'
When 258 Then 'Boot Image'
When 259 Then 'OS'
Else ' '
END AS 'Type'
from dbo.vSMS_DistributionDPStatus DPS
inner join SMSPackages P on dps.PackageID=p.PkgID
inner join v_package Pa on dps.PackageID=pa.PackageID
 where 
 --MessageState not like '1' and DPS.nalpath like '%catofps01%'  and  and pa.PackageType not like '4'
  DPS.MessageID='2383'
 ORDER BY 7

--select top 2 * From dbo.vSMS_DistributionDPStatus