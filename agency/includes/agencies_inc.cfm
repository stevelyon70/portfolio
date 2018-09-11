<cfinvoke  
		component="#Application.CFCPath#.agency_profile"  
		method="get_Contacts"  
		returnVariable="contacts_query"> 
				<cfinvokeargument name="supplierID" value="#supplierID#"/> 
    </cfinvoke>	
	

<!---Contacts--->
							<!-- start: RESPONSIVE TABLE PANEL -->
							<div class="panel panel-default">
								<div class="panel-heading_dark">
									<i class="fa fa-external-link-square"></i>
									Contacts
									
								</div>
								<div class="panel-body">
									<div class="table-responsive">
								         <table class="table table-striped table-bordered table-hover table-full-width" id="contactsT">
											<thead>
												<tr>
													<th>Name</th>
													<th>Phone</th>
													<th>Fax</th>
													<th>Email</th>
													<th>Type</th>
												</tr>
											</thead>
											<tbody>
												<cfloop query="contact_query" >
													<cfoutput>
												<tr>
													<td class="dataTables_empty"><a href="">
													#name#
													</a>
													</td>
												
													<td>
													#phonenumber#
													</td>
													<td>#faxnumber#</td>
													<td>#emailaddress#</td>
													<td></td>
													
													
												</tr>
												   </cfoutput>
												</cfloop>
												<cfif agency_query.recordcount EQ 0>
												<tr>
													<td colspan="4">No agency award activity for this period.</td>
													
												</tr>
												</cfif>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<!-- end: RESPONSIVE TABLE PANEL -->
											