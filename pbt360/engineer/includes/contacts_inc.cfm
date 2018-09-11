<cfinvoke  
		component="#Application.CFCPath#.engineer_profile"  
		method="pull_contacts"  
		returnVariable="getContactResults"> 
				<cfinvokeargument name="engineerID" value="#engineerID#"/> 
    </cfinvoke>	

	
<!---Contacts--->
							<!-- start: RESPONSIVE TABLE PANEL -->
							<div class="panel panel-default">
								<div class="panel-heading_dark">
									<i class="fa fa-external-link-square"></i>
									Contacts
									<div class="panel-tools">
										<a class="btn btn-xs btn-link panel-collapse collapses" href="#">
										</a>
										
									</div>
								</div>
								<div class="panel-body">
									<div class="table-responsive">
								         <table class="table table-striped table-bordered table-hover table-full-width" id="contactT">
											<thead>
												<tr>
													<th>Name</th>
													<th>Department</th>
													<th>Title</th>
													<th>Phone</th>
													<th>Fax</th>
													<th>Email</th>
													<th>Type</th>
												</tr>
											</thead>
											<tbody>
												<cfloop query="getContactResults">
													<cfoutput>
												<tr>
													<td >
													<cfif name NEQ "">
														#name#
													<cfelse>
														N/A
													</cfif>
													</td>
													<td>
														<cfif department NEQ "">
															#department#
														<cfelse>
															
														</cfif>
														</td>
													<td>
														<cfif contact_title NEQ "">
													    #contact_title#
														<cfelse>
														
														</cfif>
														</td>
													<td>#phonenumber#</td>
													<td>#faxnumber#</td>
													<td>#emailaddress#</td>
													<td>#contact_type#</td>
													
												</tr>
												   </cfoutput>
												</cfloop>
												<!---cfif getContactResults.recordcount EQ 0>
												<tr>
													<td colspan="5">No activity for this period.</td>
													
												</tr>
												</cfif--->
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<!-- end: RESPONSIVE TABLE PANEL -->
											