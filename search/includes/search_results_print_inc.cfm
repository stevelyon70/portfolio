<!---
Name:       print_inc.cfm
Author:     DS
Description: Printable version of search_results page
Created:     12/11/2011
--->
<CFSET todaydate = #CREATEODBCDATETIME(NOW())#>
	<cfif isdefined("packageID") and packageID NEQ "">
		<cfswitch expression="#packageID#">
		  <cfcase value="1">
			<cfset result_title = "Industrial Painting Leads and Bid Notices">
		  </cfcase>
		  <cfcase value="2">
			<cfset result_title = "Commercial Painting Leads and Bid Notices">
		  </cfcase>
		  <cfcase value="3">
			<cfset result_title = "General Construction Leads and Bid Notices">
		  </cfcase>
		  <cfcase value="4">
			<cfset result_title = "Engineering & Design Leads">
		  </cfcase>	 
		  <cfcase value="5">
			<cfset result_title = "Industrial Painting Awards and Results">
		  </cfcase>	 
		  <cfcase value="6">
			<cfset result_title = "General Construction Awards and Results">
		  </cfcase>	 
		  <cfcase value="7">
			<cfset result_title = "Engineering & Design Awards and Results">
		  </cfcase>	 
		  <cfcase value="9">
			<cfset result_title = "Subcontracting Opportunities">
		  </cfcase>		  	  	  	   	  	  
		</cfswitch>
	</cfif>

<cfinclude template="user_trash.cfm">
<!---include the returned results--->
<cfif isdefined("ltype") and ltype NEQ "">
<cfinclude template="view_results.cfm">
<cfelseif isDefined("lst") and lst NEQ "">
<cfinclude template="lastvisit_results.cfm">
<cfelse>
<cfinclude template="search_results.cfm">	
</cfif>
<!---pull bids that are saved for form--->
<cfquery name="pull_saved_projects" datasource="#application.datasource#">
	select bidID 
	from bid_user_project_bids
	where userID = #userID# and active = 1
