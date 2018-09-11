<!---set the sort options--->
<cfif isdefined("sorting")>
	<cfswitch expression="#sorting#">
		<cfcase value="submittaldate">
			<cfset sortvalue = "CASE WHEN submittaldate IS NULL  THEN 1 ELSE 0 END,submittaldate">
		</cfcase>
		<cfcase value="submittaldatedesc">
			<cfset sortvalue = "CASE WHEN submittaldate IS NULL  THEN 1 ELSE 0 END,submittaldate desc">
		</cfcase>
		<cfcase value="stage">
			<cfset sortvalue = "stage">
		</cfcase>
		<cfcase value="stagedesc">
			<cfset sortvalue = "stage desc">
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
			<cfset sortvalue = "CASE WHEN submittaldate IS NULL  THEN 1 ELSE 0 END,submittaldate">
		</cfdefaultcase>
	</cfswitch>
<cfelse>
	<cfset sortvalue = "CASE WHEN submittaldate IS NULL  THEN 1 ELSE 0 END,submittaldate desc">
</cfif>