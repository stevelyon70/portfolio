<!---
 Filename: Application.cfc
 Created by: DS
 Please note: Executes for every page request
--->

<cfcomponent output="false">
  <!--- name the application. --->
  <cfset this.name="PaintSquare">
  <!--- Turn on session management. --->
  <cfset this.sessionManagement=true>
  <!--- Default datasource --->  
  <cfset this.dataSource="paintsquare"> 
    
  <cffunction name="onApplicationStart" output="false" returnType="void">
    <!--- Any variables set here can be used by all our pages --->
     
 
  </cffunction>
  <cffunction name="onRequestStart" output="false" returnType="void">
  	 <cfset request.directory = "agency">
  	 <cfset request.rootpath="../">
	 <cfset Application.rootpath="../">
	 <cfset Application.CFCPath = "contrakcfc">  
	<cfif isdefined("url.basic")>
		<cfset variables.basic = 1>
	</cfif>
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
   <cfif isdefined("variables.basic")>
		   	 <cfscript>
		// *** Restrict Access To Page: Grant or deny access to this page
		MM_authorizedUsers="";
		MM_authFailedURL="http://www.paintbidtracker.com";
		MM_grantAccess=false;
		MM_Session = IIf(IsDefined("Session.MM_Username"),"Session.MM_Username",DE(""));
		if (MM_Session IS NOT "") {
		  if (true OR (Session.MM_UserAuthorization IS "") OR (Find(Session.MM_UserAuthorization, MM_authorizedUsers) GT 0)) {
		    MM_grantAccess = true;
		  }
		}
		if (NOT MM_grantAccess) {
		  MM_qsChar = "?";
		  if (Find("?",MM_authFailedURL) GT 0) MM_qsChar = "&";
		  MM_referrer = CGI.SCRIPT_NAME;
		  if (CGI.QUERY_STRING IS NOT "") MM_referrer = MM_referrer & "?" & CGI.QUERY_STRING;
		  MM_authFailedURL_Trigger = MM_authFailedURL & MM_qsChar & "accessdenied=" & URLEncodedFormat(MM_referrer);
		}
		</cfscript>
		<cfif IsDefined("MM_authFailedURL_Trigger")>
		<cflocation url="#MM_authFailedURL_Trigger#" addtoken="no">
		</cfif>
   </cfif>
    <cfinclude template="#application.rootpath#forceUserLogin.cfm">
  </cffunction>
 
</cfcomponent>