</cfquery>

   <cfif isdefined("state") and state NEQ "">
		<cfquery name="getstate" datasource="#application.datasource#">
		  select distinct fullname,state as statename,stateID
		  from state_master
		  where state_master.stateid in (#state#)
		</cfquery>
	</cfif>
	 <cfif isdefined("project_stage") and project_stage NEQ ""> 
		  <cfquery name="gettype" datasource="#application.datasource#">
		  select distinct interface_stage
		  from pbt_interface_stages
		  where psID in (#project_stage#)
		  and psID not in (12,13,14) and active = 1
		  </cfquery>
	 </cfif>

	 <cfif isdefined("selected_user_tags") and selected_user_tags NEQ "" and (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary EQ "")>
		 <cfquery name="getTags" datasource="#application.datasource#">
		  select distinct tag
		  from pbt_tags
		  where tagID in (#selected_user_tags#)
		  </cfquery>
		<!---structures and scopes--->
		<cfelseif isdefined("selected_user_tags") and selected_user_tags NEQ "" and (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary NEQ "")>
		 <cfquery name="getTags" datasource="#application.datasource#">
		  select distinct tag
		  from pbt_tags
		  where tagID in (#selected_user_tags#) or tagID in (#selected_user_tags_secondary#)
		  </cfquery>
		<!---scopes only--->
		<cfelseif (isdefined("selected_user_tags") and selected_user_tags EQ "") and (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary NEQ "")>
		 <cfquery name="getTags" datasource="#application.datasource#">
		  select distinct tag
		  from pbt_tags
		  where tagID in (#selected_user_tags_secondary#)
		  </cfquery>
		<cfelse>
		
		</cfif>
	 
	 
	 

<cfdocument localUrl="yes" format="pdf">
	<!--- Header --->
<cfdocumentitem type="header">
<img src="../assets/images/WBT_Logo_WebHeader_Home_DoubleSize.png" width="300" alt="Water BidTracker" border="0"> Water BidTracker Search Results
</cfdocumentitem>
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
                              <strong>#search_results.recordcount# Results Found</strong> under the following criteria:<br>
							  <cfif isdefined("qt") and qt is not "">
							Keyword: "#qt#"<br>
							</cfif>
							<cfif isdefined("bidID") and bidID is not "">
							BidID: "#bidID#"<br>
							</cfif>
							States: <cfif isdefined("state") and state NEQ "">
										<cfloop query="getstate">
											<cfoutput>#fullname#
												<cfif stateID is not "66"><!---span class="deleteBox">[<span class="xRed">x</span>]</span---></cfif><cfif currentrow lt recordcount>,</cfif>&nbsp; 
											</cfoutput>
										</cfloop>
									<cfelse>
										All
								   </cfif> 
							 <br>
                       	 	Project Stage: 
							<cfif isdefined("project_stage") and project_stage NEQ "">
								<cfloop query="gettype">
									<cfoutput>#interface_stage# <!---span class="deleteBox">[<span class="xRed">x</span>]</span---><cfif currentrow lt recordcount>,</cfif></cfoutput>
								</cfloop>
							<cfelse>
								All
							</cfif>
							<cfif (isdefined("verifiedprojects") and verifiedprojects NEQ "") or (isdefined("allprojects") and allprojects NEQ "") or (isdefined("generalcontracts") and generalcontracts NEQ "") or (isdefined("paintingprojects") and paintingprojects NEQ "")>
							<br>
							Project Types: 
								<cfif (isdefined("verifiedprojects") and verifiedprojects NEQ "")>Verified Painting</cfif>
								<cfif (isdefined("allprojects") and allprojects NEQ "")>All Projects</cfif>
								<cfif (isdefined("paintingprojects") and paintingprojects NEQ "")>Painting Projects</cfif>
								<cfif (isdefined("generalcontracts") and generalcontracts NEQ "")>General Contracts</cfif>
							</cfif> 
							<cfif isdefined("postfrom") and postfrom NEQ "">
							<br>
							Post Date: #postfrom# <cfif isdefined("postto") and postto NEQ "">to #postto#</cfif>
							</cfif>
							<cfif isdefined("subfrom") and subfrom NEQ "">
							<br>
							Submittal Date: #subfrom# <cfif isdefined("subto") and subto NEQ "">to #subto#</cfif>
							</cfif>
							<br>
							<cfif isdefined("filter") and filter NEQ "">
							Search Operator: #filter#
							<br>
							</cfif>
							<cfif not isdefined("ltype")>
                            Relevant Tags: 
							<cfif (isdefined("selected_user_tags") and selected_user_tags NEQ "") or (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary NEQ "")>
								<cfloop startrow="1" endrow="5" query="getTags">
									<cfif currentrow GT 5><div id="tag_selected"></cfif><cfoutput>#tag#<!---span class="deleteBox">[<span class="xRed">x</span>]</span---><cfif currentrow lt recordcount>,</cfif></cfoutput><cfif currentrow GT 5></div></cfif>
								</cfloop>
								<div id="tag_selected">
								<cfloop startrow="6" endrow="#getTags.recordcount#" query="getTags">
									<cfoutput>#tag#<!---span class="deleteBox">[<span class="xRed">x</span>]</span---><cfif currentrow lt recordcount>,</cfif></cfoutput>
								</cfloop>
								</div>
								<cfif getTags.recordcount GT 5>...
									<span id="tag_button" >
                               			<img src="../images/expand.gif"  class="tag_add" >
							   			<img src="../images/collapse.gif" class="tag_minus" style="display:none;">
							   		</span>
								</cfif>
							<cfelse>
								All
							</cfif> 
							</cfif>
                              </td>
                              <td width="200" valign="top" align="right">
								
							  </td>
                            </tr>
                          </table>
							
							
							
                        	</td>
                     	</tr>
</cfoutput>
                      	<tr>
                        <td align="right">
                        <strong>Showing Records<cfoutput> #startrow# to #endrow#</cfoutput>:</strong>
						</td>
						</tr>
                        	
						
						<tr>
						     <td>
						<!--New code-->
						       <table width="100%" cellpadding="2" cellspacing="0">
						          <tr>
						             <td class="yellowLeft">
						                  <div id="searchText">Search Results
								<cfif isDefined("result_title")> - <cfoutput>#result_title#</cfoutput></cfif>
								</div>
						              </td>                                                                                                 
						              <td class="yellow">
						                 
						                </td>                                   
						             </tr>
						       </table>
						    </td>            
						</tr>
	
					<!---include grid results--->
                    <cfinclude template="search_results_grid_inc_print.cfm">
					
                	</table>
<!--- Footer --->
<cfdocumentitem type="footer">
<p align="center">
<cfoutput>
<font face="arial, Arial, Helvetica" size="2">
Distribution of Water BidTracker information to unauthorized users is strictly prohibited and will result in the permanent cancellation of your account.
</cfoutput>
</p>
</cfdocumentitem>
</cfdocument>