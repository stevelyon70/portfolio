<!---modified on 10/5/11 by DS to migrate from Ultraseek to Solr--->

<!---run the search and return the results--->

<!--- Run the search against the Bid collection being passed over --->

	
<cfparam name="contractorlist" default="">	
	<cfif isdefined("contractorname") and contractorname NEQ "">
		<cfsearch name="contractor_results" collection="pbt_contractor_search_v2a,pbt_contractor_search_v2b" criteria="#contractorname#"  maxrows="300">
			<cfif contractor_results.recordcount GT 0>
			   <cfset contractorlist = listappend(contractorlist,valuelist(contractor_results.custom1))>
			 </cfif>
	</cfif>	



