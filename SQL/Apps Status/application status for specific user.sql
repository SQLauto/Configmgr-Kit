--http://systemcenteradmin.com/?p=67

DECLARE @user varchar(50);
SET @user='kom\eswar.koneti'
DECLARE @appname varchar(50);
SET @appname='Data Loss Prevention V12.0.1'

select
all

SMS_AppDeploymentAssetDetails.AppName as 'App Name',

CASE WHEN SMS_AppDeploymentAssetDetails.AppStatusType = '1' Then 'Success'
when SMS_AppDeploymentAssetDetails.AppStatusType = '2' Then 'In Progress'
when SMS_AppDeploymentAssetDetails.AppStatusType = '3' Then 'Requirements Not Met'
when SMS_AppDeploymentAssetDetails.AppStatusType = '4' Then 'Unknown'
when SMS_AppDeploymentAssetDetails.AppStatusType = '5' Then 'Error'
else 'Unknown'
End as 'App Status Type',

CASE WHEN SMS_AppDeploymentAssetDetails.ComplianceState = '1' Then 'Compliant'
WHEN SMS_AppDeploymentAssetDetails.ComplianceState = '2' Then 'Non-Compliant'
WHEN SMS_AppDeploymentAssetDetails.ComplianceState = '4' Then 'Error'
WHEN SMS_AppDeploymentAssetDetails.ComplianceState = '6' Then 'Partial Compliance'
else 'Unknown'
End as 'Compliance State',

CASE WHEN SMS_AppDeploymentAssetDetails.EnforcementState  >= 5000 then 'Error'
when SMS_AppDeploymentAssetDetails.EnforcementState  >= 4000 then 'Unknown'
when SMS_AppDeploymentAssetDetails.EnforcementState  >= 3000 then 'Requirements Not Met'
when SMS_AppDeploymentAssetDetails.EnforcementState  >= 2000 then 'In Progress'
when SMS_AppDeploymentAssetDetails.EnforcementState  >= 1000 then 'Success'
else 'Unknown'
End As 'Enforcement State',

CASE WHEN SMS_AppDeploymentAssetDetails.DeploymentIntent  = '1' Then 'Install'
WHEN SMS_AppDeploymentAssetDetails.DeploymentIntent  = '2' Then 'Uninstall'
WHEN SMS_AppDeploymentAssetDetails.DeploymentIntent  = '3' Then 'Preflight'
else 'Unknown'
End as 'Deployment Intent',

SMS_AppDeploymentAssetDetails.DTName as 'Deplyoment Type Name',

CASE WHEN SMS_AppDeploymentAssetDetails.InstalledState  = '1' Then 'Uninstall'
WHEN SMS_AppDeploymentAssetDetails.InstalledState  = '2' Then 'Install'
WHEN SMS_AppDeploymentAssetDetails.InstalledState  = '3' Then 'Unknown'
else 'Unknown'
End as 'Installed State',

CASE WHEN SMS_AppDeploymentAssetDetails.IsMachineAssignedToUser = '1' Then 'Yes'
Else 'No'
End as 'Device Assigned to User?',
SMS_AppDeploymentAssetDetails.MachineName as 'Device Name',

 

CASE WHEN CHARINDEX('\',SMS_AppDeploymentAssetDetails.UserName)>0 THEN SUBSTRING
(SMS_AppDeploymentAssetDetails.UserName,CHARINDEX('\',SMS_AppDeploymentAssetDetails.UserName)+1,255)
ELSE SMS_AppDeploymentAssetDetails.UserName END 'User Name'

from fn_AppDeploymentAssetDetails(1033) AS SMS_AppDeploymentAssetDetails

where

((SMS_AppDeploymentAssetDetails.UserName like '%' +  @user
or SMS_AppDeploymentAssetDetails.UserName =  '(SYSTEM)')

AND (SMS_AppDeploymentAssetDetails.AppName in (@appname )))
ORDER BY 9

--SELECT TOP 2 * FROM fn_AppDeploymentAssetDetails(1033)where dbo.fn_AppDeploymentAssetDetails.appname like '%Data loss%'
-- WHERE dbo.fn_AppDeploymentAssetDetails.UserName LIKE 'kom\eswar.koneti'