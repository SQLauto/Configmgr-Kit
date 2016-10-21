

	select top 10 * From v_CH_ClientSummary

	select count(sys.name0) [Total Computers],
	Count(CS.resourceID) [Client Installed],
	SUM (CASE WHEN cs.ClientActiveStatus = 1 THEN 1 
                        ELSE 0 END) AS 'Active Clients',
               SUM(CASE WHEN cs.ClientState=1 OR ClientState=3 THEN 1 
                        ELSE 0 END) AS 'Clients Passed Health Check',
               SUM(CASE WHEN cs.ClientState=2 THEN 1 
                        ELSE 0 END) AS 'Clients failed health Check',
			  SUM(CASE WHEN sys.Client0 is NULL THEN 1 
                        ELSE 0 END) AS 'Client Missing',
ROUND((CAST(count(cs.ResourceID) as float) /COUNT(sys.ResourceID) )*100,2) as 'Client %',
round((CAST(SUM (CASE WHEN cs.ClientActiveStatus = 1 THEN 1 ELSE 0 END) as float)/COUNT(sys.ResourceID ) )*100,2) as 'Active %',
round((CAST(count(case when  sys.Client0 is NULL then '*' else NULL end) as float)/COUNT(sys.ResourceID ) )*100,2) as 'Missing %'
			from v_CH_ClientSummary CS
			right join v_r_system sys on cs.ResourceID=sys.ResourceID



						select sys.name0,sys.client0,sys.active0 from v_CH_ClientSummary CS,v_r_system sys
						where cs.ResourceID=sys.ResourceID and ClientActiveStatus = 0

						select * from  v_CH_ClientSummary where ClientActiveStatus != 1


