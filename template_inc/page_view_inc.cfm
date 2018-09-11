<!---insert view info--->
<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 

<cfquery name="log_view">
	insert into pbt_contrak_page_view_log
	(remoteIP,page_name,pageID,date_viewed,path,query_string,userID)
	values('#cgi.remote_addr#',<cfif isdefined("variables.pageID")>'#variables.page_name#'<cfelse>NULL</cfif>,<cfif isdefined("variables.pageID")>#variables.pageID#<cfelse>NULL</cfif>,#date#,'#CGI.SCRIPT_NAME#','#CGI.QUERY_STRING#',<cfif isdefined("session.auth.userID")>#session.auth.userID#<cfelseif isdefined("userID")>#userID#<cfelse>NULL</cfif>)
</cfquery>