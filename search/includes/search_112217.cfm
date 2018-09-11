
<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 
<cfquery name="getcustomerstates" datasource="#application.dataSource#">
<!---get the user states--->
select b.stateid from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  and b.packageid in (1,2,3,4,5,6,7,8,9,12) and a.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where 0=0 and  bid_users.bt_status = 1)
</cfquery>
<cfset states = "#valuelist(getcustomerstates.stateid)#">

<cfquery name="insert_usage" datasource="#application.datasource#">
INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
VALUES(#userid#,'#cfid#',#date#,8,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
</cfquery>

<cfquery name="state" datasource="#application.datasource#">
	select stateID,fullname 
	from state_master 
	where (stateid in (#states#) and countryid = 73) or stateid in (66)  
	order by fullname  
</cfquery>
 
<!---set the stages-- default to all may limit in the future--->
  	<!---cfparam name="current_notices" default="yes">
    <cfparam name="advanced_notices" default="yes">
	<cfparam name="current_bids" default="yes">
	<cfparam name="engineering_awards" default="yes">
	<cfparam name="bid_results" default="yes">
	<cfparam name="current_subcontracts" default="yes">
    <cfparam name="current_engineering" default="yes"--->
 	
 <cfquery name="checkuserpackage" datasource="#application.datasource#">
	select distinct bid_subscription_log.packageid
	from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
	where bid_users.userid =  <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER"> and bid_subscription_log.packageid in (1,2,3,4,5,6,7,8,12)  and bid_subscription_log.effective_date <= #date# and bid_subscription_log.expiration_date >= #date# and bid_subscription_log.active = 1
</cfquery> 	

<!---set the stages--->
<cfif listfind(valuelist(checkuserpackage.packageid),"1") or listfind(valuelist(checkuserpackage.packageid),"2") or listfind(valuelist(checkuserpackage.packageid),"3")>
	<cfset current_notices = "yes">
	<cfset current_bids = "yes">
	<cfset advanced_notices = "yes">
	<cfset planholders = "yes">
</cfif>
<cfif listfind(valuelist(checkuserpackage.packageid),"5") or listfind(valuelist(checkuserpackage.packageid),"6") or listfind(valuelist(checkuserpackage.packageid),"15") or listfind(valuelist(checkuserpackage.packageid),"12")  >
	<cfset bid_results = "yes">
	<cfset planholders = "yes">
</cfif>
<cfif listfind(valuelist(checkuserpackage.packageid),"4") >
	<cfset current_engineering = "yes">
	<cfset planholders = "yes">
</cfif>
<cfif listfind(valuelist(checkuserpackage.packageid),"7") >
	<cfset engineering_awards = "yes">
	<cfset planholders = "yes">
</cfif>
<cfif listfind(valuelist(checkuserpackage.packageid),"9") >
	<cfset current_subcontracts = "yes">
	<cfset current_notices = "yes">
	<cfset planholders = "yes">
</cfif>

<script src="<cfoutput>#request.rootpath#</cfoutput>assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script>
	$(function() {
		
		
		//hide default element
		//$( "#project_stage" ).hide();
		$( "#structures" ).hide();
		$( "#scopes" ).hide();
		$( "#supply" ).hide();
		$( "#qualifications" ).hide();
		$( "#filterSearch" ).hide();
		
		// set project stage toggle
		$( "#buttonSearch" ).click(function() {
			$( "#project_stageSearch" ).toggle();
			$('.minus, .add').toggle();
			return false;
		});
		
		// set structure toggle
		$( "#structure_button" ).click(function() {
			$( "#structures" ).toggle();
			$('.struct_minus, .struct_add').toggle();
			return false;
		});
		
		// set scopes toggle
		$( "#scopes_button" ).click(function() {
			$( "#scopes" ).toggle();
			$('.scopes_minus, .scopes_add').toggle();
			return false;
		});
		
		// set supply toggle
		$( "#supply_button" ).click(function() {
			$( "#supply" ).toggle();
			$('.supply_minus, .supply_add').toggle();
			return false;
		});
		
		// set qualifications toggle
		$( "#qual_button" ).click(function() {
			$( "#qualifications" ).toggle();
			$('.qual_minus, .qual_add').toggle();
			return false;
		});
		
		// set filter toggle
		$( "#filter_button" ).click(function() {
			$( "#filterSearch" ).toggle();
			$('.filter_minus, .filter_add').toggle();
			return false;
		});
	});
	</script>
	<script>
	$(function() {
		var dates = $( "#postfrom, #postto" ).datepicker({
			defaultDate: "-1w",
			maxDate: "+0",
			changeMonth: true,
			numberOfMonths: 3,
			/*beforeShowDay: $.datepicker.noWeekends,*/
			onSelect: function( selectedDate ) {
				var option = this.id == "postfrom" ? "minDate" : "maxDate",
					instance = $( this ).data( "datepicker" ),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings );
				dates.not( this ).datepicker( "option", option, date );
			}
		});
	});
	</script>
		<script>
	$(function() {
		var dates = $( "#subfrom, #subto" ).datepicker({
			defaultDate: "-1w",
			changeMonth: true,
			numberOfMonths: 3,
			onSelect: function( selectedDate ) {
				var option = this.id == "subfrom" ? "minDate" : "maxDate",
					instance = $( this ).data( "datepicker" ),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings );
				dates.not( this ).datepicker( "option", option, date );
			}
		});
	});
	</script>

 
<cfoutput>
<!---table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
    	<td width="100%" align="left" valign="top" colspan="3">
        	<div align="left">
          	<table border="0" cellpadding="0" cellspacing="0" width="100%">
            	<tr>
                	<td align="left" valign="bottom">
                  	<div class="page-header">
  						<h3>Search Paint BidTracker <small> full search</small></h3>
					</div>
                  	</td>
             	</tr>
         	</table>
            </div>
		</td>
    </tr>
</table--->
<!--end heading-->
<cfform name="searchForm" action="#cgi.script.name#?agency&results" method="post" enctype="multipart/form-data" class="form-horizontal">

</cfform>
<cfform name="searchForm" action="#request.rootpath#search/?action=sresults" method="GET" enctype="multipart/form-data" role="form" class="form-horizontal">
	<input type="hidden" name="search_history" value="1">
	<input type="hidden" name="action" value="sresults">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
              	<tr>
                   	<td height="15">                   		
                    </td>
               	</tr>
               	<tr>
                  	<td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: ##FFFFFF;">
                    	<table width="100%" cellpadding="5" cellspacing="0">
                         	<tr>
                				<td class="yellowLeft">
                               <span class="normal">
                               <span id="buttonSearch" >
                               <img src="http://app.paintbidtracker.com/images/expand.gif"  class="add" style="display:none;">
							   <img src="http://app.paintbidtracker.com/images/collapse.gif" class="minus" >
							   </span>
							   </span> Project Stage <span class="normal">(select all that apply)</span>
                                </td>
                                <td align="right" class="yellow" width="40">
                               	<cftooltip tooltip="Filter search results based on the<br> specific project stages that you'd like to view.">
                                <img src="http://app.paintbidtracker.com/images/Help.png" alt="Project Stage Filter" width="25" border="0">
								</cftooltip>
                                </td>
               				</tr>
                        </table>
						<div id="project_stageSearch" >
                        <table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<!--- packages 1,2,4,9--->
                            	<td width="1%" class="lightYellow">
                                </td>
                            	<td width="4%" class="lightYellow">
                                <cfif isdefined("current_notices")><cfinput id="selectall" name="project_stage" type="checkbox" value="12"><cfelse><cfinput name="currentContracts" type="checkbox" value="" disabled = "true"></cfif>
                                </td>
                            	<td width="28%" class="lightYellow">
                             	Current Contracts and Notices
                               	</td>
                                <td width="1%" class="lightYellow">
                                </td>
                                
								<!--- packages 5,12,7--->
                                <td width="1%" class="lightGray">
                                </td>
                              	<td width="4%" class="lightGray">
                                <cfif isdefined("bid_results") or isdefined("engineering_awards")><cfinput id="selectall_results" name="project_stage" type="checkbox" value="13"><cfelse><cfinput name="bidResults" type="checkbox" value="" disabled></cfif>
                                </td>
                            	<td width="26%" class="lightGray">
                             	 Bid Results  
                               	</td>
                                <td width="1%" class="lightGray">
                                </td>
								
								
                                <td width="1%" class="lightYellow">
                                </td>
                                <td width="3%" class="lightYellow">
                                <cfif isdefined("current_notices") or isdefined("current_subcontracts")><cfinput id="selectall_expired" name="project_stage" type="checkbox" value="14"><cfelse><cfinput name="reportArchive" type="checkbox" value="" disabled></cfif>
                                </td>
                            	<td width="28%" class="lightYellow">
                             	 Archive of Expired Reports 
                               	</td>
                                <td width="1%" class="lightYellow">
                                </td>
                        	</tr>
                        </table>
						
                        <table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td width="5%">
                                </td>
                            	<td width="4%">
                                <cfif isdefined("advanced_notices")><cfinput name="project_stage" type="checkbox" value="1" class="currentprojects"><cfelse><cfinput name="advancedNotices" type="checkbox" value="" disabled></cfif>
                                </td>
                            	<td width="24%">
                             	Advanced Notices
                               	</td>
                                <td width="1%">
                                </td>
                                <td width="5%">
                                </td>
                              	<!---td width="4%">
                               <cfif isdefined("planholders")><cfinput name="planholders" type="checkbox" value="16" class="resultsprojects"><cfelse><cfinput name="planholders" type="checkbox" value="" disabled="true"></cfif> 
                                </td>
                            	<td width="22%">
                             	Planholders/Bidders List
                               	</td>
                                <td width="1%">
                                </td>
                                <td width="5%" >
                                </td---><td width="4%">
                                <cfif isdefined("bid_results")><cfinput name="project_stage" type="checkbox" value="7" class="resultsprojects"><cfelse><cfinput name="lowBids" type="checkbox" value="" disabled></cfif>
                                </td>
                            	<td width="22%">
                             	Apparent Low Bids
                               	</td>
                                <td width="1%">
                                </td>
                                <td width="5%" >
                                </td>
                                <td width="4%">
                                <cfif isdefined("current_bids") or isdefined("advanced_notices")><cfinput id="advanced" name="project_stage" type="checkbox" value="10" class="expiredprojects"><cfelse><cfinput name="expiredBids" type="checkbox" value="" disabled></cfif>
                                </td>
                            	<td width="24%">
                             	Expired Bids
                               	</td>
                                <td width="1%">
                                </td>
                        	</tr>
                            <tr>
                            	<td width="5%">
                                </td>
                            	<td width="4%">
                                <cfif isdefined("current_bids")><cfinput  name="project_stage" type="checkbox" value="2" checked class="currentprojects"><cfelse><cfinput name="currentBids" type="checkbox" value="" disabled></cfif>
                                </td>
                            	<td width="24%">
                             	Current Bids
                               	</td>
                                <td width="1%">
                                </td>
                                <td width="5%">
                                </td>
                              	<td width="4%">
                                <cfif isdefined("bid_results")><cfinput name="project_stage" type="checkbox" value="8" class="resultsprojects"><cfelse><cfinput name="awards" type="checkbox" value="" disabled ></cfif>
                                </td>
                            	<td width="22%">
                             	Awards</td>
                                <td width="1%">
                                </td>
                                <td width="5%" >
                                </td>
                                <td width="4%">
                                <!---cfif isdefined("current_subcontracts")---><cfinput name="project_stage" type="checkbox" value="11" class="expiredprojects"><!---cfelse><cfinput name="expiredSubcontracting" type="checkbox" value="" disabled="true"></cfif--->
                                </td>
                            	<td width="24%">
                             	Expired Subcontracting
                               	</td>
                                <td width="1%">
                                </td>
                        	</tr>
                            <tr>
                            	<td width="5%">
                                </td>
                            	<td width="4%">
                                <cfif isdefined("current_engineering")><cfinput name="project_stage" type="checkbox" value="3" class="currentprojects"><cfelse><cfinput name="currentEngineering" type="checkbox" value="" disabled ></cfif>
                                </td>
                            	<td width="24%">
                             	Current Engineering &amp; Design Notices
                               	</td>
                                <td width="1%">
                                </td>
                                <td width="5%">
                                </td>
                              	<td width="4%">
                                <cfif isdefined("engineering_awards")><cfinput name="project_stage" type="checkbox" value="9" class="resultsprojects"><cfelse><cfinput name="engineeringAwards" type="checkbox" value="" disabled ></cfif>
                                </td>
                            	<td width="22%">
                             	Engineering &amp; Design Awards
                               	</td>
                                <td width="1%">
                                </td>
                                <td width="5%" >
                                </td>
                                <td width="4%">
                                <cfif isdefined("current_engineering")><cfinput name="project_stage" type="checkbox" value="15" class="expiredprojects"><cfelse><cfinput name="expiredEngineering" type="checkbox" value="" disabled></cfif>
                                </td>
                            	<td width="24%">
                             	Expired Engineering & Design
                               	</td>
                                <td width="1%">
                                </td>
                        	</tr>
                            <tr>
                            	<td width="5%">
                                </td>
                            	<td width="4%">
                                <!---cfif isdefined("current_subcontracts")---><cfinput name="project_stage" type="checkbox" value="4" class="currentprojects"><!---cfelse><cfinput name="currentSubcontracts" type="checkbox" value="" disabled="true" ></cfif--->
                                </td>
                            	<td width="24%">
                             	Current Subcontracting Notices
                               	</td>
                                <td width="1%">
                                </td>
                                <td width="5%">
                                </td>
                              	
                                <td width="4%"></td>
                           	  <td width="24%">
                           	  </td>
                                <td width="1%">
                                </td>
                        	</tr>
                            <!---tr>
                            	<td width="5%">
                                </td>
                            	<td width="4%">
                                <cfif isdefined("current_subcontracts")><cfinput name="project_stage" type="checkbox" value="5" class="currentprojects"><cfelse><cfinput name="allcurrentSubcontracting" type="checkbox" value="" disabled="true" ></cfif>
                                </td>
                            	<td width="24%">
                             	All Current Subcontracting
                               	</td>
                                <td width="1%">
                                </td>
                                <td width="4%">
                                </td>
                              	<td width="4%">
                                </td>
                            	<td width="22%">
                               	</td>
                                <td width="1%">
                                </td>
                                <td width="5%" >
                                </td>
                                <td width="4%"></td>
                           	  <td width="24%">
                           	  </td>
                                <td width="1%">
                                </td>
                        	</tr--->
                   		</table>
                        
						</div>
                        <table width="100%" cellpadding="0" cellspacing="0">
                         	<tr>
                				<td height="15">
                  				</td>
               				</tr>
                        </table>
                        <table width="100%" cellpadding="5" cellspacing="0">
                         	<tr>
                				<td class="blackLeft">
                                Filter By <span class="white">(select all that apply)</span>
                  				</td>
                                <td align="right" class="black" width="33">
                                <cftooltip tooltip="Filter search results based on region, time period, cost estimate,<br> the bid's identification number or specific search word.">
                                <img src="http://app.paintbidtracker.com/images/Help.png" alt="Sort By Filter" width="25" border="0">
								</cftooltip>
                                </td>
               				</tr>
                        </table>
                        <table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td valign="top" class="bold" width="25%">
                                Keyword Search: <br>
                                <cfinput name="qt" type="text" >
                                </td>
								<td valign="top" class="bold" width="25%">
                                Bid ID Search:<br>
								<cfinput type="text" name="bidid"  validate="integer" message="BidID must be numeric.">
                                </td>
                                <td valign="top" class="bold" width="50%">
                                Contractor Name:<br>
								<cfinput type="text" name="contractorname" size="54">
                                </td>
                        	</tr>
                            <tr>
                            	<td width="25%" valign="top" class="bold">
                                State(s): <br>
                                 <cfselect name="state" size="5" query="state" value="stateid" display="fullname" multiple selected="66"></cfselect>
                                </td>
                                <td width="25%" valign="top" class="bold">
                                Cost Estimate Range: <BR>
								<select name="amount" size="5" multiple>
									<option value="1" SELECTED>Any</option>
									<option value="2">< $100,000</option>
									<option value="3">$100,000 - $500,000</option>
									<option value="4">$500,000 - 1 million</option>
									<option value="5">Over 1 million</option>
								</select>
                                </td>
                                <td valign="top" class="bold" width="50%">
                                Post Date:<br>
                                <label for="postfrom">From</label>
								<input type="text" id="postfrom" name="postfrom"/>
								<label for="postto">to</label>
								<input type="text" id="postto" name="postto"/>
								<br>	
                                Submittal Date:<br>
                               <label for="subfrom">From</label>
								<input type="text" id="subfrom" name="subfrom"/>
								<label for="subto">to</label>
								<input type="text" id="subto" name="subto"/>
								<br /><br />
								<cfif isdefined("planholders")><cfinput name="planholders" type="checkbox" value="16"> Limit to only projects with planholders</cfif>
                                </td>
                            </tr>
                   		</table>
                        <table width="100%" cellpadding="0" cellspacing="0">
                         	<tr>
                				<td height="15">
                  				</td>
               				</tr>
                        </table>
                        <table width="100%" cellpadding="5" cellspacing="0">
                         	<tr>
                				<td class="yellowLeft">
                                Project Types <span class="normal">(select one)</span>
                  				</td>
                                <td align="right" class="yellow" width="40">
                                <cftooltip autodismissdelay="5000" tooltip="Click on the plus signs to expand and filter search results based on specific<br> structure types (industrial and commercial), scopes (construction and professional services),<br> Supply Opportunities, and Qualifications.">
                                <img src="http://app.paintbidtracker.com/images/Help.png" alt="Sort By Filter" width="25" border="0">
								</cftooltip>
                                </td>
               				</tr>
                        </table>
                        <table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td width="5%">
                                </td>
                            	<td width="4%">
                                <cfinput name="projecttype" type="radio" value="1" checked>
                                </td>
                            	<td width="24%">
                             	Verified Painting
                               	</td>
                                <td width="1%">
                                </td>
                                <td width="4%">
                                </td>
                              	<td width="4%">
                                <cfinput name="projecttype" type="radio" value="2">
                                </td>
                            	<td width="22%">
                             	Prime Painting Contracts
                               	</td>
                                <td width="1%">
                                </td>
                                <td width="5%" >
                                </td>
								<td width="4%">
                                <cfinput name="projecttype" type="radio" value="3">
                                </td>
                            	<td width="24%">
                             	All Contracts
                               	</td>
                                <!---td width="4%">
                                <cfinput name="generalContracts" type="checkbox" value="">
                                </td>
                            	<td width="24%">
                             	General Contracts
                               	</td--->
                                <td width="1%">
                                </td>
                        	</tr>
                        </table>
                        <!---new filter section--->
						   <table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td width="10">
                                </td>
                            	<td class="lightGray">
                             	<span id="filter_button" >
                               <img src="http://app.paintbidtracker.com/images/expand.gif"  class="filter_add" >
							   <img src="http://app.paintbidtracker.com/images/collapse.gif" class="filter_minus" style="display:none;">
							   </span> Search Operator <span class="normal"></span>
                               	</td>
								<td align="right" class="lightGray" width="40">
                               	<cftooltip autodismissdelay="8000" tooltip="Selecting the 'And' operator will limit search results to reports<br> with at least one of the structure types selected 
											  <br>and at least one of the scopes/supplies/qualifications selected.<br> 
											  The default 'Or' operator returns all reports that include any of the selected tags.">
                                <img src="http://app.paintbidtracker.com/images/Help.png" alt="Project Search Operator" width="25" border="0">
								</cftooltip>
                                </td>
                        	</tr>
                   		</table>
					<div id="filterSearch" >
                       <table width="90%" cellpadding="5" cellspacing="0" border="0">
                            <tr>
                            	<td width="10%">
                                </td>
                            	<td width="5%">
                            		<cfinput name="filterOP" type="radio" value="or" checked> 	
                            	</td>
                            	<td width="35%">
                             	Or (expands search results)
                               	</td>
                              	<td width="5%">
                            		<cfinput name="filterOP" type="radio" value="and" > 	
                            	</td>
                            	<td width="35%">
                             	And (narrows search results)
                               	</td>
								<td>
									
								</td>
                        	</tr>
                        </table>
						</div>
                   
                     <div id="structures2" >
						   <div class="form-group">
							<div class="col-xs-7">
							<label for="structure_field">
								Structure Type
							</label>
							<select  placeholder="Search by Structure Type" name="structures" multiple="multiple" id="structure_field" class="form-control search-select-structure">
								<cfoutput><option value="#valuelist(pull_industrial_structures.tagID)#,#valuelist(pull_commercial_structures.tagID)#" >All Structures</option></cfoutput>
								<cfoutput><option value="#valuelist(pull_industrial_structures.tagID)#" >All Industrial Structures Below</option></cfoutput>								
								<cfloop query="pull_industrial_structures">
									<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
								</cfloop>
								<cfoutput><option value="#valuelist(pull_commercial_structures.tagID)#" >All Commercial Structures Below</option></cfoutput>
								<cfloop query="pull_commercial_structures">
									<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
								</cfloop>
								<!---<cfloop query="pull_industrial_structures_all">
									<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
								</cfloop>--->
							</select>
							</div>
							</div>                   
					</div>
					
					
					
							<div class="form-group">
							<div class="col-xs-7">
							<label for="scopes_field">
								Scopes
							</label>
							<select  placeholder="Search by Scope" name="scopes" multiple="multiple" id="scopes_field" class="form-control search-select-structure">
								<cfoutput><option value="#valuelist(pull_gc_scopes.tagID)#,#valuelist(pull_professional_services.tagID)#" >All Scopes</option></cfoutput>
								<cfoutput><option value="#valuelist(pull_gc_scopes.tagID)#" >All Constuction Scopes Below</option></cfoutput>	
								<cfloop query="pull_gc_scopes">
									<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
								</cfloop>

								<cfoutput><option value="#valuelist(pull_professional_services.tagID)#" >All Prefessional Services Below</option></cfoutput>								
								<cfloop query="pull_professional_services">
									<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
								</cfloop>
							</select>
							</div>
							</div>
							<div class="form-group">
							<div class="col-xs-7">
							<label for="supply_field">
								Supply
							</label>
							<select  placeholder="Search by Supply" name="supply" multiple="multiple" id="supply_field" class="form-control search-select-structure">
								<cfloop query="pull_supply_ops">
									<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
								</cfloop>
							</select>
							</div>
							</div>
                    	   <div class="form-group">
							<div class="col-xs-7">
							<label for="services_field">
								Qualifications
							</label>
							<select  placeholder="Search by Qualification" name="services" multiple="multiple" id="services_field" class="form-control search-select-structure">
								<cfloop query="pull_qualifications">
									<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
								</cfloop>
							</select>
							</div>
							</div>
                        <!---<table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td width="10">
                                </td>
                            	<td class="lightYellow">
                               <span id="scopes_button" >
                               <img src="http://app.paintbidtracker.com/images/expand.gif"  class="scopes_add" >
							   <img src="http://app.paintbidtracker.com/images/collapse.gif" class="scopes_minus" style="display:none;">
							   </span> Scopes <span class="normal">(select all that apply) </span>
							</td>
                        	</tr>
                   		</table>--->
					<!---<div id="scopes" >
						 
                        <table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td width="5%">
                                </td>
                            	<td width="4%">
                                <cfinput id="selectall_construction" name="all_scopes" type="checkbox" value="">
                                </td>
                            	<td width="40%" class="bold">
                             	 CONSTRUCTION SCOPES 
                               	</td>
                                <td width="4%">
                                <cfinput id="selectall_services" name="all_services" type="checkbox" value="">
                                </td>
                            	<td width="40%" class="bold">
                             	 PROFESSIONAL SERVICES 
                               	</td>
                                <td width="7%">
                                </td>
                        	</tr>
                        </table>
                        <table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td width="5%">
                                </td>
                            	<td width="4%">
                                </td>
                            	<td width="40%" valign="top">
                                	<table width="100%" cellpadding="5" cellspacing="0">
                                    	<cfloop query="pull_gc_scopes">
										<cfquery name="check_subs3" datasource="#application.datasource#">
									 	 select pbt_tags.tag,pbt_tags.tagID
										 from pbt_tags
										 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 2
										 and tag_parentID <> 0
										 order by pbt_tags.tag
									 	</cfquery>    
 	
                                        <tr>
                                        	<td width="4%">
                                             <cfif listfind(variable.user_tags,tagID)><cfinput name="scopes" type="checkbox" value="#tagID#" class="constructionprojects"><cfelse><cfinput name="scopes" type="checkbox" value="#tagID#" disabled></cfif>
                                            </td>
                                            <td width="96%">
                                            <!---span class="normal">[<a href=""><strong>-</strong></a>]</span---> #tag# 
                                            </td>
                                        </tr>
										<cfif check_subs3.recordcount GT 0>
                                        <tr>
                                        	<td width="4%">
                                            </td>
                                            <td width="96%">
                                            	<table width="100%" cellpadding="5" cellspacing="0">
                                                   <cfloop query="check_subs3">
												    <tr>
                                                        <td width="4%">
                                                         <cfif listfind(variable.user_tags,tagID)><cfinput name="scopes" type="checkbox" value="#tagID#" class="constructionprojects"><cfelse><cfinput name="scopes" type="checkbox" value="#tagID#" disabled></cfif>
                                                        </td>
                                                        <td width="96%">
                                                        #tag#
                                                        </td>
                                                    </tr>
												   </cfloop>
                                                </table>
                                            </td>
                                        </tr>
										</cfif>
									</cfloop>
                                   	</table>
                               	</td>
                                <td width="4%">
                                </td>
                            	<td width="40%" valign="top">
                                	<table width="100%" cellpadding="5" cellspacing="0">
                                    	<cfloop query="pull_professional_services">
										<cfquery name="check_subs4" datasource="#application.datasource#">
									 	 select pbt_tags.tag,pbt_tags.tagID
										 from pbt_tags
										 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 4
										 and tag_parentID <> 0
										 order by pbt_tags.tag
									 	</cfquery>    
 	
                                        <tr>
                                        	<td width="4%">
                                              <cfif listfind(variable.user_tags,tagID)><cfinput name="services" type="checkbox" value="#tagID#" class="professionalprojects"><cfelse><cfinput name="services" type="checkbox" value="#tagID#" disabled></cfif>
                                            </td>
                                            <td width="96%">
                                            <!---span class="normal">[<a href=""><strong>-</strong></a>]</span---> #tag# 
                                            </td>
                                        </tr>
										<cfif check_subs4.recordcount GT 0>
                                        <tr>
                                        	<td width="4%">
                                            </td>
                                            <td width="96%">
                                            	<table width="100%" cellpadding="5" cellspacing="0">
                                                   <cfloop query="check_subs4">
												    <tr>
                                                        <td width="4%">
                                                          <cfif listfind(variable.user_tags,tagID)><cfinput name="services" type="checkbox" value="#tagID#" class="professionalprojects"><cfelse><cfinput name="services" type="checkbox" value="#tagID#" disabled></cfif>
                                                        </td>
                                                        <td width="96%">
                                                        #tag#
                                                        </td>
                                                    </tr>
												   </cfloop>
                                                </table>
                                            </td>
                                        </tr>
										</cfif>
									</cfloop>
                                   	</table>
                               	</td>
                                <td width="7%">
                                </td>
                        	</tr>
                        </table> 
						</div>
                        <table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td width="10">
                                </td>
                            	<td class="lightGray">
                             	<span id="supply_button">
                               <img src="http://app.paintbidtracker.com/images/expand.gif"  class="supply_add" >
							   <img src="http://app.paintbidtracker.com/images/collapse.gif" class="supply_minus" style="display:none;">
							   </span> Supply Opportunities <span class="normal">(select all that apply) </span>
                                </td>
                        	</tr>
                   		</table>--->
					<!---<div id="supply" >
                        <table width="100%" cellpadding="5" cellspacing="0">
                           <cfloop query="pull_supply_ops">
										<cfquery name="check_subs5" datasource="#application.datasource#">
									 	 select pbt_tags.tag,pbt_tags.tagID
										 from pbt_tags
										 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 2
										 and tag_parentID <> 0
										 order by pbt_tags.tag
									 	</cfquery>    
 										
                                        <tr>
                                        	<td width="5%">
                                			</td>
											<td width="4%">
                                              <cfif listfind(variable.user_tags,tagID)><cfinput name="supply" type="checkbox" value="#tagID#"><cfelse><cfinput name="supply" type="checkbox" value="#tagID#" disabled></cfif>
                                            </td>
                                            <td width="84%">
                                            <!---span class="normal">[<a href=""><strong>-</strong></a>]</span---> #tag# 
                                            </td>
											 <td width="7%">
                                			</td>
                                        </tr>
										<cfif check_subs5.recordcount GT 0>
                                        <tr>
                                        	<td width="4%">
                                            </td>
                                            <td width="96%">
                                            	<table width="100%" cellpadding="5" cellspacing="0">
                                                   <cfloop query="check_subs5">
												    <tr>
												    	<td width="5%">
                                						</td>
                                                        <td width="4%">
                                                          <cfif listfind(variable.user_tags,tagID)><cfinput name="supply" type="checkbox" value="#tagID#"><cfelse><cfinput name="supply" type="checkbox" value="#tagID#" disabled></cfif>
                                                        </td>
                                                        <td width="96%">
                                                        #tag#
                                                        </td>
														 <td width="7%">
                                						</td>
                                                    </tr>
												   </cfloop>
                                                </table>
                                            </td>
                                        </tr>
										</cfif>
									</cfloop>
                        </table>
						</div>--->
                       <!---- <table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td width="10">
                                </td>
                            	<td class="lightYellow">
                             	<span id="qual_button" >
                               <img src="http://app.paintbidtracker.com/images/expand.gif"  class="qual_add" >
							   <img src="http://app.paintbidtracker.com/images/collapse.gif" class="qual_minus" style="display:none;">
							   </span> Qualifications <span class="normal">(select all that apply) </span>
                               	</td>
                        	</tr>
                   		</table>--->
					<!----<div id="qualifications" >
                        <table width="100%" cellpadding="5" cellspacing="0">
                            <cfloop query="pull_qualifications">
										<cfquery name="check_subs6" datasource="#application.datasource#">
									 	 select pbt_tags.tag,pbt_tags.tagID
										 from pbt_tags
										 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
										 and tag_parentID <> 0
										 order by pbt_tags.tag
									 	</cfquery>    
 	
                                        <tr>
                                        	<td width="5%">
                                			</td>
                                        	<td width="4%">
                                              <cfif listfind(variable.user_tags,tagID)><cfinput name="qualifications" type="checkbox" value="#tagID#"><cfelse><cfinput name="qualifications" type="checkbox" value="#tagID#" disabled></cfif>
                                            </td>
                                            <td width="96%">
                                            <!---span class="normal">[<a href=""><strong>-</strong></a>]</span---> #tag# 
                                            </td>
											 <td width="7%">
                                			</td>
                                        </tr>
										<cfif check_subs6.recordcount GT 0>
                                        <tr>
                                        	<td width="4%">
                                            </td>
                                            <td width="96%">
                                            	<table width="100%" cellpadding="5" cellspacing="0">
                                                   <cfloop query="check_subs6">
												    <tr>
												    	<td width="5%">
                                						</td>
                                                        <td width="4%">
                                                        <cfif listfind(variable.user_tags,tagID)><cfinput name="qualifications" type="checkbox" value="#tagID#"><cfelse><cfinput name="qualifications" type="checkbox" value="#tagID#" disabled></cfif>
                                                        </td>
                                                        <td width="96%">
                                                        #tag#
                                                        </td>
														 <td width="7%">
                                						</td>
                                                    </tr>
												   </cfloop>
                                                </table>
                                            </td>
                                        </tr>
										</cfif>
									</cfloop>
                        </table>
						</div>--->
                        <table width="100%" cellpadding="0" cellspacing="0">
                         	<tr>
                				<td height="15">
                  				</td>
               				</tr>
                        </table>
                        <table width="100%" cellpadding="0" cellspacing="0">
                         	<tr>
                				<td height="25">
                                <input name="SEARCH" type="submit" value="SEARCH" style="background-color:##ffc303;">&nbsp;&nbsp;&nbsp;<input name="Reset" type="reset" value="Reset">
                  				</td>
               				</tr>
                        </table>
                        <table width="100%" cellpadding="0" cellspacing="0">
                         	<tr>
                				<td height="25">
                  				</td>
               				</tr>
                        </table>
                   	</td>
              	</tr>
           	</table>
		</td>
	</tr>
</table>
</cfform>
</cfoutput>