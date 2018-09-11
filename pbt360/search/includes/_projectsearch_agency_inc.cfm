

<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 
<cfquery name="getcustomerstates" datasource="#application.dataSource#"><!---get the user states--->
select b.stateid from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  and b.packageid in (18) and a.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where reg_users.username = '#Session.auth.username#' and bid_users.bt_status = 1)
</cfquery>
<cfif getcustomerstates.recordcount is 0 ><cflocation url="?action=92&userid=#userid#" addtoken="Yes"></cfif>
<cfset states = "#valuelist(getcustomerstates.stateid)#">

 	<cfif not isdefined("session.packages") or (isdefined("session.packages") and session.packages EQ "")>
		<cfquery name="checkuserpackage" datasource="#application.dataSource#">
		select distinct bid_subscription_log.packageid
		from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
		where bid_users.userid =  <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER"> 
		and bid_subscription_log.effective_date <= #date# 
		and bid_subscription_log.expiration_date >= #date# 
		and bid_subscription_log.active = 1
		</cfquery> 
		<cfset session.packages = valuelist(checkuserpackage.packageid)>
		<!---run another check to verify user is approved for this package--->
			<cfif not listfind(session.packages, 18)>
				<cflocation url="?action=92&userid=#userid#" addtoken="Yes">
			</cfif>
	</cfif>

