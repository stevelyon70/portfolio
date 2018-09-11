<CFSET todaydate = #CREATEODBCDATETIME(NOW())#>

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
	filter,
	planholders)
	values
	(
	<cfif isdefined("qt") and qt NEQ "">'#qt#'<cfelse>NULL</cfif>,
	'#label#',
	#todaydate#,
	#userid#,
	'#amount#',
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
	'#action#',
	<cfif isdefined("sorting") and sorting NEQ "">'#sorting#'<cfelse>NULL</cfif>,
	<cfif isdefined("showall") and showall NEQ "">'#showall#'<cfelse>NULL</cfif>,
	<cfif isdefined("generalcontracts") and generalcontracts NEQ "">'#generalcontracts#'<cfelse>NULL</cfif>,
	<cfif isdefined("allprojects") and allprojects NEQ "">'#allprojects#'<cfelse>NULL</cfif>,
	<cfif isdefined("all_services") and all_services NEQ "">'#all_services#'<cfelse>NULL</cfif>,
	<cfif isdefined("services") and services NEQ "">'#services#'<cfelse>NULL</cfif>,
	<cfif isdefined("verifiedprojects") and verifiedprojects NEQ "">'#verifiedprojects#'<cfelse>NULL</cfif>,
	<cfif isdefined("contractorname") and contractorname NEQ "">'#contractorname#'<cfelse>NULL</cfif>,
	<cfif isdefined("filter") and filter NEQ "">'#trim(filter)#'<cfelse>NULL</cfif>,
	<cfif isdefined("planholders") and planholders NEQ "">'#planholders#'<cfelse>NULL</cfif>
	)
	</cfquery>
	<!---prompt user success--->
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
	<cfelse><!---prompt user for duplicate--->
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


<cfinclude template="user_trash.cfm">
<cftry><cfcatch></cfcatch></cftry>
<!---include the returned results--->
<cfinclude template="search_results.cfm">
<!---pull bids that are saved for form--->
<cfquery name="pull_saved_projects" datasource="#application.dataSource#">
	select bidID 
	from bid_user_project_bids
	where userID = #session.auth.userID# and active = 1
</cfquery>

<cfinclude template="recordsShowingparams.cfm">

<div class="row">
	<cfinclude template="search_results_criteria_inc.cfm">
</div> 

<!---<cfinclude template="paging.cfm" />--->
<div>
	<cfinclude template="search_results_grid_inc.cfm">
</div> 
<!---<cfinclude template="paging.cfm" />--->
<!---
<table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                      <td width="100%" align="left" valign="top" colspan="3">
                        <div align="left">
                          <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                              <td align="left" valign="bottom">
                              <h1><span style="font-size:16px">Search Paint BidTracker</span></h1>
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
</table>
--->
<cfif search_results.recordcount GT 0>
	<cfinclude template="search_params.cfm">
</cfif>