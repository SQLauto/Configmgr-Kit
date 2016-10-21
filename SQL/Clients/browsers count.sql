SELECT A.BrowserTitle,sum(A.total)'Total' FROM 
( select case when charindex('Firefox', v_add_remove_programs.displayname0) > 0 then 'Mozilla Firefox'
	        when charindex('Chrome', v_add_remove_programs.displayname0) > 0 then 'Google Chrome'
			when charindex('Opera', v_add_remove_programs.displayname0) > 0 then 'Opera'
			when charindex('Safari', v_add_remove_programs.displayname0) > 0 then 'Apple Safari'
		    else v_add_remove_programs.displayname0 end BrowserTitle,
		    count(*) as total
	   FROM v_add_remove_programs
	   where (
		   (v_add_remove_programs.displayname0 like '%Firefox%')
		or (v_add_remove_programs.displayname0 like '%Safari%')
		or (v_add_remove_programs.displayname0 like '%Opera%')
		or v_add_remove_programs.displayname0 = 'Google Chrome'
       )
	  GROUP BY v_add_remove_programs.displayname0) A
	  GROUP BY A.BrowserTitle
