(SELECT        
       COUNT(DISTINCT rs.Name0) as 'Total computers'
FROM            dbo.v_R_System AS rs 
INNER JOIN dbo.v_RA_System_SystemOUName AS ou 
       ON rs.ResourceID = ou.ResourceID
WHERE
(rs.Last_Logon_Timestamp0 > DATEADD(dd, -30, GETDATE())) AND 
(ou.System_OU_Name0 LIKE '%/computers/%tops') AND 
(ou.System_OU_Name0 NOT LIKE '%/IRTETPIR%') AND 
(ou.System_OU_Name0 NOT LIKE '%/TPCH%') AND 
(ou.System_OU_Name0 NOT LIKE '%/LocalApp%') AND
(rs.Operating_System_Name_And0 LIKE 'Microsoft Windows NT Workstation _.1') AND
rs.ResourceID not in (SELECT ResourceID FROM V_RA_System_SystemGroupName g where g.System_Group_Name0 like 'TP1\SMS.ExcludedClientComputers')
)
