SELECT psd.PackageID,p.Name,psd.ServerNALPath,
PSd.LastCopied,PSd.SiteCode [Reporting Site],PSD.SourceVersion,
SP.SourceSize / 1000 AS [Size (MB)],
Case P.PackageType When 0 Then 'Package' When 8 Then 'Application' When 3 Then 'Driver' When 4 Then 'Task Sequence' When 5 Then 'software Update'
When 7 Then 'Virtual' When 257 Then 'OSImage' When 258 Then 'BootImage' When 259 Then 'OS' else ' ' END AS 'Type',
PSd.SummaryDate,PSD.InstallStatus,PSD.State
from v_PackageStatusDistPointsSumm PSD
inner join v_Package P ON P.PackageID=psd.PackageID
inner join SMSPackages SP ON SP.PkgID=P.PackageID
inner join v_PackageStatusRootSummarizer PSR ON PSR.PackageID=psd.PackageID
WHERE   (PSd.State <> 0) and PSD.ServerNALPath like '%SGNS07200001%'
--and len(p.name)>49 
 --psd.PackageID='TP1006A7'
and p.PackageType !=4
order by 10

--SELECT TOP 2 * FROM v_PackageStatusDistPointsSumm
