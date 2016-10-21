SELECT distinct v_CIAssignment.AssignmentName, v_CIAssignment.CollectionName, 
v_R_System.Name0 [Computer_Name], v_R_System.User_Name0, IIf([EnforcementState]=1001,'Already Present',
IIf([EnforcementState]>=1000 And [EnforcementState]<2000 And [EnforcementState]<>1001,'Success',
IIf([EnforcementState]>=2000 And [EnforcementState]<3000,'In Progress',
IIf([EnforcementState]>=3000 And [EnforcementState]<4000,'Requirements Not Met ',
IIf([EnforcementState]>=4000 And [EnforcementState]<5000,'Unknown',
IIf([EnforcementState]>=5000 And [EnforcementState]<6000,'Error','Unknown')))))) AS Status,
dbo.vAppDeploymentResultsPerClient.LastModificationTime
FROM v_R_System INNER JOIN (dbo.vAppDeploymentResultsPerClient
 INNER JOIN v_CIAssignment ON dbo.vAppDeploymentResultsPerClient.AssignmentID = v_CIAssignment.AssignmentID) ON v_R_System.ResourceID = dbo.vAppDeploymentResultsPerClient.ResourceID
 WHERE v_R_System.Name0 = 'sggc8z5q1'

 select top 10 * from v_CIAssignment where AssignmentName like'%tetra pak sans%'

 select * from v_Advertisement

 select top 2 * From v_ApplicationAssignment where AssignmentAction!=1

  select CA.ApplicationName,
 case when NotifyUser=1 then 'Yes' Else 'No' End as 'Show Notifications in SC',
 case when AssignmentAction=2 then 'Avilable' Else 'Uninstall' End as 'Action',
 CA.CreationTime,CA.LastModificationTime,CA.LastModifiedBy from v_ApplicationAssignment CA,v_Collection coll
 where ca.CollectionID=coll.CollectionID and
 coll.CollectionID like 'TP10049E' and (CA.AssignmentName not like '%Software Update%' and CA.AssignmentName not like '%Endpoint Protection%')

 select adv.AdvertisementName,adv.ProgramName,adv.ExpirationTime from v_Advertisement adv,v_Collection coll
 where adv.CollectionID=coll.CollectionID
 and coll.CollectionID like 'TP10049E'

