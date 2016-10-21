select sys.name0,cache.Size0 from v_GS_CACHECONFIG cache,v_R_System sys
where cache.ResourceID=sys.ResourceID
and cache.Size0<='5120'
order by sys.name0