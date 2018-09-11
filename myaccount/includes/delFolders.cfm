

<cfloop list="#form.folderdel#" index="_x">
<cfquery datasource="#application.dataSource#">
	insert into pbt_user_folders_deletions
	(userID, folderID, dateadded, active)
	values
	(#session.auth.userid#, #_x#, '#datetimeformat(now(), 'yyyy-mm-dd hh:mm:ss')#', 1)
</cfquery>
<cfquery datasource="#application.datasource#">
	update bid_user_project_bids
	set active = 2
	where folderid = #_x#	
</cfquery>	
</cfloop>


<cflocation url="?action=folders" addtoken="No" />