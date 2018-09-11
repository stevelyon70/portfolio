	<cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
		method="get_Awards_wbt"  
		returnVariable="awards_query"> 
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
	
					
												<!---Awards--->
												<!-- start: RESPONSIVE TABLE PANEL -->
							<div class="panel panel-default">
								<div class="panel-heading_dark">
									<i class="fa fa-external-link-square"></i>
									Awards
									<div class="panel-tools">
										<a class="btn btn-xs btn-link panel-collapse collapses" href="#">
										</a>
									
									</div>
								</div>
								<div class="panel-body">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover table-full-width" id="award_table">
											<thead>
												<tr>
													<th>
													Project Name</th>
													<th>Agency</th>
													<th>Location</th>
													<th>Contractor</th>
													<th>Date</th>
													<th>Amount</th>
												</tr>
											</thead>
											<tbody>
												<cfloop query="awards_query">
													<cfoutput>
												<tr>
													
													<td>
													<a href="#request.rootpath#leads/?bidID=#bidID#" target="_blank" class="restrictLink">
														#projectname#
													</a></td>
													<td><cfif isdefined("agencyname") and agencyname NEQ ""><a href="#Application.rootpath#agency/?agency&supplierID=#awards_query.owner_supplierID#" >#agencyname#</a><cfelse>#owner#</cfif></td>
													<td>#city#, #state#</td>
													<td>#contractor#</td>
													<td>#dateformat(paintpublishdate,"short" )#</td>
													<td>#dollarformat(amount)#</td>
												</tr>
												</cfoutput>
												</cfloop>
												<!---cfif awards_query.recordcount EQ 0>
												<tr>
													<td>No awards activity for this period.</td>
													
												</tr>
												</cfif--->
												
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<!-- end: RESPONSIVE TABLE PANEL -->
									