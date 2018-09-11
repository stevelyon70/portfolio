<cfset rootpath = "">
<cfif not isdefined("fuseaction")>
	<cfinclude template="includes/main_inc.cfm">
<cfelse>
	<cfswitch expression="#fuseaction#">
		<cfcase value="view">
			<cfquery  name="detail" datasource="#application.dataSource#" maxrows="1">
				select standards.standardid,standards.standard_title,standards.sspc_number,standards.revision_date,standards.editorial_change,standards.updatedon,standards.catid,standards.description1
				,standards.description2,standards.description3,standards.description4,standards.description5,standards.description6
				from standards 
				where standardid =<cfqueryPARAM value = "#url.id#" CFSQLType = "CF_SQL_INTEGER">  and active = 'y'
			</cfquery>
			<cfquery name="cat" datasource="#application.dataSource#">
				select category,catid
				from standardcat
				where catid = #detail.catid#
			</cfquery>		
			<cfinclude template="includes/standard_display_inc.cfm">
		</cfcase>
		<cfcase value="org">
			<cfquery name="pull_subs" datasource="#application.dataSource#">
				select standardsubcat.subcatid,standardsubcat.category as subcategory,standardsubcat.catid,standardcat.category
				from standardsubcat
				left outer join standardcat on standardcat.catid = standardsubcat.catid
				where standardsubcat.catid = <cfqueryPARAM value = "#catid#" CFSQLType = "CF_SQL_INTEGER"> 
				order by standardsubcat.category
			</cfquery>		
			<cfinclude template="includes/org_inc.cfm">
		</cfcase>
		<cfcase value="subcat">
			<cfquery name="pull_subs" datasource="#application.dataSource#">
				select standardsubcat.subcatid,standardsubcat.category as subcategory,standardsubcat.catid,standardcat.category
				from standardsubcat
				left outer join standardcat on standardcat.catid = standardsubcat.catid
				where standardsubcat.catid = <cfqueryPARAM value = "#catid#" CFSQLType = "CF_SQL_INTEGER"> and subcatid = <cfqueryPARAM value = "#subcatid#" CFSQLType = "CF_SQL_INTEGER"> 
				order by standardsubcat.category
			</cfquery>		
			<cfinclude template="includes/org_subcat_inc.cfm">
		</cfcase>
		<cfcase value="search">
			<cfinclude template="includes/search_inc.cfm">
		</cfcase>
		<cfcase value="results">
			<cfinclude template="includes/search_results_inc.cfm">
		</cfcase>
	</cfswitch>
</cfif>
					

