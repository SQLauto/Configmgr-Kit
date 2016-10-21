 select CA.ApplicationName,
 case when NotifyUser=1 then 'Yes' Else 'No' End as 'Notify User',
 case when  UserUIExperience=1 then 'Yes' Else 'No' End as 'UserUIExperience',
 case when AssignmentAction=2 then 'Install' Else 'Uninstall' End as 'Action',
 CA.CreationTime,CA.LastModificationTime,CA.LastModifiedBy from v_ApplicationAssignment CA,v_Collection coll
 where ca.CollectionID=coll.CollectionID and
 coll.CollectionID like 'TP10049E' and (CA.AssignmentName not like '%Software Update%' and CA.AssignmentName not like '%Endpoint Protection%')

 select SUBSTRING(adv.AdvertisementName, 1, CHARINDEX('_', adv.AdvertisementName) - 1) aS [Advertisement Name],
 adv.ProgramName,adv.ExpirationTime from v_Advertisement adv,v_Collection coll
 where adv.CollectionID=coll.CollectionID
 and coll.CollectionID like 'TP10049E'


 