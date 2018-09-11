  <!---check permissions to contrak application when coming from pbt url--->
	
  <cfset date = #CREATEODBCDATE(NOW())#> 
<cfif (isdefined("session.userID") or isdefined("userID")) and isdefined("Session.MM_Username")>
	<cfif isdefined("session.userID") and session.userID NEQ "">
		<cfset variables.userID = session.userID>
	<cfelseif isdefined("userID") and userID NEQ "">
		<cfset variables.userID = userID>
	<cfelse>
		<cfset variables.userID = "">
	</cfif>
	<cfquery name="getUser">
		select distinct bid_subscription_log.packageid,reg_users.password,bid_users.userid,reg_users.username as name,pa.access_token,pa.named_user_group_id
		from bid_subscription_log 
		inner join bid_users on bid_users.userid = bid_subscription_log.userid
		inner join bid_user_suppliers on bid_user_suppliers.sid = bid_users.sid 
		inner join pbt_contrak_oauth pa on pa.userID = bid_users.userID
		inner join reg_users on reg_users.reg_userID = bid_users.reguserID
		where bid_users.userid =  <cfqueryPARAM value = "#variables.userid#" CFSQLType = "CF_SQL_INTEGER"> 
		and bid_subscription_log.packageid in (19)  
		and bid_subscription_log.effective_date <= #date# 
		and bid_subscription_log.expiration_date >= #date# 
		and (bid_user_suppliers.effectivedate <= #date# 
		and bid_user_suppliers.expirationdate >= #date#)
		and bid_subscription_log.active = 1
		and pa.expire_date >= #date#
		and bid_users.bt_status = 1
		and bid_subscription_log.userid in 
		(
		select bid_users.userid 
		from bid_users 
		inner join reg_users on bid_users.reguserid = reg_users.reg_userid 
		where reg_users.username = '#Session.MM_Username#' 
		and bid_users.bt_status = 1
		)
	</cfquery>
	<cfif getUser.recordCount eq 1>
	   	   
     <!--- Tell ColdFusion to consider the user "logged in" --->
     <!--- For the nAME attribute, we will provide the user’s --->
     <!--- ContactID number and frst name, separated by commas --->
     <!--- Later, we can access the nAME value via GetAuthUser() --->
     <cfset variables.userRole = "default">
     <cfloginuser
     name="#getUser.userID#,#getUser.name#"
     password="#getUser.password#"
     roles="#variables.userRole#">
	   
  		<cfquery name="insertLogin">
		  	insert into pbt_contrak_login_log
			(userID,visitdate,remoteIP)
			values(#getUser.userID#,#date#,'#cgi.remote_addr#')
	  	</cfquery>

	  <cflock timeout=20 scope="Session" type="Exclusive">
	   	 <cfset session.auth = structnew()>
		 <cfset session.auth.userID = getUser.userID>
		 <cfset session.auth.name = getUser.name>
		 <cfset session.auth.userName = getUser.name>
	     <cfset session.auth.user_access_token = getUser.access_token>
		 <cfset session.auth.user_group = getUser.named_user_group_id>
		 <cfif session.auth.userID EQ 13400>
		  	  <cfset session.auth.default_year = 2013>
			  <cfset session.auth.default_qtr = "Q1">
		 <cfelse>
				<cfset session.auth.default_year = 2016>
				<cfset session.auth.default_qtr = "Q4">
		 </cfif>
		</cflock>
		
	
	<cfelse>

	<!---not current contrak subscriber check pbt and set basic if so--->
		<cfscript>
		// *** Restrict Access To Page: Grant or deny access to this page
		MM_authorizedUsers="";
		MM_authFailedURL="http://www.paintbidtracker.com";
		MM_grantAccess=false;
		MM_Session = IIf(IsDefined("Session.MM_Username"),"Session.MM_Username",DE(""));
		if (MM_Session IS NOT "") {
		  if (true OR (Session.MM_UserAuthorization IS "") OR (Find(Session.MM_UserAuthorization, MM_authorizedUsers) GT 0)) {
		    MM_grantAccess = true;
		  }
		}
		if (NOT MM_grantAccess) {
		  MM_qsChar = "?";
		  if (Find("?",MM_authFailedURL) GT 0) MM_qsChar = "&";
		  MM_referrer = CGI.SCRIPT_NAME;
		  if (CGI.QUERY_STRING IS NOT "") MM_referrer = MM_referrer & "?" & CGI.QUERY_STRING;
		  MM_authFailedURL_Trigger = MM_authFailedURL & MM_qsChar & "accessdenied=" & URLEncodedFormat(MM_referrer);
		}
		</cfscript>
		<cfif IsDefined("MM_authFailedURL_Trigger")>
		<cflocation url="#MM_authFailedURL_Trigger#" addtoken="no">
		</cfif>
		<cfset session.auth = structnew()>
	 	<cfset session.auth.access = "basic">
		<cfset session.auth.user_group = "">
	</cfif>
<!---not current contrak subscriber check pbt and set basic if so--->
<cfelse>

		<cfset session.auth = structnew()>
	 	<cfset session.auth.access = "basic">
		<cfset session.auth.user_group = "">

</cfif>
