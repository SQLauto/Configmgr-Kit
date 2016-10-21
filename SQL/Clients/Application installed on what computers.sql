select sys.name0 [Computer Name],us.Full_User_Name0,sys.User_Name0,sys.Last_Logon_Timestamp0,arp.ProdID0 from v_Add_Remove_Programs arp
left join v_r_system sys on arp.ResourceID=sys.ResourceID
left join v_R_User us on us.User_Name0=sys.User_Name0
where arp.DisplayName0 like '%Microsoft User Experience Virtualization Agent%'
order by 3

--select count(*) from v_Add_Remove_Programs where DisplayName0 like '%TPCAS%'

--select top 2 * from v_R_User

select * from SMSPackages where PkgID='tp1004c3'