select top 2 * From v_TaskSequencePackage where packageid='CMS00144'

select TP.name [TS Name],TP.packageID [TS ID],TP.Description,TP.sourcesite [Source Site] From  v_TaskSequenceReferencesInfo TSR
inner join v_TaskSequencePackage TP on TP.PackageID=TSR.PackageID
inner join  v_Package pkg on pkg.packageid=tsr.packageid
 where referencepackageid='CMS00144' AND pkg.PackageType =@pkgType
 from  v_Package pkg
GROUP BY pkg.PackageType
ORDER BY 1

select packagetype From  v_Package
group by packagetype

SELECT pkg.PackageType,
Case pkg.PackageType
When 0 Then 'Software Distribution Package'
When 3 Then 'Driver Package'
When 4 Then 'Task Sequence Package'
When 5 Then 'software Update Package'
When 6 Then 'Device Settings Package'
When 8 Then 'Application'
When 7 Then 'Virtual Package'
When 257 Then 'Image Package'
When 258 Then 'Boot Image Package'
When 259 Then 'OS Install Package'
Else ' '
END AS 'Package Type Desc'
from  v_Package pkg
GROUP BY pkg.PackageType
ORDER BY 1



--where pkg.PackageType='257'


select
pkg.Name as [Package Name],
pkg.PackageID
from  v_Package pkg
where pkg.PackageType=@pkgType
order by 1
