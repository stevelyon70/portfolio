<!---
 Filename: Application.cfc
 Created by: DS
 Please note: Executes for every page request
 --modified on 4/7/2016 by DS 
 	**changed datasource to paintsquare
 	**added check authentication for coming from pbt application
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
   </cfif>
   	<!---include auth check for pbt users 
	 <cfinclude template="#application.rootpath#template_inc/contrak_pbt_auth_inc.cfm">--->
	<!---run login check, if not coming from pbt or is not on auth page--->
	  <cfif not StructKeyExists(session,"auth") or (isdefined("session.auth.access") and session.auth.access NEQ "basic") or not isdefined("url.agency") or not isdefined("url.userID")>
	 	<cfinclude template="#application.rootpath#forceUserLogin.cfm">
	  </cfif>
  </cffunction>
 
</cfcomponent>