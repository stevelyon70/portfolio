
<!--- create a new function to verify access --->

<cfif not listfind(session.packages, 18)>
	<div class="row">
		<div class="col-sm-3"></div>
		<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/#contact" >sales rep</a> directly.
		</div>
		<div class="col-sm-3"></div>
	</div>
<cfelse>

<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 
<cfquery name="getcustomerstates" datasource="#application.dataSource#" result="r1"><!---get the user states--->
select b.stateid from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  and b.packageid in (18) and a.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where reg_users.username = '#Session.auth.username#' and bid_users.bt_status = 1)
</cfquery>
<cfif getcustomerstates.recordcount is 0 ><cflocation url="?action=92&userid=#session.auth.userid#" addtoken="Yes"></cfif>
<cfset states = "#valuelist(getcustomerstates.stateid)#">
<cfif listcontains(session.packages, 16)>
	  <CFQUERY NAME="GET_Sub_TAGS" DATASOURCE="#application.dataSource#">
		select * 
		from pbt_user_tags
		where userID = <cfqueryPARAM value = "#session.auth.userID#" CFSQLType = "CF_SQL_INTEGER">
		and active = 1 
	  </cfquery>
	  <cfif get_sub_tags.recordcount GT 0>
		<cfset variable.user_tags = valuelist(GET_Sub_TAGS.tagID)>
	  <cfelse>
		<cflocation url="#rootpath#account/?action=104">
	  </cfif>
<cfelse>
	  <CFQUERY NAME="GET_Sub_TAGS" DATASOURCE="#application.dataSource#">
		select * 
		from pbt_tags
	  </cfquery>
	  <cfset variable.user_tags = valuelist(GET_Sub_TAGS.tagID)>
</cfif> 

