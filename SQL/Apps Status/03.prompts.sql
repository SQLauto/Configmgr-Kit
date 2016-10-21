select distinct ads.collectionname,ads.collectionid
from fn_AppDeploymentAssetDetails(1033) ADS
where ADS.DTName like 'UE-V 2.0 Patch for Excel'
group by ads.collectionname,ads.collectionid

select Distinct ADS.DTName
 from fn_AppDeploymentAssetDetails(1033) ADS
 group by ads.dtname


select
  advert.AdvertisementID,
  advert.PresentTime
from fn_rbac_Advertisement(@UserSIDs)  advert
where advert.CollectionID = @Collection and
            advert.PackageID = @PackageProgram