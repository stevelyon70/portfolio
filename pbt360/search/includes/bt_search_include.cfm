<!---modified on 10/5/11 by DS to migrate from Ultraseek to Solr--->

<!---run the search and return the results--->

<!--- Run the search against the Bid collection being passed over --->

	
<cfparam name="bidlist" default="">	
<cfif isdefined("project_stage")>
	<cfloop list="#project_stage#" index="i">
	 <cfswitch expression="#i#">
	 	  <cfcase value="1">
		   	<cfif not listcontains(project_stage, 12)>
		   	   <cftry><cfsearch name="search_Results1" collection="pbt_advanced_notices" criteria="#qt#" maxrows="300">
			   	<cfif search_Results1.recordcount GT 0>
			   		<cfset bidlist = listappend(bidlist,valuelist(search_results1.key))>
			 	</cfif><cfcatch></cfcatch></cftry>
			</cfif>
		  </cfcase>
		   <cfcase value="2">
		   	<cfif not listcontains(project_stage, 12)>
		   		<cftry><cfsearch name="search_Results2" collection="pbt_current_bids" criteria="#qt#" maxrows="300">
			    <cfif search_Results2.recordcount GT 0> 
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results2.key))>
				</cfif> <cfcatch></cfcatch></cftry>
			</cfif>
		  </cfcase>
		   <cfcase value="3">
		   	  <cfif not listcontains(project_stage, 12)>
		   	 	<cftry><cfsearch name="search_Results3" collection="pbt_engineering" criteria="#qt#" maxrows="300">
			   <cfif search_Results3.recordcount GT 0>
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results3.key))>
			   </cfif><cfcatch></cfcatch></cftry>
			 </cfif>
		  </cfcase>
		   <cfcase value="4">
		   	<cfif not listcontains(project_stage, 12)>
		   	 	<cftry><cfsearch name="search_Results4" collection="pbt_current_subcontracting" criteria="#qt#" maxrows="300">
			    <cfif search_Results4.recordcount GT 0>
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results4.key))>
				</cfif><cfcatch></cfcatch></cftry>
			</cfif>
		  </cfcase>
		   <cfcase value="5">
		   	 <cfif not listcontains(project_stage,4) and not listcontains(project_stage, 12)>
		   	 	<cftry><cfsearch name="search_Results5" collection="pbt_current_subcontracting" criteria="#qt#" maxrows="300">
			   <cfif search_Results5.recordcount GT 0>
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results5.key))>
			   </cfif><cfcatch></cfcatch></cftry>
			</cfif>
		  </cfcase>
		   <cfcase value="6">
		   	 	<cftry><cfsearch name="search_Results6" collection="pbt_awards" criteria="#qt#" maxrows="300">
			    <cfif search_Results6.recordcount GT 0>
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results6.key))>
				</cfif><cfcatch></cfcatch></cftry>
		  </cfcase>
		   <cfcase value="7">
		   	 <cfif not listcontains(project_stage,6) and not listcontains(project_stage, 13)>
		    	<cftry><cfsearch name="search_Results7" collection="pbt_lowbids" criteria="#qt#" maxrows="300">
			    <cfif search_Results7.recordcount GT 0>
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results7.key))>
				</cfif><cfcatch></cfcatch></cftry>
			 </cfif>
		  </cfcase>
		   <cfcase value="8">
		   	  <cfif not listcontains(project_stage,6) and not listcontains(project_stage, 13)>
		   	 	<cftry><cfsearch name="search_Results8" collection="pbt_awards_results" criteria="#qt#" maxrows="300">
			   	<cfif search_Results8.recordcount GT 0>
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results8.key))>
				</cfif><cfcatch></cfcatch></cftry>
			  </cfif>
		  </cfcase>
		   <cfcase value="9">
		   	  <cfif not listcontains(project_stage,6) and not listcontains(project_stage, 13)>
		   	 	<cftry><cfsearch name="search_Results9" collection="pbt_awards" criteria="#qt#" maxrows="300">
			    <cfif search_Results9.recordcount GT 0>
			   	 	<cfset bidlist = listappend(bidlist,valuelist(search_results9.key))>
				</cfif><cfcatch></cfcatch></cftry>
			 </cfif>
		  </cfcase>
		   <cfcase value="10">
		   	  <cfif listcontains(project_stage, 10)>
		   	 	<cftry><cfsearch name="search_Results10" collection="pbt_expired_bids_00,pbt_expired_bids_01,pbt_expired_bids_02" criteria="#qt#" maxrows="100">
				<!---cfsearch name="search_Results10" collection="pbt_expired_bids_00,pbt_expired_bids_01,pbt_expired_bids_02,pbt_expired_bids_03,pbt_expired_bids_04,pbt_expired_bids_05,pbt_expired_bids_06,pbt_expired_bids_07,pbt_expired_bids_08,pbt_expired_bids_09,pbt_expired_bids_10,pbt_expired_bids_11" criteria="#qt#"--->
			    <cfif search_Results10.recordcount GT 0>
			   	 	<cfset bidlist = listappend(bidlist,valuelist(search_results10.key))>
				</cfif><cfcatch></cfcatch></cftry>
			  </cfif>
		  </cfcase>
		   <cfcase value="11">
		   	  <cfif listcontains(project_stage, 11)>
		   	 	<cftry><cfsearch name="search_Results11" collection="pbt_expired_subcontracting" criteria="#qt#" maxrows="300">
			    <cfif search_Results11.recordcount GT 0>
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results11.key))>
				</cfif><cfcatch></cfcatch></cftry>
			  </cfif>
		  </cfcase>
		   <cfcase value="12">
		   	 <cftry><cfsearch name="search_Results1" collection="pbt_advanced_notices" criteria="#qt#" maxrows="300">
			   	<cfif search_Results1.recordcount GT 0>
			   		<cfset bidlist = listappend(bidlist,valuelist(search_results1.key))>
			 	</cfif><cfcatch></cfcatch></cftry>
			 <cftry><cfsearch name="search_Results2" collection="pbt_current_bids" criteria="#qt#" maxrows="300">
			    <cfif search_Results2.recordcount GT 0> 
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results2.key))>
				</cfif> <cfcatch></cfcatch></cftry>
		  </cfcase>
		   <cfcase value="13">
		   	 <cftry><cfsearch name="search_Results6" collection="pbt_awards" criteria="#qt#" maxrows="300">
			     <cfif search_Results6.recordcount GT 0> 
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results6.key))>
				</cfif><cfcatch></cfcatch></cftry>
		  </cfcase>
		   <cfcase value="14">
		   	 <cftry><cfsearch name="search_Results10" collection="pbt_expired_bids" criteria="#qt#" maxrows="300">
			    <cfif search_Results10.recordcount GT 0>
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results10.key))>
				</cfif><cfcatch></cfcatch></cftry>
			 <cftry><cfsearch name="search_Results11" collection="pbt_expired_subcontracting" criteria="#qt#" maxrows="300">
			    <cfif search_Results11.recordcount GT 0>
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results11.key))>
				</cfif><cfcatch></cfcatch></cftry>
			<cftry><cfsearch name="search_Results12" collection="pbt_expired_engineering" criteria="#qt#" maxrows="300">
			    <cfif search_Results12.recordcount GT 0>
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results12.key))>
				</cfif><cfcatch></cfcatch></cftry>
		  </cfcase>
		   <cfcase value="15">
		   	 <cftry><cfsearch name="search_Results12" collection="pbt_expired_engineering" criteria="#qt#" maxrows="300">
			    <cfif search_Results12.recordcount GT 0>
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results12.key))>
				</cfif><cfcatch></cfcatch></cftry>
		  </cfcase>
		</cfswitch>
	</cfloop>
	<cfelseif isdefined("qt") and qt NEQ "">
		<cfsearch name="search_Results1" collection="pbt_advanced_notices" criteria="#qt#" maxrows="300">
			<cfif search_Results1.recordcount GT 0>
			   <cfset bidlist = listappend(bidlist,valuelist(search_results1.key))>
			 </cfif>
		<cfsearch name="search_Results2" collection="pbt_current_bids" criteria="#qt#" maxrows="300">
			 <cfif search_Results2.recordcount GT 0> 
			    <cfset bidlist = listappend(bidlist,valuelist(search_results2.key))>
			</cfif> 
		<cfsearch name="search_Results3" collection="pbt_engineering" criteria="#qt#" maxrows="300">
			<cfif search_Results3.recordcount GT 0>
			    <cfset bidlist = listappend(bidlist,valuelist(search_results3.key))>
			</cfif>
		<cfsearch name="search_Results4" collection="pbt_current_subcontracting" criteria="#qt#" maxrows="300">
			<cfif search_Results4.recordcount GT 0>
			    <cfset bidlist = listappend(bidlist,valuelist(search_results4.key))>
			</cfif>
		<cfsearch name="search_Results5" collection="pbt_current_subcontracting" criteria="#qt#" maxrows="300">
			<cfif search_Results5.recordcount GT 0>
			    <cfset bidlist = listappend(bidlist,valuelist(search_results5.key))>
			</cfif>
		<cfsearch name="search_Results6" collection="pbt_awards" criteria="#qt#" maxrows="300">
			<cfif search_Results6.recordcount GT 0>
			    <cfset bidlist = listappend(bidlist,valuelist(search_results6.key))>
			</cfif>
		<cfsearch name="search_Results7" collection="pbt_lowbids" criteria="#qt#" maxrows="300">
			<cfif search_Results7.recordcount GT 0>
			    <cfset bidlist = listappend(bidlist,valuelist(search_results7.key))>
			</cfif>
		<cfsearch name="search_Results8" collection="pbt_awards_results" criteria="#qt#" maxrows="300">
			<cfif search_Results8.recordcount GT 0>
			    <cfset bidlist = listappend(bidlist,valuelist(search_results8.key))>
			</cfif>
		<cfsearch name="search_Results10" collection="pbt_expired_bids" criteria="#qt#" maxrows="300">
			<cfif search_Results10.recordcount GT 0>
			    <cfset bidlist = listappend(bidlist,valuelist(search_results10.key))>
			</cfif>
		<cfsearch name="search_Results11" collection="pbt_expired_subcontracting" criteria="#qt#" maxrows="300">
			<cfif search_Results11.recordcount GT 0>
			    <cfset bidlist = listappend(bidlist,valuelist(search_results11.key))>
			</cfif>
		<cfsearch name="search_Results12" collection="pbt_expired_engineering" criteria="#qt#" maxrows="300">
			<cfif search_Results12.recordcount GT 0>
			    <cfset bidlist = listappend(bidlist,valuelist(search_results12.key))>
			</cfif>
	</cfif>	



