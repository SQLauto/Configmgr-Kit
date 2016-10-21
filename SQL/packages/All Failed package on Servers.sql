DECLARE @days INT; set @days=180;
SELECT psd.PackageID,p.Name,
Case P.PackageType
When 0 Then 'Package'
When 8 Then 'Application'
When 3 Then 'Driver'
When 4 Then 'Task Sequence'
When 5 Then 'software Update'
When 7 Then 'Virtual'
When 257 Then 'Image'
When 258 Then 'Boot Image'
When 259 Then 'OS'
Else ' '
END AS 'Type',
'\\'+SUBSTRING(PSD.ServerNALPath, 13, CHARINDEX('\', PSD.ServerNALPath, 14) - 13) AS [Server Name],
--SUBSTRING(SUBSTRING(PSD.ServerNALPath,CHARINDEX('\\',PSD.ServerNALPath,1)+2,LEN(PSD.ServerNALPath)),1,CHARINDEX('\',SUBSTRING(PSD.ServerNALPath,CHARINDEX('\\',PSD.ServerNALPath,1)+2,LEN(PSD.ServerNALPath)))-1),
PSd.LastCopied,PSd.SiteCode [Reporting Site],PSD.SourceVersion,
SP.SourceSize / 1000 AS [Size (MB)],
PSd.SummaryDate,PSD.InstallStatus
from v_PackageStatusDistPointsSumm PSD
inner join v_Package P ON P.PackageID=psd.PackageID
inner join SMSPackages SP ON SP.PkgID=P.PackageID
inner join v_PackageStatusRootSummarizer PSR ON PSR.PackageID=psd.PackageID
--WHERE     (PSd.State <> 0) and psd.PackageID='TP10002D'
where PSd.State <> 0 and  psr.Targeted<>0 
and p.PackageType='0'
and p.PackageID='C0000343'
group by psd.LastCopied, psd.PackageID,p.Name,PSd.LastCopied,PSd.SiteCode,PSD.SourceVersion,
SP.SourceSize,PSd.SummaryDate,PSD.InstallStatus,PSD.ServerNALPath,P.PackageType
having (datediff(dd,max(psd.LastCopied),getdate()-@days) <0)
order by 4


--Declare @str varchar(8000)
--set @str = '["Displayytyyr87y887ytr=\\K01\"]MSWNET:["SMS_SITE=C36"]\\KOLS00300001\'
--select SUBSTRING(@str,CHARINDEX('\\',@str,1)+2,LEN(@str)), SUBSTRING(SUBSTRING(@str,CHARINDEX('\\',@str,1)+2,LEN(@str)),1,CHARINDEX('\',SUBSTRING(@str,CHARINDEX('\\',@str,1)+2,LEN(@str)))-1)

--DECLARE @URL    VARCHAR(1000)
--SET @URL = 'http://www.sql-se2342342rver-helper.com/tips/tip-of-the-day.aspx?tid=58'
--SELECT SUBSTRING(@URL, 8, CHARINDEX('/', @URL, 9) - 8) AS [Domain Name],
--       REVERSE(SUBSTRING(REVERSE(@URL), CHARINDEX('?', REVERSE(@URL)) + 1,
--       CHARINDEX('/', REVERSE(@URL)) - CHARINDEX('?', REVERSE(@URL)) - 1)) AS [Page Name],
--       SUBSTRING(@URL, CHARINDEX('?', @URL) + 1, LEN(@URL)) AS [Query Parameter]
