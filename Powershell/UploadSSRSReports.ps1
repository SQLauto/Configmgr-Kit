<#
.SYNOPSIS
    Bulk import SSRS Reports from a folder and update the reports data source.
.DESCRIPTION
    This script takes all the RDL files in a folder and imports them into a SSRS and updates the reports data source to the Configmgr shared data source.
.NOTES
    File Name  : Upload SSRS Reports.ps1
    Version    : 1.04 ,01.Dec-2015
    Original Author     : Thomas Larsen - thomas.larsen@tromsfylke.no
    Modified Author     : Eswar Koneti -www.eskonr.com
    what has been modifed from original script ? Script is updated to read CSV file for list of SSRS Servers,execute the script and write the results into
    log file for reference.
    Requires   : PS Version 3
.LINK
    Blog  http://www.eskonr.com
     
#>
#Create csv file ,add up the servers,custom folder to be created and folder to upload from report from.

$servers  = "C:\Eskonr\Powershell\SCCM\SSRS_servers_Upload.csv"
$log      = "C:\Eskonr\Powershell\SCCM\SSRS_servers_upload.log"

#function to write the output to log
Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Log -value $logstring
}

Import-CSV $servers | ForEach-Object {
$webServiceUrl=$_."webServiceUrl"
$reportFolder=$_."reportFolder"
$SourceDirectory=$_."SourceDirectory"

$ErrorActionPreference = "Continue"

############Connect to SSRS

LogWrite "Reportserver: $webServiceUrl" -ForegroundColor Magenta
#LogWrite "Creating Proxy, connecting to : $webServiceUrl/ReportServer/ReportService2005.asmx?WSDL"
#LogWrite ""
$ssrsProxy = New-WebServiceProxy -Uri $webServiceUrl'/ReportServer/ReportService2005.asmx?WSDL' -UseDefaultCredential
$reportPath = "/" 

#####Get Configmgr shared datasource
$Items = $ssrsProxy.listchildren("/", $true) | where {$_.Type -eq "Datasource" }
foreach ($item in $items)
{
#Check to see if Datasource name patches Guid Pattern
if ($item.name -match '{([a-zA-Z0-9]{8})-([a-zA-Z0-9]{4})-([a-zA-Z0-9]{4})-([a-zA-Z0-9]{4})-([a-zA-Z0-9]{12})}' -and $item.path -like '/ConfigMgr*')
{
#LogWrite "Datasource:" $item.Name -ForegroundColor Magenta
#LogWrite "Type:" $item.Type
#LogWrite "Path:" $item.Path

#Save parameters for later use.
$DatasourceName = $item.Name
$DatasourcePath = $item.Path
}}


##########################################    
#Create Folder
        #LogWrite ""
        try
        {
            $ssrsProxy.CreateFolder($reportFolder, $reportPath, $null)
            LogWrite "Created new folder: $reportFolder"
        }
        catch [System.Web.Services.Protocols.SoapException]
        {
            if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]")
            {
                LogWrite "Folder: $reportFolder already exists."
            }
            else
            {
                $msg = "Error creating folder: $reportFolder. Msg: '{0}'" -f $_.Exception.Detail.InnerText
                LogWrite $msg
            }
        }


#############################
#For each RDL file in Folder

foreach($rdlfile in Get-ChildItem $SourceDirectory -Filter *.rdl)
{
#LogWrite ""


#ReportName
 $reportName = [System.IO.Path]::GetFileNameWithoutExtension($rdlFile);
 LogWrite "Report Name: $reportName.rdl" -ForegroundColor Green 
 #Upload File
     try
    {
        #Get Report content in bytes
        #LogWrite "Getting file content of : $rdlFile"
        $byteArray = gc $rdlFile.FullName -encoding byte
        $msg = "Total length: {0}" -f $byteArray.Length
        LogWrite ($msg)/1024
 
        $reportFolder = $reportPath + $reportFolder
        # LogWrite "Uploading to: $reportFolder " 
 
        #Call Proxy to upload report
        $warnings = $ssrsProxy.CreateReport($reportName,$reportFolder,$force,$byteArray,$null) 
        if($warnings.Length -le 1) { LogWrite "Upload Success." -ForegroundColor Green }
        else { LogWrite $warnings | % { Write-Warning "Warning: $_" }}
  
    }
    catch [System.IO.IOException]
    {
        $msg = "Error while reading rdl file : '{0}', Message: '{1}'" -f $rdlFile, $_.Exception.Message
        LogWrite msg
    }
    catch [System.Web.Services.Protocols.SoapException]
 {
            if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]")
            {
                LogWrite "Report: $reportName already exists on $webServiceUrl " 
            }
            else
            {
                $msg = "Error uploading report: $reportName. Msg: '{0}'" -f $_.Exception.Detail.InnerText
                LogWrite $msg
            }
  
 }



##Change Datasource
$rep = $ssrsProxy.GetItemDataSources($reportFolder+"/"+$reportName)
$rep | ForEach-Object {
$proxyNamespace = $_.GetType().Namespace
    $constDatasource = New-Object ("$proxyNamespace.DataSource")
    $constDatasource.Name = $DataSourceName
    $constDatasource.Item = New-Object ("$proxyNamespace.DataSourceReference")
    $constDatasource.Item.Reference = $DataSourcePath

$_.item = $constDatasource.Item
$ssrsProxy.SetItemDataSources($reportFolder+"/"+$reportName, $_)
#LogWrite "Changing datasource `"$($_.Name)`" to $($_.Item.Reference)"
}

#Something in the foreach loop keeps adding forward slashes to the parameter evertime it runs. 
#Strips slashes from the parameter.  
$reportFolder = $reportFolder -replace "/",""
}

#LogWrite "Finished on $webServiceUrl" -ForegroundColor Magenta
#LogWrite ""
}

