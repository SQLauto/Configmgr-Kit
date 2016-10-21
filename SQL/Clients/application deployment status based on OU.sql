DECLARE @OU varchar(50),@state varchar(100);
SET @OU='KSMBN';
PRINT '%'+@OU+'%'
DECLARE @app varchar(255);
SET @app='Microsoft Office Upgrade 2010 Std to 2013 Std'
SET @state='Error'

SELECT distinct  
vrs.Name0 [Computer Name], vgos.Caption0 [OS],vrs.User_Name0 [User Name],
IIf([EnforcementState]=1001,'Already Present',
IIf([EnforcementState]>=1000 And [EnforcementState]<2000 And [EnforcementState]<>1001,'Success',
IIf([EnforcementState]>=2000 And [EnforcementState]<3000,'In Progress',
IIf([EnforcementState]>=3000 And [EnforcementState]<4000,'Requirements NotMet',
IIf([EnforcementState]>=4000 And [EnforcementState]<5000,'Unknown',
IIf([EnforcementState]>=5000 And [EnforcementState]<6000,'Error','Unknown')))))) AS Status,
vrs.Last_Logon_Timestamp0,lac.DisplayName,
vgws.LastHWScan,max(sou.System_OU_Name0) 'OU'
FROM dbo.v_R_System AS vrs INNER JOIN (dbo.vAppDeploymentResultsPerClient
INNER JOIN v_CIAssignment ON dbo.vAppDeploymentResultsPerClient.AssignmentID = v_CIAssignment.AssignmentID) ON vrs.ResourceID = dbo.vAppDeploymentResultsPerClient.ResourceID
INNER JOIN dbo.fn_ListApplicationCIs(1033) lac ON lac.ci_id=dbo.vAppDeploymentResultsPerClient.CI_ID
INNER JOIN dbo.v_GS_WORKSTATION_STATUS AS vgws ON vgws.ResourceID=vrs.resourceid
INNER JOIN dbo.v_RA_System_SystemOUName SOU ON sou.ResourceID = vrs.ResourceID
INNER JOIN dbo.v_GS_OPERATING_SYSTEM AS vgos ON vgos.ResourceID = vrs.ResourceID
 WHERE lac.DisplayName='Microsoft Office Upgrade 2010 Std to 2013 Std' --for ms office 2013 from dbo.fn_ListApplicationCIs(1033)
 AND (sou.System_OU_Name0 like '%'+@OU+'%')	
 and((@state='Already Present' AND [EnforcementState]=1001)	or
 (@state='Success' AND [EnforcementState]>=1000 And [EnforcementState]<2000 And [EnforcementState]<>1001)OR
 (@state='In Progress' AND [EnforcementState]>=2000 And [EnforcementState]<3000) OR
 (@state='Requirements NotMet' AND [EnforcementState]>=3000 And [EnforcementState]<4000) OR
 (@state='Unknown' AND [EnforcementState]>=4000 And [EnforcementState]<5000) OR
 (@state='Error' AND [EnforcementState]>=5000 And [EnforcementState]<6000))
 GROUP BY vrs.Name0,vgos.Caption0,vrs.User_Name0, EnforcementState,vrs.Last_Logon_Timestamp0,lac.DisplayName,vgws.LastHWScan
 ORDER BY 1  
 	

 --SELECT TOP 2 * FROM dbo.vAppDeploymentResultsPerClient

 --SELECT lac.DisplayName
 --FROM dbo.fn_ListApplicationCIs(1033) lac
 --INNER JOIN dbo.vAppDeploymentResultsPerClient adrp ON lac.CI_ID=adrp.CI_ID
 --GROUP BY lac.DisplayName
 --ORDER BY lac.DisplayName
 --SELECT TOP 10 * FROM fn_AppDeploymentStatus(1033)