select top 2 * From v_DPGroupContentDetails where GroupID like '{FD85%'
select top 2 * From v_DPGroupContentInfo
select top 10 * from v_DPGroupPackages where GroupID like '{FD85%'
select top 2 * From v_DPGroupMembers

select top 10 *  from DPGroupPackages where GroupID like '{FD8F%'
select count(*) From v_DPGroupPackages where GroupID='{05C37BEA-7BF5-4974-8961-C7704190AB90}'


select count(PkgID) From v_DPGroupContentDetails where GroupID='{05C37BEA-7BF5-4974-8961-C7704190AB90}'


select PkgID,Name from SMSPackages where PkgID not in(select pkgid From v_DPGroupContentDetails where GroupID='{FD8F5848-90AB-49BB-A52C-7C9C413D0A7E}')

