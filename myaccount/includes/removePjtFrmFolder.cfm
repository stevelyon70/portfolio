<cfparam name="url.fromClip" default="0">
<cfif url.fromClip eq 1>
<cfquery datasource="#application.datasource#">
	delete
	from pbt_project_clipboard
	where bidid = #url.bidid#	
	and userid = #url.userid#
</cfquery>

<cfelse>
<cfquery datasource="#application.datasource#">
	update bid_user_project_bids
	set active = 2
	where projectid = #url.pgt#
	and bidid = #url.bidid#
	and folderid = #url.id_mag#	
	and userid = #url.userid#
</cfquery>
</cfif>

<cflocation url="?action=folder&userid=#url.userid#&id_mag=#url.id_mag#" addtoken="no"/>