<!---Bid Results--->
	<cfinvoke  
		component="#Application.CFCPath#.agency_profile"  
		method="get_spending"  
		returnVariable="spending_query"> 
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
									Capital Spending Reports
									<div class="panel-tools">
										<a class="btn btn-xs btn-link panel-collapse collapses" href="#">
										</a>
										
									</div>
								</div>
								<div class="panel-body">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover table-full-width" id="capspendingT">
											<thead>
												<tr>
													<th>Project Name</th>
													<th>Location</th>
													<th>Tags</th>
													<th>Project Year(s)</th>
													<th>Total Budget</th>
												</tr>
											</thead>
											<tbody>
												<cfloop query="spending_query">
													<cfoutput>
												<tr>
													<td class="dataTables_empty">
													<a href="#request.rootpath#leads/?action=planning&bidID=#bidID#" target="_blank" class="restrictLink">
														#projectname#
													</a></td>
													<td>#city#, #state#</td>
													<td>#tags#</td>
													<td>#project_startdate#-#project_enddate#</td>
													<td>#dollarformat(total_budget)#</td>
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