<CFSET todaydate = #CREATEODBCDATETIME(NOW())#>
<!---
<cfif isdefined("label") and label is "null">
	<cfset cancel = 1>
</cfif>
<cfif isdefined("saction") and not isdefined("cancel") >
	<cfquery name="check_duplicates" datasource="#application.dataSource#">
		select id
		from pbt_user_saved_searches
		where userID = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER"> and searchname = '#label#'
	</cfquery>
	<cfif check_duplicates.recordcount EQ 0>
	<cfquery name="insert_search" datasource="#application.dataSource#">
	insert into pbt_user_saved_searches
	(
	qt,
	searchname,
	datecreated,
	userid,
	amount,
	state,
	postfrom,
	postto,
	subfrom,
	subto,
	bidID,
	project_stage,
	all_scopes,
	industrial,
	commercial,
	paintingprojects,
	qualifications,
	supply,
	structures,
	scopes,
	active,
	pageaction,
	sorting,
	showall,
	generalcontracts,
	allprojects,
	all_services,
	services,
	verifiedprojects,
	contractorname,
	filter)
	values
	(
	<cfif isdefined("qt") and qt NEQ "">'#qt#'<cfelse>NULL</cfif>,
	'#label#',
	#todaydate#,
	#userid#,
	#amount#,
	'#state#',
	<cfif isdefined("postfrom") and postfrom NEQ "">'#postfrom#'<cfelse>NULL</cfif>,
	<cfif isdefined("postto") and postto NEQ "">'#postto#'<cfelse>NULL</cfif>,
	<cfif isdefined("subfrom") and subfrom NEQ "">'#subfrom#'<cfelse>NULL</cfif>,
	<cfif isdefined("subto") and subto NEQ "">'#subto#'<cfelse>NULL</cfif>,
	<cfif isdefined("bidID") and bidID NEQ "">#bidID#<cfelse>NULL</cfif>,
	<cfif isdefined("project_stage") and project_stage NEQ "">'#project_stage#'<cfelse>NULL</cfif>,
	<cfif isdefined("all_scopes") and all_scopes NEQ "">'#all_scopes#'<cfelse>NULL</cfif>,
	<cfif isdefined("industrial") and industrial NEQ "">'#industrial#'<cfelse>NULL</cfif>,
	<cfif isdefined("commercial") and commercial NEQ "">'#commercial#'<cfelse>NULL</cfif>,
	<cfif isdefined("paintingprojects") and paintingprojects NEQ "">'#paintingprojects#'<cfelse>NULL</cfif>,
	<cfif isdefined("qualifications") and qualifications NEQ "">'#qualifications#'<cfelse>NULL</cfif>,
	<cfif isdefined("supply") and supply NEQ "">'#supply#'<cfelse>NULL</cfif>,
	<cfif isdefined("structures") and structures NEQ "">'#structures#'<cfelse>NULL</cfif>,
	<cfif isdefined("scopes") and scopes NEQ "">'#scopes#'<cfelse>NULL</cfif>,
	1,
	'planningresults',
	<cfif isdefined("sorting") and sorting NEQ "">'#sorting#'<cfelse>NULL</cfif>,
	<cfif isdefined("showall") and showall NEQ "">'#showall#'<cfelse>NULL</cfif>,
	<cfif isdefined("generalcontracts") and generalcontracts NEQ "">'#generalcontracts#'<cfelse>NULL</cfif>,
	<cfif isdefined("allprojects") and allprojects NEQ "">'#allprojects#'<cfelse>NULL</cfif>,
	<cfif isdefined("all_services") and all_services NEQ "">'#all_services#'<cfelse>NULL</cfif>,
	<cfif isdefined("services") and services NEQ "">'#services#'<cfelse>NULL</cfif>,
	<cfif isdefined("verifiedprojects") and verifiedprojects NEQ "">'#verifiedprojects#'<cfelse>NULL</cfif>,
	<cfif isdefined("contractorname") and contractorname NEQ "">'#contractorname#'<cfelse>NULL</cfif>,
	<cfif isdefined("filter") and filter NEQ "">'#trim(filter)#'<cfelse>NULL</cfif>
	)
	</cfquery>
	---prompt user success---
		<script>
	$(function() {
		$( "#dialog-message-success" ).dialog({
			modal: true,
			autoOpen: true,
			buttons: {
				Ok: function() {
					$( this ).dialog( "close" );
				}
			}
		});
	});
</script>
		<div id="dialog-message-success" title="Success">
	<p>
		<span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span>
		Search saved successfully!
	</p>
	
</div>
	<cfelse>---prompt user for duplicate---
		<script>
	$(function() {
		$( "#dialog-message-duplicate" ).dialog({
			modal: true,
			autoOpen: true,
			buttons: {
				Ok: function() {
					$( this ).dialog( "close" );
				}
			}
		});
	});
</script>
		<div id="dialog-message-duplicate" title="Duplicate Search Name">
	<p>
		<span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span>
		This saved search could not be created. There is already a saved searched using this name. Please rename the search.
	</p>
	
</div>
	<cfset searchdup = 1>
	</cfif>
</cfif>
--->

<cfinclude template="user_trash.cfm">
<!---include the returned results--->
<cfinclude template="search_results_agency.cfm">

