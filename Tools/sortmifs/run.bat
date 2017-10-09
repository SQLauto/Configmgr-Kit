@ECHO OFF

cd G:\Sources\Tools\sortmifs
G:
sortmifs.exe dbserver=VSGRHOWPSCP01 dbname=CM_RT1 xls=G:\Sources\Tools\sortmifs\BADMIFS_%date:~-10,2%%date:~-7,2%%date:~-4,4%.xls mifdir=G:\Configmgr\inboxes\auth\dataldr.box\BADMIFS /S /DEL
sortmifs.exe dbserver=VSGRHOWPSCP01 dbname=CM_RT1 xls=G:\Sources\Tools\sortmifs\DeltaMismatch_%date:~-10,2%%date:~-7,2%%date:~-4,4%.xls mifdir=G:\Configmgr\inboxes\auth\dataldr.box\BADMIFS\DeltaMismatch /S /DEL
sortmifs.exe dbserver=VSGRHOWPSCP01 dbname=CM_RT1 xls=G:\Sources\Tools\sortmifs\ErrorCode_4_%date:~-10,2%%date:~-7,2%%date:~-4,4%.xls mifdir=G:\Configmgr\inboxes\auth\dataldr.box\BADMIFS\ErrorCode_4 /S /DEL
sortmifs.exe dbserver=VSGRHOWPSCP01 dbname=CM_RT1 xls=G:\Sources\Tools\sortmifs\MajorMismatch_%date:~-10,2%%date:~-7,2%%date:~-4,4%.xls mifdir=G:\Configmgr\inboxes\auth\dataldr.box\BADMIFS\MajorMismatch /S /DEL
sortmifs.exe dbserver=VSGRHOWPSCP01 dbname=CM_RT1 xls=G:\Sources\Tools\sortmifs\NonExistentRow_%date:~-10,2%%date:~-7,2%%date:~-4,4%.xls mifdir=G:\Configmgr\inboxes\auth\dataldr.box\BADMIFS\NonExistentRow /S /DEL
sortmifs.exe dbserver=VSGRHOWPSCP01 dbname=CM_RT1 xls=G:\Sources\Tools\sortmifs\Outdated_%date:~-10,2%%date:~-7,2%%date:~-4,4%.xls mifdir=G:\Configmgr\inboxes\auth\dataldr.box\BADMIFS\Outdated /S /DEL


