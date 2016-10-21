#if you are not running the script on your SCCM Server(SMS provider),you will have to provide the SCCM server name here. Replace Localhost with your SCCM server
$SMSProvider = "sgkomtaccm01"
$DPName="SGKFECYCCM01"
Function Get-SiteCode
    {
        $wqlQuery = “SELECT * FROM SMS_ProviderLocation”
        $a = Get-WmiObject -Query $wqlQuery -Namespace “root\sms” -ComputerName $SMSProvider
      # write-host $a
        $a | ForEach-Object { if($_.ProviderForLocalSite)
                {
                  $script:SiteCode = $_.SiteCode
                            }
                }
    }

Get-SiteCode
Import-Module ($env:SMS_ADMIN_UI_PATH.Substring(0,$env:SMS_ADMIN_UI_PATH.Length – 5) + '\ConfigurationManager.psd1') -ErrorAction SilentlyContinue | Out-Null

#CM12 cmdlets need to be run from the CM12 PS drive

Set-Location "$($SiteCode):" | Out-Null
if (-not (Get-PSDrive -Name $SiteCode))
  {
    Write-Error "There was a problem loading the Configuration Manager powershell module and accessing the site's PSDrive."
    exit 1
   }
  

  # ["Display=\\SGKCLKBCCM01.KCL.KEPPELGROUP.COM\"]MSWNET:["SMS_SITE=CMS"]\\SGKCLKBCCM01.KCL.KEPPELGROUP.COM\
  # ServerNALPath like '%$($FailedPackage.ServerNALPath.Substring(12,7))%'
  
$PackageState="3"
$failedPackages = Get-WmiObject -Namespace "Root\SMS\Site_$($SiteCode)" -Query "select * from SMS_PackageStatusDistPointsSummarizer where state = $($PackageState) and ServerNALPath like '%$DPName%' "
if ($FailedPackages.Count -gt 0)
{
    Write-Host "There are $($FailedPackages.Count) Failed Packages at the moment."
}
elseif ($FailedPackages)
{
    Write-Host "There is 1 Failed Package at the moment."
}
else
{
    Write-Host "There are 0 at the moment."
}

if ($FailedPackages)
{
    foreach ($FailedPackage in $FailedPackages)
    {
        try
        {
            $DistributionPointObj = Get-WmiObject -Namespace "root\SMS\Site_$($SiteCode)" -ComputerName $SMSProvider -Class SMS_DistributionPoint -Filter "PackageID='$($FailedPackage.PackageID)' and ServerNALPath like '%$($FailedPackage.ServerNALPath.Substring(12,7))%'"
            $DistributionPointObj.RefreshNow = $True
            $result = $DistributionPointObj.Put()
            Write-Host "Refreshed $($FailedPackage.PackageID) on $($FailedPackage.ServerNALPath.Substring(12,12)) - State was: $($FailedPackage.State)"
        }
        catch
        {
            Write-Host "Unable to refresh package $($FailedPackage.PackageID) on $($FailedPackage.ServerNALPath.Substring(12,12)) - State was: $($FailedPackage.State)"
            write-host $Error
        }
    }
}

