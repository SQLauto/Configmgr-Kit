/* Find Firefox, Chrome (System), Opera, and Safari */
select distinct v_R_System.Name0
     , v_add_remove_programs.Publisher0
	 , v_add_remove_programs.displayname0
	 , case when charindex('Firefox', v_add_remove_programs.displayname0) > 0 then 'Mozilla Firefox'
	        when charindex('Chrome', v_add_remove_programs.displayname0) > 0 then 'Google Chrome'
			when charindex('Opera', v_add_remove_programs.displayname0) > 0 then 'Opera'
			when charindex('Safari', v_add_remove_programs.displayname0) > 0 then 'Apple Safari'
		    else v_add_remove_programs.displayname0
	   end BrowserTitle
     , v_add_remove_programs.Version0
     , case when charindex('.',v_add_remove_programs.version0) > 0 then substring(v_add_remove_programs.version0, 1, charindex('.',v_add_remove_programs.version0)-1)
	   else v_add_remove_programs.version0
	   end version_major
	 , v_r_user.Full_User_Name0
	 , v_r_user.Mail0
	   from v_R_System
  join v_Add_Remove_Programs
    on v_R_System.ResourceID = v_Add_Remove_Programs.ResourceID
  left join v_GS_SYSTEM_CONSOLE_USAGE
    on v_r_system.resourceid = v_GS_SYSTEM_CONSOLE_USAGE.ResourceID
  left join v_R_User
    on v_r_user.Unique_User_Name0 = v_GS_SYSTEM_CONSOLE_USAGE.TopConsoleUser0
 where v_r_system.Operating_System_Name_and0 like 'Microsoft Windows NT Workstation 6.1%' and 
       (
		   (v_add_remove_programs.displayname0 like '%Firefox%' and v_Add_Remove_Programs.Publisher0 like '%Mozilla%')
		or (v_add_remove_programs.displayname0 like '%Safari%' and v_Add_Remove_Programs.Publisher0 like '%Apple%')
		or (v_add_remove_programs.displayname0 like '%Opera%' and v_Add_Remove_Programs.Publisher0 like '%Opera%')
		or v_add_remove_programs.displayname0 = 'Google Chrome'
       )