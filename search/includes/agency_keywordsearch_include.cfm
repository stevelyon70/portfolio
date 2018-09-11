<!---modified on 10/5/11 by DS to migrate from Ultraseek to Solr--->

<!---run the search and return the results--->

<!--- Run the search against the Bid collection being passed over --->

	
<cfparam name="bidlist" default="">	
	<cfif isdefined("qt") and qt NEQ "">
		<cfsearch name="search_results1" collection="pbt_agency_spending" criteria="#qt#">
				<cfif search_Results1.recordcount GT 0>
			   		<cfset bidlist = listappend(bidlist,valuelist(search_results1.key))>
			 	</cfif>
		<cfsearch name="search_results2" collection="agencyDocs2" criteria="#qt#">
				<cfif search_Results2.recordcount GT 0 and search_results2.custom1 NEQ "">
			   		<cfset bidlist = listappend(bidlist,valuelist(search_results2.custom1))>
			 	</cfif>
	</cfif>	
	<cfif isdefined("contractorname") and contractorname NEQ "">
		 <cfsearch name="search_Results2" collection="pbt_agency_spending" criteria="#contractorname#">
			    <cfif search_Results2.recordcount GT 0> 
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results2.key))>
				</cfif> 
	</cfif>


