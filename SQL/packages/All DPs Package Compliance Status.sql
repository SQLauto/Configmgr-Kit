select UPPER(SUBSTRING(PSD.ServerNALPath,13,CHARINDEX('.', PSd.ServerNALPath) -13)) AS [DP Name],count(psd.PackageID) [Targeted] ,
 count(CASE when PSD.State='0' then '*' END) AS 'Success',
 count(CASE when PSD.State not in ('0') then '*' END) AS 'Not Success',
  round((CAST(SUM (CASE WHEN PSD.State='0' THEN 1 ELSE 0 END) as float)/COUNT(psd.PackageID ) )*100,2) as 'Success%',
  psd.SiteCode [Reporting Site]
From v_PackageStatusDistPointsSumm psd,SMSPackages P
where p.PackageType!=4 --4 is for task sequence
and (p.PkgID=psd.PackageID)
--and psd.ServerNALPath like '%BDDKF%'
AND psd.SecureObjectID NOT LIKE 'scope%'
AND psd.SiteCode='CMS'
group by  PSd.ServerNALPath,psd.SiteCode
order by 6



