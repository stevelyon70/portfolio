<cfsetting requesttimeout="500"/><cfset date = #CREATEODBCDATE(NOW())#>
<cfset datetime = #CREATEODBCDATETIME(NOW())#>
<cfquery name="getUser" datasource="paintsquare" result="r1">
   SELECT distinct bid_users.userid
	FROM reg_users
	inner join bid_users on bid_users.reguserid = reg_users.reg_userid
	inner join bid_subscription_log on bid_users.userid = bid_subscription_log.userid 
	inner join bid_user_suppliers on bid_user_suppliers.sid = bid_users.sid	
	WHERE  (bid_subscription_log.effective_date <=  #date# and bid_subscription_log.expiration_date >=  #date# )
	and (bid_user_suppliers.effectivedate <= #date# and bid_user_suppliers.expirationdate >= #date#)	
	and bid_users.bt_status = 1	
</cfquery>
		
<cfoutput query="getUser">
	<cfquery name="checkprefs" datasource="#application.dataSource#">
 		select top 1 *
 		from pbt_user_email_pref
 		where userid = #getUser.userid#
	</cfquery>
	<cfif checkprefs.recordcount eq 0>
		<cfquery name="qUserTags" datasource="#application.dataSource#">
			insert into	pbt_user_email_pref
			(userid, dailyUpdates,getSavedSearchEmail,stages,projectTypes,sendInterval,updatedOn, budget,states)
			values
			(<cfqueryPARAM value = "#getUser.userid#" CFSQLType = "CF_SQL_INTEGER">, 1,1,'1,2,3,4,7,8,9',3,1,'#datetimeformat(now(), "yyyy-mm-dd hh:mm:ss")#',1,66)	
		</cfquery>
		<cfquery datasource="#application.dataSource#">
			delete
			FROM pbt_user_email_tag
			where userID= <cfqueryPARAM value = "#getUser.userid#" CFSQLType = "CF_SQL_INTEGER">
		</cfquery>	
		<cfquery  datasource="#application.dataSource#">
			INSERT INTO pbt_user_email_tag
			(userID, tagID, active, enteredOn)
			values
			(#getUser.userid#, '10000', 1, '#dateformat(now(), 'yyyy-mm-dd')#')
		</cfquery>			
	</cfif>
</cfoutput>	