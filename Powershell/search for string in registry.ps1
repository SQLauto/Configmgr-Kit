Set-Location -Path HKLM:
$ItemExists = $false
$Reglist = (Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall).Name
foreach ($item in $Reglist)
{
    $key = Get-ItemProperty -Path $item | Select-Object -Property DisplayName
    if ($key.DisplayName -match 'pdf*' -and $key.DisplayName -match 'Gmbh')
    {
        $ItemExists = $true
    }           
}

$ItemExists