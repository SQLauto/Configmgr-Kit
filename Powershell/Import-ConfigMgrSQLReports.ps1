#requires -version 2
#========================================================================
#
# Created on:   30/08/2012
# Created by:   M Whittle
# Organization: WAE, BNP Paribas
# Filename:  	Import-ConfigMgrSQLReports.ps1
# Description: 	Imports SQL Reporting services reports into ConfigMgr
# 
# Version: 	1.0.0   30/08/2012  M Whittle, Initial Version
#               1.0.1	04/12/2012  M Whittle, Delete report if it already exists before import
#                                              Some minor changes to reports includeing descriptions
#                                              wern't being imported
#========================================================================

$version = "1.0.1"

# *********************************************************************************************************************
# Functions
# *********************************************************************************************************************

function UploadReports
{
	Param(
         [parameter(Mandatory=$true)][String]   $reportFolderRoot,
         [parameter(Mandatory=$true)][String]   $ReportFolderPath,
         [parameter(Mandatory=$true)][String[]] $RDLFiles
	)
	
	Try
	{
		# Make sure there are no trailing back slashes on the report folder path
		if ($reportFolderPath -ne "/")
		{
			$reportFolderPath = $reportFolderPath.TrimEnd("/")
		}

		# If folder doesnt exist create it
		New-SSRSFolder $ReportFolderPath

		# Create the datasource
		$proxyNamespace = $proxy.GetType().Namespace
		$DataSources = New-Object ("$proxyNamespace.DataSource")
		$DataSources.Name = "AutoGen__5C6358F2_4BB6_4a1b_A16E_8D96795D8602_"
		$DataSources.Item = New-Object ("$proxyNamespace.DataSourceReference")
		$DataSources.Item.Reference ="/$ReportFolderRoot/{5C6358F2-4BB6-4a1b-A16E-8D96795D8602}"

		# Iterate through list of files and import each one
		foreach ($RDLFile in $RDLFiles) 
		{ 
			$reportName = [System.IO.Path]::GetFileNameWithoutExtension($RDLFile) 
			$percentDone = (($uploadedCount/$RDLFiles.Count) * 100) 
			Write-Progress -activity "Uploading to $ReportFolderPath" -status $reportName -percentComplete $percentDone
			Write-Output "%$percentDone : Uploading '$reportName' to '$ReportFolderPath'"

			# Replace any references to the ConfigMgr_C00 with the reporting folder on the destination
			[string]$data = Get-Content $RDLFile
			$data = $data.replace("ConfigMgr_C00", $ReportFolderRoot)
			$enc = [system.Text.Encoding]::UTF8
			$bytes = $enc.GetBytes($data)


			# If the report already exists, delete the report first
			$reports = $proxy.ListChildren($ReportFolderPath, $false)
			foreach ($report in $reports | Where-Object { ($_.Type -eq "Report") -AND ($_.Name -eq $reportName)}) 
                    	{
				$proxy.DeleteItem($report.Path);
			}

			# Create the report, capture any warnings
			$warnings = $proxy.CreateReport($reportName, $ReportFolderPath, $true, $bytes, $null) 
			if ($warnings) 
			{ 
				foreach ($warn in $warnings) 
				{ 
					Write-Warning $warn.Message 
				} 
			} 
			$uploadedCount += 1 
			
			# Fix data sources
			$proxy.SetItemDataSources($reportFolderPath.TrimEnd("/") + "/" + $reportName, $dataSources)
		}
		
	}
	Catch [System.SystemException] 
    {
        throw $_
    }
}

function Test-SSRSFolder([string]$SSRSFullFolderPathToCheck)
{
	# Check Report folder path exists
	try
	{
		$script:proxy.ListChildren($SSRSFullFolderPathToCheck, $false)
		return $true
	}
	Catch [System.SystemException] 
    	{
		if ($_.Exception.Message.Contains("Microsoft.ReportingServices.Diagnostics.Utilities.ItemNotFoundException"))
		{
			# folder doesn't exist
			$Error.Clear()
			return $false
		}
		else
		{
	        	throw $_
		}
	}
}

