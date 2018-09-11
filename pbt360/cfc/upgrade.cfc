<cfcomponent>

	<cffunction name="upgradeEmail" description="sends email to sales rep for upgrade to ConTrak" access="remote">
				<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 
				<cfquery name="log_view">
					insert into pbt_contrak_mar_landing_requests
					(remoteIP,firstname,lastname,email,phone,userID,visit_date,type)
					values('#cgi.remote_addr#',<cfif isdefined("form.firstname")><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.firstname#" ><cfelse>NULL</cfif>,<cfif isdefined("form.lastname")><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.lastname#" ><cfelse>NULL</cfif>,<cfif isdefined("form.email")><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#" ><cfelse>NULL</cfif>,<cfif isdefined("form.phone")><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.phone#" ><cfelse>NULL</cfif>,<cfif isdefined("session.auth.userID")>#session.auth.userID#<cfelseif isdefined("userID")>#userID#<cfelse>NULL</cfif>,#date#,'ConTrak Core Subscriber Upgrade Request')
				</cfquery>	
					
					<cfmail
			 			from="contrak@paintbidtracker.com"
			 			to="dstevens@paintsquare.com"
			 			subject="ConTrak Sales Upgrade Request" 
						port="25" 
						type="html">
			 
			 The following Paint BidTracker user has requested information via the ConTrak unlock form.
			 <br><br>
			  
			 Name: #form.firstname#<br>
			 Email: #email#<br>
			 Phone: <cfif isdefined("form.phone")>#form.phone#<cfelse>N/A</cfif><br>
			 UserID: <cfif isdefined("session.auth.userID")>#session.auth.userID#<cfelseif isdefined("userID")>#userID#<cfelse>N/A</cfif><br>
			 <br><br>
			 Request Date: #dateformat(date)#
			 <br><br>
			 IP: #cgi.remote_addr#
			 </cfmail>
	</cffunction>

</cfcomponent>