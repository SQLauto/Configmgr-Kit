SELECT P.Name,psd.PackageID,
SUBSTRING(PSD.ServerNALPath, 13, CHARINDEX('.', PSD.ServerNALPath) -13 ) AS [Server Name] ,
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
END AS 'Type',
PSd.LastCopied,PSd.SiteCode [Reporting Site],PSD.SourceVersion,Sp.SourceSize/1024 [size MB],PSd.SummaryDate,PSD.InstallStatus
from v_PackageStatusDistPointsSumm PSD
inner join v_Package P ON P.PackageID=psd.PackageID
inner join SMSPackages SP ON sP.PkgID=P.PackageID
where PSd.State <> 0 and psd.SiteCode='sgs'
order by 2
--total 40 rows now.