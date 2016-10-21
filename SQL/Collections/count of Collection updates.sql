select 
case refreshtype

when 1 then 'No Scheduled Update'
when 2 then 'Full Scheduled Update'
when 4 then 'Incremental Update (Only)'
when 6 then 'Incremental and Full Update Scheduled'
Else 'Total'
End as  RefreshType,
count(*) as Total
 from v_Collection
 group by RefreshType,RefreshType with rollup