<cfquery name="insert_usage" datasource="#application.dataSource#">
INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
VALUES(#session.auth.userid#,'#cfid#',#date#,8,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
</cfquery>

<cfquery name="state" datasource="#application.dataSource#">
	select stateID,fullname 
	from state_master 
	where (stateid in (#states#) and countryid = 73) or stateid in (66)   
	order by fullname  
</cfquery>
 
<!---set the stages-- default to all may limit in the future--->
 
	<cfparam name="planning" default="yes">
	
	<cfquery name="pull_agency_ind_structures" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 1 and tag_parentID = 1
		 and tag_parentID <> 0 
		 and pbt_tags.tagID in (#variable.user_tags#)
	 --and pbt_tags.tagID in (8,9,10,11,12)
	 order by pbt_tags.tag
 	</cfquery>  
 	<cfquery name="pull_agency_commercial_structures" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 2
	 	and tag_parentID <> 0
		 and pbt_tags.tagID in (#variable.user_tags#)
	 --and pbt_tags.tagID in (14,22,25)
	 order by pbt_tags.tag
 	</cfquery>  
 
<script>
	$(function() {
		
		
		//hide default element
		$( "#project_stage" ).hide();
		//$( "#structures" ).hide();
		$( "#scopes" ).hide();
		$( "#supply" ).hide();
		$( "#qualifications" ).hide();
		$( "#filter" ).hide();
		
		// set project stage toggle
		$( "#button" ).click(function() {
			$( "#project_stage" ).toggle();
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
			$( "#filter" ).toggle();
			$('.filter_minus, .filter_add').toggle();
			return false;
		});

		$('#ssearch').on('click', function(){
			$('.sectionButtons').addClass("hidden");
			$('.sProcess').removeClass("hidden");
		});

	});
	
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
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
    	<td width="100%" align="left" valign="top" colspan="3">
        	<div align="left">
          	<table border="0" cellpadding="0" cellspacing="0" width="100%">
            	<tr>
                	<td align="left" valign="bottom">
                   		<h1><span style="font-size:16px">Search Capital Spending Reports</span></h1>
                  	</td>
             	</tr>
         	</table>
            </div>
            <!--div align="left">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
    			<tr>
      				<td width="100%"><hr class="PBT" noshade></td>
    			</tr>
  			</table>
			</div-->
		</td>
    </tr>
</table>
<style>
	.sectionHead{background-color: ##D8D8D8;padding:5px;margin:0;width: 100%!important; text-indent: 15px;}
	.sectionBody{background-color: ##f5f4f4;width: 100%!important; padding: 0 15px 10px 15px;}
	.formSelect{width:100%!important;}
	.main-content .container{border:0;}
	.sectionBody .form-row {
		min-height: 25px;
		padding-top: 10px;
	}
	.sectionButtons{padding:10px 0 10px 0;}
	input {border-radius: 3px!important;min-width: 75px!important;}
</style>
<cfform name="searchForm" action="#cgi.script.name#?action=planningresults&userid=#session.auth.userid#" method="GET" enctype="multipart/form-data">
	<input type="hidden" name="search_history" value="1">
	<input type="hidden" name="action" value="planningresults">
<div class="container">
	<div class="col-xs-12 col-sm-12 col-md-6 pull-left">
		<div class="sectionHead">Filter By</div>
		<div class="sectionBody">
			
			<div class="form-row"><div class="col"><label for="structures">Structures:</label>
				<select placeholder="Select Structures" name="structures" multiple="multiple" id="structures" class="form-control search-select-structure">
				<cfoutput><option value="#valuelist(pull_agency_ind_structures.tagID)#,#valuelist(pull_agency_commercial_structures.tagID)#" >All Structures</option></cfoutput>
				<cfif listlen(valuelist(pull_agency_ind_structures.tagID))>
				<cfoutput><option value="#valuelist(pull_agency_ind_structures.tagID)#" >All Industrial Structures Below</option></cfoutput>	</cfif>						
				<cfloop query="pull_agency_ind_structures">
					<cfquery name="check_subs" datasource="#application.datasource#">
					 select pbt_tags.tag,pbt_tags.tagID
					 from pbt_tags
					 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
		 and tagID in (#variable.user_tags#)
					 and tag_parentID <> 0
					 order by pbt_tags.tag
					</cfquery>											
					<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
					<cfif check_subs.recordcount GT 0>
					   <cfloop query="check_subs">
							<cfoutput><option value="#tagID#">#tag#</option></cfoutput>
					   </cfloop>
					</cfif>	
				</cfloop>
				<cfif listlen(valuelist(pull_agency_commercial_structures.tagID))>
				<cfoutput><option value="#valuelist(pull_agency_commercial_structures.tagID)#" >All Commercial Structures Below</option></cfoutput>
				</cfif>
				<cfloop query="pull_agency_commercial_structures">
					<cfquery name="check_subs2" datasource="#application.datasource#">
					 select pbt_tags.tag,pbt_tags.tagID
					 from pbt_tags
					 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
		 and tagID in (#variable.user_tags#)
					 and tag_parentID <> 0
					 order by pbt_tags.tag
					</cfquery>											
					<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
					<cfif check_subs.recordcount GT 0>
					   <cfloop query="check_subs2">
							<cfoutput><option value="#tagID#">#tag#</option></cfoutput>
					   </cfloop>
					</cfif>	
				</cfloop>
				</select></div></div>
			<hr style="border-top: 1px solid ##8c8b8b;">
			<div class="form-row"><div class="col">Keyword Search:</div></div>
			<div class="form-row"><div class="col"><cfinput name="qt" type="text" size="30" class="form-control"></div></div>
			<div class="form-row"><div class="col">PBT Project ID Search:</div></div>
			<div class="form-row"><div class="col"><cfinput type="text" name="bidid"  validate="integer" message="project ID must be numeric." class="form-control"></div></div>
			
			<!---div class="form-row"><div class="col">Post Date:</div></div>
			<div class="form-row"><div class="col"><input type="text" id="postfrom" name="postfrom" class="form-control"/>
				<label for="postto">to</label>
				<input type="text" id="postto" name="postto" class="form-control"/></div></div--->
				

			<div class="form-row"><div class="col"><cfinput name="painting" type="checkbox" value="16"> Limit to only projects that include paint & coatings scope</div></div>

			
		</div>
	</div>
	<div class="col-xs-12 col-sm-12 col-md-6 pull-left">
		<div class="col-xs-12 col-sm-6 col-md-6 pull-left">
			<div class="sectionHead">State(s)</div>
			<div class="sectionBody">
				<cfselect name="state" size="5" query="state" value="stateid" display="fullname" multiple selected="66" class="formSelect form-control"></cfselect>
			</div>
		</div>
		<div class="col-xs-12 col-sm-6 col-md-6 pull-left">
			<div class="sectionHead">Total Project Budget</div>
			<div class="sectionBody">
				<select name="amount" size="5" multiple class="formSelect form-control">
					<option value="1" SELECTED>Any</option>
					<option value="2">< $100,000</option>
					<option value="3">$100,000 - $500,000</option>
					<option value="4">$500,000 - 1 million</option>
					<option value="5">Over 1 million</option>
				</select>
			</div>
		</div>
	 	<br><br>
		<div class="col-xs-12 col-sm-12 col-md-12 pull-left">
			<div class="sectionHead">Filter By</div>
			<div class="sectionBody">	
				<div class="form-row"><div class="col">Post Date:</div></div>
				<div class="form-row">
					<div class="col-sm-6"><input type="text" id="postfrom" name="postfrom" class="form-control" placeholder="From Date"/></div>
					<div class="col-sm-6"><input type="text" id="postto" name="postto" class="form-control" placeholder="To Date"/></div>
				</div>	

				<div class="form-row"><div class="col">Project Year:</div></div>
				<div class="form-row">
					<div class="col-sm-6"><input type="text" id="subfrom" name="subfrom" class="form-control" placeholder="From Date"/></div>
					<div class="col-sm-6"><input type="text" id="subto" name="subto" class="form-control" placeholder="To Date"/></div>				
				</div>	<br>	
			</div>	
		</div>
	</div>	
	<div class="col-md-12 pull-left">
		<div class="sectionButtons">
			<input name="SEARCH" id="ssearch" type="submit" value="Search" class="btn btn-primary">
			<!---&nbsp;&nbsp;&nbsp;
			<input name="Reset" type="reset" value="Reset" class="btn btn-default">--->
		</div>
		<div class="sProcess hidden">SEARCHING...  <img src='../../assets/images/spinner.svg'></div>
	</div>
</div>
</cfform>

<!--end heading-->
<!---
<cfform name="searchForm" action="#cgi.script.name#?action=planningresults&userid=#session.auth.userid#" method="GET" enctype="multipart/form-data">
	<input type="hidden" name="search_history" value="1">
	<input type="hidden" name="action" value="planningresults">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
             
               	<tr>
                  	<td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: ##FFFFFF;">
                    
                      
                 
                        <table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td valign="top" class="bold" width="25%">
                                Keyword Search: <br>
                                <cfinput name="qt" type="text" size="30">
                                </td>
								<td valign="top" class="bold" width="25%">
                                PBT Project ID Search:<br>
								<cfinput type="text" name="bidid"  validate="integer" message="project ID must be numeric.">
                                </td>
								<td valign="top" class="bold" width="50%">
                                Post Date:<br>
                                <label for="postfrom">From</label>
								<input type="text" id="postfrom" name="postfrom"/>
								<label for="postto">to</label>
								<input type="text" id="postto" name="postto"/>
                                </td>
                                <!---td valign="top" class="bold" width="50%">
                                Agency Name:<br>
								<cfinput type="text" name="contractorname" size="54">
                                </td--->
                        	</tr>
                            <tr>
                            	<td width="25%" valign="top" class="bold">
                                State(s): <br>
                                 <cfselect name="state" size="5" query="state" value="stateid" display="fullname" multiple selected="66"></cfselect>
                                </td>
                                <td width="25%" valign="top" class="bold">
                                Total Project Budget: <BR>
								<select name="amount" size="5" multiple>
									<option value="1" SELECTED>Any</option>
									<option value="2">< $100,000</option>
									<option value="3">$100,000 - $500,000</option>
									<option value="4">$500,000 - 1 million</option>
									<option value="5">Over 1 million</option>
								</select>
                                </td>
                                <td valign="top" class="bold" width="50%">
                                Project Year:<br>
                               <label for="subfrom">From</label>
								<input type="text" id="subfrom" name="subfrom"/>
								<label for="subto">to</label>
								<input type="text" id="subto" name="subto"/>
                                <br /><br />
                                <cfinput name="painting" type="checkbox" value="16"> Limit to only projects that include paint & coatings scope
                                </td>
								
								
                            </tr>
                   		</table>
			
			
			  <table width="100%" cellpadding="5" cellspacing="0"> 
				<tr><td>          
				<label for="structures">Structures:</label>
				<select placeholder="Select Structures" name="structures" multiple="multiple" id="structures" class="form-control search-select-structure">
				<cfoutput><option value="#valuelist(pull_agency_ind_structures.tagID)#,#valuelist(pull_agency_commercial_structures.tagID)#" >All Structures</option></cfoutput>
				<cfif listlen(valuelist(pull_agency_ind_structures.tagID))>
				<cfoutput><option value="#valuelist(pull_agency_ind_structures.tagID)#" >All Industrial Structures Below</option></cfoutput>	</cfif>							
				<cfloop query="pull_agency_ind_structures">
					<cfquery name="check_subs" datasource="#application.datasource#">
					 select pbt_tags.tag,pbt_tags.tagID
					 from pbt_tags
					 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
		 and tagID in (#variable.user_tags#)
					 and tag_parentID <> 0
					 order by pbt_tags.tag
					</cfquery>											
					<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
					<cfif check_subs.recordcount GT 0>
					   <cfloop query="check_subs">
							<cfoutput><option value="#tagID#">#tag#</option></cfoutput>
					   </cfloop>
					</cfif>	
				</cfloop>
				<cfif listlen(valuelist(pull_agency_commercial_structures.tagID))>
				<cfoutput><option value="#valuelist(pull_agency_commercial_structures.tagID)#" >All Commercial Structures Below</option></cfoutput>
				</cfif>
				<cfloop query="pull_agency_commercial_structures">
					<cfquery name="check_subs2" datasource="#application.datasource#">
					 select pbt_tags.tag,pbt_tags.tagID
					 from pbt_tags
					 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
		 and tagID in (#variable.user_tags#)
					 and tag_parentID <> 0
					 order by pbt_tags.tag
					</cfquery>											
					<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
					<cfif check_subs.recordcount GT 0>
					   <cfloop query="check_subs2">
							<cfoutput><option value="#tagID#">#tag#</option></cfoutput>
					   </cfloop>
					</cfif>	
				</cfloop>
				</select>
				</td></tr>
			  </table>  

                        <table width="100%" cellpadding="0" cellspacing="0">
                         	<tr>
                				<td height="15">
                  				</td>
               				</tr>
                        </table>
                        <table width="100%" cellpadding="0" cellspacing="0">
                         	<tr>
                				<td height="25">
                                <input name="SEARCH" type="submit" value="SEARCH" class="btn btn-primary">&nbsp;&nbsp;&nbsp;<input name="Reset" type="reset" value="Reset" class="btn btn-default">
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
--->
</cfoutput>
</cfif>