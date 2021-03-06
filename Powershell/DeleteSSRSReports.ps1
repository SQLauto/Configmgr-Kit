<#
.SYNOPSIS
	Uninstalls an RDL file from SQL Reporting Server using Web Service

.DESCRIPTION
	Uninstalls an RDL file from SQL Reporting Server using Web Service

.NOTES
	File Name: Uninstall-SSRSRDL.ps1
	Author: Randy Aldrich Paulo
	Prerequisite: SSRS 2008, Powershell 2.0

.EXAMPLE
	Uninstall-SSRSRDL -webServiceUrl "http://[ServerName]/ReportServer/ReportService2005.asmx?WSDL" -path "MyReport"

.EXAMPLE
	Uninstall-SSRSRDL -webServiceUrl "http://[ServerName]/ReportServer/ReportService2005.asmx?WSDL" -path "Reports/Report1"

#>

$servers  = "C:\Eskonr\Powershell\SCCM\SSRS_servers-deletion.csv"
$log      = "C:\Eskonr\Powershell\SCCM\SSRS_servers-deletion.log"

#function to write the output to log
Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Log -value $logstring
}

Import-CSV $servers | ForEach-Object {
$webServiceUrl=$_."webServiceUrl"
$reportFolder=$_."reportFolder"


$ErrorActionPreference = "Continue"


	#Create Proxy
	Logwrite "[Uninstall-SSRSRDL()] Creating Proxy, connecting to : $webServiceUrl"
    $ssrsProxy = New-WebServiceProxy -Uri $webServiceUrl'/ReportServer/ReportService2005.asmx?WSDL' -UseDefaultCredential
    	
	#Set Report Folder
	      $reportPath = "/" + $reportFolder 
     try
	{

		Logwrite "[Uninstall-SSRSRDL()] Deleting: $reportPath"
		#Call Proxy to upload report
		$ssrsProxy.DeleteItem($reportPath)
		Logwrite "[Uninstall-SSRSRDL()] Delete Success."
	}
	catch [System.Web.Services.Protocols.SoapException]
	{
		$msg = "[Uninstall-SSRSRDL()] Error while deleting report : '{0}', Message: '{1}'" -f $reportPath, $_.Exception.Detail.InnerText
		Logwrite $msg
	}
    }
    Logwrite "Script completed"
	



