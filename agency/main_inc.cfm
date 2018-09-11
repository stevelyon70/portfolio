	<cftry>
	<cfinvoke  
		component="#Application.CFCPath#.agency_profile"  
		method="pull_company_details"  
		returnVariable="getAgency"> 
				<cfinvokeargument name="supplierID" value="#supplierID#"/> 
	</cfinvoke>
	<cfinvoke  
		component="#Application.CFCPath#.agency_profile"  
		method="get_Additional_industries"  
		returnVariable="get_Additional_industries"> 
				<cfinvokeargument name="supplierID" value="#supplierID#"/> 
	</cfinvoke>							
	<cfinvoke  
		component="#Application.CFCPath#.agency_profile"  
		method="pull_company_website"  
		returnVariable="getURL"> 
				<cfinvokeargument name="supplierID" value="#supplierID#"/> 
    </cfinvoke>			
	<cfcatch type="Any">
		<cfdump var="#application#" />
		<cfdump var="#cfcatch#" />
	</cfcatch>
	</cftry>				
							<cfoutput query="getAgency">
									<div class="row">
											<div class="col-sm-5 col-md-4 profileDetailAddInfo">
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
																<th colspan="3">Contact Information <a href="includes/createVcard.cfm?supplierID=#url.supplierID#" target="_blank"><i class="fa fa-address-card-o" aria-hidden="true"></i></a></th>
															</tr>
														</thead>
														<tbody>
															<tr>
																<td>Address</td>
																<td><cfif billingaddress NEQ "">
																		#trim(billingaddress)#, 
																	</cfif>
																	<cfif city NEQ "">
																		#city#, 
																	</cfif>
																	<cfif state NEQ "">
																		#state#
																	</cfif> 
																	<cfif zipcode NEQ "">
																		#zipcode#
																	</cfif>
																</td>
															</tr>
															<tr>
																<td>Phone:</td>
																<td><cfif phonenumber NEQ "">
																		#phonenumber#
																	<cfelse>
																		N/A
																	</cfif></td>
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
																		<a href="#websiteurl#">
																			#websiteurl#
																		</a>
																	<cfelseif isdefined("getURL.owner_url") and getURL.owner_url NEQ "">
																		<a href="#getURL.owner_url#">
																			#getURL.owner_url#
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
																		<h5><i class="fa fa-lock"></i> Plus Subscribers Only</h5>
																	<cfelse>
																		#valuelist(get_Additional_industries.tag)#
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
												
												</div>
											</div>
											<!---cfdump var="#session#"--->
											<!---revenue Metrics--->
											<!------>
											<!---cfif StructKeyExists(session,"auth.access") and session.auth.access EQ "basic"--->
											<cfif isdefined("session.auth.access") and session.auth.access EQ "basic">
												<cfinclude template="includes/metric_upgrade_inc.cfm">
											<cfelse>
												<cfinclude template="includes/metric_inc.cfm">
											</cfif>
												<hr>
												
											<!---contacts--->
											<!---cfif StructKeyExists(session,"auth.access") and session.auth.access EQ "basic"--->
											<cfif isdefined("session.auth.access") and session.auth.access EQ "basic">
												<cfinclude template="includes/contacts_upgrade_inc.cfm">
											<cfelse>
												<cfinclude template="includes/contacts_inc.cfm">
											</cfif>
											<!---cfif StructKeyExists(session,"auth.access") and session.auth.access EQ "basic"--->
											<cfif isdefined("session.auth.access") and session.auth.access EQ "basic">
												<cfinclude template="includes/engineers_upgrade_inc.cfm">
											<cfelse>
												<cfinclude template="includes/engineers_inc.cfm">
											</cfif>
											<!---cfif StructKeyExists(session,"auth.access") and session.auth.access EQ "basic"--->
											<cfif isdefined("session.auth.access") and session.auth.access EQ "basic">
												<cfinclude template="includes/contractors_upgrade_inc.cfm">
											<cfelse>
												<cfinclude template="includes/contractors_inc.cfm">
											</cfif>
											<cfif StructKeyExists(session,"packages") and (listfind(session.packages,"1") or listfind(session.packages,"2"))>
												<!---bids--->
												<cfinclude template="includes/bids_notices_inc.cfm">
											</cfif>
											<!---cfif StructKeyExists(session,"auth.access") and session.auth.access EQ "basic"--->
											<!---cfif isdefined("session.auth.access") and session.auth.access EQ "basic">
												<cfinclude template="includes/capital_spending_reports_upgrade_inc.cfm">
											<cfelseif isdefined("session.packages") and listfind(session.packages,"18")>
												<cfinclude template="includes/capital_spending_reports_inc.cfm">
											<cfelse>
												<cfinclude template="includes/capital_spending_reports_upgrade_inc.cfm">
											</cfif--->
											<!---awards include--->
											<cfinclude template="includes/awards_inc2.cfm">
											<!---
											<!---agencies--->
											<cfinclude template="includes/agencies_inc.cfm">
											--->
											<!---bid results--->
											<cfinclude template="includes/bid_results_inc.cfm">
											<!---expired bids--->
											<cfinclude template="includes/expired_bids_inc.cfm">
												
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
<cfif not listfind(session.packages, 19) and not listfind(session.packages, 20)> 
	 <!---class="restrictLink"--->
<script>
$(function() {
	$(".restrictLink").attr("href", "#");
    $('.restrictLink').on('click', function(e){
		 e.preventDefault();		
		$("#restrictModal").modal({show: true});
	})
});												
</script>												
</cfif>													