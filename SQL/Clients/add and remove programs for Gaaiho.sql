SELECT vrs.name0 [Computer Name] ,
       vrs.User_Name0 ,u.description0 [PS Number],u.department0 [Department],
	  vrs.operatingSystem0,
	  varp.DisplayName0,varp.Version0,
       CONVERT ( varchar (26) , vrs.Last_Logon_Timestamp0 , 100
       ) 'Last_Logon_Timestamp0' ,
	  CONVERT ( varchar (26) , vgws.LastHWScan , 100
       ) 'LastHWScan'
	  
  FROM dbo.v_R_System AS vrs
  inner JOIN dbo.v_GS_WORKSTATION_STATUS AS vgws ON vgws.ResourceID = vrs.ResourceID
  INNER JOIN v_R_User u ON u.User_Name0 = vrs.User_Name0 
right JOIN dbo.v_Add_Remove_Programs AS varp ON varp.ResourceID=vrs.resourceid
  WHERE varp.DisplayName0 LIKE 'Intergraph SmartPlant%'
  AND vrs.Name0 NOT LIKE ''
--AND u.department0 LIKE 'KOM Human Resource'
  GROUP BY vrs.name0,vrs.User_Name0,u.description0,u.department0,vrs.operatingSystem0,varp.DisplayName0,varp.Version0,
  vrs.Last_Logon_Timestamp0 ,vgws.LastHWScan
  ORDER BY 1

  SELECT varp.DisplayName0,count (*) FROM dbo.v_Add_Remove_Programs AS varp
  WHERE varp.DisplayName0 LIKE 'Intergraph SmartPlant%'
  GROUP by varp.DisplayName0

  SELECT vrs.name0,vrs.User_Name0,vru.department0 FROM dbo.v_R_system AS vrs 
  right JOIN dbo.v_Add_Remove_Programs AS varp ON varp.ResourceID=vrs.resourceid
  RIGHT JOIN dbo.v_r_user AS vru ON vru.User_Name0 = vrs.User_Name0
  WHERE varp.DisplayName0 LIKE 'Gaaiho PDF Suite'
  AND vrs.Name0 NOT LIKE ''

  SELECT name0 FROM dbo.v_R_System AS vrs WHERE USER_NAME0='Pajan.SINGH'

  SELECT TOP 2 * FROM dbo.v_Add_Remove_Programs  varp 
  where varp.DisplayName0 LIKE 'intergraph%'

  SELECT vru.department0,count(*) FROM dbo.v_R_User AS vru
  GROUP BY vru.department0
  ORDER BY 1
