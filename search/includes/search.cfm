




<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 

	<cfquery name="getcustomerstates" datasource="#application.datasource#">
	select distinct b.stateid 
	from bid_user_state_log a 
		inner join bid_user_supplier_state_log b on b.id = a.id
	where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  
		and a.userid in 
		(select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where 0=0 and bid_users.bt_status = 1)
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
		
		// set project stage toggle
		$( "#buttonSearch" ).click(function() {
			$( "#project_stageSearch" ).toggle();
			$('.minus, .add').toggle();
			return false;
		});		
		
		// set filter toggle
		$( "#filter_button" ).click(function() {
			$( "#filterSearch" ).toggle();
			$('.filter_minus, .filter_add').toggle();
			return false;
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
<style>
	.sectionHead{background-color: ##D8D8D8;padding:5px;margin:0;width: 100%!important; text-indent: 15px;}
	.sectionBody{background-color: ##f5f4f4;width: 100%!important; padding: 0 15px 10px 15px;min-height: 115px;}
	.formSelect{width:100%!important;}
	.main-content .container{border:0;}
	.sectionBody .form-row {
		min-height: 35px;
		padding-top: 10px;
	}
	.sectionSubRow{background-color: white;}
	.sectionBody .form-row .col{text-indent: 10px;}
	.sectionBody .form-row .sectionSubHead{text-indent: 0;}
	.sectionSubHead{font-weight:600;}
	.sectionButtons{padding:10px 0 10px 0;}
	input {border-radius: 3px!important;min-width: 75px!important;}
	.checkinput {border-radius: 3px!important;min-width: 25px!important;margin-left: 40px!important;}
</style>
<cfform name="searchForm" action="#request.rootpath#search/?action=sresults" method="GET" enctype="multipart/form-data" role="form" class="form-horizontal">
	<input type="hidden" name="search_history" value="1">
	<input type="hidden" name="action" value="sresults">
	<div class="container">
		<div class="col-xs-12 col-md-6 pull-left">
			<!--- stage --->
			<div class="col-md-12 col-xs-12 pull-left">
				<div class="sectionHead">Project Stage (Select All that Apply)</div>
				<div class="sectionBody">

					<select placeholder="Select Stage(s)" name="project_stage" multiple="multiple" id="project_stage" class="form-control search-select-structure" autocomplete="off">
							<!--option value="" disabled>Current Contracts and Notices</option-->
							<option value="1,2,3,4"  >ALL - Current Contracts and Notices</option>
							<option value="1" >Advanced Notices</option>
							<option value="2" selected>Current Bids</option>				
							<option value="3" >Current Engineering & Design Notices</option>				
							<option value="4" >Current Subcontracting Notices</option>
							<!--option value="" disabled>Bid Results</option-->
							<option value="7,8,9" >ALL - Bid Results</option>
							<option value="7" >Apparent Low Bids</option>
							<option value="8" >Awards</option>				
							<option value="9" >Engineering & Design Awards</option>		
							<!--option value="" disabled>Archive of Expired Reports</option-->
							<option value="10,11,15" >ALL - Archive of Expired Reports</option>
							<option value="10" >Expired Bids</option>
							<option value="11" >Expired Subcontracting</option>				
							<option value="15" >Expired Engineering & Design</option>									
					</select>					

					
				</div>
			</div>

			

			<!--- tags --->
			<div class="col-md-12 col-xs-12 pull-left">
				<div class="sectionHead">Filter By</div>
				<div class="sectionBody">
					<div class="form-row">
						<div class="col"><label for="structures">Structures:</label>
						<select placeholder="Select Structures" name="structures" multiple="multiple" id="structures" class="form-control search-select-structure" autocomplete="off">

						<cfif listlen(valuelist(session.model.formStructureDropOptions.tagID))>
						<cfoutput>
							<option value="#valuelist(session.model.formStructureDropOptions.tagID)#" >All Structures</option>
						</cfoutput>
						</cfif>								
						<cfloop query="session.model.formStructureDropOptions">
							<cfquery name="check_subs" datasource="#application.datasource#">
							 select pbt_tags.tag,pbt_tags.tagID
							 from pbt_tags
								 inner join site_tag_xref x on pbt_tags.tagID = x.tagID 
							 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID in (1,16)
							 and tag_parentID <> 0
								 and siteID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.siteID#" />
	 							and pbt_tags.tagID in (#session.user_tags#)
							 order by pbt_tags.tag
							</cfquery>											
							<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
							<cfif check_subs.recordcount GT 0>
							   <cfloop query="check_subs">
									<cfoutput><option value="#tagID#">#tag#</option></cfoutput>
							   </cfloop>
							</cfif>	
						</cfloop>

						</select>
						</div>
					</div>

					<div class="form-row">
						<div class="col">
						<label for="structures">Search operator:</label><br>
						<cfinput name="filter" type="radio" value="and" checked>And
						<cfinput name="filter" type="radio" value="or" >Or
							<!---<div class="col-sm-2 col-md-2 col-lg-2"><cfinput name="filter" type="radio" value="and" checked> And</div>
							<div class="col-sm-2 col-md-2 col-lg-2"><cfinput name="filter" type="radio" value="or" > Or</div>
							<div class="col-sm-8 col-md-8 col-lg-8"></div>--->
						</div>
					</div>
				</div>	
				<div class="sectionBody">				
					<div class="form-row"><div class="col"><label for="structures">Scopes:</label>		
					<select  placeholder="Search by Scope" name="scopes" multiple="multiple" id="scopes_field" class="form-control search-select-structure" autocomplete="off">
										<cfoutput><option value="#valuelist(session.model.formScopesDropOptions.tagID)#,#valuelist(session.model.formProfSvcDropOptions.tagID)#" >All Scopes</option></cfoutput>
										<cfif listlen(valuelist(session.model.formScopesDropOptions.tagID))>
											<cfoutput>
												<option value="#valuelist(session.model.formScopesDropOptions.tagID)#" >All Constuction Scopes Below</option>	
											</cfoutput>	
										</cfif>
										<cfloop query="session.model.formScopesDropOptions">
											<cftry>
											<cfquery name="check_subs3" datasource="#application.datasource#">
											 select pbt_tags.tag,pbt_tags.tagID
											 from pbt_tags
		 inner join site_tag_xref x on pbt_tags.tagID = x.tagID 
											 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID in (1,16)
												 and tag_parentID <> 0
		 and siteID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.siteID#" />
	 											and pbt_tags.tagID in (#session.user_tags#)
											 order by pbt_tags.tag
											</cfquery>								
											<cfcatch><cfset check_subs3.recordcount =0/></cfcatch></cftry>
											<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
											<cfif check_subs3.recordcount GT 0>
											   <cfloop query="check_subs3">
													<cfoutput><option value="#tagID#">#tag#</option></cfoutput>
											   </cfloop>
											</cfif>										
										</cfloop>
										<cfif listlen(valuelist(session.model.formProfSvcDropOptions.tagID))>
										<cfoutput><option value="#valuelist(session.model.formProfSvcDropOptions.tagID)#" >All Professional Services Below</option></cfoutput>
										</cfif>								
										<cfloop query="session.model.formProfSvcDropOptions">
											<cfquery name="check_subs4" datasource="#application.datasource#">
											 select pbt_tags.tag,pbt_tags.tagID
											 from pbt_tags
		 inner join site_tag_xref x on pbt_tags.tagID = x.tagID 
											 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID in (1,16)
												 and tag_parentID <> 0
		 and siteID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.siteID#" />
	 											and pbt_tags.tagID in (#session.user_tags#)
											 order by pbt_tags.tag
											</cfquery>								
											<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
											<cfif check_subs4.recordcount GT 0>
											   <cfloop query="check_subs4">
													<cfoutput><option value="#tagID#">#tag#</option></cfoutput>
											   </cfloop>
											</cfif>										
										</cfloop>
									</select>
					</div></div>
					</div>
					<div class="sectionBody">
					<div class="form-row"><div class="col"><label for="structures">Supply:</label>
					<select  placeholder="Search by Supply" name="supply" multiple="multiple" id="supply_field" class="form-control search-select-structure" autocomplete="off">
										<cfloop query="session.model.formSuppliesDropOptions">
											<cfquery name="check_subs5" datasource="#application.datasource#">
											 select pbt_tags.tag,pbt_tags.tagID
											 from pbt_tags
		 inner join site_tag_xref x on pbt_tags.tagID = x.tagID 
											 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID in (1,16)
												 and tag_parentID <> 0
		 and siteID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.siteID#" />
	 											and pbt_tags.tagID in (#session.user_tags#)
											 order by pbt_tags.tag
											</cfquery>								
											<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
											<cfif check_subs5.recordcount GT 0>
											   <cfloop query="check_subs5">
													<cfoutput><option value="#tagID#">#tag#</option></cfoutput>
											   </cfloop>
											</cfif>										
										</cfloop>
									</select>

					</div></div>
					</div>
					<div class="sectionBody">
					<div class="form-row"><div class="col"><label for="structures">Qualifications:</label>
					<select  placeholder="Search by Qualification" name="services" multiple="multiple" id="services_field" class="form-control search-select-structure" autocomplete="off">
										<cfloop query="session.model.formQualDropOptions">
											<cfquery name="check_subs6" datasource="#application.datasource#">
											 select pbt_tags.tag,pbt_tags.tagID
											 from pbt_tags
		 inner join site_tag_xref x on pbt_tags.tagID = x.tagID 
											 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID in (1,16)
												 and tag_parentID <> 0
		 and siteID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.siteID#" />
	 											 and pbt_tags.tagID in (#session.user_tags#)
											 order by pbt_tags.tag
											</cfquery>								
											<cfoutput><option value="#tagID#" >#tag#</option></cfoutput>
											<cfif check_subs6.recordcount GT 0>
											   <cfloop query="check_subs6">
													<cfoutput><option value="#tagID#">#tag#</option></cfoutput>
											   </cfloop>
											</cfif>										
										</cfloop>
									</select>

					</div></div>

			
					

				</div>

			</div>
				
		</div>

		<div class="col-xs-12 col-md-6 pull-left">	
			<!--- state --->
			<div class="col-md-6 col-xs-12 pull-left">
				<div class="sectionHead">State(s)</div>
				<div class="sectionBody">
					<cfselect name="state" size="5" query="state" value="stateid" display="fullname" multiple selected="66" class="formSelect form-control"></cfselect>
				</div>
			</div>

			<!--- proj budget --->
			<div class="col-md-6 col-xs-12 pull-left">
				<div class="sectionHead">Total Project Budget</div>
				<div class="sectionBody">
					<select name="amount" size="5" multiple class="formSelect form-control" autocomplete="off">
						<option value="1" SELECTED>Any</option>
						<option value="2">< $100,000</option>
						<option value="3">$100,000 - $500,000</option>
						<option value="4">$500,000 - 1 million</option>
						<option value="5">Over 1 million</option>
					</select>
				</div>
			</div>

			<!--- misc --->
			<div class="col-md-12 col-xs-12 pull-left">
				<div class="sectionHead">Filter By</div>
				<div class="sectionBody">
					<div class="form-row"><div class="col">Keyword Search: <cfif session.auth.userID eq 15210 or session.auth.userID eq 14601><input name="qt_docs" type="checkbox" class="checkinput"><em>Include Search of PDF Documents</em></cfif></div></div>
					<div class="form-row"><div class="col"><cfinput name="qt" type="text" size="30" class="form-control"></div></div>

					<div class="form-row"><div class="col">Project ID Search: <cfif session.auth.userID eq 15210 or session.auth.userID eq 14601><input name="bidid_docs" type="checkbox" class="checkinput"><em>Include Search of PDF Documents</em></cfif></div></div>
					<div class="form-row"><div class="col"><cfinput type="text" name="bidid"  validate="integer" message="project ID must be numeric." class="form-control"></div></div>
					<div class="form-row"><div class="col">Contractor Name:</div></div>
					<div class="form-row"><div class="col"><cfinput type="text" name="contractorname" size="54" class="form-control"></div></div>
					<div class="form-row"><div class="col">Post Date:</div></div>
					<div class="form-row">
						<div class="col-sm-6"><input type="text" id="postfrom" name="postfrom" class="form-control" placeholder="From Date"/></div>
						<div class="col-sm-6"><input type="text" id="postto" name="postto" class="form-control" placeholder="To Date"/></div>
					</div>			
					<div class="form-row"><div class="col">Submittal Date:</div></div>
					<div class="form-row">
						<div class="col-sm-6"><input type="text" id="subfrom" name="subfrom" class="form-control" placeholder="From Date"/></div>
						<div class="col-sm-6"><input type="text" id="subto" name="subto" class="form-control" placeholder="To Date"/></div>
					</div>						

					<hr/>
				</div>
			</div>	

			<!--- planholders --->
			<div class="col-md-12 col-xs-12 pull-left">
				<div class="sectionHead">Filter By</div>
				<div class="sectionBody">
					<div class="form-row"><div class="col"><input name="planholders" id="planholders" type="checkbox" value="16">  Limit to only projects with planholders
										</div></div>
				</div>
			</div>
		</div>	

		<!--- buttons --->
		<div class="col-md-12 col-xs-12">
			<div class="sectionButtons">
				<input name="SEARCH" type="submit" value="Search" id="ssearch" class="btn btn-primary">
				<!--&nbsp;&nbsp;&nbsp;
				<input name="Reset" type="reset" value="Reset" class="btn btn-default">-->
			</div>
			<div class="sProcess hidden">SEARCHING...  <img src='../../assets/images/spinner.svg'></div><!--- --->
		</div>
	</div>
</cfform>

</cfoutput>
<script>
$(document).ready(function(){
	$('#ssearch').on('click', function(){
		$('.sectionButtons').addClass("hidden");
		$('.sProcess').removeClass("hidden");
	});	
	$( window ).unload(function() {
		$('.sectionButtons').removeClass("hidden");
  		$('.sProcess').addClass("hidden");
	});
});
</script>