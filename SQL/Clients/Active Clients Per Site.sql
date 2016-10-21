
SELECT DISTINCT 
v_GS_COMPUTER_SYSTEM.Name0, v_GS_PC_BIOS.SerialNumber0, v_GS_COMPUTER_SYSTEM.Manufacturer0, v_GS_COMPUTER_SYSTEM.Model0, 
 v_GS_OPERATING_SYSTEM.Caption0 AS [OS Type], v_GS_OPERATING_SYSTEM.CSDVersion0 AS [OS Version], v_GS_SYSTEM_CONSOLE_USAGE_MAXGROUP.TopConsoleUser0, 
 v_R_System.User_Name0 AS [Last Logged],
 v_GS_PC_BIOS.ReleaseDate0 AS [BIOS Date], v_GS_NETWORK_ADAPTER_CONFIGUR.IPAddress0, v_GS_NETWORK_ADAPTER_CONFIGUR.DefaultIPGateway0, CASE WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '1' THEN 'Virtual' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '2' THEN 'Blade Server' WHEN 
v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '3' THEN 'Desktop' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '4' THEN 'Low-Profile Desktop' WHEN 
v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '5' THEN 'Pizza-Box' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '6' THEN 'Mini Tower' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 
LIKE '7' THEN 'Tower' WHEN v_GS_SYSTEM_ENCLOSURE.ChassisTypes0 LIKE '8' THEN 'Portable' WHEN v_GS_SYSTEM_ENCLOSURE.ChassisTypes0 LIKE '9' THEN 
'Laptop' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '10' THEN 'Notebook' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '11' THEN 'Hand-Held' 
WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '12' THEN 'Mobile Device in Docking Station' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '13' 
THEN 'All-in-One' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '14' THEN 'Sub-Notebook' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '15' THEN 
'Space Saving Chassis' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '16' THEN 'Ultra Small Form Factor' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 
LIKE '17' THEN 'Server Tower ChASsis' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '18' THEN 'Mobile Device in Docking Station' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 
LIKE '19' THEN 'Sub-ChASsis' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '20' THEN 'Bus-Expansion chASsis' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 
LIKE '21' THEN 'Peripheral ChASsis' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '22' THEN 'Storage ChASsis' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 
LIKE '23' THEN 'Rack-Mounted ChASsis' WHEN v_GS_SYSTEM_ENCLOSURE.ChASsisTypes0 LIKE '24' THEN 'Sealed-Case PC' ELSE 'Unknown' END AS 'Chassis Type' 

FROM         v_GS_PC_BIOS INNER JOIN 
                      v_GS_COMPUTER_SYSTEM ON v_GS_PC_BIOS.ResourceID = v_GS_COMPUTER_SYSTEM.ResourceID INNER JOIN 
                      v_GS_NETWORK_ADAPTER_CONFIGUR ON v_GS_COMPUTER_SYSTEM.ResourceID = v_GS_NETWORK_ADAPTER_CONFIGUR.ResourceID INNER JOIN 
                      v_GS_OPERATING_SYSTEM ON v_GS_COMPUTER_SYSTEM.ResourceID = v_GS_OPERATING_SYSTEM.ResourceID INNER JOIN 
                      v_R_System ON v_GS_COMPUTER_SYSTEM.ResourceID = v_R_System.ResourceID LEFT OUTER JOIN 
                      v_GS_SYSTEM_CONSOLE_USAGE_MAXGROUP ON v_GS_COMPUTER_SYSTEM.ResourceID = v_GS_SYSTEM_CONSOLE_USAGE_MAXGROUP.ResourceID INNER JOIN 
v_GS_SYSTEM_ENCLOSURE ON v_R_System.ResourceID = v_GS_SYSTEM_ENCLOSURE.ResourceID 
inner join v_R_User on v_R_User.User_Name0=v_R_System.User_Name0
WHERE     (v_GS_NETWORK_ADAPTER_CONFIGUR.IPEnabled0 = 1) AND (NOT (v_GS_NETWORK_ADAPTER_CONFIGUR.DefaultIPGateway0 IS NULL)) AND 
                      (v_R_System.Operating_System_Name_and0 LIKE '%Workstation%')
ORDER BY v_GS_PC_BIOS.ReleaseDate0 