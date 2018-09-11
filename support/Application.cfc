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
    
  <cffunction name="onApplicationStart" output="false" returnType="void">
    <!--- Any variables set here can be used by all our pages --->
     
 
  </cffunction>
  <cffunction name="onRequestStart" output="false" returnType="void">
  	 <cfset request.directory = "support">
  	 <cfset request.rootpath="../">
	 <cfset Application.rootpath="../">
	 <cfset Application.CFCPath = "contrakcfc">  
	
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
   	 <!---cfset session.auth = structnew()>
	 <cfset session.auth.userID = listFirst(getAuthUser())>
	 <cfset session.auth.name = listRest(getAuthUser())>
	 <cfset application.userID = session.auth.userID>
	 <cfset application.userName = session.auth.name>
	  <cfif application.userID EQ 10871>
	  	  <cfset application.default_year = 2013>
		  <cfset application.default_qtr = "Q1">
		<cfelse>
			<cfset application.default_year = 2014>
			<cfset application.default_qtr = "Q4">
	  </cfif--->
   </cfif>
    <cfinclude template="#application.rootpath#forceUserLogin.cfm">
  </cffunction>
 
</cfcomponent>