	<!---remove after dev--->
	<!---cfparam name="supplierID" default="0"--->
	<cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
		method="pull_company_details"  
		returnVariable="getContractor"> 
				<cfinvokeargument name="supplierID" value="#supplierID#"/> 
	</cfinvoke>
	<cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
		method="get_Additional_industries"  
		returnVariable="get_Additional_industries"> 
				<cfinvokeargument name="supplierID" value="#supplierID#"/> 
	</cfinvoke>	
	<cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
		method="get_CompanyType"  
		returnVariable="get_CompanyType"> 
				<cfinvokeargument name="supplierID" value="#supplierID#"/> 
	</cfinvoke>							
	<cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
		method="get_Additional_states"  
		returnVariable="get_Additional_states"> 
				<cfinvokeargument name="supplierID" value="#supplierID#"/> 
	</cfinvoke>	
	<cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
		method="get_Additional_locations"  
		returnVariable="get_Additional_locations"> 
				<cfinvokeargument name="supplierID" value="#supplierID#"/> 
	</cfinvoke>							
							<cfoutput query="getContractor">
									<div class="row">
											<div class="col-sm-5 col-md-4">
												<div class="user-left">
													<div class="center">
														<h3>#companyname#</h3>
														<cfif isdefined("logo") and logo NEQ "">
														
														<div class="fileupload fileupload-new" data-provides="fileupload">
															<div class="user-image">
																<div class="fileupload-new thumbnail"><img src="#logo#" alt="">
																</div>
															</div>
														</div>
														</cfif>
														<hr>
													</div>
													<table class="table table-condensed table-hover">
														<thead>
															<tr>
																<th colspan="3">Contact Information</th>
															</tr>
														</thead>
														<tbody>
															<tr>
																<td>Address</td>
																<td>#billingaddress#</td>
															</tr>
															<tr>
																<td>Phone:</td>
																<td>#phonenumber#</td>
																</tr>
															<tr>
																<td>Email:</td>
																<td>
																	<cfif isdefined("emailaddress") and emailaddress NEQ "">
																		<a href="mailto:#emailaddress#">
																			#emailaddress#
																		</a>
																	<cfelse>
																			N/A
																	</cfif>
																</td>
																</tr>
															<tr>
																<td>Website:</td>
																<td>
																	<cfif isdefined("websiteurl") and websiteurl NEQ "">
																	<cfset _url = websiteurl>
																	<cfset _url = replace(_url,'http://','all')>
																	<cfset _url = replace(_url,'https://','all')>
																		<a href="//#_url#" target="_blank">
																			#websiteurl#
																		</a>
																	<cfelse>
																			N/A
																	</cfif>
																</td>
																</tr>
															
														</tbody>
													</table>
										</cfoutput>				
													<table class="table table-condensed table-hover">
														<thead>
															<tr>
																<th colspan="3">Additional information</th>
															</tr>
														</thead>
														<tbody>
															<cfoutput>
															<tr>
																<td>Top 5 Structure Tags:</td>
																<td><cfif isdefined("session.auth.access") and session.auth.access EQ "basic">
																		<h5><i class="fa fa-lock"></i> Subscribers Only</h5>
																	<cfelse>
																		#valuelist(get_Additional_industries.tag)#
																	</cfif></td>
															</tr>
															<tr>
																<td>Top 5 States:</td>
																<td><cfif isdefined("session.auth.access") and session.auth.access EQ "basic">
																		<h5><i class="fa fa-lock"></i> Subscribers Only</h5>
																	<cfelse>
																		#valuelist(get_Additional_states.state)#
																	</cfif></td>
															</tr>
															<tr>
																<td>Company Type:</td>
																<td><cfif get_CompanyType.contractor_type NEQ "">
																	#valuelist(get_CompanyType.contractor_type)#
																	<cfelse>
																		N/A
																	</cfif></td>
															</tr>
																<!---tr>
																<td>First Activity</td>
																<td>2006</td>
															</tr>
															<tr>
																<td>Last Activity</td>
																<td>2014</td>
															</tr--->
															</cfoutput>
														</tbody>
													</table>
													<cfif get_Additional_locations.recordcount GT 0>
													<table class="table table-condensed table-hover">
														<thead>
															<tr>
																<th colspan="3">Additional Locations</th>
															</tr>
														</thead>
														<tbody><cfloop query="get_additional_locations">
															<tr>
																
																
																<td>
																<cfoutput>
																	<a href="?contractor&supplierID=#get_additional_locations.supplierID#">#get_additional_locations.city#, #get_additional_locations.state#</a><br>
																</cfoutput>
																</td>
																
															</tr>
															</cfloop>
														</tbody>
													</table>
													</cfif>
												</div>
											</div>
											<!---revenue Metrics--->
								
											<cfif not isdefined("session.auth.access") and session.auth.access NEQ "basic">
												<cfinclude template="includes/metric_inc.cfm">
											<cfelse>
												<cfinclude template="includes/metric_upgrade_inc.cfm">
											</cfif>
												
												<hr>
											<!---awards include--->
											<cfinclude template="includes/awards_inc2.cfm">
											
											<!---agencies--->
											<cfif not isdefined("session.auth.access") and session.auth.access NEQ "basic">
												<cfinclude template="includes/agencies_inc.cfm">
											<cfelse>
												<cfinclude template="includes/agencies_upgrade_inc.cfm">
											</cfif>
										
											
											<!---bid results--->
											<cfinclude template="includes/bid_results_inc.cfm">
												
											<!---planholders	
											<cfinclude template="includes/planholders_inc.cfm">
											--->
											
											</div>
										</div>
									</div>
									
								</div>
							</div>
						</div>
					</div>