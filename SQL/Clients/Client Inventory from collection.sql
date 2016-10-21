SELECT vrs.Netbios_Name0 AS [Device Name], vrs.Client_Version0 AS [SCCM Client], sites.SMS_Assigned_Sites0 AS Site, cs.Domain0 AS Domain,
 cs.Manufacturer0 AS Manufacturer, cs.Model0 AS Model, cs.UserName0 AS [Console ID], os.Caption0 AS [Operating System],
 os.CSDVersion0 AS [Service Pack], os.LastBootUpTime0 AS [Last Boot], os.InstallDate0 AS [Build Date], uss.LastWUAVersion AS [WSUS Client],
 uss.LastScanTime AS [WSUS Scan], chcs.LastHW AS [Hardware Scan], chcs.LastSW AS [Software Scan],coll.collectionID,coll.name,
  CASE WHEN (se.ChassisTypes0 = '1')
 THEN 'Other' WHEN (se.ChassisTypes0 = '2') THEN 'Unknown' WHEN (se.ChassisTypes0 = '3') THEN 'Desktop' WHEN (se.ChassisTypes0 = '4')
 THEN 'Low Profile Desktop' WHEN (se.ChassisTypes0 = '5') THEN 'Pizza Box' WHEN (se.ChassisTypes0 = '6')
 THEN 'Mini Tower' WHEN (se.ChassisTypes0 = '7') THEN 'Tower' WHEN (se.ChassisTypes0 = '8') THEN 'Portable' WHEN (se.ChassisTypes0 = '9')
 THEN 'Laptop' WHEN (se.ChassisTypes0 = '10') THEN 'Notebook' WHEN (se.ChassisTypes0 = '11')
 THEN 'Hand Held' WHEN (se.ChassisTypes0 = '12') THEN 'Docking Station' WHEN (se.ChassisTypes0 = '13')
 THEN 'All in One' WHEN (se.ChassisTypes0 = '14') THEN 'Sub Notebook' WHEN (se.ChassisTypes0 = '15')
 THEN 'Space-Saving' WHEN (se.ChassisTypes0 = '16') THEN 'Lunch Box' WHEN (se.ChassisTypes0 = '17')
 THEN 'Main System Chassis' WHEN (se.ChassisTypes0 = '18') THEN 'Expansion Chassis' WHEN (se.ChassisTypes0 = '19')
 THEN 'SubChassis' WHEN (se.ChassisTypes0 = '20') THEN 'Bus Expansion Chassis' WHEN (se.ChassisTypes0 = '21')
 THEN 'Peripheral Chassis' WHEN (se.ChassisTypes0 = '22') THEN 'Storage Chassis' WHEN (se.ChassisTypes0 = '23')
 THEN 'Rack Mount Chassis' WHEN (se.ChassisTypes0 = '24') THEN 'Sealed-Case PC' ELSE se.ChassisTypes0 END AS [Chassis Type]
 FROM dbo.v_CH_ClientSummary AS chcs LEFT OUTER JOIN
 dbo.v_r_system AS vrs on chcs.ResourceID = vrs.ResourceID LEFT OUTER JOIN
 dbo.v_GS_COMPUTER_SYSTEM AS cs ON chcs.ResourceID = cs.ResourceID LEFT OUTER JOIN
 dbo.v_GS_OPERATING_SYSTEM AS os ON chcs.ResourceID = os.ResourceID LEFT OUTER JOIN
 dbo.v_GS_SYSTEM_ENCLOSURE AS se ON chcs.ResourceID = se.ResourceID LEFT OUTER JOIN
 dbo.v_RA_System_SMSAssignedSites as sites ON chcs.ResourceID = sites.ResourceID LEFT OUTER JOIN
 dbo.v_UpdateScanStatus AS uss ON chcs.ResourceID = uss.ResourceID LEFT OUTER JOIN
 v_FullCollectionMembership fcm on chcs.ResourceID=fcm.ResourceID LEFT OUTER JOIN
 v_Collection coll on fcm.CollectionID=coll.CollectionID
 WHERE coll.CollectionID='TP10000C'
 