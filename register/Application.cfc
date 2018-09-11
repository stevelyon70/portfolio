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
    
  <cffunction name="onApplicationStart" output="false" returntype="boolean">
    <!--- Any variables set here can be used by all our pages --->
     <cfset application.dataSource="paintsquare"> 
	 <cfset Application.rootpath="../">
	 <cfset Application.CFCPath = "contrakcfc"> 
     <cfreturn true />
  </cffunction>
  
  <cffunction name="onRequestStart" output="false" returnType="void">
 	 <cfset request.rootpath="/"> 
     <cfset application.dataSource="paintsquare"> 
	 <cfset Application.rootpath="/">
	 <cfset Application.CFCPath = "contrakcfc"> 
	 <cfset site_tagID = 50>
     <cfset siteID = 50><!---For PBT--->
      <!---if user has chosen to logout--->	
    <!--- Remember user’s logged-in status, plus --->
 	<!--- editorID and name, in structure --->
   
   
  </cffunction> 
  
  <cffunction name="onRequest">
  	<cfargument name="targetPage" />
  	<cfparam name="url.debug" default="false" />
  	<cftry>
  	<cfif url.debug><cfinclude template="#request.rootpath#debug.cfm"></cfif>
  	<cfinclude template="#arguments.targetPage#" />
  	<cfcatch><cfinclude template="#request.rootpath#debug.cfm"><cfdump var="#cfcatch#" /></cfcatch></cftry>
  	
  </cffunction>
  
  
</cfcomponent>