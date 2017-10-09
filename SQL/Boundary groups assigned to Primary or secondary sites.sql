SELECT DISTINCT  
          case   
              when srl.InternetEnabled = 0 or srl.Shared = 1  
                then case when srl2.ServerRemoteName!=N'' then srl2.ServerRemoteName else srl2.Servername end  
              else N''   
           end as ServerName,  
          case   
              when srl.InternetEnabled = 1 and srl2.PublicDNSName!=N''  
                then srl2.PublicDNSName   
                else N''   
              end as ServerRemoteName,   
          s.BuildNumber as Version,   
          srl.RoleCapabilities as Capabilities,   
          s.SiteCode,  s.ReportToSite as Parentsite,
       s.ReportToSite as AssignmentSiteCode, srl2.ForestFQDN as SiteSystemForest, srl2.DomainFQDN as SiteSystemDomain,
       bgss.ServerNALPath as ReferredSiteSystem,
       bg.Name
   FROM Sites s   
   INNER JOIN vSysResList srl on srl.SiteCode=s.SiteCode AND srl.RoleName=N'SMS Management Point' and srl.IsAvailable = 1 
   INNER JOIN SysResList srl2 on srl.SiteCode=srl2.SiteCode AND srl.NALPath=srl2.NALPath AND srl2.RoleName=N'SMS Site System'  
   LEFT JOIN vSysResList srl3 on srl3.SiteCode=s.SiteCode AND srl3.NALPath=srl.NALPath AND srl3.RoleName=N'SMS Device Management Point' 
   INNER JOIN BoundaryGroupSiteSystem BGSS on srl2.NALPath=BGSS.ServerNALPath  
   join BoundaryGroup bg on bgss.GroupID = bg.groupid
