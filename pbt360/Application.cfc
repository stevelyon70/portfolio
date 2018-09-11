<!---
 Filename: Application.cfc
 Created by: DS
 Please note: Executes for every page request
--->

<cfcomponent output="false">
  <!--- name the application. --->
  <cfset this.name="pbt_360_beta">
  <!--- Turn on session management. --->
  <cfset this.sessionManagement=true>
  <!--- Default datasource --->  
  <cfset this.dataSource="paintsquare"> 
  <cfset this.rootpath="/">
  <cfset this.CFCPath = "360cfc"> 
  <cfset this.CONTRAKPATH = 'http://beta360.paintbidtracker.com/' />
    
  <cffunction name="onApplicationStart" output="false" returntype="boolean">
    <!--- Any variables set here can be used by all our pages --->
     <cfset application.dataSource="paintsquare"> 
	 <cfset Application.rootpath="/">
	 <cfset Application.CFCPath = "360cfc"> 
     <cfset Application.CONTRAKPATH = 'http://beta360.paintbidtracker.com/' />
     <cfreturn true />
  </cffunction>
  
  <cffunction name="onRequestStart" output="false" returnType="void">  
  	 <cfset request.rootpath="/"> 
     <cfset application.dataSource="paintsquare"> 
	 <cfset Application.rootpath="/">
	 <cfset Application.CFCPath = "360cfc"> 
     <cfparam default="" name="session.auth.access" />
     <cfset Application.CONTRAKPATH = 'http://beta360.paintbidtracker.com/' />
     <CFSET DATE = #CREATEODBCDATETIME(NOW())#>  
      <!---if user has chosen to logout--->
	<cfif isdefined("url.logout")>
		<cflogout>
		<cflock timeout=20 scope="Session" type="Exclusive">
    		<cfset StructDelete(Session, "auth")>
		</cflock>
		
	</cfif>
    <!--- Remember user’s logged-in status, plus --->
 	<!--- editorID and name, in structure --->
   <cfif isUserLoggedIn()>
		<cfif not isdefined("session.auth.username") or session.auth.username EQ "" or not isdefined("session.auth.user_access_token") or session.auth.user_access_token EQ "">
			<cflocation url="?logout=1" addtoken="false">
		</cfif>
   <cfelse>
   	<cfinclude template="#request.rootpath#forceUserLogin.cfm">
   </cfif>
   
   
   
   <cfif isdefined("session.auth.userID") and session.auth.userID NEQ "">
	<cfset userID = session.auth.userID>
	<cfif not isdefined("session.packages") or (isdefined("session.packages") and session.packages EQ "")>
	  <cfquery name="checkuserpackage" datasource="#application.dataSource#">
		select distinct bid_subscription_log.packageid
		from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
		where bid_users.userid =  <cfqueryPARAM value = "#session.auth.userID#" CFSQLType = "CF_SQL_INTEGER"> 
		and bid_subscription_log.effective_date <= #date# 
		and bid_subscription_log.expiration_date >= #date# 
		and bid_subscription_log.active = 1
	</cfquery>
	  <cfset session.packages = valuelist(checkuserpackage.packageid)>
	</cfif>
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
</cfif>
  </cffunction> 
  
  <cffunction name="onRequest">
  	<cfargument name="targetPage" />
  	<cfparam name="url.debug" default="false" />
  	<cfparam name="url.restart" default="false" />
  	
  	<cfif url.debug><cfinclude template="#request.rootpath#debug.cfm"></cfif>
  	<cfif url.restart><cfset x = onApplicationStart()></cfif>
  	
  	<cfinclude template="#arguments.targetPage#" />
  	
  	
  </cffunction>
  
  
</cfcomponent>