<cfquery name="insert_usage" datasource="#application.dataSource#">
INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
VALUES(#userid#,'#cfid#',#date#,8,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
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
	 --and pbt_tags.tagID in (8,9,10,11,12)
	 order by pbt_tags.tag
 	</cfquery>  
 	<cfquery name="pull_agency_commercial_structures" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 2
	 and tag_parentID <> 0
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
	<script type="text/javascript" language="javascript">
	
	/*
	$(function () {
    $('#selectall').click(function () {
        $('#project_stage .currentprojects').attr('checked', this.checked);
    });
}); */
/*
$( function() {
        $( '#selectall' ).live( 'change', function() {
            $( '.currentprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
       
        });
        $( '.currentprojects' ).live( 'change', function() {
            $( '.currentprojects' ).length == $( '.currentprojects:checked' ).length ? $( '#selectall' ).prop( 'checked', 'checked' ).next() : $( '#selectall' ).prop( 'checked', '' ).next();

        });
    });

$( function() {
        $( '#selectall_results' ).live( 'change', function() {
            $( '.resultsprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.resultsprojects' ).live( 'change', function() {
            $( '.resultsprojects' ).length == $( '.resultsprojects:checked' ).length ? $( '#selectall_results' ).prop( 'checked', 'checked' ).next() : $( '#selectall_results' ).prop( 'checked', '' ).next();

        });
    });

$( function() {
        $( '#selectall_expired' ).live( 'change', function() {
            $( '.expiredprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.expiredprojects' ).live( 'change', function() {
            $( '.expiredprojects' ).length == $( '.expiredprojects:checked' ).length ? $( '#selectall_expired' ).prop( 'checked', 'checked' ).next() : $( '#selectall_expired' ).prop( 'checked', '' ).next();

        });
    });

$( function() {
        $( '#selectall_industrial' ).live( 'change', function() {
            $( '.industrialprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.industrialprojects' ).live( 'change', function() {
            $( '.industrialprojects' ).length == $( '.industrialprojects:checked' ).length ? $( '#selectall_industrial' ).prop( 'checked', 'checked' ).next() : $( '#selectall_industrial' ).prop( 'checked', '' ).next();

        });
    });

$( function() {
        $( '#selectall_commercial' ).live( 'change', function() {
            $( '.commercialprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.commercialprojects' ).live( 'change', function() {
            $( '.commercialprojects' ).length == $( '.commercialprojects:checked' ).length ? $( '#selectall_commercial' ).prop( 'checked', 'checked' ).next() : $( '#selectall_commercial' ).prop( 'checked', '' ).next();

        });
    });

$( function() {
        $( '#selectall_construction' ).live( 'change', function() {
            $( '.constructionprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.constructionprojects' ).live( 'change', function() {
            $( '.constructionprojects' ).length == $( '.constructionprojects:checked' ).length ? $( '#selectall_construction' ).prop( 'checked', 'checked' ).next() : $( '#selectall_construction' ).prop( 'checked', '' ).next();

        });
    });


$( function() {
        $( '#selectall_services' ).live( 'change', function() {
            $( '.professionalprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.professionalprojects' ).live( 'change', function() {
            $( '.professionalprojects' ).length == $( '.professionalprojects:checked' ).length ? $( '#selectall_services' ).prop( 'checked', 'checked' ).next() : $( '#selectall_services' ).prop( 'checked', '' ).next();

        });
    });*/


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
                 	<td valign="top" width="180">
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
<cfform name="searchForm" action="#cgi.script.name#?action=planningresults&userid=#userid#" method="GET" enctype="multipart/form-data">
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
			<!---
                        <table width="100%" cellpadding="0" cellspacing="0">
                         	<tr>
                				<td height="15">
                  				</td>
               				</tr>
                        </table>
                        <table width="100%" cellpadding="5" cellspacing="0">
                         	<tr>
                				<td class="yellowLeft">
                                Project Types <span class="normal">(select all that apply)</span>
                  				</td>
                                <td align="right" class="yellow" width="40">
                                <cftooltip autodismissdelay="5000" tooltip="Click on the plus signs to expand and filter search results based on specific<br> structure types (industrial and commercial), scopes (construction and professional services),<br> Supply Opportunities, and Qualifications.">
                                <img src="//app.paintbidtracker.com/images/Help.png" alt="Sort By Filter" width="25" border="0">
								</cftooltip>
                                </td>
               				</tr>
                        </table>
			--->
                        <!---table width="100%" cellpadding="5" cellspacing="0">
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
                                <td width="1%">
                                </td>
                        	</tr>
                        </table--->
			
			  <table width="100%" cellpadding="5" cellspacing="0"> 
				<tr><td>          
				<label for="structures">Structures:</label>
				<select placeholder="Select Structures" name="structures" multiple="multiple" id="structures" class="form-control search-select-structure">
				<cfoutput><option value="#valuelist(pull_agency_ind_structures.tagID)#,#valuelist(pull_agency_commercial_structures.tagID)#" >All Structures</option></cfoutput>
				<cfoutput><option value="#valuelist(pull_agency_ind_structures.tagID)#" >All Industrial Structures Below</option></cfoutput>								
				<cfloop query="pull_agency_ind_structures">
					<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
				</cfloop>
				<cfoutput><option value="#valuelist(pull_agency_commercial_structures.tagID)#" >All Commercial Structures Below</option></cfoutput>
				<cfloop query="pull_agency_commercial_structures">
					<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
				</cfloop>
				</select>
				</td></tr>
			  </table>  


			<!---
                        <table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td width="10">
                                </td>
                            	<td class="lightYellow">
                               <span class="normal">
                               <span id="structure_button" >
                               <img src="//app.paintbidtracker.com/images/expand.gif"  class="struct_add" >
							   <img src="//app.paintbidtracker.com/images/collapse.gif" class="struct_minus" style="display:none;">
							   </span>
							   </span> Structure Types <span class="normal">(select all that apply) </span>
                               	</td>
                        	</tr>
                   		</table>
                      <div id="structures" >
                        <table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td width="5%">
                                </td>
                            	<td width="4%">
                                <cfinput id="selectall_industrial" name="industrial" type="checkbox" value="">
                                </td>
                            	<td width="40%" class="bold">
                             	 INDUSTRIAL STRUCTURES  
                               	</td>
                                <td width="4%">
                                <cfinput id="selectall_commercial" name="commercial" type="checkbox" value="">
                                </td>
                            	<td width="40%" class="bold">
                             	 COMMERCIAL STRUCTURES
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
									<cfloop query="pull_agency_ind_structures">
										<cfquery name="check_subs" datasource="#application.dataSource#">
									 	 select pbt_tags.tag,pbt_tags.tagID
										 from pbt_tags
										 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
										 and tag_parentID <> 0
										 order by pbt_tags.tag
									 	</cfquery>    
 	
                                        <tr>
                                        	<td width="4%">
                                           <cfif listfind(variable.user_tags,tagID)><cfinput name="structures" type="checkbox" value="#tagID#" class="industrialprojects"><cfelse><cfinput name="structures" type="checkbox" value="#tagID#" disabled></cfif> 
                                            </td>
                                            <td width="96%">
                                            ---span class="normal">[<a href=""><strong>-</strong></a>]</span--- #tag# 
                                            </td>
                                        </tr>
										<cfif check_subs.recordcount GT 0>
                                        <tr>
                                        	<td width="4%">
                                            </td>
                                            <td width="96%">
                                            	<table width="100%" cellpadding="5" cellspacing="0">
                                                   <cfloop query="check_subs">
												    <tr>
                                                        <td width="4%">
                                                        <cfif listfind(variable.user_tags,tagID)><cfinput name="structures" type="checkbox" value="#tagID#" class="industrialprojects"><cfelse><cfinput name="structures" type="checkbox" value="#tagID#" disabled></cfif> 
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
                                    	<cfloop query="pull_agency_commercial_structures">
										<cfquery name="check_subs2" datasource="#application.dataSource#">
									 	 select pbt_tags.tag,pbt_tags.tagID
										 from pbt_tags
										 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
										 and tag_parentID <> 0
										 order by pbt_tags.tag
									 	</cfquery>    
 	
                                        <tr>
                                        	<td width="4%">
                                           <cfif listfind(variable.user_tags,tagID)><cfinput name="structures" type="checkbox" value="#tagID#" class="commercialprojects"><cfelse><cfinput name="structures" type="checkbox" value="#tagID#" disabled></cfif> 
                                          	</td>
                                            <td width="96%">
                                            ---span class="normal">[<a href=""><strong>-</strong></a>]</span--- #tag# 
                                            </td>
                                        </tr>
										<cfif check_subs2.recordcount GT 0>
                                        <tr>
                                        	<td width="4%">
                                            </td>
                                            <td width="96%">
                                            	<table width="100%" cellpadding="5" cellspacing="0">
                                                   <cfloop query="check_subs2">
												    <tr>
                                                        <td width="4%">
                                                        <cfif listfind(variable.user_tags,tagID)><cfinput name="structures" type="checkbox" value="#tagID#" class="commercialprojects"><cfelse><cfinput name="structures" type="checkbox" value="#tagID#" disabled></cfif> 
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
			--->		
					<!---new filter section--->
						   <!---table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td width="10">
                                </td>
                            	<td class="lightGray">
                             	<span id="filter_button" >
                               <img src="../images/expand.gif"  class="filter_add" >
							   <img src="../images/collapse.gif" class="filter_minus" style="display:none;">
							   </span> Search Operator <span class="normal"></span>
                               	</td>
								<td align="right" class="lightGray" width="40">
                               	<cftooltip autodismissdelay="8000" tooltip="Selecting the 'And' operator will limit search results to reports<br> with at least one of the structure types selected 
											  <br>and at least one of the scopes/supplies/qualifications selected.<br> 
											  The default 'Or' operator returns all reports that include any of the selected tags.">
                                <img src="../images/Help.png" alt="Project Search Operator" width="25" border="0">
								</cftooltip>
                                </td>
                        	</tr>
                   		</table>
					<div id="filter" >
                       <table width="90%" cellpadding="5" cellspacing="0" border="0">
                            <tr>
                            	<td width="10%">
                                </td>
                            	<td width="5%">
                            		<cfinput name="filter" type="radio" value="or" checked> 	
                            	</td>
                            	<td width="35%">
                             	Or (expands search results)
                               	</td>
                              	<td width="5%">
                            		<cfinput name="filter" type="radio" value="and" > 	
                            	</td>
                            	<td width="35%">
                             	And (narrows search results)
                               	</td>
								<td>
									
								</td>
                        	</tr>
                        </table>
						</div>
					
                        <table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td width="10">
                                </td>
                            	<td class="lightYellow">
                               <span id="scopes_button" >
                               <img src="../images/expand.gif"  class="scopes_add" >
							   <img src="../images/collapse.gif" class="scopes_minus" style="display:none;">
							   </span> Scopes <span class="normal">(select all that apply) </span>
                               	</td>
                        	</tr>
                   		</table>
					<div id="scopes" >
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
										<cfquery name="check_subs3" datasource="#application.dataSource#">
									 	 select pbt_tags.tag,pbt_tags.tagID
										 from pbt_tags
										 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 2
										 and tag_parentID <> 0
										 order by pbt_tags.tag
									 	</cfquery>    
 	
                                        <tr>
                                        	<td width="4%">
                                             <cfif listfind(variable.user_tags,tagID)><cfinput name="scopes" type="checkbox" value="#tagID#" class="constructionprojects"><cfelse><cfinput name="scopes" type="checkbox" value="#tagID#" disabled="true"></cfif>
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
                                                         <cfif listfind(variable.user_tags,tagID)><cfinput name="scopes" type="checkbox" value="#tagID#" class="constructionprojects"><cfelse><cfinput name="scopes" type="checkbox" value="#tagID#" disabled="true"></cfif>
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
										<cfquery name="check_subs4" datasource="#application.dataSource#">
									 	 select pbt_tags.tag,pbt_tags.tagID
										 from pbt_tags
										 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 4
										 and tag_parentID <> 0
										 order by pbt_tags.tag
									 	</cfquery>    
 	
                                        <tr>
                                        	<td width="4%">
                                              <cfif listfind(variable.user_tags,tagID)><cfinput name="services" type="checkbox" value="#tagID#" class="professionalprojects"><cfelse><cfinput name="services" type="checkbox" value="#tagID#" disabled="true"></cfif>
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
                                                          <cfif listfind(variable.user_tags,tagID)><cfinput name="services" type="checkbox" value="#tagID#" class="professionalprojects"><cfelse><cfinput name="services" type="checkbox" value="#tagID#" disabled="true"></cfif>
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
                               <img src="//app.paintbidtracker.com/images/expand.gif"  class="supply_add" >
							   <img src="//app.paintbidtracker.com/images/collapse.gif" class="supply_minus" style="display:none;">
							   </span> Supply Opportunities <span class="normal">(select all that apply) </span>
                                </td>
                        	</tr>
                   		</table>
					<div id="supply" >
                        <table width="100%" cellpadding="5" cellspacing="0">
                           <cfloop query="pull_supply_ops">
										<cfquery name="check_subs5" datasource="#application.dataSource#">
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
                                              <cfif listfind(variable.user_tags,tagID)><cfinput name="supply" type="checkbox" value="#tagID#"><cfelse><cfinput name="supply" type="checkbox" value="#tagID#" disabled="true"></cfif>
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
                                                          <cfif listfind(variable.user_tags,tagID)><cfinput name="supply" type="checkbox" value="#tagID#"><cfelse><cfinput name="supply" type="checkbox" value="#tagID#" disabled="true"></cfif>
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
						</div>
                        <table width="100%" cellpadding="5" cellspacing="0">
                            <tr>
                            	<td width="10">
                                </td>
                            	<td class="lightYellow">
                             	<span id="qual_button" >
                               <img src="//app.paintbidtracker.com/images/expand.gif"  class="qual_add" >
							   <img src="//app.paintbidtracker.com/images/collapse.gif" class="qual_minus" style="display:none;">
							   </span> Qualifications <span class="normal">(select all that apply) </span>
                               	</td>
                        	</tr>
                   		</table>
					<div id="qualifications" >
                        <table width="100%" cellpadding="5" cellspacing="0">
                            <cfloop query="pull_qualifications">
										<cfquery name="check_subs6" datasource="#application.dataSource#">
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
                                              <cfif listfind(variable.user_tags,tagID)><cfinput name="qualifications" type="checkbox" value="#tagID#"><cfelse><cfinput name="qualifications" type="checkbox" value="#tagID#" disabled="true"></cfif>
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
                                                        <cfif listfind(variable.user_tags,tagID)><cfinput name="qualifications" type="checkbox" value="#tagID#"><cfelse><cfinput name="qualifications" type="checkbox" value="#tagID#" disabled="true"></cfif>
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
						</div--->
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