
	<cfif isdefined("form.process") and form.process is 3>
		<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
		<cfquery name="addcomment" datasource="#application.datasource#">
		insert into bid_user_project_comments
		(userid,date_entered,comment,projectid,active)
		values(#userid#,#date#,'#comments#',#projectid#,1)
		</cfquery>
	</cfif>
	
	<cfif isdefined("deletecomment")>
		<cfquery name="deletecomment" datasource="#application.datasource#">
		update bid_user_project_comments
		set active = 2
		where bid_commentid = #deletecomment# and userID = <cfqueryPARAM value = "#userID#" CFSQLType = "CF_SQL_INTEGER"> 
		and userID in (select userID from bid_users inner join reg_users on reg_users.reg_userID = bid_users.reguserID where reg_users.username = '#session.auth.username#' )
		</cfquery>
	</cfif>