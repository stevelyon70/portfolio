<CFSET todaydate = #CREATEODBCDATETIME(url.reportDate)#>
<cfset day=dayofweek(todaydate)>
<cfset d =#dayofweekasstring(day)#>
<Cfif d is "Saturday" or d is "Sunday">Bids are not published on the weekend. <cfabort /></cfif>
<!---run holiday check--->
<cfset cdate = dateformat(todaydate, "mm/dd/yyy")>
<cfquery name="check_holiday" datasource="paintsquare_master">
	select nl_holidayid
	from nl_holiday
	where target_date = '#cdate#' and (content_type = 'all' or content_type = 'pbt')
</cfquery>
<Cfif check_holiday.recordcount gt 0>Bids are not published on holidays. <cfabort /></cfif>
	
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
<cftry><cfinclude template="./WbtNotices.cfm" />
<cfcatch>
	<cfdump var="#cfcatch#" expand="no" label="error" />
	Error<cfabort />
</cfcatch>
</cftry>
<cfoutput>#datetimeformat(now(),'mmm dd yyyy h:nn tt')#</cfoutput>	
<cfif getusers.recordcount>
<cfoutput>
<h6>Your WBT Bid Notices Email has been sent for #url.reportDate#.</h6>
</cfoutput>
</cfif>

	
	
	