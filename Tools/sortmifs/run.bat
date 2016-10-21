@ECHO OFF

cd D:\Media\12374sortmifs
F:
sortmifs dbserver=PRODSCM dbname=SMS_KBS xls=F:\eswar2.xls mifdir=E:\SCCM\inboxes\auth\dataldr.box\BADMIFS /S /DEL

Pause

