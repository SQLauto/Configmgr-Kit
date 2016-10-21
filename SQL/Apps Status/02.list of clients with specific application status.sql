select ADS.MachineName,os.Caption0 [OS],CS.UserName0 [Last Loggedon],
case ADS.deploymentintent when '1' then 'Required' Else 'Available' end as 'Purpose',
ADS.StartTime,CHS.LastMPServerName,WS.LastHWScan,
case ADS.Statustype  when '1' then 'success'  when '2' then 'InProgress'  when '3' then 'RequirementsNotMet'  when '4' then 'Unknown'  when '5' then 'Error'  end as 'Status',aa.AssignmentName
 From vAppDeploymentAssetDetails ads  --, v_GS_COMPUTER_SYSTEM CS,v_CH_ClientSummary CHS,v_GS_WORKSTATION_STATUS WS,v_GS_OPERATING_SYSTEM os
left join v_GS_COMPUTER_SYSTEM CS on cs.ResourceID=ads.MachineID
 right join v_CH_ClientSummary CHS on chs.ResourceID=ads.machineid
 left join v_GS_WORKSTATION_STATUS ws on ws.ResourceID=ads.machineid
 left join v_GS_OPERATING_SYSTEM os on os.ResourceID=ads.machineid
  right join v_ApplicationAssignment aa on aa.AssignmentID=ads.AssignmentID
  where ADS.AssignmentID='16779731'
  and ads.StatusType='3'
  group by ads.MachineName,ads.StartTime,ads.DeploymentIntent,ads.StatusType,cs.UserName0,CHS.LastMPServerName,WS.LastHWScan,os.Caption0,aa.AssignmentName

 select case StatusType
 when '1' then 'Success'
 when '2' then 'InProgress'
 when '3' then 'RequirementsNotMet'
 when '4' then 'Unknown'
 when '5' then 'Error' ELSE 'Null'
  end as 'Status',statustype
  From vAppDeploymentAssetDetails
  group by StatusType
  order by 1


 select machinename from vAppDeploymentAssetDetails where AssignmentID='16779731' and StatusType='3'
 group by machinename