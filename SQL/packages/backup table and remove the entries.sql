select * from PkgNotification

select * from pkgservers where pkgid='tp10019c' and action=3

select * into pkgserversbak1 from dbo.pkgservers
delete  pkgservers where(pkgid='tp10042E') and action=3

 select * from pkgservers where(pkgid='TP100458') and action=3


 
select * into v_distributionpointdriveinfoback1 from v_distributionpointdriveinfo


Update v_distributionpointdriveinfo Set AvailableContentLibDrivesList = 'F',AvailablePkgShareDrivesList='F' where NALPath like '%SGCMDP%'


select * from v_distributionpointdriveinfoback1 where AvailableContentLibDrivesList like '%f%'

