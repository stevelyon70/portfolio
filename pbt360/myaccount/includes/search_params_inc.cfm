

<cfset tempHRef2 = ""><!---new variables for search--->
<cfif isdefined("project_stage") and project_stage NEQ ""><cfset tempHRef2 = tempHRef2 & "&project_stage=#project_stage#"></cfif>	
<cfif isdefined("amount") and amount NEQ ""><cfset tempHRef2 = tempHRef2 & "&amount=#amount#"></cfif>	
<cfif isdefined("subfrom") and subfrom NEQ ""><cfset tempHRef2 = tempHRef2 & "&subfrom=#subfrom#"></cfif>	
<cfif isdefined("subto") and subto NEQ ""><cfset tempHRef2 = tempHRef2 & "&subto=#subto#"></cfif>	
<cfif isdefined("postfrom") and postfrom NEQ ""><cfset tempHRef2 = tempHRef2 & "&postfrom=#postfrom#"></cfif>	
<cfif isdefined("postto") and postto NEQ ""><cfset tempHRef2 = tempHRef2 & "&postto=#postto#"></cfif>	
<cfif isdefined("allprojects") and allprojects NEQ ""><cfset tempHRef2 = tempHRef2 & "&allprojects=#trim(allprojects)#"></cfif>	
<cfif isdefined("all_scopes") and all_scopes NEQ ""><cfset tempHRef2 = tempHRef2 & "&all_scopes=#trim(all_scopes)#"></cfif>	
<cfif isdefined("all_services") and all_services NEQ ""><cfset tempHRef2 = tempHRef2 & "&all_services=#trim(all_services)#"></cfif>
<cfif isdefined("services") and services NEQ ""><cfset tempHRef2 = tempHRef2 & "&services=#services#"></cfif>
<cfif isdefined("commercial") and commercial NEQ ""><cfset tempHRef2 = tempHRef2 & "&commercial=#trim(commercial)#"></cfif>
<cfif isdefined("industrial") and industrial NEQ ""><cfset tempHRef2 = tempHRef2 & "&industrial=#trim(industrial)#"></cfif>	
<cfif isdefined("generalcontracts") and generalcontracts NEQ ""><cfset tempHRef2 = tempHRef2 & "&generalcontracts=#trim(generalcontracts)#"></cfif>	
<cfif isdefined("paintingprojects") and paintingprojects NEQ ""><cfset tempHRef2 = tempHRef2 & "&paintingprojects=#trim(paintingprojects)#"></cfif>	
<cfif isdefined("qualifications") and qualifications NEQ ""><cfset tempHRef2 = tempHRef2 & "&qualifications=#qualifications#"></cfif>		
<cfif isdefined("scopes") and scopes NEQ ""><cfset tempHRef2 = tempHRef2 & "&scopes=#scopes#"></cfif>
<cfif isdefined("structures") and structures NEQ ""><cfset tempHRef2 = tempHRef2 & "&structures=#structures#"></cfif>
<cfif isdefined("supply") and supply NEQ ""><cfset tempHRef2 = tempHRef2 & "&supply=#supply#"></cfif>
<cfif isdefined("sorting") and sorting NEQ ""><cfset tempHRef2 = tempHRef2 & "&sorting=#sorting#"></cfif>
<cfif isdefined("ownerID") and ownerID NEQ ""><cfset tempHRef2 = tempHRef2 & "&ownerID=#ownerID#"></cfif>
<cfif isdefined("bidstatus") and bidstatus NEQ ""><cfset tempHRef2 = tempHRef2 & "&bidstatus=#bidstatus#"></cfif>
<cfif isdefined("state") and state NEQ ""><cfset tempHRef2 = tempHRef2 & "&state=#state#"></cfif>
<cfif isdefined("qt") and qt NEQ ""><cfset tempHRef2 = tempHRef2 & "&qt=#urlencodedformat(qt)#"></cfif>
<cfif isdefined("contractorname") and contractorname NEQ ""><cfset tempHRef2 = tempHRef2 & "&contractorname=#contractorname#"></cfif>
<cfif isdefined("verifiedprojects") and verifiedprojects NEQ ""><cfset tempHRef2 = tempHRef2 & "&verifiedprojects=#trim(verifiedprojects)#"></cfif>
<cfif isdefined("ltype") and ltype NEQ ""><cfset tempHRef2 = tempHRef2 & "&ltype=#ltype#"></cfif>
<cfif isdefined("filter") and filter NEQ ""><cfset tempHRef2 = tempHRef2 & "&filter=#filter#"></cfif>
<!---view agency page sorting--->
<cfif isdefined("bidfrom")><cfset tempHRef2 = tempHRef2 & "&bidfrom=#bidfrom#"></cfif>
<cfif isdefined("bidto")><cfset tempHRef2 = tempHRef2 & "&bidto=#bidto#"></cfif>
<cfif isdefined("awardfrom")><cfset tempHRef2 = tempHRef2 & "&awardfrom=#awardfrom#"></cfif>
<cfif isdefined("awardto")><cfset tempHRef2 = tempHRef2 & "&awardto=#awardto#"></cfif>
<cfif isdefined("bid")><cfset tempHRef2 = tempHRef2 & "&bid=#bid#"></cfif>
<cfif isdefined("awd")><cfset tempHRef2 = tempHRef2 & "&awd=#awd#"></cfif>
<!---end--->