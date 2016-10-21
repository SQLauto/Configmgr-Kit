$data = Get-ChildItem -path `
registry::'hklm\software\microsoft\windows\currentversion\installer\userdata\s-1-5-18\components' `
-Recurse | Where-Object -FilterScript {$_.Name -like '*\19BF4688EE4961F41A44D0282A2340D9' }
	foreach( $d in $data ) {
		$d.Name >> hive.txt
	}