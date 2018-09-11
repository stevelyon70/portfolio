<!---
 Filename: Application.cfc
 Created by: DS
 Please note: Executes for every page request
--->

<cfcomponent output="false">
  <!--- name the application. --->
  <cfset this.name="wbt_360_beta">
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
     <cfset Application.gglapikey="AIzaSyDFlb2PqHECcsyzOk9s2yikvkrZg9HM2j4" />
		<cfinclude template="functionInc/AppObjects.cfm" />
     <cfreturn true />
  </cffunction>
  
  <cffunction name="onRequestStart" output="false" returnType="void">  
  	 <cfset request.rootpath="/"> 
     <cfset application.dataSource="paintsquare"> 
	 <cfset Application.rootpath="/">
	 <cfset Application.CFCPath = "360cfc"> 
     <!---cfparam default="" name="session.auth.access" / --->
     <cfset Application.CONTRAKPATH = 'http://beta360.paintbidtracker.com/' />
  	 <cfset Application.gglapikey="AIzaSyDFlb2PqHECcsyzOk9s2yikvkrZg9HM2j4" />    
     <CFSET DATE = #CREATEODBCDATETIME(NOW())#>  
      <!---if user has chosen to logout--->
	<cfif isdefined("url.logout")>
		<cftry>
			<cflog application="yes" file="pbt_login" type="Information" text="User Logout :#session.auth.username#.#session.auth.userid#" />
		<cfcatch></cfcatch></cftry>
		<cflogout>
		<cflock timeout=20 scope="Session" type="Exclusive">
    		<cfset StructDelete(Session, "auth")>
			<cfset structClear(session) />
		</cflock>
		<cflocation url="#request.rootpath#index.cfm" addtoken="No" />
	</cfif>
    <!--- Remember user’s logged-in status, plus --->
 	<!--- editorID and name, in structure --->
   <cfif isUserLoggedIn()>
		<cfif not isdefined("session.auth.username") or session.auth.username EQ "" or not isdefined("session.auth.user_access_token") or session.auth.user_access_token EQ "">
			<cflocation url="?logout=1" addtoken="false">
		</cfif>
   <cfelse>
	 <!---cfset userid="0" />   
	 <cfset session.auth.userID="0">
	 <cfset session.auth.name="">
	 <cfset session.auth.userName="">
	 <cfset session.auth.firstname="">
	 <cfset session.auth.lastname="">
     <cfset session.auth.user_access_token="">
	 <cfset session.auth.user_group="">
	 <cfset session.auth.default_year="2017">
	 <cfset session.auth.default_qtr="Q4">	 
	 <cfset session.auth.access = ''/ --->
   	<cfinclude template="#request.rootpath#forceUserLogin.cfm">
   </cfif>  
   
   <cftry>
   <cfparam name="userid" default="#session.auth.userid#" />
   <cfparam name="session.packages" default="0" />
   <cfcatch>
  	 
   </cfcatch></cftry>
   
  
  </cffunction> 
  
  <cffunction name="onRequest">
  	<cfargument name="targetPage" />
  	<cfparam name="url.debug" default="false" />
  	<cfparam name="url.restart" default="false" />
  	
  	<cfif url.debug><cfinclude template="#request.rootpath#debug.cfm"></cfif>
  	<cfif url.restart><cfset x = onApplicationStart()></cfif>
  	
  	<cfinclude template="#arguments.targetPage#" />
  	
  	
  </cffunction>
    <cffunction name="onSessionStart" output="false" returnType="void"><cfset session.bidDetail = structNew() /></cffunction> 

  
</cfcomponent>