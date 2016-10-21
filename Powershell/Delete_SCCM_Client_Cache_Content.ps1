#Connect to Resource Manager COM Object
$CMObject = new-object -com "UIResource.UIResourceMgr"
$cacheInfo = $CMObject.GetCacheInfo()
#Enum Cache elements, compare date, and delete older than 2 days
$objects=$cacheinfo.GetCacheElements()  | 
where-object {$_.LastReferenceTime -lt (get-date).AddDays(-2)} |
foreach {$cacheInfo.DeleteCacheElement($_.CacheElementID)}