select distinct

s1.Netbios_Name0,

ci2.FullName,

ae.AssignmentID,

ae.descript,

ae.AppEnforcementState,

ci2.LastComplianceMessageTime,

ae.EnforcementState,

case when ae.EnforcementState = 1001 then 'Already Present'

when ae.EnforcementState >= 1000 And ae.EnforcementState < 2000 And ae.EnforcementState <> 1001 then 'Compliant'

when ae.EnforcementState >= 2000 And ae.EnforcementState < 3000 then 'InProgress'

when ae.EnforcementState >= 3000 And ae.EnforcementState < 4000 then 'RequirementsNotMet'

when ae.EnforcementState >= 4000 And ae.EnforcementState < 5000 then 'Unknown'

when ae.EnforcementState >= 5000 And ae.EnforcementState < 6000 then 'Error'

End as 'State'

from v_R_System_Valid s1

join vAppDTDeploymentResultsPerClient ae on ae.ResourceID=s1.ResourceID

join v_CICurrentComplianceStatus ci2 on ci2.CI_ID=ae.CI_ID AND ci2.ResourceID=s1.ResourceID

where ae.Descript like '%Acrobat%'

and ae.EnforcementState is not null