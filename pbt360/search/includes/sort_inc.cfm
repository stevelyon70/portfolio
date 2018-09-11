<cfoutput>
	<cfif isdefined("action")>
		<cfset action = action>
	</cfif>
<cfform id="searchSortForm" class="sortByForm" method="get" action="?action=#action#">
	<cfif isdefined("qt")><cfinput type="hidden" name="qt" value="#qt#"></cfif>
	<cfif isdefined("amount")><input type="Hidden" name="amount" value="#amount#"><cfelse><input type="Hidden" name="amount" value=""></cfif>
	<cfif isdefined("state")><input type="Hidden" name="state" value="#state#"><cfelse><input type="Hidden" name="state" value="66"></cfif>
	<cfif isdefined("postfrom")><input type="Hidden" name="postfrom" value="#postfrom#"><cfelse></cfif>
	<cfif isdefined("postto")><input type="Hidden" name="postto" value="#postto#"><cfelse></cfif>
	<cfif isdefined("subfrom")><input type="Hidden" name="subfrom" value="#subfrom#"><cfelse></cfif>
	<cfif isdefined("subto")><input type="Hidden" name="subto" value="#subto#"><cfelse></cfif>
	<cfif isdefined("packageID")><input type="Hidden" name="packageID" value="#packageID#"><cfelse></cfif>
	<!---set the owner/agency detail params--->
	<cfif isdefined("bidfrom")><input type="Hidden" name="bidfrom" value="#bidfrom#"><cfelse></cfif>
	<cfif isdefined("bidto")><input type="Hidden" name="bidto" value="#bidto#"><cfelse></cfif>
	<cfif isdefined("awardfrom")><input type="Hidden" name="awardfrom" value="#awardfrom#"><cfelse></cfif>
	<cfif isdefined("awardto")><input type="Hidden" name="awardto" value="#awardto#"><cfelse></cfif>
	<cfif isdefined("ownerID")><input type="hidden" name="ownerID" value="#ownerID#"><cfelse></cfif>
	<cfif isdefined("bid")><input type="hidden" name="bid" value="#bid#"><cfelse></cfif>
	<cfif isdefined("awd")><input type="hidden" name="awd" value="#awd#"><cfelse></cfif>
	<!---end--->
	<cfif isdefined("project_stage")><input type="Hidden" name="project_stage" value="#project_stage#"><cfelse></cfif>
	<cfif isdefined("all_scopes")><input type="Hidden" name="all_scopes" value="#all_scopes#"><cfelse></cfif>
	<cfif isdefined("bidID")><input type="hidden" name="bidID" value="#bidID#"><cfelse></cfif>
	<cfif isdefined("sort")><input type="hidden" name="sort" value="#sort#"><cfelse></cfif>
 	<cfif isdefined("desc")><input type="hidden" name="desc" value="#desc#"><cfelse></cfif>
	<cfif isdefined("showall")><input type="hidden" name="showall" value="#showall#"><cfelse></cfif>
	<cfif isdefined("industrial")><input type="Hidden" name="industrial" value="#industrial#"><cfelse></cfif>
	<cfif isdefined("paintingprojects")><input type="Hidden" name="paintingprojects" value="#paintingprojects#"><cfelse></cfif>
	<cfif isdefined("qualifications")><input type="Hidden" name="qualifications" value="#qualifications#"><cfelse></cfif>
	<cfif isdefined("supply")><input type="Hidden" name="supply" value="#supply#"></cfif>
	<cfif isdefined("structures")><input type="hidden" name="structures" value="#structures#"><cfelse></cfif>
	<cfif isdefined("scopes")><input type="hidden" name="scopes" value="#scopes#"></cfif>
	<cfif isdefined("userid")><input type="hidden" name="userid" value="#userid#"></cfif>
	<cfif isdefined("generalcontracts")><input type="hidden" name="generalcontracts" value="#generalcontracts#"></cfif>	
	<cfif isdefined("allprojects")><input type="hidden" name="allprojects" value="#allprojects#"></cfif>
	<cfif isdefined("verifiedprojects")><input type="hidden" name="verifiedprojects" value="#verifiedprojects#"></cfif>	
	<cfif isdefined("contractorname")><input type="hidden" name="contractorname" value="#contractorname#"></cfif>
	<cfif isdefined("supplierID")><input type="hidden" name="supplierID" value="#supplierID#"></cfif>		
	<cfif isdefined("services")><input type="hidden" name="services" value="#services#"></cfif>	
	<cfif isdefined("commercial")><input type="Hidden" name="commercial" value="#commercial#"><cfelse></cfif>
	<cfif isdefined("all_services")><input type="Hidden" name="all_services" value="#all_services#"><cfelse></cfif>
	<cfif isdefined("ltype")><input type="Hidden" name="ltype" value="#ltype#"><cfelse></cfif>
	<cfif isdefined("filter")><input type="Hidden" name="filter" value="#filter#"><cfelse></cfif>
	<cfif isdefined("planholders")><input type="Hidden" name="planholders" value="#planholders#"><cfelse></cfif>
	<input type="hidden" value="#action#" name="action">
	<label class="sortByLabel">Sort by&nbsp;</label>
	<select id="sort" class="sortByDropdown" onchange="this.form.submit();" name="sorting">
		<cfif isdefined("sorting") and sorting EQ "submittaldate">
			<option value="submittaldatedesc" selected="selected">Submittal Date</option>
		<cfelseif isdefined("sorting") and sorting EQ "submittaldatedesc">
			<option value="submittaldate" selected="selected">Submittal Date</option>
		<cfelse>
			<option value="submittaldate">Submittal Date</option>
		</cfif>
		<cfif isdefined("sorting") and sorting EQ "stage">
			<option value="stagedesc" selected="selected">Stage</option>
		<cfelseif isdefined("sorting") and sorting EQ "stagedesc">
			<option value="stagedate" selected="selected">Stage</option>
		<cfelse>
			<option value="stage">Stage</option>
		</cfif>
		<cfif isdefined("sorting") and sorting EQ "projectname">
			<option value="projectnamedesc" selected="selected">Project Name</option>
		<cfelseif isdefined("sorting") and sorting EQ "projectnamedesc">
			<option value="projectname" selected="selected">Project Name</option>
		<cfelse>
			<option value="projectname">Project Name</option>
		</cfif>
		
		<cfif isdefined("sorting") and sorting EQ "agency">
			<option value="agencydesc" selected="selected">Agency</option>
		<cfelseif isdefined("sorting") and sorting EQ "agencydesc">
			<option value="agency" selected="selected">Agency</option>
		<cfelse>
			<option value="agency">Agency</option>
		</cfif>
		
		
		<cfif isdefined("sorting") and sorting EQ "city">
			<option value="citydesc" selected="selected">City</option>
		<cfelseif isdefined("sorting") and sorting EQ "citydesc">
			<option value="city" selected="selected">City</option>
		<cfelse>
			<option value="city">City</option>
		</cfif>
		
		<cfif isdefined("sorting") and sorting EQ "state">
			<option value="statedesc" selected="selected">State</option>
		<cfelseif isdefined("sorting") and sorting EQ "statedesc">
			<option value="state" selected="selected">State</option>
		<cfelse>
			<option value="state">State</option>
		</cfif>
		
	</select>
</cfform>
</cfoutput>