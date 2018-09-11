<!---
 Filename: Application.cfc
 Created by: DS
 Please note: Executes for every page request
--->

<cfcomponent output="false">
  <!--- name the application. --->
  <cfset this.name="contrak">
  <!--- Turn on session management. --->
  <cfset this.sessionManagement=true>
  <!--- Default datasource --->  
  <cfset this.dataSource="pbt_analytics"> 
    
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
	</cfif>
    <!--- Remember user’s logged-in status, plus --->
 	<!--- editorID and name, in structure --->
   <cfif isUserLoggedIn()>
   	 <cfset session.auth = structnew()>
	 <cfset session.auth.editorID = listFirst(getAuthUser())>
	 <cfset session.auth.name = listRest(getAuthUser())>
	 <cfset application.editorID = session.auth.editorID>
	 <cfset application.editorName = session.auth.name>
   </cfif>
    <cfinclude template="#application.rootpath#forceUserLogin.cfm">
   
  </cffunction>
 
</cfcomponent>