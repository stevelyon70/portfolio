<cfoutput>		
	<cfset search_variables = "">
	
<!---new variables for search--->
<cfif isdefined("project_stage")><cfset search_variables = search_variables & "&project_stage=#project_stage#"></cfif>	
<cfif isdefined("amount")><cfset search_variables = search_variables & "&amount=#amount#"></cfif>	
<cfif isdefined("postfrom")><cfset search_variables = search_variables & "&postfrom=#postfrom#"></cfif>	
<cfif isdefined("postto")><cfset search_variables = search_variables & "&postto=#postto#"></cfif>	
<cfif isdefined("subfrom")><cfset search_variables = search_variables & "&subfrom=#subfrom#"></cfif>	
<cfif isdefined("subto")><cfset search_variables = search_variables & "&subto=#subto#"></cfif>
<cfif isdefined("allprojects")><cfset search_variables = search_variables & "&allprojects=#allprojects#"></cfif>	
<cfif isdefined("all_scopes")><cfset search_variables = search_variables & "&all_scopes=#all_scopes#"></cfif>	
<cfif isdefined("industrial")><cfset search_variables = search_variables & "&industrial=#industrial#"></cfif>	
<cfif isdefined("paintingprojects")><cfset search_variables = search_variables & "&paintingprojects=#paintingprojects#"></cfif>	
<cfif isdefined("qualifications")><cfset search_variables = search_variables & "&qualifications=#qualifications#"></cfif>		
<cfif isdefined("scopes")><cfset search_variables = search_variables & "&scopes=#scopes#"></cfif>
<cfif isdefined("structures")><cfset search_variables = search_variables & "&structures=#structures#"></cfif>
<cfif isdefined("supply")><cfset search_variables = search_variables & "&supply=#supply#"></cfif>
<cfif isdefined("sorting")><cfset search_variables = search_variables & "&sorting=#sorting#"></cfif>
<cfif isdefined("generalcontracts")><cfset search_variables = search_variables & "&generalcontracts=#generalcontracts#"></cfif>	
<cfif isdefined("state")><cfset search_variables = search_variables & "&state=#state#"></cfif>
<cfif isdefined("qt")><cfset search_variables = search_variables & "&qt=#urlencodedformat(qt)#"></cfif>
<cfif isdefined("bidid")><cfset search_variables = search_variables & "&bidid=#bidid#"></cfif>
<cfif isdefined("verifiedprojects")><cfset search_variables = search_variables & "&verifiedprojects=#verifiedprojects#"></cfif>
<cfif isdefined("contractorname")><cfset search_variables = search_variables & "&contractorname=#contractorname#"></cfif>
<cfif isdefined("commercial")><cfset search_variables = search_variables & "&commercial=#commercial#"></cfif>
<cfif isdefined("all_services")><cfset search_variables = search_variables & "&all_services=#all_services#"></cfif>
<cfif isdefined("action")><cfset search_variables = search_variables & "&action=#action#"></cfif>
<cfif isdefined("ltype")><cfset search_variables = search_variables & "&ltype=#ltype#"></cfif>
<cfif isdefined("filter")><cfset search_variables = search_variables & "&filter=#filter#"></cfif>
<cfif isdefined("planholders")><cfset search_variables = search_variables & "&planholders=#planholders#"></cfif>
<cfif isdefined("packageID")><cfset search_variables = search_variables & "&packageID=#packageID#"></cfif>
<cfif isdefined("lst")><cfset search_variables = search_variables & "&lst=#lst#"></cfif>
</cfoutput>