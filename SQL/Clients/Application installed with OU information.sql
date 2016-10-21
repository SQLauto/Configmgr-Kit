select  cs.Name0 [Computer Name],u.Full_User_Name0 [User Name],arp.DisplayName0 [Application Name],arp.Version0,max(ou.System_OU_Name0) [OU Name] ,ws.LastHWScan
from v_Add_Remove_Programs arp
left join v_RA_System_SystemOUName OU on ou.ResourceID=arp.ResourceID
left join v_GS_COMPUTER_SYSTEM cs on cs.ResourceID=arp.ResourceID
left join v_R_User U ON U.Unique_User_Name0=cs.UserName0
left join v_GS_WORKSTATION_STATUS ws on ws.ResourceID=arp.ResourceID
where DisplayName0 like 'adobe acrobat _ pro%%'
and (ou.System_OU_Name0 like '%MACA%' or ou.System_OU_Name0 like '%TNTU%' or ou.System_OU_Name0 like '%DZAL%' )
group by cs.Name0,u.Full_User_Name0,arp.DisplayName0,arp.Version0,ws.LastHWScan
order by 1
