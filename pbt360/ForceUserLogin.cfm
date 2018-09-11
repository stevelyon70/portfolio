<!---
 Filename: ForceUserLogin.cfm
 Created by: DJuan Stevens
 Purpose: Requires each user to log in
 Please note Included by Application.cfc
--->

<!--- Force the user to log in --->
<!--- *** This code only executes if the user has not logged in yet! *** --->
<!--- Once the user is logged in via <cfoginuser>, this code is skipped --->
<cflogin applicationtoken="pbt_360_beta"	idletimeout = "7200" allowconcurrent="false"> 
<cfset date = #CREATEODBCDATE(NOW())#>
<cfset datetime = #CREATEODBCDATETIME(NOW())#>
 <!--- If the user hasn’t gotten the login form yet, display it --->
 <cfif (not (isDefined("form.loginUsername") and isDefined("form.loginPassword")))>
    <cfinclude template="login/index.cfm">
    <cfabort>
 <!--- Otherwise, the user is submitting the login form --->
 
 <!--- This code decides whether the username and password are valid --->
 <cfelse>
   <!--- Find record with this Username/Password --->
   <!--- If no rows returned, password not valid --->
   <cfquery name="getUser" datasource="paintsquare" result="r1">
   	   SELECT distinct bid_users.supplierid,reg_users.reg_userid,bid_users.userid,reg_users.username as name, reg_users.firstname, reg_users.lastname, '01834c0cbc5ac994' as access_token, 5830 as named_user_group_id
   	   
   	   --,pa.access_token,pa.named_user_group_id
		FROM reg_users
		inner join bid_users on bid_users.reguserid = reg_users.reg_userid
		inner join bid_subscription_log on bid_users.userid = bid_subscription_log.userid 
		inner join bid_user_suppliers on bid_user_suppliers.sid = bid_users.sid
		--inner join pbt_contrak_oauth pa on pa.userID = bid_users.userID
		WHERE  (reg_users.emailaddress = <cfqueryPARAM value = "#form.loginUsername#" CFSQLType = "cf_sql_varchar" >
				or
				reg_users.username = <cfqueryPARAM value = "#form.loginUsername#" CFSQLType = "cf_sql_varchar" >)
		AND reg_users.Password=<cfqueryPARAM value = "#form.loginPassword#" CFSQLType = "cf_sql_varchar" >  
		and (bid_subscription_log.effective_date <=  #date# and bid_subscription_log.expiration_date >=  #date# )
		and (bid_user_suppliers.effectivedate <= #date# and bid_user_suppliers.expirationdate >= #date#)
		--and pa.expire_date >= #date#
	
		and bid_users.bt_status = 1
		--and bid_subscription_log.packageID = 19
   </cfquery>
   <cftry>
   <cfif getUser.recordcount>
   <cfset pass= true/>
   <cfelse>
   <cfset pass=false />
   </cfif>
   <cflog application="yes" file="pbt_login" type="Information" text="User Login Attempt:#form.loginUsername#:#form.loginPassword# [Pass=#pass#]:#cgi.remote_addr#" />
   <!---cfmail to="slyon@technologypub.com" from="stupid@paintbidtracker.com" type="html" subject="login query">
   	<cfdump var="#getUser#" />
   	<cfdump var="#r1#" />
   	<cfdump var="#cgi#" />
   </cfmail--->
   <cfcatch type="Any"></cfcatch>
   </cftry>
   <!--- If the username and password are correct... --->
      
   <cfif getUser.recordCount eq 1>
   	   
     <!--- Tell ColdFusion to consider the user "logged in" --->
     <!--- For the nAME attribute, we will provide the user’s --->
     <!--- ContactID number and frst name, separated by commas --->
     <!--- Later, we can access the nAME value via GetAuthUser() --->
     <cfset variables.userRole = "default">
     <cfloginuser
     name="#getUser.userID#,#getUser.name#"
     password="#form.loginPassword#"
     roles="#variables.userRole#">
	   
	<cfquery name="insertlogin" datasource="#application.dataSource#">
		INSERT INTO bid_login_log (cfid,visitdate,siteid,remoteip,remotehost,localaddress,username,password,reg_userid)
		VALUES('#cfid#',#datetime#,'1000','#cgi.remote_addr#', '#cgi.remote_host#','#cgi.local_address#','#form.loginUsername#','#form.loginPassword#',#getUser.reg_userid#)
	</cfquery>
  
	  <!---cfquery name="insertLogin">
	  	insert into listman_login_log
		(editorID,visitdate,remoteIP)
		values(#getUser.editorID#,#date#,'#cgi.remote_addr#')
	  </cfquery--->
	
    <cflock timeout=20 scope="Session" type="Exclusive">
   	 <cfset session.auth = structnew()>
	 <cfset session.auth.userID = getUser.userID>
	 <cfset session.auth.name = getUser.name>
	 <cfset session.auth.userName = getUser.name>
	 <cfset session.auth.firstname = getUser.firstname>
	 <cfset session.auth.lastname = getUser.lastname>
     <cfset session.auth.user_access_token = getUser.access_token>
	 <cfset session.auth.user_group = getUser.named_user_group_id>	
	 <cfset session.auth.supplierID = getUser.supplierid>	
	  
	 <cfset session.auth.access = "360">
	 <cfif session.auth.userID EQ 13400>
	  	  <cfset session.auth.default_year = 2013>
		  <cfset session.auth.default_qtr = "Q1">
	 <cfelse>
			<cfset session.auth.default_year = 2017>
			<cfset session.auth.default_qtr = "Q4">
	 </cfif>
	</cflock>
	<cfset userID = session.auth.userID>
	  <cfquery name="checkuserpackage" datasource="#application.dataSource#">
		select distinct bid_subscription_log.packageid
		from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
		where bid_users.userid =  <cfqueryPARAM value = "#session.auth.userID#" CFSQLType = "CF_SQL_INTEGER"> 
			and bid_subscription_log.effective_date <= #date# 
			and bid_subscription_log.expiration_date >= #date# 
			and bid_subscription_log.active = 1
	  </cfquery>
	  <cfset session.packages = valuelist(checkuserpackage.packageid)>
	
		
	<!--- check for niche tag packages--->
	<cfif listcontains(session.packages, 16)>
	  <CFQUERY NAME="GET_Sub_TAGS" DATASOURCE="#application.dataSource#">
		select * 
		from pbt_user_tags
		where userID = <cfqueryPARAM value = "#session.auth.userID#" CFSQLType = "CF_SQL_INTEGER">
		and active = 1 
	  </cfquery>
	  <cfif get_sub_tags.recordcount GT 0>
		<cfset variable.user_tags = valuelist(GET_Sub_TAGS.tagID)>
	  <cfelse>
		<cflocation url="#rootpath#account/?action=104">
	  </cfif>
	 <cfelse>
	  <CFQUERY NAME="GET_Sub_TAGS" DATASOURCE="#application.dataSource#">
		select * 
		from pbt_tags
	  </cfquery>
	  <cfset variable.user_tags = valuelist(GET_Sub_TAGS.tagID)>
	</cfif>
	<cfsetting showdebugoutput="No">
	
   <!--- Otherwise, re-prompt for a valid username and password --->
   <cfelse>
   <!---cflocation url="#request.rootpath#login/?error=1" --->
   </cfif>
  
 </cfif>
</cflogin>