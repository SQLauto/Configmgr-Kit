select 
case ADS.Statustype
 when '1' then 'Success'
 when '2' then 'InProgress'
 when '3' then 'RequirementsNotMet'
 when '4' then 'Unknown'
 when '5' then 'Error'
 end as 'Status',
Count(distinct ADS.MachineName) as Total
 From fn_AppDeploymentAssetDetails(1033) ADS
 where ADS.DTName like 'UE-V 2.0 Patch for Excel' and
 ADS.CollectionName='SU_CM_San_Test_Computers'
 group by ADS.StatusType