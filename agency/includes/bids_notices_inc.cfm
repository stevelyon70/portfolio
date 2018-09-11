<!---Bid Results--->
	<cfinvoke  
		component="#Application.CFCPath#.agency_profile"  
		method="get_bids_wbt"  
		returnVariable="bids_query"> 
				<cfinvokeargument name="supplierID" value="#supplierID#"/> 
				<cfif isdefined("state_field") and state_field NEQ "">
				<cfinvokeargument name="state_field" value="#state_field#"/> 
				</cfif>
				<cfif isdefined("structure_field") and structure_field NEQ "">
				<cfinvokeargument name="structure_field" value="#structure_field#"/> 
				</cfif>
				<cfif isdefined("form.year_field") and form.year_field NEQ "">
				<cfinvokeargument name="year_field" value="#form.year_field#"/> 
				</cfif>
				<cfif isdefined("quarter_field") and quarter_field NEQ "">
				<cfinvokeargument name="quarter_field" value="#quarter_field#"/> 
				</cfif>
    </cfinvoke>	
	


							<!-- start: RESPONSIVE TABLE PANEL -->
							<div class="panel panel-default">
								<div class="panel-heading_dark">
									<i class="fa fa-external-link-square"></i>
									Bid Notices
									<div class="panel-tools">
										<a class="btn btn-xs btn-link panel-collapse collapses" href="#">
										</a>
										
									</div>
								</div>
								<div class="panel-body">
									<div class="table-responsive">
										<table class="table table-bordered table-hover" id="bidnotices">
											<thead>
												<tr>
													<th>Project Name</th>
													<th>Architect/Engineer</th>
													<th>Location</th>
													<th>Tags</th>
													<th>Submittal Date</th>
												</tr>
											</thead>
											<tbody>
												<cfloop query="bids_query">
													<cfoutput>
												<tr>
													<td class="dataTables_empty">
													<a href="#request.rootpath#leads/?bidID=#bidID#" target="_blank" class="restrictLink">
														#projectname#
													</a></td>
													<td>#architect#</td>
													<td>#city#, #state#</td>
													<td>
                                                    <!---Removal of WBT specific tags--->
                                                    <cfset clean_tags = replaceNoCase(tags, 'WBT,', '', "all")>
                                                    <!---<cfset clean_tags = replaceNoCase(clean_tags, 'Water/Wastewater,', '', "all")>--->
                                                    <cfset clean_tags = replaceNoCase(clean_tags, 'WBT', '', "all")>
                                                    <!---<cfset clean_tags = replaceNoCase(clean_tags, 'Water/Wastewater', '', "all")>--->
                                                  	#clean_tags#													
													</td>
													<td>#dateformat(submittaldate,"short" )#</td>
												</tr>
												</cfoutput>
												</cfloop>
												<!---cfif results_query.recordcount EQ 0>
												<tr>
													<td colspan="4">No results for this period.</td>
												</tr>
												</cfif--->
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<!-- end: RESPONSIVE TABLE PANEL -->				