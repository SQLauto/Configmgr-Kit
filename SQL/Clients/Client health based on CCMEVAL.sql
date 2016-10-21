declare @day int
set @day=30
SELECT ER.Result,case ER.Result
when 1 then 'Not yet evaluated' when 2 then 'Not applicable' when 3 then 'Evaluation failed'
when 4 then 'Evaluated, remediation failed' when 5 then 'Not evaluated, dependency failed' 
when 6 then 'Evaluated, remediation succeeded' when 7 then 'Evaluated,succeeded: All tests passed'
ELSE 'Others'end as 'Client Health Description',Count(*) [Total Clients]
from v_CH_EvalResults ER,v_r_system sys
where -- (DATEDIFF(dd,ER.EvalTime,GetDate()-@Day) <0) and
er.NetBiosName=sys.Name0 and
datediff(dd,sys.Last_Logon_Timestamp0,getdate())<30
AND sys.operatingSystem0 NOT LIKE '%server%'
group by er.Result
order by 3

declare @day int
set @day=30
select ER.NetBiosName,us.Full_User_Name0,OS.Caption0 [OS],WS.LastHWScan,ER.EvalTime,er.HealthCheckDescription From v_CH_EvalResults ER
left join v_GS_OPERATING_SYSTEM os ON Er.ResourceID=os.ResourceID
left join v_GS_WORKSTATION_STATUS WS on Er.ResourceID=Ws.ResourceID
left join v_GS_COMPUTER_SYSTEM CS on er.ResourceID=cs.ResourceID
left join v_R_User us on us.Unique_User_Name0=cs.UserName0
where (DATEDIFF(dd,ER.EvalTime,GetDate()-@Day) >0)
--and NetBiosName='PHHG9X3R1'
--where er.Result=5
group by ER.NetBiosName,OS.Caption0,WS.LastHWScan,ER.EvalTime,us.Full_User_Name0,er.HealthCheckDescription
order by 1

select top 2 * From v_R_User

SELECT ER.Result,case ER.Result
when 1 then 'Not yet evaluated' when 2 then 'Not applicable' when 3 then 'Evaluation failed'
when 4 then 'Evaluated, remediation failed' when 5 then 'Not evaluated, dependency failed' 
when 6 then 'Evaluated, remediation succeeded' when 7 then 'Evaluated,succeeded: All tests passed'
ELSE 'Others'end as 'Client Health Description'
from v_CH_EvalResults ER
group by er.Result

select top 10 * from v_CH_EvalResults where NetBiosName='SGKSMDT1212053'

declare @day int
set @day=30
select che.netbiosname,che.evaltime from v_CH_EvalResults CHE
,dbo.v_R_system AS sys
where (DATEDIFF(dd,che.EvalTime,GetDate()-@Day) >0) AND
che.NetBiosName=sys.Name0 and
datediff(dd,sys.Last_Logon_Timestamp0,getdate())<30
AND sys.operatingSystem0 NOT LIKE '%server%'

