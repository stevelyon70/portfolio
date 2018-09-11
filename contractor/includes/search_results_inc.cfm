
	<cfoutput>
		<input type="hidden" id="contractor_name" name="contractor_name" value="#HTMLEditFormat(contractor_name)#">
		<input type="hidden" name="state_field" value="#form.state_field#">
		<input type="hidden" name="structure_field" value="<cfif isdefined('form.structure_field')>#form.structure_field#<cfelse>0</cfif>">
		<input type="hidden" name="company_type_field" value="<cfif isdefined("form.company_type_field")>#form.company_type_field#</cfif>">
		<input type="hidden" name="geo_type" value="#form.geo_type#">
	</cfoutput>
	
	<div class="row">
						<div class="col-md-12">
							<div class="panel panel-default">
								<div class="panel-heading">
									<!---<i class="fa fa-external-link-square"></i>--->
									Contractor Search Results
									
								</div>
								<div class="panel-body">
									<div id="resultsGrid" class="table-responsive" style="display: none;">
										<div class="pull-right">
										<a id="filterInfo" data-original-title="Applied Filters:" data-content="##filterData" data-placement="left" data-trigger="hover" href="javascript:history.go(-1)" class="demo btn btn-blue popovers">
											<i  class="fa fa-arrow-left"> Modify Search</i> 
										</a>			
									</div>
									<!---<div class="row">
										<div class="col-md-12 space20">
											
											<div class="btn-group pull-right">
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
											</div>
										</div>
									</div>--->
									<table class="table table-striped table-bordered table-hover table-full-width" id="contractor_table" >
													<thead>
														<tr>
															<th>ID</th>
															<th>SupplierID</th>
															<th>Company Name</th>
															<th>Contact Name</th>
															<th>Address</th>
															<th>City</th>
															<th>State</th>
															<th>Phone</th>
															<th>Email</th>
															<th>Website</th>
														</tr>
													</thead>
													<tbody>
														<tr>
															<td colspan="12" class="dataTables_empty">Loading data from server</td>
														</tr>
													</tbody>
												</table>
									</div>
									<div id="progress_bar" class="progress progress-striped active" style="display: none;" >
												<div class="progress-bar"  role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100" style="width: 80%">
													 Processing
												</div>
											</div>
								</div>
							</div>

						</div>
					</div>