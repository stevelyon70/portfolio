   <cfparam name="paction" default="#action#">
   <cfif isdefined("state") and state NEQ "">
		<cfquery name="getstate" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
		  select distinct fullname,state as statename,stateID
		  from state_master
		  where state_master.stateid in (#state#)
		</cfquery>
	</cfif>
	 <cfif isdefined("project_stage") and project_stage NEQ ""> 
		  <cfquery name="gettype" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
		  select distinct interface_stage
		  from pbt_interface_stages
		  where psID in (#project_stage#)
		  and psID not in (12,13,14) and active = 1
		  </cfquery>
	 </cfif>
	<cfif  len(url.tags)>
	<cfquery name="getTags" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
		  select distinct tag
		  from pbt_tags
		  where tagID in (#url.tags#)
		  </cfquery>
	<cfelse>
	 <cfif isdefined("selected_user_tags") and selected_user_tags NEQ "" and (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary EQ "")>
		 <cfquery name="getTags" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
		  select distinct tag
		  from pbt_tags
		  where tagID in (#selected_user_tags#)
		  </cfquery>
		<!---structures and scopes--->
		<cfelseif isdefined("selected_user_tags") and selected_user_tags NEQ "" and (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary NEQ "")>
		 <cfquery name="getTags" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
		  select distinct tag
		  from pbt_tags
		  where tagID in (#selected_user_tags#) or tagID in (#selected_user_tags_secondary#)
		  </cfquery>
		<!---scopes only--->
		<cfelseif (isdefined("selected_user_tags") and selected_user_tags EQ "") and (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary NEQ "")>
		 <cfquery name="getTags" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
		  select distinct tag
		  from pbt_tags
		  where tagID in (#selected_user_tags_secondary#)
		  </cfquery>		 
		<cfelse>
		<cfset getTags.recordcount = 0>
		</cfif>
	
	</cfif>
	 
<cfinclude template="search_params.cfm">
<script>
	/*var saveModal = function(){
		ColdFusion.Window.show('folderSave');
	}*/
	$(function() {
		$( "#tag_selected" ).hide();
	
			// set tags toggle
		$( "#tag_button" ).click(function() {
			$( "#tag_selected" ).toggle();
			$('.tag_minus, .tag_add').toggle();
			return false;
		});
	
	});

	
	</script>
	 <!---cfinclude template="refine_search.cfm"--->
	 
	  
	 
<cfoutput>	
<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
  <div class="panel panel-default">
    <div class="panel-heading" role="tab" id="headingOne">
      <div class="panel-title">
       
		<div class="panel-title pull-left">
		  <a role="button" data-toggle="collapse" data-parent="##accordion" href="##collapseOne" aria-expanded="true" aria-controls="collapseOne"><i class="fa fa-caret-square-o-down fa-lg" aria-hidden="true"></i></a>
          <!---#total_results.total_returned#--->#search_results.recordcount# Results Found under the following criteria:  
		</div>
		<div class="panel-title pull-right">	
	  		<cfif isDefined("url.saved") and url.saved EQ 1>
			<cftooltip 
				autoDismissDelay="5000" 
				hideDelay="250" 
				preventOverlap="true" 
				showDelay="200" 
				tooltip="Return to saved searches"> 									
					<a href="../myaccount/folders/?action=searches">
					<i class="fa fa-search fa-srch-style" aria-hidden="true"></i></a>
			</cftooltip>
			<cfelse>
			<cftooltip 
				autoDismissDelay="5000" 
				hideDelay="250" 
				preventOverlap="true" 
				showDelay="200" 
				tooltip="Refine this Search"> 									
					<a href="javascript:history.go(-1)">
					<i class="fa fa-search fa-srch-style" aria-hidden="true"></i></a>
			</cftooltip>
			</cfif>
			<cfif NOT isDefined("lst")>
				<cftooltip 
					autoDismissDelay="5000" 
					hideDelay="250" 
					preventOverlap="true" 
					showDelay="200" 
					tooltip="Save this Search"> 																											
						<i class="fa fa-floppy-o fa-srch-style saveSearch" aria-hidden="true"></i>
				</cftooltip>
			</cfif>
			<cfif search_results.recordcount GT 0>
				<cfif url.action is 'planningresults'>
					<cfset _action = 'exportAgency'/>
				<cfelse>
					<cfset _action = 'export' />
				</cfif>
				<cftooltip 
					autoDismissDelay="5000" 
					hideDelay="250" 
					preventOverlap="true" 
					showDelay="200" 
					tooltip="Export to Excel"> 										
						<a href="#request.rootpath#search/index.cfm?action=#_action#&userID=#userid#&search_variables=#replace(search_variables, 'action=', 'action2=','all')#<cfif isdefined("action") and action EQ "marketresults">&prem=1</cfif>" target="_blank">
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
		<div class="clearfix"></div>   
         
      </div>
    </div>
    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
      <div class="panel-body">
           <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                              <td align="left" valign="bottom">
                              
							  <cfif isdefined("qt") and qt is not "">
							<cfset qt= #replace(qt, '\', '', "all")#>
							Keyword: #qt#<br>
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
							<cfif isdefined("project_stage") and project_stage NEQ ""><cfdump var="#project_stage#">
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
							<cfif isdefined("selected_user_tags") and selected_user_tags NEQ "" or isdefined("selected_user_tags_secondary") and selected_user_tags_secondary NEQ "" or getTags.recordcount>
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
                              <!---<td width="200" valign="top" align="right">
								<p align="right">
									<div align="right">
										<cftooltip 
											autoDismissDelay="5000" 
											hideDelay="250" 
											preventOverlap="true" 
											showDelay="200" 
											tooltip="Refine this Search"> 									
												<a href="javascript:history.go(-#session.history#)">
												<i class="fa fa-search fa-srch-style" aria-hidden="true"></i></a>
										</cftooltip>
											
										<cftooltip 
											autoDismissDelay="5000" 
											hideDelay="250" 
											preventOverlap="true" 
											showDelay="200" 
											tooltip="Save this Search"> 																					
												<a href="" id="opener2" data-toggle="modal" data-target="##myModal">
												<i class="fa fa-floppy-o fa-srch-style" aria-hidden="true"></i></a>
										</cftooltip>
																					
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
							  </td>--->
                            </tr>
                            </table>
								  
       </div>                   
     
    </div> 
  </div>
 

</div>
<div id="progress_bar" class="progress progress-striped active loadBanner">
	<div class="progress-bar" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width: 40%;transition-duration:200ms">
		 Processing
	</div>
</div>
      
    <!-- end: TEXT FIELDS PANEL --> 	
      </cfoutput> 
<script>
	var x = 40;
	var increment = function() {
  		x = (x > 100) ? 0 : x + 1;
  		$('.progress-bar').css('width', (x % 100) + '%').attr('aria-valuenow', x);
		if(x == 95){clearInterval(myVar);}
	};
	var myVar = setInterval(increment, 200);
</script>  