select sys.name0 [Computer Name],sys.operatingSystem0,arp.DisplayName0 [Application Name],arp.Version0 [Version],arp.publisher0 [Publisher] From v_Add_Remove_Programs arp
inner join v_R_System sys on arp.resourceid=sys.resourceid
where publisher0 like 'Microsoft%'
AND sys.operatingSystem0 LIKE '%server%'
AND  arp.DisplayName0 NOT LIKE 'Security Update%'
AND arp.DisplayName0 NOT LIKE 'hotfix%'
AND arp.DisplayName0 NOT LIKE 'update for%'
AND sys.Client0='1'
AND datediff(dd,sys.Last_Logon_Timestamp0,Getdate())<180

--where displayname0 like 'Microsoft Silverlight'
--and sys.operatingsystem0 not like '%server%'
order by sys.name0


select count(*)* From v_Add_remove_programs where displayname0 like 'Microsoft Silverlight'