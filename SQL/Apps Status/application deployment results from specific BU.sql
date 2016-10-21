 DECLARE @StatusType int,@App varchar(50),@OU varchar(50);
SET @StatusType = 1;
SET @OU='KSMBN';
SET @app='Microsoft Office 2013 X86 Std Upgrade'

SELECT A.[Computer Name], A.OS, A.[User Name], A.department0,A.[Office ?], A.Status,A.[Last_Logon_Timestamp0], A.[LastHWScan]
 FROM 
(
SELECT vrs.Name0 [Computer Name], vgos.Caption0 [OS],vrs.User_Name0 [User Name],vru.department0,
IIf([EnforcementState]=1001,'Already Present',
IIf([EnforcementState]>=1000 And [EnforcementState]<2000 And [EnforcementState]<>1001,'Success',
IIf([EnforcementState]>=2000 And [EnforcementState]<3000,'In Progress',
IIf([EnforcementState]>=3000 And [EnforcementState]<4000,'Requirements Not Met ',
IIf([EnforcementState]>=4000 And [EnforcementState]<5000,'Unknown',
IIf([EnforcementState]>=5000 And [EnforcementState]<6000,'Error','Unknown')))))) AS Status,
case when varp.DisplayName0 LIKE 'Microsoft Office Standard 2010' OR varp.DisplayName0 LIKE 'Microsoft Office Professional Plus 2010' THEN '2010'
when varp.DisplayName0 LIKE 'Microsoft Office Standard 2013' OR varp.DisplayName0 LIKE 'Microsoft Office Professional Plus 2013' THEN '2013'END AS 'Office ?',
vrs.Last_Logon_Timestamp0,
vgws.LastHWScan
 FROM dbo.vAppDeploymentResultsPerClient ADRP 
 inner JOIN dbo.v_RA_System_SystemOUName SOU ON sou.ResourceID = ADRP.ResourceID
 right JOIN dbo.fn_ListApplicationCIs(1033) lac ON lac.ci_id=ADRP.CI_ID
 inner JOIN dbo.v_R_System vrs ON vrs.ResourceID = ADRP.ResourceID
 INNER JOIN dbo.v_GS_WORKSTATION_STATUS AS vgws ON vgws.ResourceID=vrs.resourceid
left JOIN dbo.v_R_User AS vru ON vru.User_Name0 = vrs.User_Name0
INNER JOIN dbo.v_GS_OPERATING_SYSTEM AS vgos ON vgos.ResourceID = vrs.ResourceID
inner JOIN dbo.v_Add_Remove_Programs varp ON varp.ResourceID = adrp.ResourceID
 WHERE lac.DisplayName=@App
 AND SOU.System_OU_Name0 LIKE '%'+@OU+'%'
 GROUP BY vrs.Name0 ,vgos.Caption0 ,vrs.User_Name0 ,vru.department0,vrs.Last_Logon_Timestamp0,
vgws.LastHWScan,EnforcementState,case when varp.DisplayName0 LIKE 'Microsoft Office Standard 2010' OR varp.DisplayName0 LIKE 'Microsoft Office Professional Plus 2010' THEN '2010'
when varp.DisplayName0 LIKE 'Microsoft Office Standard 2013' OR varp.DisplayName0 LIKE 'Microsoft Office Professional Plus 2013' THEN '2013'END
) A
WHERE a.[Office ?] NOT LIKE 'null'
GROUP BY A.[Computer Name], A.OS, A.[User Name], A.department0,A.[Office ?], A.Status ,A.Last_Logon_Timestamp0, A.LastHWScan
ORDER BY A.[Computer Name], A.OS, A.[User Name], A.department0,A.[Office ?], A.Status ,A.Last_Logon_Timestamp0, A.LastHWScan