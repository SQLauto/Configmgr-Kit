select s.SiteCode,s.PackageID,p.Name,Case P.PackageType When 0 Then 'Package' When 8 Then 'Application' When 3 Then 'Driver' When 4 Then 'Task Sequence' When 5 Then 'software Update'
When 7 Then 'Virtual' When 257 Then 'OSImage' When 258 Then 'BootImage' When 259 Then 'OS' else ' ' END AS 'Type',
(p.sourcesize)/1024 as "size(MB)",s.sourceversion as "DPVersion",p.storedpkgversion as Latversion,s.Installstatus as 'Package Status'
from v_PackageStatusDistPointsSumm s
inner join smspackages p on s.packageid = p.pkgid
inner join v_Package on v_Package.PackageID=p.[PkgID]
where s.PackageID not in (select PackageID from v_DistributionPoint where ServerNALPath like  '%brmmfps01%') and ServerNALPath like '%selucmdp01%'
--and s.PackageID not in ('TP100441','TP100440','TP1003EC','TP1003BE','tp100459','tp1003fd','TP100007','TP100006','TP100008')
--and s.PackageID not in ('TP1003FD','TP100006','TP100007','TP100008','TP100440','tp100441','tp1001ee','TP1002B0','TP1001BA','TP1003EC','TP1001EE','TP1003EE','TP1003F0','TP100432','TP100433','TP10042E','TP1003E9','TP100456','TP100457','tp100188','tp10019c') 
--and ((p.sourcesize)/1024)>'2000' 
and len(p.name)<49
and p.Description not like '%lund%' and p.Name not like '%test%' and p.name not like '%develop%'
and p.PackageType!=4
--and s.PackageID='tp100014'
order by 4,5