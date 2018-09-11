
<cfparam name="form.biddel" default="" />
<cfloop list="#form.biddel#" index="_b">
<cfquery datasource="#application.datasource#">
	update bid_user_project_bids
	set active = 2
	where  bidid = #_b#
	and userid = #session.auth.userid#
</cfquery>
</cfloop>
<cflocation url="/myaccount/folders/" addtoken="no"/>