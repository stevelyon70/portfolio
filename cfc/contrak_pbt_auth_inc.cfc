  <!---check permissions to contrak application when coming from pbt url--->

<cfcomponent>

	<cffunction name="checkPermissions" description="validate contrak access from pbt if no access then set to basic if auth" access="remote" output="true" returntype="Any">
			<cfset date = #CREATEODBCDATE(NOW())#> 
			<cfquery name="getUser">
				select distinct bid_subscription_log.packageid,bid_users.userid,reg_users.username as name,pa.access_token,pa.named_user_group_id,reg_users.password
				from bid_subscription_log 
				inner join bid_users on bid_users.userid = bid_subscription_log.userid
				inner join bid_user_suppliers on bid_user_suppliers.sid = bid_users.sid 
				inner join pbt_contrak_oauth pa on pa.userID = bid_users.userID
				inner join reg_users on reg_users.reg_userID = bid_users.reguserID
				where bid_users.userid =  <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER"> 
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
			<cfif getUser.recordCount GTE 1>
			   	   
			     <!--- consider the user "logged in" --->
			  
			     <cfset variables.userRole = "default">
			     <cfloginuser
			     name="#getUser.userID#,#getUser.name#"
			     password="#getUser.Password#"
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
						<cfset session.auth.default_year = 2015>
						<cfset session.auth.default_qtr = "Q4">
				 </cfif>
				</cflock>
				
				
		<cfelse>
				
				<!---not current contrak subscriber check pbt and set basic if so--->
					
					<cfset session.auth.user_group = "">
					<cfset variables.basic = 1>
					
			</cfif>

	<cfreturn variables.basic>
	</cffunction>

</cfcomponent>



  