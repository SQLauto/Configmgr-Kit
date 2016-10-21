DECLARE @days INT
set @days=30

SELECT psd.PackageID,p.Name,
SUBSTRING(PSD.ServerNALPath, 13, CHARINDEX('.', PSD.ServerNALPath) -13 ) AS [Server Name] ,
PSd.LastCopied,PSd.SiteCode [Reporting Site],PSD.SourceVersion,
SP.SourceSize / 1000 AS [Size (MB)],
PSd.SummaryDate,PSD.InstallStatus
from v_PackageStatusDistPointsSumm PSD
inner join v_Package P ON P.PackageID=psd.PackageID
inner join SMSPackages SP ON SP.PkgID=P.PackageID
inner join v_PackageStatusRootSummarizer PSR ON PSR.PackageID=psd.PackageID
left join v_TaskSequenceAppReferencesInfo tsr on tsr.RefAppPackageID=psd.PackageID
--WHERE (PSd.State <> 0) and (PSD.ServerNALPath like '%zachfps01%') 
--and psd.PackageID='tp1004c3'
where psd.ServerNALPath like '%thbafps01%' and
(tsr.PackageID='tp1004cc' or tsr.PackageID='tp1004c7' or tsr.packageid='TP1004ce')
group by psd.PackageID,p.Name,psd.ServerNALPath,psd.LastCopied,
psd.SiteCode,psd.SourceVersion,sp.SourceSize,psd.SummaryDate,psd.InstallStatus
having (datediff(dd,max(psd.SummaryDate),getdate()-@days) >0)
order by 8
