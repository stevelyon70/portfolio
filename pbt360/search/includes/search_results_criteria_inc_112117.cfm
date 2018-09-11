   <cfparam name="paction" default="#action#">
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
	 
	 
	 
<cfinclude template="search_params.cfm">
<script>
	var saveModal = function(){
		ColdFusion.Window.show('folderSave');
	}
	$(function() {
		$( "#tag_selected" ).hide();
	
			// set tags toggle
		$( "#tag_button" ).click(function() {
			$( "#tag_selected" ).toggle();
			$('.tag_minus, .tag_add').toggle();
			return false;
		});
	});
	
	$(function() {
		
		//$("#saved-form").hide();
		/*
		$("#dialog-form").dialog({ 
			autoOpen: false,
			height: 300,
			modal: true,
			buttons: {
				"Search": function() {
						$( this ).dialog( "close" );
					
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			},
			close: function() {
				
			} 
			});
	
		
		$("#opener").click(function() {
			$("#dialog-form").dialog('open');
			// prevent the default action, e.g., following a link
			return false;
		});
		
		*/

	/*	
		// Quick View handler
	$("#opener2").click(function(){
	  //var bidID = $(this).attr('data-bidid');
		//console.log(bidID);
	  $(".modal .modal-body").html("Content loading please wait...  <img src='../assets/images/spinner.svg'>");
  	  $(".modal .modal-title").html("QUICK VIEW - BidID: " + bidID);
 
	  $("#quickview").modal("show");
	  $(".modal .modal-body").load('../leads/includes/quickview.cfm?bidid=' + bidID);
	});	
		
		$("#saved-form").dialog({ 
			autoOpen: false,
			height: 300,
			modal: true,
			buttons: {
				"Save": function() {
						$( this ).dialog( "close" );
					
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			},//
			close: function() {
				
			} 
			});
	
		
		$("#opener2").click(function() {
			$("#saved-form").dialog('open');
			// prevent the default action, e.g., following a link
			return false;
		});
		
		*/
	}
	
	);
	
	</script>
	 <!---cfinclude template="refine_search.cfm"--->
	 
	  
	 
<cfoutput>	
 
<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
  <div class="panel panel-default">
    <div class="panel-heading" role="tab" id="headingOne">
      <h4 class="panel-title">
        <a role="button" data-toggle="collapse" data-parent="##accordion" href="##collapseOne" aria-expanded="true" aria-controls="collapseOne"><i class="fa fa-caret-square-o-down" aria-hidden="true"></i></a>
          <strong>#total_results.total_returned# Results Found</strong> under the following criteria:        
      </h4>
    </div>
    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
      <div class="panel-body">
           <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                              <td align="left" valign="bottom">
                              
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
                            Relevant Tags: 
							<cfif isdefined("selected_user_tags") and selected_user_tags NEQ "" or isdefined("selected_user_tags_secondary") and selected_user_tags_secondary NEQ "">
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
                               			<img src="//app.paintbidtracker.com/images/expand.gif"  class="tag_add" >
							   			<img src="//app.paintbidtracker.com/images/collapse.gif" class="tag_minus" style="display:none;">
							   		</span>
								</cfif>
							<cfelse>
								All
							</cfif> 
                              </td>
                              <td width="200" valign="top" align="right">
								<p align="right">
									<div align="right">
											<cftooltip 
												autoDismissDelay="5000" 
												hideDelay="250" 
												preventOverlap="true" 
												showDelay="200" 
												tooltip="Refine this Search"> 									
													<a href="javascript:history.go(-1)">
													<i class="fa fa-search fa-srch-style" aria-hidden="true"></i></a>
											</cftooltip>
										<cfif (not isdefined("saved") and not isdefined("saction")) or isdefined("searchdup")>
											<cfoutput>	
												<cftooltip 
													autoDismissDelay="5000" 
													hideDelay="250" 
													preventOverlap="true" 
													showDelay="200" 
													tooltip="Save this Search"> 																					
														<a href="" id="opener2" data-toggle="modal" data-target="##myModal">
														<i class="fa fa-floppy-o fa-srch-style" aria-hidden="true"></i></a>
												</cftooltip>
											</cfoutput>
										<cfelseif ((isdefined("saction") and not isdefined("cancel")) or isdefined("saved")) and not isdefined("searchdup")>
											<cftooltip 
												autoDismissDelay="5000" 
												hideDelay="250" 
												preventOverlap="true" 
												showDelay="200" 
												tooltip="Export to Excel"> 											
													<img src="//app.paintbidtracker.com/images/icons/SaveSearch.png" alt="Saved Search">
											</cftooltip>
										<cfelseif isdefined("cancel")>
											<a href="javascript:saveSearch();">
											Save This Search
											</a>
										</cfif>
										
										<cfif search_results.recordcount GT 0>
											<cftooltip 
												autoDismissDelay="5000" 
												hideDelay="250" 
												preventOverlap="true" 
												showDelay="200" 
												tooltip="Export to Excel"> 										
													<a href="#request.rootpath#search/index.cfm?action=export&userID=#userid#&search_variables=#replace(search_variables, 'action=', 'action2=','all')#<cfif isdefined("action") and action EQ "marketresults">&prem=1</cfif>" target="_blank">
													<i class="fa fa-file-excel-o fa-srch-style" aria-hidden="true"></i></a>
											</cftooltip>
										</cfif>

										<cftooltip 
											autoDismissDelay="5000" 
											hideDelay="250" 
											preventOverlap="true" 
											showDelay="200" 
											tooltip="Print List"> 	
											<a href="#request.rootpath#search/index.cfm?action=print&search_variables=#replace(search_variables, 'action=', 'action2=','all')#<cfif isdefined("action") and action EQ "marketresults">&prem=1</cfif><cfif url.showall>&showall=yes</cfif>" target="_blank">
											<i class="fa fa-print fa-srch-style" aria-hidden="true"></i></a>
										</cftooltip>
									</div> 
                              </p>
							  </td>
                            </tr>
                          </table>
      </div>
    </div>
  </div>
 

</div>
      
    
   
        
  <!-- Modal -->
  <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Modal Header</h4>
        </div>
        <div class="modal-body">
          <p><cfinclude template="saved_search_form2.cfm"></p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
      
    </div>
  </div>
        
    <!-- end: TEXT FIELDS PANEL --> 	
      </cfoutput> 
	 
