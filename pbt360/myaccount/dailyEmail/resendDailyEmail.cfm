
<cffunction name="queryScope" returntype="string" output="no">
	<cfargument name="_userPrefs" required="yes"/>	
	<cfargument name="qryDefaults" required="yes"/>	
	
	<cfloop list="#arguments.qryDefaults#" index="_x">
		<cfset itemFound = listfind(arguments._userPrefs,_x)>
		<cfif itemFound>
			<cfset arguments._userPrefs= listDeleteAt(arguments._userPrefs,itemFound)/>
		</cfif>
	</cfloop>
	<cfreturn arguments._userPrefs />
</cffunction>
<cftry><cfinclude template="./PbtBidNotices.cfm" />
<cfcatch>
	<cfdump var="#cfcatch#" expand="no" label="error" />
	Error<cfabort />
</cfcatch>
</cftry>

<h6>Notices Email has been sent @ <cfoutput>#datetimeformat(now(),'mmm dd yyyy hh:mm:ss tt')# for #url.reportDate# to #getusers.recordcount# users.</cfoutput></h6>


<cftry><cfinclude template="./PbtBidAwards.cfm" />
<cfcatch>
	<cfdump var="#cfcatch#" expand="no" label="error" />
	Error<cfabort />
</cfcatch>
</cftry>

<h6>Award Email has been sent @ <cfoutput>#datetimeformat(now(),'mmm dd yyyy hh:mm:ss tt')# for #url.reportDate# to #getusers.recordcount# users.</cfoutput></h6>
