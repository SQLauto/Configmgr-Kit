select distinct tp.name [TS Name],TSR.ReferencePackageID,tsr.ReferenceName,tsr.ReferenceDescription ,ReferencePackageType =
Case tsr.ReferencePackageType
When 0 Then 'Software Distribution Package'
When 3 Then 'Driver Package'
When 4 Then 'Task Sequence Package'
When 5 Then 'software Update Package'
When 6 Then 'Device Settings Package'
When 7 Then 'Virtual Package'
When 8 Then 'Application'
When 257 Then 'Image Package'
When 258 Then 'Boot Image Package'
When 259 Then 'OS Install Package'
End
from v_TaskSequenceReferencesInfo TSR, v_TaskSequencePackage TP
where tsr.PackageID=tp.PackageID and
tsr.ReferencePackageID in (select PackageID from v_PackageStatusDistPointsSumm )
order by 1

select top 2 * from v_TaskSequencePackage
