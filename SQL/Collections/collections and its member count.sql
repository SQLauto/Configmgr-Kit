SELECT       COLL.CollectionID,COLL.Name, 
COLL.MemberCount, Count(*) As 'Direct Member Rule Count'
FROM            dbo.v_CollectionRuleDirect CRD INNER JOIN
                         dbo.v_Collection COLL ON 
CRD.CollectionID = COLL.CollectionID 
Group by coll.CollectionID, coll.Name, coll.MemberCount
having count(*)>1
order by 4 desc