<!---pull bids that are saved for form--->
<cfquery name="pull_saved_projects" datasource="#application.dataSource#">
	select bidID 
	from bid_user_project_bids
	where userID = #userID# and active = 1
</cfquery>

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
	<cfinclude template="search_results_grid_agency_inc.cfm">
</div> 
<!---<cfinclude template="paging.cfm" />--->
<!----
<table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                      <td width="100%" align="left" valign="top" colspan="3">
                        <div align="left">
                          <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                              <td align="left" valign="bottom">
                              <h1><span style="font-size:16px">Search Capital Spending Reports</span></h1>
                              </td>
                              <td width="200" valign="top" align="right">
									<!---p>
					<!-- AddThis Button BEGIN -->
					<div class="addthis_toolbox addthis_default_style"><a class="addthis_button_email"></a> <a class="addthis_button_print"></a> <a class="addthis_button_twitter"></a> <a class="addthis_button_facebook"></a> <a class="addthis_button_linkedin"></a> <!---a class="addthis_button_stumbleupon"></a> <a class="addthis_button_digg"></a---> <span class="addthis_separator">|</span> <a class="addthis_button_expanded">More</a></div>
					<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js?pub=xa-4a843f5743c4576f"></script>
					<!-- AddThis Button END -->
               		</p--->
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
                   		<cfinclude template="search_results_criteria_inc.cfm">
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
						                  <div id="searchText">Search Results</div>
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
                    <cfinclude template="search_results_grid_agency_inc.cfm">
						
						<!---new search format--->
							<!---tr>
                            <td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: #FFFFFF;">
                             	<table width="100%"  cellspacing="1" cellpadding="3">
                             					<tr>
                                                	<td width="6%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    Trash
                                                    </td> 
                                                    <td width="18%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    Project Name
                                                    </td>
													<td width="10%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    Type
                                                    </td>
                                                    <td width="13%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    Agency
                                                    </td>
                                                    <td width="9%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    City
                                                    </td>
                                                    <td width="3%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    State
                                                    </td>
                                                    <td width="12%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    Tags
                                                    </td>
													<td width="10%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    Submittal Date
                                                    </td>
                                                    <td width="14%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    Est. Value / Project Size
                                                    </td>
                                                    <td align="center" width="3%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    <a href="">Save to Folder</a>
                                                    </td>
                                                </tr>
											<cfloop query="search_results" >	
                                            	<cfoutput> 
										
                                                <tr >
                                                	<td>
                                                    <!---span class="redNotices">Updated</span---><br />
                                                   <input name="trash" type="checkbox" value="#bidID#">
                                                    </td>
                                                    <td>
                                                    <!---cfif dateformat(paintpublishdate) gte dateformat(todaydate)>
														<span class="tex6">New Today!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and (updateid is 1 or updateid is 7 or updateid is 8 or updateid is 9) >
														<span class="tex6">Updated!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 2 >
														<span class="tex6">Submittal Change!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 3 >
														<span class="tex6">Cancelled!</span><br><cfelseif updateid is not "" and viewed is not bidid and updateid is 4 >
														<span class="tex6">Amendment</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 5 >
														<span class="tex6">Award!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 6 >
														<span class="tex6">Submittal Extended!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 14 >
														<span class="tex6">Pre-Bid Mandatory!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 15 >
														<span class="tex6">No Painting!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 19 >
														<span class="tex6">Rejected!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 20 >
														<span class="tex6">Rebid!</span><br></cfif>
														<cfif isdefined("planholders") and planholders is not ""><span class="tex6">Planholders</span><br></cfif--->
														BidID - #bidid#<br>
														<a href="?action=36&bidid=#bidid#&userid=#userid#&keywords=" style="color:##2d53ac; text-decoration:none; font-weight:bold;">
															<!---cfif viewed is not "" ><span class="tex3"><cfelse></cfif--->
														#trim(projectname)#</a> 
																
														</td>
                                                    <td>
                                                    #stage#
                                                    </td>
                                                    <td>
                                                    <cfif isdefined("ownerid") and ownerid is not ""><a href="?action=53&userid=#userid#&ownerid=#ownerid#" style="color:##2d53ac; text-decoration:none; font-weight:bold;">#owner#</a><cfelse><span class="tex">#owner#</span></cfif>
                                                    </td>
                                                    <td>
                                                    #city#
                                                    </td>
                                                    <td>
                                                    #state#
                                                    </td>
                                                    <td>
                                                  	#tags#
                                                    </td>
													 <td>
                                                    #dateformat(submittaldate, "mm/dd/yyyy")#
                                                    </td>
                                                    <td>
                                                    <cfif minimumvalue is not "" and minimumvalue is not "0" and maximumvalue is not "0"><cfset bidvalue = "#dollarformat(minimumvalue)# - #dollarformat(maximumvalue)# #valueT#">#bidvalue#<cfelseif minimumvalue is not "" and minimumvalue is not "0"><cfset bidvalue= "#dollarformat(minimumvalue)# #valueT#">#bidvalue#<cfelse><cfset bidvalue = #projectsize#>#bidvalue#</cfif></span>&nbsp;
                                                    </td>
                                                    <td align="center">
                                                    <input name="save" type="checkbox" value="">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="10">
                                                    <hr class="Gray">
                                                    </td>
                                                </tr>
											
											</cfoutput>
											</cfloop> 
										
                                            
                            	</table>
                        	</td>
                    	</tr--->
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