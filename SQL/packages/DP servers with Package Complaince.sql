SELECT distinct SUBSTRING(CDR.DPNALPath,13,CHARINDEX('.', CDR.DPNALPath) -13) AS [Server Name],
CDR.PkgCount [Targetted],CDR.NumberInstalled [Installed],CDR.PkgCount-CDR.NumberInstalled [Not Installed],
PSd.SiteCode [Reporting Site],
ROUND((100 * CDR.NumberInstalled/CDR.pkgcount),2) as 'Compliance %'
from v_ContentDistributionReport_DP CDR,v_PackageStatusDistPointsSumm PSd
where CDR.DPNALPath=PSD.ServerNALPath 
and (ROUND((100 * CDR.NumberInstalled/CDR.pkgcount),2)) <100 
--and cdr.DPNALPath like '%deli%'
order by 6

