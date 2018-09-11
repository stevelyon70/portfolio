<CFSET TDATE = #CREATEODBCDATE(NOW())#>
<cfset TDATE = dateformat(Tdate, 'm/d/yyyy')>
<!---insert the nl_main item--->
<cfquery name="insert_main" datasource="paintsquare_master">
insert into nl_main
(newsletter_id,target_date,active,status,content)
values(35,'#tdate#','y',4,'y')
</cfquery>
<cfquery name="getnew" datasource="paintsquare_master">
select max(nl_versionid) as nl_versionid
from nl_main
</cfquery>
<cfset nl_versionID = getnew.nl_versionID>