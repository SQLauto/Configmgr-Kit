select top 2 * From  cicontentpackage where PkgID like 'TP10019F'

select displayname from ci_localizedproperties where len(DisplayName)>49 
--and displayname like 'lenovo%'
and displayname not like '%.msi%'
and LocaleID='65535'
group by displayname
order by 1

select top 20 * From  ci_localizedproperties where
displayname like 'SAP%' and len(DisplayName)>49 