select AA.ApplicationName, 
case when NotifyUser=1 then 'Yes' Else 'No' End as 'Notify User', 
case when  UserUIExperience=1 then 'Yes' Else 'No' End as 'UserUIExperience', 
case when AssignmentAction=2 then 'Install' Else 'Uninstall' End as 'Action', 
case when ads.DeploymentIntent=2 then 'Avilable' Else 'Required' End as 'Purpose', 
AA.CreationTime,AA.LastModificationTime,AA.LastModifiedBy from v_ApplicationAssignment AA,v_Collection coll ,vAppDeploymentStatus ADS
where (AA.CollectionID=coll.CollectionID) and (AA.AssignmentID=ADS.AssignmentID) and
coll.CollectionID='TP1001F5' and (AA.AssignmentName not like '%Software Update%' and AA.AssignmentName not like '%Endpoint Protection%') 
group by aa.ApplicationName,aa.NotifyUser,aa.UserUIExperience,aa.AssignmentAction,ads.DeploymentIntent,aa.CreationTime,aa.LastModificationTime,aa.LastModifiedBy

select top 10 * From v_Advertisement where AdvertisementName like '%outlook_%'
group by AssignedScheduleEnabled

 select adv.AdvertisementName [Advertisement Name],adv.packageid [Package ID],
 adv.ProgramName,adv.ExpirationTime,case when AssignedScheduleEnabled=0 then 'Available' Else 'Required' End as 'Purpose'
  from v_Advertisement adv,v_Collection coll
   where adv.CollectionID=coll.CollectionID
 and coll.CollectionID ='TP1001F5'
 group by adv.AdvertisementName,adv.AdvertisementID,adv.PackageID,adv.ProgramName,adv.ExpirationTime,adv.AssignedScheduleEnabled