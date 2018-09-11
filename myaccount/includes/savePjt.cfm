<cfquery datasource="#application.datasource#">
	update bid_user_project_bids
	set folderid = #newfolder#
	where userid = #session.auth.userid#
	and bidid = #url.bidid#
	and folderid = #url.oldFolder#	
</cfquery>
<cflocation url="?action=folder&id_mag=#newfolder#" addtoken="no"/>