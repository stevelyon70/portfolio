
<cfparam name="contractorlist" default="">	
	<cfif isdefined("contractor_name") and contractor_name NEQ "">
		<cfsearch name="contractor_results" collection="contrak_contractor_search" criteria="#contractor_name#">
			<cfif contractor_results.recordcount GT 0>
			   <cfset contractorlist = listappend(contractorlist,valuelist(contractor_results.key))>
			 </cfif>
	</cfif>	


<!---cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
		method="pull_contractor_results"  
		returnVariable="getContractorResults"> 
				<cfif isdefined("supplierID")>
				<cfinvokeargument name="supplierID" value="#supplierID#"/> 
				</cfif>
				<cfif isdefined("contractorlist") and contractorlist NEQ "">
				<cfinvokeargument name="contractorlist" value="#contractorlist#"/> 
				</cfif>
				<cfif isdefined("state_field") and state_field NEQ "66">
				<cfinvokeargument name="state_field" value="#state_field#"/> 
				</cfif>
				<cfif isdefined("structure_field")>
				<cfinvokeargument name="structure_field" value="#structure_field#"/> 
				</cfif>
	</cfinvoke--->
	
	
	<!---cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
		method="pull_contacts_server" 
		returnVariable="qfiltered"> 
				<cfif isdefined("supplierID")>
				<cfinvokeargument name="supplierID" value="#supplierID#"/> 
				</cfif>
				<cfif isdefined("contractorlist") and contractorlist NEQ "">
				<cfinvokeargument name="contractorlist" value="#contractorlist#"/> 
				</cfif>
				<cfif isdefined("state_field") and state_field NEQ "66">
				<cfinvokeargument name="state_field" value="#state_field#"/> 
				</cfif>
				<cfif isdefined("structure_field")>
				<cfinvokeargument name="structure_field" value="#structure_field#"/> 
				</cfif>
	</cfinvoke--->

	<div class="row">
						<div class="col-md-12">
							<div class="panel panel-default">
								<div class="panel-heading">
									<i class="fa fa-external-link-square"></i>
									Contractor Search Results
									
								</div>
								<div class="panel-body">
									<div class="row">
										<div class="col-md-12 space20">
											
											<!---div class="btn-group pull-right">
												<button data-toggle="dropdown" class="btn btn-blue dropdown-toggle">
													Export <i class="fa fa-angle-down"></i>
												</button>
												<ul class="dropdown-menu dropdown-light pull-right">
													<li>
														<a href="#" class="export-pdf" data-table="#sample-table-2" data-ignoreColumn ="3,4"> Save as PDF </a>
													</li>
													<li>
														<a href="#" class="export-png" data-table="#sample-table-2" data-ignoreColumn ="3,4"> Save as PNG </a>
													</li>
													<li>
														<a href="#" class="export-csv" data-table="#sample-table-2" data-ignoreColumn ="3,4"> Save as CSV </a>
													</li>
													<li>
														<a href="#" class="export-excel" data-table="#sample-table-2" data-ignoreColumn ="3,4"> Export to Excel </a>
													</li>
												</ul>
											</div--->
										</div>
									</div>
									<div class="table-responsive">
										<!---table class="table table-striped table-bordered table-hover table-full-width" id="search_resultsTable">
											<thead>
												<tr>
													<th>Company Name</th>
													<th>Company Location</th>
													<th>Revenue</th>
													
												</tr>
											</thead>
											<tbody>
												<cfloop query="getContractorResults">
													<cfoutput>
														<!---cfinvoke  
															component="#Application.CFCPath#.contractor_profile"  
															method="get_Additional_industries"  
															returnVariable="get_Additional_industries"> 
																	<cfinvokeargument name="supplierID" value="#supplierID#"/> 
														</cfinvoke>							
														<cfinvoke  
															component="#Application.CFCPath#.contractor_profile"  
															method="get_Additional_states"  
															returnVariable="get_Additional_states"> 
																	<cfinvokeargument name="supplierID" value="#supplierID#"/> 
														</cfinvoke--->	
														
												<tr>
													<td><a href="?contractor&supplierID=#supplierID#">#trim(contractor)#</a></td>
													<td>#city#, #fullname#</td>
													<td><cfif award_amount EQ "">
															N/A
														<cfelse> 
															#dollarformat(award_amount)#
														</cfif></td>
													<!---td>#valuelist(get_Additional_industries.tag)#</td--->
												</tr>
													</cfoutput>
												
												</cfloop>
												<cfif getContractorResults.recordcount EQ 0>
												<tr>
													<td colspan="3">No results found based on your search criteria. Please <a href="javascript:history.go(-1)">modify</a> search criteria.</td>
													
												</tr>
												</cfif>
											</tbody>
										</table--->
										
<!---server side processing--->
<table class="table table-striped table-bordered table-hover table-full-width" id="contractor_table_rev">
	<thead>
		<tr>
			<th><div class="th_wrapp">SupplierID</div></th>
			<th><div class="th_wrapp">Company Name</div></th>
			<th><div class="th_wrapp">Company City</div></th>
			<th><div class="th_wrapp">Company State</div></th>
			<th><div class="th_wrapp">Revenue</div></th>	
		</tr>
	</thead>
	<tbody>
		<tr>
			<td colspan="4" class="dataTables_empty">Loading data from server</td>
		</tr>
	</tbody>
	
</table>
</div>
										
										
									</div>
								</div>
							</div>

						</div>
					</div>

			