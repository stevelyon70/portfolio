<cfinvoke  
		component="#Application.CFCPath#.agency_profile"  
		method="top_contractor_query_wbt"  
		returnVariable="top_contractor_query"> 
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
	<!---sum results--->
	<cfquery name="sumprojects" dbtype="query">
		select sum(numberofprojects) as totalproj
		from top_contractor_query
	</cfquery>


<!---Agencies--->
							<!-- start: RESPONSIVE TABLE PANEL -->
							<div class="panel panel-default">
								<div class="panel-heading_dark">
									<i class="fa fa-external-link-square"></i>
									Top Contractors
									<div class="panel-tools">
										<a class="btn btn-xs btn-link panel-collapse collapses" href="#">
										</a>
										
									</div>
								</div>
								<div class="panel-body">
									<div class="table-responsive">
								         <table class="table table-striped table-bordered table-hover table-full-width" id="agencyT">
											<thead>
												<tr>
													<th>Contractor Name</th>
													<th>Location</th>
													<th>Awards</th>
													<th>Activity</th>
													<th>Total Spending</th>
												</tr>
											</thead>
											<tbody>
												<cfloop query="top_contractor_query" >
													<cfinvoke  
														component="#Application.CFCPath#.agency_profile"  
														method="pull_contractor_revenue"  
														returnVariable="total_revenue"> 
															<cfinvokeargument name="supplierID" value="#supplierID#"/> 
															<cfinvokeargument name="owner_supplierID" value="#url.supplierID#"/>
													</cfinvoke>				
													<cfoutput>
														<cfset activity = top_contractor_query.numberofprojects*100/sumprojects.totalproj>
												<tr>
													<td class="dataTables_empty"><a href="#Application.rootpath#contractor/?contractor&supplierID=#top_contractor_query.supplierID#">
													#top_contractor_query.contractorname#
													</a>
													</td>
													<td>
													#top_contractor_query.state#
													</td>
													<td>#top_contractor_query.numberofprojects#</td>
													<td>#round(activity)#%</td>
													<td>#dollarformat(total_revenue.bidAmount)#</td>
												</tr>
												   </cfoutput>
												</cfloop>
												<!---cfif top_contractor_query.recordcount EQ 0>
												<tr>
													<td colspan="5">No agency award activity for this period.</td>
													
												</tr>
												</cfif--->
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<!-- end: RESPONSIVE TABLE PANEL -->
											