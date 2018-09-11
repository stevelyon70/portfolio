<cfsetting showdebugoutput="false">
<cfset valid = false>
<cfset message = "">

<CFSET todaydate = #CREATEODBCDATETIME(NOW())#>

<cfif isdefined("form.saction")>
	<cfquery name="check_duplicates" datasource="#application.datasource#">
		select id
		from pbt_user_saved_searches
		where userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and searchname = '#form.label#'
	</cfquery>
	<cfif check_duplicates.recordcount EQ 0>
		<cfquery name="insert_search" datasource="#application.datasource#">
		insert into pbt_user_saved_searches
		(
		qt,
		searchname,
		datecreated,
		userid,
		amount,
		state,
		postfrom,
		postto,
		subfrom,
		subto,
		bidID,
		project_stage,
		all_scopes,
		industrial,
		commercial,
		paintingprojects,
		qualifications,
		supply,
		structures,
		scopes,
		active,
		pageaction,
		sorting,
		showall,
		generalcontracts,
		allprojects,
		all_services,
		services,
		verifiedprojects,
		contractorname,
		filter,
		planholders)
		values
		(
		<cfif isdefined("qt") and qt NEQ "">'#qt#'<cfelse>NULL</cfif>,
		'#label#',
		#todaydate#,
		#session.auth.userid#,
		'#amount#',
		'#state#',
		<cfif isdefined("postfrom") and postfrom NEQ "">'#postfrom#'<cfelse>NULL</cfif>,
		<cfif isdefined("postto") and postto NEQ "">'#postto#'<cfelse>NULL</cfif>,
		<cfif isdefined("subfrom") and subfrom NEQ "">'#subfrom#'<cfelse>NULL</cfif>,
		<cfif isdefined("subto") and subto NEQ "">'#subto#'<cfelse>NULL</cfif>,
		<cfif isdefined("bidID") and bidID NEQ "">#bidID#<cfelse>NULL</cfif>,
		<cfif isdefined("project_stage") and project_stage NEQ "">'#project_stage#'<cfelse>NULL</cfif>,
		<cfif isdefined("all_scopes") and all_scopes NEQ "">'#all_scopes#'<cfelse>NULL</cfif>,
		<cfif isdefined("industrial") and industrial NEQ "">'#industrial#'<cfelse>NULL</cfif>,
		<cfif isdefined("commercial") and commercial NEQ "">'#commercial#'<cfelse>NULL</cfif>,
		<cfif isdefined("paintingprojects") and paintingprojects NEQ "">'#paintingprojects#'<cfelse>NULL</cfif>,
		<cfif isdefined("qualifications") and qualifications NEQ "">'#qualifications#'<cfelse>NULL</cfif>,
		<cfif isdefined("supply") and supply NEQ "">'#supply#'<cfelse>NULL</cfif>,
		<cfif isdefined("structures") and structures NEQ "">'#structures#'<cfelse>NULL</cfif>,
		<cfif isdefined("scopes") and scopes NEQ "">'#scopes#'<cfelse>NULL</cfif>,
		1,
		'#action#',
		<cfif isdefined("sorting") and sorting NEQ "">'#sorting#'<cfelse>NULL</cfif>,
		<cfif isdefined("showall") and showall NEQ "">'#showall#'<cfelse>NULL</cfif>,
		<cfif isdefined("generalcontracts") and generalcontracts NEQ "">'#generalcontracts#'<cfelse>NULL</cfif>,
		<cfif isdefined("allprojects") and allprojects NEQ "">'#allprojects#'<cfelse>NULL</cfif>,
		<cfif isdefined("all_services") and all_services NEQ "">'#all_services#'<cfelse>NULL</cfif>,
		<cfif isdefined("services") and services NEQ "">'#services#'<cfelse>NULL</cfif>,
		<cfif isdefined("verifiedprojects") and verifiedprojects NEQ "">'#verifiedprojects#'<cfelse>NULL</cfif>,
		<cfif isdefined("contractorname") and contractorname NEQ "">'#contractorname#'<cfelse>NULL</cfif>,
		<cfif isdefined("filter") and filter NEQ "">'#trim(filter)#'<cfelse>NULL</cfif>,
		<cfif isdefined("planholders") and planholders NEQ "">'#planholders#'<cfelse>NULL</cfif>
		)
		</cfquery>
		
		<!---prompt user success--->
		<cfset valid = true>		
		<cfset message="Search saved successfully!">

	<cfelse>
	
		<!---prompt user for duplicate--->
		<cfset message="<br><br>This saved search could not be created. There is already a saved searched using this name. Please rename the search.">	
	
	</cfif>
</cfif>


{ "valid": <cfoutput>#valid#</cfoutput>, "message": "<cfoutput>#message#</cfoutput>"}