function New-SSRSFolder([string]$SSRSFullFolderPath)
{
	# Check Report folder path exists
	try
	{
		if(($SSRSFullFolderPath -ne "/") -AND !(Test-SSRSFolder $SSRSFullFolderPath))
		{
			$ParentFolder = (split-path -parent $SSRSFullFolderPath).replace("\","/")
			$FolderName = $SSRSFullFolderPath.replace("$ParentFolder/", "")
			
			# Parent folder doesn't exist so recall function to get it created
			New-SSRSFolder $ParentFolder
			
			# Create folder
			$script:proxy.CreateFolder($FolderName, $ParentFolder, $null)
		}
	}
	Catch [System.SystemException] 
    	{
	    throw $_
	}
}

Function Get-Owner
{
	Add-Type -TypeDefinition @"
	using System;
	using System.Windows.Forms;

	public class Win32Window : IWin32Window
	{
		private IntPtr _hWnd;

		public Win32Window(IntPtr handle)
		{
			_hWnd = handle;
		}

		public IntPtr Handle
		{
			get { return _hWnd; }
		}
	}
"@ -ReferencedAssemblies "System.Windows.Forms.dll"

	[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

	$owner = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
	Return $owner
}

Function Select-File
{   
	param (
        	[System.String]$Title = "Select File", 
        	[System.String]$InitialDirectory = "C:\", 
        	[System.String]$Filter = "All Files(*.*)|*.*"
	)
	$Owner = Get-Owner

	[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |	Out-Null

	$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
	$OpenFileDialog.initialDirectory = $initialDirectory
	$OpenFileDialog.filter = $Filter
	$OpenFileDialog.Multiselect = $true
	$OpenFileDialog.ShowHelp = $true
	$OpenFileDialog.Title = $Title
	$result = $OpenFileDialog.ShowDialog($owner)
	return $OpenFileDialog.FileNames

} 

function Get-ScriptDirectory 
{ 
	$Invocation = (Get-Variable MyInvocation -Scope 1).Value 
	return Split-Path $Invocation.MyCommand.Path 
} 



# *********************************************************************************************************************
# Main
# *********************************************************************************************************************
cls
Write-Host "Import-ConfigMgrSQLReports.ps1 version: $version"
Write-Host ""
Write-Host "Imports SQL Reporting services reports into ConfigMgr"
Write-Host ""
Write-Host ""

# Get the servers FQDN
Write-Host "Enter the FQDN of the server hosting SQL Reporting Services"
$serverFQDN = Read-Host "FQDN (or enter for LocalHost) "
if($serverFQDN -eq "")
{
	$serverFQDN = "localhost"
}
Write-Host ""


# Check server has SQL Server 2008 R2 SP1 CU4 installed or higher
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | out-null
$sql = New-Object "Microsoft.SqlServer.Management.Smo.Server" $serverFQDN
if (($sql.Version.Major -ne 10) -OR ($sql.Version.Minor -ne 50) -OR ($sql.Version.Build -lt 2796))
{
	write-host "SQL Server 2008 R2 SP1 CU4 (or higher) doesn't appear to be installed and is required"
	write-host ""
	break;
}


# Check server has hotfix KB2449910 installed
If (!(test-path -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\KB2449910"))
{
	Write-host "Warning - KB2449910 doesn't appear to be installed, this hotfix is recommended but not required." -foregroundcolor Yellow
	write-host ""
}


# Get the name of the folder where the ConfigMgr reports are stored in SSRS
$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $serverFQDN)
$regKey = $reg.OpenSubKey("SOFTWARE\\Wow6432Node\\Microsoft\\SMS\\SRSRP" )
$reportFolderRoot = $regKey.GetValue("Report Folder")


# Set the path to where the reports should be imported too.
$reportFolderPath = "/$reportFolderRoot/_Global Reports/Neos CIB 64"


# Select the names of the .RDL files that are to be imported
Write-host "Select the .RDL files to be imported"
$RDLFiles = Select-File -Title "Select .RDL Files" -initialDirectory (Get-ScriptDirectory) -Filter "RDL Files (*.rdl)|*.rdl"
write-host ""


# If any files were selected import them
if ($RDLFiles -ne $null)
{
	# Get a connection to the web service
	Write-host "Connecting to reporting services on: $serverFQDN"
	$script:proxy = New-WebServiceProxy -Uri "http://$serverFQDN/ReportServer/ReportService2005.asmx" -UseDefaultCredential


	# Upload the reports
	UploadReports $reportFolderRoot $reportFolderPath $RDLFiles
	write-host "Complete"
}
else
{
	write-host "No .RDL files selected"
}
write-host ""