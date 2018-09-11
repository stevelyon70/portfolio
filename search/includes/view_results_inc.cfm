<CFSET todaydate = #CREATEODBCDATETIME(NOW())#>
<cfinclude template="user_trash.cfm">
<!---include the returned results--->
<cfinclude template="view_results.cfm">
<!---pull bids that are saved for form--->
<cfquery name="pull_saved_projects" datasource="#application.dataSource#">
	select bidID 
	from bid_user_project_bids
	where userID = #userID# and active = 1
</cfquery>
	 <cfswitch expression="#ltype#">
	 	  <cfcase value="1">
		   <cfset viewtype = "Verified Industrial Projects">
		  </cfcase>
		   <cfcase value="2">
		   <cfset viewtype = "Verified Commercial Projects">
		  </cfcase>
		   <cfcase value="3">
		   	 <cfset viewtype = "Verified Industrial & Commercial Bid Results">
		  </cfcase>
		</cfswitch>
	

<cfinclude template="recordsShowingparams.cfm">

<div class="row">
	<cfinclude template="search_results_criteria_inc.cfm">
</div> 
<div class="row">
	<div class="text-right col-sm-12">
		
	</div>	
</div> 
<!---<cfinclude template="paging.cfm" />--->
<div>
	<cfinclude template="search_results_grid_inc.cfm">
</div> 
<!---

<table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                      <td width="100%" align="left" valign="top" colspan="3">
                        <div align="left">
                          <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                              <td align="left" valign="bottom">
                              <h1><span style="font-size:16px">Project Intelligence - <cfoutput>#viewtype#</cfoutput></span></h1>
                              </td>
                              <td width="200" valign="top" align="right">
								<p align="right">
									  <!-- AddThis Button BEGIN -->
								<div class="addthis_toolbox addthis_default_style"><a class="addthis_button_email"></a>  <a class="addthis_button_print"></a> <a class="addthis_button_twitter"></a> <a class="addthis_button_facebook"></a> <a class="addthis_button_linkedin"></a> <!---a class="addthis_button_stumbleupon"></a> <a class="addthis_button_digg"></a---> <span class="addthis_separator">|</span> <a class="addthis_button_expanded">More</a></div>
								<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js?pub=xa-4a843f5743c4576f"></script>
								<!-- AddThis Button END -->
                              </p>
							  </td>
                            </tr>
                          </table>
                        </div>
                        <div align="left">
  						<table border="0" cellpadding="0" cellspacing="0" width="100%">
    						<tr>
      							<td width="100%"><hr class="PBT" noshade></td>
    						</tr>
  						</table>
						</div>
                   	</td>
                </tr>
           </table>
			<!--end heading-->
 
<table border="0" cellpadding="5" cellspacing="0" width="100%">
<tr>
	<td>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
               	<td width="100%">
                  	<div align="center">
                	<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
                        	<td height="10"></td>
                  		</tr>
						
                   		<cfoutput>
<tr>
                            
							<td>
                      		
							 <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                              <td align="left" valign="bottom">
                              <strong>#total_results.total_returned# Results Found</strong> under the following criteria:<br>
							 
                       	 	Project Stage: 
							<cfif isdefined("project_stage") and project_stage NEQ "">
								<cfloop query="gettype">
									<cfoutput>#interface_stage# <!---span class="deleteBox">[<span class="xRed">x</span>]</span---><cfif currentrow lt recordcount>,</cfif></cfoutput>
								</cfloop>
							<cfelse>
								All
							</cfif>
							<br />
							Project Types: Verified Painting
                              </td>
                              <td width="200" valign="top" align="right">
								<p align="right">
									<div align="right">
										
									<cfif search_results.recordcount GT 0> 
										<cftooltip 
										    autoDismissDelay="5000" 
										    hideDelay="250" 
										    preventOverlap="true" 
										    showDelay="200" 
										    tooltip="Export to Excel"> 
										 		<a href="../export/?userID=#userid#&ltype=#ltype#" title="Export to Excel" alt="Export to Excel" target="_blank">
													<img src="//app.paintbidtracker.com/images/icons/SaveExcel.png">
												</a>
										</cftooltip>
									</cfif>
										
									<cftooltip 
										    autoDismissDelay="5000" 
										    hideDelay="250" 
										    preventOverlap="true" 
										    showDelay="200" 
										    tooltip="Print List"> 
												<cfoutput>
												<a href="../print/?ltype=#ltype#<cfif url.showall>&showall=yes</cfif>" target="_blank">
												<img src="//app.paintbidtracker.com/images/icons/print.png">
												</a>
												</cfoutput>
									</cftooltip>
									
                   				
									</div> 
                              </p>
							  </td>
                            </tr>
                          </table>
							
							
							
                        	</td>
                     	</tr>
</cfoutput>
						
						
						
                      	<tr>
                        <td align="right">
                        <strong>Showing Records<cfoutput> #startrow# to #endrow#</cfoutput>:</strong>
						<cfif not url.showall><cfinclude template="NextNIncludeBackNext.cfm"> </cfif><cfif search_results.recordcount is not 0><cfif not url.showall><cfoutput> | <a href="?ShowAll=Yes&userid=#userid#&tempHRef=#tempHRef#">Show All</a></cfoutput></cfif></cfif>
						
						 
						</td>
						</tr>
                        	
						
						<tr>
						     <td>
						<!--New code-->
						       <table width="100%" cellpadding="2" cellspacing="0">
						          <tr>
						             <td class="yellowLeft">
						                  <div id="searchText">Results</div>
						              </td>                                                                                                 
						              <td class="yellow">
						                 <div id="sortBy" class="sortBy" align="right">
                        					<cfinclude template="sort_inc.cfm">
										</div>
						                </td>                                   
						             </tr>
						       </table>
						    </td>            
						</tr>
	
					<!---include grid results--->
                    <cfinclude template="search_results_grid_inc.cfm">
					
			
                        <tr>
                        	<td align="right"><strong>Showing Records <cfoutput>#startrow# to #endrow#</cfoutput>:</strong>
							<cfif search_results.recordcount is not 0>
								<p class="tinytext">
									<cfif not url.showall><cfinclude template="nextninclude_pagelinks.cfm"></cfif><cfif not url.showall><cfoutput> | <a href="?ShowAll=Yes&userid=#userid#&tempHRef=#tempHRef#">Show All</a></cfoutput></cfif>
								</p>
						    </cfif>   </td>
                  		</tr>
                	</table>
            	</div>
           		</td>
            </tr>
            <tr>
                <td width="100%" align="right">
                </td>
            </tr>
            <tr>
                <td>
                &nbsp;<br>
                &nbsp;
            	</td>
          	</tr>
   	      </table>
		</td>
	</tr>
</table>--->
<cfif search_results.recordcount GT 0>
	<cfinclude template="search_params.cfm">
</cfif>