		  select "Type"=
		  case when  CollectionType='2' then 'Machine Based' 
		   when  CollectionType='1' then 'Used Based' 
		  Else 'Others'
		  End,Count(*) [Total collections]
		   from v_Collection
		   group by CollectionType
		   order by CollectionType desc