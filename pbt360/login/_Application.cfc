<!---
 Filename: Application.cfc
 Created by: DS
 Please note: Executes for every page request
--->

<cfcomponent output="false">
  <!--- name the application. --->
  <cfset this.name="pbt_360">
  <!--- Turn on session management. --->
  <cfset this.sessionManagement=true>
  <!--- Default datasource --->  
  <cfset this.dataSource="paintsquare"> 
 
 
  <cffunction name="onRequestStart" output="false" returnType="void">
    <!---if user has chosen to logout--->
	<cfif isdefined("url.logout")>
		<cflogout>
	</cfif>
     <cfset application.rootpath = "/">
	 
    <!--- Remember user’s logged-in status, plus --->
 	<!--- editorID and name, in structure --->
   <cfif isUserLoggedIn()>
   	 <cfset session.auth = structnew()>
	 <cfset session.auth.editorID = listFirst(getAuthUser())>
	 <cfset session.auth.name = listRest(getAuthUser())>
	 <cfset application.editorID = session.auth.editorID>
	 <cfset application.editorName = session.auth.name>
   </cfif>
    
   
  </cffunction>

</cfcomponent>