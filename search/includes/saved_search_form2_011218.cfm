<div id="saved-form" title="Save this Search">
Please enter a name for this search.

<cfif isdefined("qt")>
<CFSET qt = #replace(qt,"%22","""","ALL")#>
</cfif>
<cfoutput>
	<cfif isdefined("sort") and isdefined("desc")>
			<cfset sortdesc= "">
			<cfset sortdesc = sortdesc & "&sort=#sort#&desc=#desc#">
	<cfelse>
		<cfset sortdesc="">
	</cfif>
	<cfif isdefined("showall") and showall is not "no">
			<cfset sortdesc = sortdesc & "&showall=#showall#">
	</cfif>
	<cfform name="saveSearchParams" action="?action=#paction#&userid=#userid#&sortdesc=#sortdesc#" method="get">
	<cfif isdefined("qt")><cfinput type="hidden" name="qt" value="#qt#"></cfif>
	<cfif isdefined("amount")><input type="Hidden" name="amount" value="#amount#"><cfelse><input type="Hidden" name="amount" value=""></cfif>
	<cfif isdefined("state")><input type="Hidden" name="state" value="#state#"><cfelse><input type="Hidden" name="state" value="66"></cfif>
	<cfif isdefined("postfrom")><input type="Hidden" name="postfrom" value="#postfrom#"><cfelse></cfif>
	<cfif isdefined("postto")><input type="Hidden" name="postto" value="#postto#"><cfelse></cfif>
	<cfif isdefined("subfrom")><input type="Hidden" name="subfrom" value="#subfrom#"><cfelse></cfif>
	<cfif isdefined("subto")><input type="Hidden" name="subto" value="#subto#"><cfelse></cfif>
	<cfif isdefined("project_stage")><input type="Hidden" name="project_stage" value="#project_stage#"><cfelse></cfif>
	<cfif isdefined("all_scopes")><input type="Hidden" name="all_scopes" value="#all_scopes#"><cfelse></cfif>
	<cfif isdefined("bidID")><input type="hidden" name="bidID" value="#bidID#"><cfelse></cfif>
	<cfif isdefined("showall")><input type="hidden" name="showall" value="#showall#"><cfelse></cfif>
	<cfif isdefined("industrial")><input type="Hidden" name="industrial" value="#industrial#"><cfelse></cfif>
	<cfif isdefined("paintingprojects")><input type="Hidden" name="paintingprojects" value="#paintingprojects#"><cfelse></cfif>
	<cfif isdefined("qualifications")><input type="Hidden" name="qualifications" value="#qualifications#"><cfelse></cfif>
	<cfif isdefined("supply")><input type="Hidden" name="supply" value="#supply#"></cfif>
	<cfif isdefined("structures")><input type="hidden" name="structures" value="#structures#"><cfelse></cfif>
	<cfif isdefined("scopes")><input type="hidden" name="scopes" value="#scopes#"></cfif>
	<cfif isdefined("sorting")><input type="hidden" name="sorting" value="#sorting#"></cfif>
	<cfif isdefined("all_services")><input type="Hidden" name="all_services" value="#all_services#"><cfelse></cfif>
	<cfif isdefined("services")><input type="Hidden" name="services" value="#services#"><cfelse></cfif>
	<cfif isdefined("commercial")><input type="Hidden" name="commercial" value="#commercial#"><cfelse></cfif>
	<cfif isdefined("generalcontracts")><input type="Hidden" name="generalcontracts" value="#generalcontracts#"><cfelse></cfif>
	<cfif isdefined("verifiedprojects")><input type="Hidden" name="verifiedprojects" value="#verifiedprojects#"><cfelse></cfif>
	<cfif isdefined("contractorname")><input type="Hidden" name="contractorname" value="#contractorname#"><cfelse></cfif>
	<cfif isdefined("filter")><input type="Hidden" name="filter" value="#filter#"><cfelse></cfif>
	<cfif isdefined("allprojects")><input type="Hidden" name="allprojects" value="#allprojects#"><cfelse></cfif>
	<cfif isdefined("planholders")><input type="Hidden" name="planholders" value="#planholders#"><cfelse></cfif>
	<input type="hidden" name="action" value="#paction#">
	<cfif isdefined("userid")><input type="hidden" name="userid" value="#userid#"></cfif>
	<input type="Hidden" name="sAction" value="SaveSearch">
	
<cfinput type="text" name="label" value="" required="yes" message="Please enter a search name.">

<input type="submit" name="submit" value="Save Search">
</cfform>
</cfoutput>
</div>

