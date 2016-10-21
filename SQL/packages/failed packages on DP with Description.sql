SELECT
SMS_DistributionDPStatus.PackageID,
dbo.v_Package.Manufacturer + ' ' + dbo.v_Package.Name + ' ' + dbo.v_Package.[Version] AS [Content Name],
--REPLACE(dbo.RBAC_SecuredObjectTypes.ObjectTypeName, 'SMS_',") AS [Content Type],
--REPLACE(SMS_DistributionDPStatus.Name, '\', ") AS [Distribution Point],
SMS_DistributionDPStatus.SiteCode,
CASE SMS_DistributionDPStatus.MessageState
WHEN 1 THEN 'Success'
WHEN 2 THEN 'In Progress'
WHEN 4 THEN 'Failed'
ELSE 'Unknown'
END AS [Status],
CASE SMS_DistributionDPStatus.MessageID
WHEN 2303 THEN 'Content was successfully refreshed'
WHEN 2324 THEN 'Failed to access or create the content share'
WHEN 2330 THEN 'Content was distributed to distribution point'
WHEN 2384 THEN 'Content hash has been successfully verified'
WHEN 2323 THEN 'Failed to initialize NAL'
WHEN 2354 THEN 'Failed to validate content status file'
WHEN 2357 THEN 'Content transfer manager was instructed to send content to the distribution point'
WHEN 2360 THEN 'Status message 2360 unknown'
WHEN 2370 THEN 'Failed to install distribution point'
WHEN 2371 THEN 'Waiting for prestaged content'
WHEN 2372 THEN 'Waiting for content'
WHEN 2380 THEN 'Content evaluation has started'
WHEN 2381 THEN 'An evaluation task is running. Content was added to the queue'
WHEN 2382 THEN 'Content hash is invalid'
WHEN 2383 THEN 'Failed to validate content hash'
WHEN 2391 THEN 'Failed to connect to remote distribution point'
WHEN 2398 THEN 'Content Status not found'
WHEN 8203 THEN 'Failed to update package'
WHEN 8204 THEN 'Content is being distributed to the distribution point'
WHEN 8211 THEN 'Failed to update package'
ELSE 'Status message ' + CAST(SMS_DistributionDPStatus.MessageID AS VARCHAR) + ' unknown'
END AS [Message],
SMS_DistributionDPStatus.GroupCount AS [Group Count]
FROM
dbo.vSMS_DistributionDPStatus AS SMS_DistributionDPStatus
INNER JOIN dbo.RBAC_SecuredObjectTypes
ON SMS_DistributionDPStatus.ObjectTypeID = dbo.RBAC_SecuredObjectTypes.ObjectTypeID
LEFT OUTER JOIN dbo.v_Package
ON SMS_DistributionDPStatus.PackageID = dbo.v_Package.PackageID
where SMS_DistributionDPStatus.Name like '%catofps01%'
and SMS_DistributionDPStatus.MessageState<>1
ORDER BY PackageID ASC