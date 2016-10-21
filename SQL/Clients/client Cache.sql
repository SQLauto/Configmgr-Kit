select sys.name0 [Computer Name],sys.Client_Version0,os.caption0 [OS],sys.User_Name0 [Last loggedon User Name],sys.Last_Logon_Timestamp0,ws.LastHWScan,ld.FreeSpace0 [Avilable disk MB],cc.size0 [Cache Size MB]  from v_R_System sys
left join v_GS_COMPUTER_SYSTEM cs on cs.ResourceID=sys.ResourceID
left join v_GS_WORKSTATION_STATUS ws on ws.ResourceID=sys.ResourceID
left join v_GS_OPERATING_SYSTEM os on os.ResourceID=sys.ResourceID
left join  v_gs_CacheConfig CC on CC.resourceid=sys.ResourceID
left join v_GS_LOGICAL_DISK LD on ld.ResourceID=sys.ResourceID
where cc.size0<20000
and sys.Client0 = 1 AND sys.Obsolete0 = 0 AND sys.Active0 = 1
and ld.DeviceID0='C:' and ld.FreeSpace0 >'30000'
order by 1 