select fcm.collectionid [Collection ID],coll.Name,
count(case when fcm.IsActive=1 then '*' else NULL end) [Active Clients],
count(case when fcm.IsClient= 1 then '*' else NULL end) [Client Installed],
count(case when fcm.IsAssigned=1 then '*' else NULL end) [Assigned Clients],
count(case when fcm.IsObsolete= 1 then '*' else NULL end) [Obsolete Clients]
 from v_FullCollectionMembership fcm,v_Collection coll
where fcm.ResourceType='5' and fcm.CollectionId=coll.CollectionID
group by fcm.CollectionID,coll.Name
order by fcm.CollectionID