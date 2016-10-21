# =======================================================================================
# 
# Name: RemoveExpiredUpdates.ps1
# Author: Jeroen Erkelens
#Modified by: Eswar Koneti
# Version: 0.6
# Date: 16-Sep-2015
# Goal: Enumerate all Software Update groups. For CM2012 R2, WSUS cleanup will remove the 
#       expired updates from the deployment packages.
# 
# =======================================================================================
Clear-Host
 
# ====================================
# Defining the environment
# Please modify these settings to match your environment:
# CMServerName = your CM site server
# CMSiteCode = your CM site code
# ====================================
$CMServerName = "SGRHOWPSCM01"
$CMSiteCode = "SGP"
$CMNameSpace = "root\sms\site_$($CMSiteCode)"
 
 
# ====================================
# Update Software Update Groups
# ====================================
 
# Retrieve all Software Update Groups
Write-Host "Getting all Software Update Groups ..."
$AllSUPGroups = gwmi -computername "$CMServerName" -Namespace $CMNameSpace -query "SELECT * FROM SMS_AuthorizationList where LocalizedDisplayName like 'SUM%'"
Write-Host "$($allsupgroups.count) found`n" 
 
if ($AllSUPGroups -eq $null) {
	Write-Host "No Update Groups found!"
	Exit
}
 
# Retrieve all Updates within the Update Group
foreach ($SUPGroup in $AllSUPGroups) {
    $SUPGroupCIID = $SUPGroup.CI_ID
    $SUPGroupName = $SUPGroup.LocalizedDisplayName
    Write-Host "`nGetting updates information for '$($SUPGroupName)'"
 
    $updates = gwmi -computername $CMServerName -Namespace $CMNameSpace -query "SELECT SU.* FROM SMS_SoftwareUpdate SU, SMS_CIRelation CIRelation WHERE CIRelation.FromCIID=$($SUPGroupCIID) AND CIRelation.RelationType=1 AND SU.CI_ID=CIRelation.ToCIID"
    Write-Host "There are $($updates.length) updates in the group"
 
	# Evaluate updates
    foreach($update in $updates)
	{
		if ($update.IsExpired -eq $true) { continue }
		$SUPGroup.Updates += $update.CI_ID
	}
 
	if ($SUPGroup.Updates.Length -eq $updates.Length) 
	{
        Write-Host "There are $($SUPGroup.Updates.Length - $updates.length) expired updates in the group ..."
	} else {
    	Write-Host "Updating Software Update Group..."
	    $SUPGroup.Put() | Out-Null
	    Write-Host "Software Update Group $SUPGroupName updated successfully..."
    }
}