<cfinvoke  
		component="#Application.CFCPath#.agency_profile"  
		method="get_Engineers"  
		returnVariable="engineers_query"> 
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
		from engineers_query
	</cfquery>


<!---Agencies--->
							<!-- start: RESPONSIVE TABLE PANEL -->
							<div class="panel panel-default">
								<div class="panel-heading_dark">
									<i class="fa fa-external-link-square"></i>
									Architect/Engineer Firms
									<div class="panel-tools">
										<a class="btn btn-xs btn-link panel-collapse collapses" href="#">
										</a>
										
									</div>
								</div>
								<div class="panel-body">
									<div class="table-responsive">
								         <table class="table table-striped table-bordered table-hover table-full-width" id="engineerT">
											<thead>
												<tr>
													<th>Company Name</th>
													<th>Location</th>
													<th>Total Projects</th>
													<th>Activity</th>
												</tr>
											</thead>
											<tbody>
												<cfloop query="engineers_query" >
													<cfoutput>
														<cfset activity = engineers_query.numberofprojects*100/sumprojects.totalproj>
												<tr>
													<td>
														<cfif isdefined("engineers_query.agencyname") and engineers_query.agencyname NEQ "">
															<a href="#Application.rootpath#engineer/?engineer&engineerID=#engineerID#">
																#engineers_query.agencyname#
															</a>
														<cfelse>
															N/A
														</cfif>
													</td>
													<td>
													#engineers_query.state#
													</td>
													<td>#engineers_query.numberofprojects#</td>
													<td>#round(activity)#%</td>
												</tr>
												   </cfoutput>
												</cfloop>
												<!---cfif agency_query.recordcount EQ 0>
												<tr>
													<td colspan="4">No agency award activity for this period.</td>
													
												</tr>
												</cfif--->
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<!-- end: RESPONSIVE TABLE PANEL -->
											