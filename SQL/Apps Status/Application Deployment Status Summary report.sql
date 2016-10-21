/*
declare @Total int
              select @Total=sum(DSC.NumberSuccess+DSC.NumberInProgress+DSC.NumberUnknown+DSC.NumberErrors+DSC.NumberOther)
              from fn_DeploymentSummary(1033) DSC 
		    */

SELECT DISTINCT 
 DSC.SoftwareName, 
DSC.CollectionName,
DSC.DeploymentTime, 
DSC.ModificationTime,
AA.LastModifiedBy,
case when dsc.DeploymentIntent=2 then 'Avilable' Else 'Required' End as 'Purpose', 
sum(DSC.NumberSuccess+DSC.NumberInProgress+DSC.NumberUnknown+DSC.NumberErrors+DSC.NumberOther) [Total],
DSC.NumberSuccess, 
DSC.NumberUnknown, 
DSC.NumberErrors, 
DSC.NumberOther
FROM fn_DeploymentSummary(1033) DSC 
JOIN fn_ListApplicationCIs(1033) CIS ON DSC.CI_ID = CIS.CI_ID
JOIN v_ApplicationAssignment AA on AA.AssignmentID = DSC.AssignmentID
--WHERE dsc.AssignmentID='16777513'
GROUP BY DSC.CollectionID,
DSC.CollectionName,
DSC.SoftwareName,
DSC.DeploymentTime,
DSC.CreationTime,
DSC.ModificationTime,
AA.LastModifiedBy,
DSC.FeatureType,
DSC.DeploymentIntent,
DSC.NumberSuccess,
DSC.NumberInProgress,
DSC.NumberUnknown,
DSC.NumberErrors,
DSC.NumberOther