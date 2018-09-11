	<cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
		method="get_Awards"  
		returnVariable="awards_query"> 
				<cfinvokeargument name="supplierID" value="#supplierID#"/> 
				<cfif isdefined("state_field") and state_field NEQ "">
				<cfinvokeargument name="state_field" value="#state_field#"/> 
				</cfif>
				<cfif isdefined("structure_field") and structure_field NEQ "">
				<cfinvokeargument name="structure_field" value="#structure_field#"/> 
				</cfif>
    </cfinvoke>	
	
	
	
	<!---div class="panel panel-white">
													<div class="panel-heading">
														<i class="clip-menu"></i>
														Awards
														<div class="panel-tools">
															<a class="btn btn-xs btn-link panel-collapse collapses" href="#">
															</a>
															<a class="btn btn-xs btn-link panel-config" href="#panel-config" data-toggle="modal">
																<i class="fa fa-wrench"></i>
															</a>
															<a class="btn btn-xs btn-link panel-refresh" href="#">
																<i class="fa fa-refresh"></i>
															</a>
															<a class="btn btn-xs btn-link panel-close" href="#">
																<i class="fa fa-times"></i>
															</a>
														</div>
													</div>
													
												<!---Awards--->
												<!--- start: RESPONSIVE TABLE PANEL --->
							
									<div class="table-responsive">
										<table class="table table-bordered table-hover" id="sample-table-1">
											<thead>
												<tr>
													<th class="center">
													<div class="checkbox-table">
														<label>
															<input type="checkbox" class="flat-grey">
														</label>
													</div></th>
													<th>Domain</th>
													<th>Price</th>
													<th>Clicks</th>
													<th><i class="fa fa-time"></i> Update </th>
													<th>Status</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td class="center">
													<div class="checkbox-table">
														<label>
															<input type="checkbox" class="flat-grey">
														</label>
													</div></td>
													<td>
													<a href="#">
														alpha.com
													</a></td>
													<td>$45</td>
													<td>3,330</td>
													<td>Feb 13</td>
													<td><span class="label label-sm label-warning">Expiring</span></td>
												</tr>
												<tr>
													<td class="center">
													<div class="checkbox-table">
														<label>
															<input type="checkbox" class="flat-grey">
														</label>
													</div></td>
													<td>
													<a href="#">
														beta.com
													</a></td>
													<td>$70</td>
													<td>3,330</td>
													<td>Jen 15</td>
													<td><span class="label label-sm label-success">Registered</span></td>
												</tr>
												<tr>
													<td class="center">
													<div class="checkbox-table">
														<label>
															<input type="checkbox" class="flat-grey">
														</label>
													</div></td>
													<td>
													<a href="#">
														gamma.com
													</a></td>
													<td>$25</td>
													<td>3,330</td>
													<td>Mar 09</td>
													<td><span class="label label-sm label-danger">Expired</span></td>
												</tr>
												<tr>
													<td class="center">
													<div class="checkbox-table">
														<label>
															<input type="checkbox" class="flat-grey">
														</label>
													</div></td>
													<td>
													<a href="#">
														delta.com
													</a></td>
													<td>$50</td>
													<td>3,330</td>
													<td>Feb 10</td>
													<td><span class="label label-sm label-inverse">Flagged</span></td>
												</tr>
												<tr>
													<td class="center">
													<div class="checkbox-table">
														<label>
															<input type="checkbox" class="flat-grey">
														</label>
													</div></td>
													<td>
													<a href="#">
														epsilon.com
													</a></td>
													<td>$35</td>
													<td>3,330</td>
													<td>Feb 18</td>
													<td><span class="label label-sm label-success">Registered</span></td>
												</tr>
												
											</tbody>
										</table>
									</div>
								
							<!-- end: RESPONSIVE TABLE PANEL -->
												
													
												</div--->
												
												<!---Awards--->
												<!-- start: RESPONSIVE TABLE PANEL -->
							<div class="panel panel-default">
								<div class="panel-heading_dark">
									<i class="fa fa-external-link-square"></i>
									Awards
									<div class="panel-tools">
										<a class="btn btn-xs btn-link panel-collapse collapses" href="#">
										</a>
										<a class="btn btn-xs btn-link panel-config" href="#panel-config" data-toggle="modal">
											<i class="fa fa-wrench"></i>
										</a>
										<a class="btn btn-xs btn-link panel-refresh" href="#">
											<i class="fa fa-refresh"></i>
										</a>
										<a class="btn btn-xs btn-link panel-expand" href="#">
											<i class="fa fa-resize-full"></i>
										</a>
										<a class="btn btn-xs btn-link panel-close" href="#">
											<i class="fa fa-times"></i>
										</a>
									</div>
								</div>
								<div class="panel-body">
									<div class="table-responsive">
										<table class="table table-bordered table-hover" id="sample-table-1">
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
												<cfloop query="awards_query" ENDROW="5">
													<cfoutput>
												<tr>
													
													<td>
													<a href="">
														#projectname#
													</a></td>
													<td>#agencyname#</td>
													<td>#city#, #state#</td>
													<td>#contractor#</td>
													<td>#dateformat(paintpublishdate,"short" )#</td>
													<td>#dollarformat(amount)#</td>
												</tr>
												</cfoutput>
												</cfloop>
												
												
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<!-- end: RESPONSIVE TABLE PANEL -->
												