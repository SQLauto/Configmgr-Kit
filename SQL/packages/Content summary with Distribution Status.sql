SELECT case when grouping(pkgs.type)=1 THEN 'Total' ELSE Type end as Type,sum(pkgs.count)[Count]
FROM 
(
SELECT CASE LCE.ObjectType When 0 Then 'Package' When 512 Then 'Application' When 3 Then 'Driver' When 4 Then 'Task Sequence' When 5 Then 'Software Update'
When 7 Then 'Virtual' When 257 Then 'OSImage' When 258 Then 'BootImage' When 259 Then 'OS' END AS 'Type',Count (*) AS count
FROM fn_ListObjectContentExtraInfo(1033) LCE
GROUP BY LCE.ObjectType ) pkgs
GROUP BY pkgs.Type WITH ROLLUP


SELECT  LCE.SoftwareName,
Case LCE.objectType When 0 Then 'Package' When 512 Then 'Application' When 3 Then 'Driver' When 4 Then 'Task Sequence' When 5 Then 'software Update'
When 7 Then 'Virtual' When 257 Then 'OSImage' When 258 Then 'BootImage' When 259 Then 'OS' END AS 'Type',
LCE.PackageID,LCE.SourceSize/1024 [Size in MB],LCE.SourceSite,LCE.Targeted,LCE.NumberInProgress,LCE.NumberInstalled,LCE.NumberErrors
,LCE.NumberUnknown FROM fn_ListObjectContentExtraInfo(1033) LCE
ORDER BY 3






 select * From fn_ListObjectContentExtraInfo(1033) LCE