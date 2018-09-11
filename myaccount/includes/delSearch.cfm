

<cfquery datasource="#application.dataSource#">
	update pbt_user_saved_searches
	set active = 0
	where id = #url.SearchID#
</cfquery>
<cflocation url="?action=searches" addtoken="No" />