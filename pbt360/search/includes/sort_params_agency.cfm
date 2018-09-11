<!---set the sort options--->
<cfif isdefined("sorting")>
	<cfswitch expression="#sorting#">
		<cfcase value="projectdate">
			<cfset sortvalue = "CASE WHEN project_startdate IS NULL  THEN 1 ELSE 0 END,project_startdate">
		</cfcase>
		<cfcase value="projectdatedesc">
			<cfset sortvalue = "CASE WHEN project_startdate IS NULL  THEN 1 ELSE 0 END,project_startdate desc">
		</cfcase>
		
		<cfcase value="projectname">
			<cfset sortvalue = "projectname">
		</cfcase>
		<cfcase value="projectnamedesc">
			<cfset sortvalue = "projectname desc">
		</cfcase>
		<cfcase value="agency">
			<cfset sortvalue = "owner">
		</cfcase>
		<cfcase value="agencydesc">
			<cfset sortvalue = "owner desc">
		</cfcase>
		<cfcase value="city">
			<cfset sortvalue = "city">
		</cfcase>
		<cfcase value="citydesc">
			<cfset sortvalue = "city desc">
		</cfcase>
		<cfcase value="state">
			<cfset sortvalue = "state">
		</cfcase>
		<cfcase value="statedesc">
			<cfset sortvalue = "statedesc">
		</cfcase>
		<cfdefaultcase>
			<cfset sortvalue = "CASE WHEN project_startdate IS NULL  THEN 1 ELSE 0 END,project_startdate">
		</cfdefaultcase>
	</cfswitch>
<cfelse>
	<cfset sortvalue = "paintpublishdate desc">
</cfif>