<cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
		method="get_Agency_wbt"  
		returnVariable="agency_query"> 
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
		from agency_query
	</cfquery>


<!---Agencies--->
							<!-- start: RESPONSIVE TABLE PANEL -->
							<div class="panel panel-default">
								<div class="panel-heading_dark">
									<i class="fa fa-external-link-square"></i>
									Agencies
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
													<th>Agency</th>
													<th>Location</th>
													<th>Awards</th>
													<th>Activity</th>
												</tr>
											</thead>
											<tbody>
												<cfloop query="agency_query" >
													<cfoutput>
														<cfset activity = agency_query.numberofprojects*100/sumprojects.totalproj>
												<tr>
													<td>
														<cfif isdefined("agency_query.agencyname") and agency_query.agencyname NEQ "">
															<a href="#Application.rootpath#agency/?agency&supplierID=#supplierID#">
																#agency_query.agencyname#
															</a>
														<cfelse>
															#owner#
														</cfif>
													</td>
													<td>
													#agency_query.state#
													</td>
													<td>#agency_query.numberofprojects#</td>
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
											