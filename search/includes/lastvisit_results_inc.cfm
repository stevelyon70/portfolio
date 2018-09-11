<CFSET todaydate = #CREATEODBCDATETIME(NOW())#>	
	<!---TO DO put in a CFC --->
<cfinclude template="user_trash.cfm">
<!---include the returned results--->
<cfinclude template="lastvisit_results.cfm">
<cfquery name="pull_saved_projects" datasource="#application.datasource#">
	select bidID 
	from bid_user_project_bids
	where userID = #userID# and active = 1
</cfquery>
 
<cfinclude template="recordsShowingparams.cfm">
<cfif search_results.recordcount GT 0>
	<cfinclude template="search_params.cfm">
</cfif>
	<cfset result_title = "Water BidTracker">
	<cfif isdefined("packageID") and packageID NEQ "">
		<cfswitch expression="#packageID#">
		  <cfcase value="1">
			<cfset result_title = "Industrial Painting Leads and Bid Notices">
		  </cfcase>
		  <cfcase value="2">
			<cfset result_title = "Commercial Painting Leads and Bid Notices">
		  </cfcase>
		  <cfcase value="3">
			<cfset result_title = "Leads and Bid Notices">
		  </cfcase>
		  <cfcase value="4">
			<cfset result_title = "Engineering & Design Leads">
		  </cfcase>	 
		  <cfcase value="5">
			<cfset result_title = "Industrial Painting Awards and Results">
		  </cfcase>	 
		  <cfcase value="6">
			<cfset result_title = "Awards and Results">
		  </cfcase>	 
		  <cfcase value="7">
			<cfset result_title = "Engineering & Design Awards and Results">
		  </cfcase>	 
		  <cfcase value="9">
			<cfset result_title = "Subcontracting Opportunities">
		  </cfcase>		  	  	  	   	  	  
		</cfswitch>
	</cfif>
<div class="row">	
	<div class="col-sm-12">
		<h3><cfoutput>#result_title#</cfoutput></H3>
	</div>	
</div>
<div class="row">
	<cfinclude template="search_results_criteria_inc.cfm">
</div> 
<!---<div class="row">
	<div class="text-right col-sm-12">
		
	</div>	
</div> --->
<!---<cfinclude template="paging.cfm" />--->
<div>
	<cfinclude template="search_results_grid_inc.cfm">
</div> 
<!---<cfinclude template="paging.cfm" />--->


