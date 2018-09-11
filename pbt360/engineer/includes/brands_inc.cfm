<cfinvoke  
		component="#Application.CFCPath#.engineer_profile"  
		method="get_top_Brands"  
		returnVariable="get_top_Brands"> 
				<cfinvokeargument name="engineerID" value="#engineerID#"/> 
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
		select sum(numproj) as totalproj
		from get_top_Brands
	</cfquery>


<!---Agencies--->
							<!-- start: RESPONSIVE TABLE PANEL -->
							<div class="panel panel-default">
								<div class="panel-heading_dark">
									<i class="fa fa-external-link-square"></i>
									Brand Specification
									<div class="panel-tools">
										<a class="btn btn-xs btn-link panel-collapse collapses" href="#">
										</a>
									</div>
								</div>
								<div class="panel-body">
									<div class="table-responsive">
								         <table class="table table-striped table-bordered table-hover table-full-width" id="search_resultsTable">
											<thead>
												<tr>
													<th>Brand Name</th>
													<th>Specifications</th>
													<th>Activity</th>
												</tr>
											</thead>
											<tbody>
												<cfloop query="get_top_Brands" >
														
													<cfoutput>
														<cfset activity = get_top_Brands.numproj*100/sumprojects.totalproj>
												<tr>
													<td class="dataTables_empty"><a href="#Application.rootpath#?brand_dashboard&#get_top_Brands.brands#">
													#get_top_Brands.brands#
													</a>
													</td>
													<td>#get_top_Brands.numproj#</td>
													<td>#round(activity)#%</td>
												</tr>
												   </cfoutput>
												</cfloop>
												<!---cfif get_top_Brands.recordcount EQ 0>
												<tr>
													<td colspan="3">No brand specification activity for this period.</td>
												</tr>
												</cfif--->
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<!-- end: RESPONSIVE TABLE PANEL -->
											