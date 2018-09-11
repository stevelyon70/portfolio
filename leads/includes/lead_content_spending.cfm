<!---
********************************
	LEAD BODY - SPENDING
	CREATED BY RM 02/23/2018
*************************************
--->

	<cfif getdetail.bidID NEQ "">
		<cfinvoke  
			component="cfc.documents"  
			method="listSpendingDocuments"  
			returnVariable="listDocuments"> 
			<cfif getdetail.bidID NEQ ""><cfinvokeargument name="bidID" value="#getdetail.bidID#"/><cfelse><cfinvokeargument name="bidID" value="0"/></cfif> 
			<cfif getdetail.vendorID NEQ ""><cfinvokeargument name="vendorID" value="#getdetail.vendorID#"/></cfif>
		</cfinvoke>
	</cfif>

	 <cfif isdefined("session.auth.userID") and session.auth.userID NEQ ""><!---run if not coming from showcase--->

		<cfif not isdefined("session.packages") or (isdefined("session.packages") and session.packages EQ "")>
			<cfquery name="checkuserpackage" datasource="#application.dataSource#">
			select distinct bid_subscription_log.packageid
			from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
			where bid_users.userid =  <cfqueryPARAM value = "#session.auth.userID#" CFSQLType = "CF_SQL_INTEGER"> 
			and bid_subscription_log.effective_date <= #date# 
			and bid_subscription_log.expiration_date >= #date# 
			and bid_subscription_log.active = 1
			</cfquery> 
			<cfset session.packages = valuelist(checkuserpackage.packageid)>

			<!---run another check to verify user is approved for this package--->
			<cfif not listfind(session.packages, 18)>
				<cfset valid = false>
				<!---<cflocation url="../projectsearch/?action=92&userid=#session.auth.userID#" addtoken="Yes">--->
			</cfif>
		</cfif>

		<!--- check for niche tag packages--->
		<cfif listfind(session.packages, 16)>
			<CFQUERY NAME="GET_Sub_TAGS" DATASOURCE="#application.dataSource#">
				select * 
				from pbt_user_tags
				where userID = <cfqueryPARAM value = "#session.auth.userID#" CFSQLType = "CF_SQL_INTEGER"> 
				and active = 1
			</cfquery>
			<cfif get_sub_tags.recordcount GT 0>
				<cfset variable.user_tags = valuelist(GET_Sub_TAGS.tagID)>
			<cfelse>
				<cfset valid = false>
				<!---<cflocation url="#rootpath#account/?action=104">--->
			</cfif>
			<cfelse>
				<CFQUERY NAME="GET_Sub_TAGS" DATASOURCE="#application.dataSource#">
					select * 
					from pbt_tags
				</cfquery>
			<cfset variable.user_tags = valuelist(GET_Sub_TAGS.tagID)>
		</cfif>

		<cfquery name="check_user_st" datasource="#application.dataSource#">
		select distinct * from bid_users where userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userID#"> and bt_status = 1
		</cfquery>

		<cfif check_user_st.recordcount is 0>
			<cfset valid = false>
			<!---<cflocation url="?userid=#session.auth.userID#" addtoken="No">--->
		</cfif>

		<!---check to see if user is auth. to receive paint bids, if not send them back--->
		<cfquery name="checkuser" datasource="#application.dataSource#">select distinct bid_user_suppliers.basicpkg,bid_user_suppliers.aebids,bid_user_suppliers.awards from bid_user_suppliers inner join bid_users on bid_users.sid = bid_user_suppliers.sid where bid_users.userid = #session.auth.userID#</cfquery>                                                  

		<cfquery  name="getsid" datasource="#application.dataSource#">select sid from bid_users where userid = <cfqueryPARAM value = "#session.auth.userID#" CFSQLType = "CF_SQL_INTEGER"></cfquery>
		<cfquery name="checktrack_status" datasource="#application.dataSource#" >
		select bid_user_project_bids.projectid,bid_user_project_folders.foldername,bid_user_project_folders.folderid 
		from bid_user_project_bids 
		inner join bid_user_project_folders on bid_user_project_folders.folderid = bid_user_project_bids.folderid 
		left outer join bid_user_privacy_log on bid_user_privacy_log.folderid = bid_user_project_folders.folderid
		where  bid_user_project_bids.bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#b#">
		and bid_user_project_folders.active = 1 and (1 <> 1 
		or (bid_user_project_folders.privacy_setting = 1 and bid_user_project_folders.userid in (select userid from bid_users where sid = #getsid.sid#)) 
		or (bid_user_project_folders.privacy_setting = 3 and ((bid_user_privacy_log.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userID#"> and bid_user_privacy_log.userid in (select userid from bid_users where sid in (select sid from bid_users where userid = bid_user_project_folders.userid))) or bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userID#">))
		or (bid_user_project_folders.privacy_setting is null and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userID#">)
		or (bid_user_project_folders.privacy_setting = 2 and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userID#">))
		and bid_user_project_bids.active = 1
		</cfquery>
			<cfif checktrack_status.recordcount is not 0>
				<cfquery name="checknotes" datasource="#application.dataSource#">
					select bid_user_project_comments.bid_commentid
					from bid_user_project_comments inner join bid_user_project_bids on bid_user_project_comments.projectid = bid_user_project_bids.projectid
					where bid_user_project_bids.bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#b#"> and bid_user_project_comments.active = 1 and bid_user_project_comments.projectid = #checktrack_status.projectid# 
					order by bid_user_project_comments.date_entered desc,bid_user_project_comments.bid_commentid desc
				</cfquery>
			</cfif>	
	 </cfif>


	 <cfquery name="insertbid" datasource="#application.dataSource#">
	 insert into bid_user_viewed_log
	 (bidid,userid,dateviewed)
	 values('#b#',<cfif isdefined("userID") and userID NEQ "">#session.auth.userID#<cfelse>NULL</cfif>,#date#)
	 </cfquery>
	 
 
	<cfquery name="insert_usage" datasource="#application.dataSource#">
		INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
		VALUES(<cfif isdefined("userID") and userID NEQ "">#session.auth.userID#<cfelse>NULL</cfif>,'#cfid#',#date#,36,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
	</cfquery>

 	<!---check to verify user is approved for these tags--->
	<cfif isdefined("variable.user_tags")>
			<cfquery name="get_tags1" datasource="#application.dataSource#">
			select distinct pbt_project_master_cats.tagID,pbt_tags.tag
			from pbt_project_master_cats
			left outer join pbt_tags on pbt_tags.tagID = pbt_project_master_cats.tagID
			where pbt_tags.active = 1 and pbt_project_master_cats.bidID = <cfqueryPARAM value = "#b#" CFSQLType = "CF_SQL_INTEGER"> 
			and pbt_project_master_cats.tagID in (#variable.user_tags#)
			and pbt_tags.tag_typeID <> 9
			order by tag 
			</cfquery>
		<cfif get_tags1.recordcount EQ 0>
			<cfset valid = false>
			<!---<cflocation url="../index.cfm">--->
		</cfif>
	</cfif>

	<cfquery name="get_tags" datasource="#application.dataSource#">
			select distinct pbt_project_master_cats.tagID,pbt_tags.tag
			from pbt_project_master_cats
			left outer join pbt_tags on pbt_tags.tagID = pbt_project_master_cats.tagID
			where pbt_tags.active = 1 and pbt_project_master_cats.bidID = <cfqueryPARAM value = "#b#" CFSQLType = "CF_SQL_INTEGER">
			and pbt_tags.tag_typeID <> 9
			order by tag 
   </cfquery>


	<CFSCRIPT>		
		// Capitalize first char of each word
		function CapsFirst(string)
		{
		// Define local variables
		VAR outstring="";
		VAR c1=0;
		VAR c2=0; 
		// Loop through string
		for (i=1; i LTE Len(string); i=i+1)
		{
		// Is this the first char in string?
		if (i IS 1)
		{
		// First is always upper case
		c1=UCase(Mid(string, i, 1));
		}
		else
		{
		// Get char and previous char
		c1=Mid(string, i, 1);
		c2=Mid(string, i-1, 1); 

		// If Previous char is . or space
		if ((c2 IS ".") OR (c2 IS ' '))
		// then upper case
		c1=UCase(c1);
		else
		// else lower case
		c1=LCase(c1);
		} 


		// And put the string back together
		outstring=outstring & c1;
		} 

		return outstring;
		}
	</CFSCRIPT>
	<cfscript>
		/*
		I highlight words in a string that are found in a keyword list. Useful for search result pages.
		@param str String to be searched
		@param searchterm Comma delimited list of keywords
		*/
		string function highlightKeywords( required string str, required string searchterm ){
		var j = "";
		var matches = "";
		var word = "";
		// loop through keywords
		for( var i=1; i lte ListLen( arguments.searchterm, " " ); i=i+1 ){
		// get current keyword and escape any special regular expression characters
		word = ReReplace( ListGetAt( arguments.searchterm, i, " " ), "\.|\^|\$|\*|\+|\?|\(|\)|\[|\]|\{|\}|\\", "" );
		// return matches for current keyword from string
		matches = ReMatchNoCase( word, arguments.str );
		// remove duplicate matches (case sensitive)
		matches = CreateObject( "java", "java.util.HashSet" ).init( matches ).toArray();
		// loop through matches
		for( j=1; j <= ArrayLen( matches ); j=j+1 ){
		// where match exists in string highlight it
		arguments.str = Replace( arguments.str, matches[ j ], "<span style='background:yellow;'>#matches[ j ]#</span>", "all" );
		}
		}
		return arguments.str;
		}
	</cfscript>
	
	<cfsavecontent variable="leadDetail_#b#">	
		<cfoutput query="getdetail">
			<div>
				
				<cfparam name="keywords" default="">	
				
				<div class="row">	
					<div class="col-sm-12">
					  <h3>Project: #highlightKeywords( projectname, keywords )#</H3>
					  <hr style="border-top: 1px solid ##8c8b8b;">
					</div>	
				</div>						

				<div class="row">						
					<div class="col-xs-12 col-sm-12 col-md-12 col-lg-6">
						<p>
						<cfif owner is not "">
							<br>Agency: #highlightKeywords( owner, keywords )#
						</cfif> 
						<cfif city NEQ "" or county NEQ "" or primary_location_state NEQ "" or zipcode NEQ "">
							<br>Location: 
							<cfif city is not "">
								#capsfirst(city)#,
							<cfelse> 
								<cfif county is not "">
									#capsfirst(county)#
								</cfif>
							</cfif>
							<cfif primary_location_state is not "">
								#primary_location_state#
							</cfif> 
							<cfif zipcode is not "">
								#zipcode#
							</cfif>
						</cfif>
						<br>
						Level of Government: #highlightKeywords(levelofgovt, keywords )#<br>
						Total Project Budget: #total_budget#<br>
						Project Year(s): #project_startdate#-#project_enddate#<br>
						<cfif agencyprojectID NEQ "">Project Number: #agencyprojectID#<br></cfif>
						Date Posted: #dateformat(paintpublishdate, "m/d/yyyy")#	<br>
						<CFIF ISDEFINED("EDITDATE") >
							Updated on:<cfif dateformat(edate) is not dateformat(paintpublishdate)>#dateformat(EDATE, "mmmm d, yyyy")#<br></cfif>		
						</cfif>
						Paint BidTracker Project ID: #bidID#<br>					
						</p>
					</div>
					<div class="col-xs-12 col-sm-12 col-md-12 col-lg-6 pull-left map-div">
					</div>
				</div>

				<cfinvoke  
					component="cfc.asr"  
					method="getCosts"  
					returnVariable="getCosts"> 
					<cfinvokeargument name="bidID" value="#getdetail.bidID#"/> 
					<cfinvokeargument name="yearID" value="1"/> 
				</cfinvoke>
				<cfinvoke  
					component="cfc.asr"  
					method="getCosts"  
					returnVariable="getCosts2"> 
					<cfinvokeargument name="bidID" value="#getdetail.bidID#"/> 
					<cfinvokeargument name="yearID" value="2"/> 
				</cfinvoke>
				<cfinvoke  
					component="cfc.asr"  
					method="getCosts"  
					returnVariable="getCosts3"> 
					<cfinvokeargument name="bidID" value="#getdetail.bidID#"/> 
					<cfinvokeargument name="yearID" value="3"/> 
				</cfinvoke>
				<cfinvoke  
					component="cfc.asr"  
					method="getCosts"  
					returnVariable="getCosts4"> 
					<cfinvokeargument name="bidID" value="#getdetail.bidID#"/> 
					<cfinvokeargument name="yearID" value="4"/> 
				</cfinvoke>
				<cfinvoke  
					component="cfc.asr"  
					method="getCosts"  
					returnVariable="getCosts5"> 
					<cfinvokeargument name="bidID" value="#getdetail.bidID#"/> 
					<cfinvokeargument name="yearID" value="5"/> 
				</cfinvoke>

				<cfparam name="total_costs" default="0">

				<hr style="border-top: 1px solid ##8c8b8b;">	
				<h5>PROJECT COSTS</h5> 
				<div id="projectcosts">
					<table bgcolor="black" bordercolor="black" bordercolorlight="black" border="0" bordercolordark="black"  cellspacing="1" cellpadding="5">
						<tr bgcolor="white" bordercolor="black" bordercolorlight="black" bordercolordark="black" >
							<td width="150"><b>Project Costs</b></td>
							<cfif getCosts.recordcount GT 0><td align="center" width="150"><b>2014</b></td></cfif>
							<cfif getCosts2.recordcount GT 0><td align="center" width="150"><b>2015</b></td></cfif>
							<cfif getCosts3.recordcount GT 0><td align="center" width="150"><b>2016</b></td></cfif>
							<cfif getCosts4.recordcount GT 0><td align="center" width="150"><b>2017</b></td></cfif>
							<cfif getCosts5.recordcount GT 0><td align="center" width="150"><b>2018</b></td></cfif>
							<td align="center" class="cheader" width="150"><b>Total</b></td>
						</tr>
						<tr bgcolor="white" bordercolor="black" bordercolorlight="black" bordercolordark="black" >
							<td width="150"><b>Total Budget by year</b></td>
							<cfif getCosts.recordcount GT 0><td class="theader" align="center" width="150">$#numberformat(getCosts.budget_amount)#<cfset total_costs = total_costs + getCosts.budget_amount></td></cfif>
							<cfif getCosts2.recordcount GT 0><td class="theader" align="center" width="150">$#numberformat(getCosts2.budget_amount)#<cfset total_costs = total_costs + getCosts2.budget_amount></td></cfif>
							<cfif getCosts3.recordcount GT 0><td class="theader" align="center" width="150">$#numberformat(getCosts3.budget_amount)#<cfset total_costs = total_costs + getCosts3.budget_amount></td></cfif>
							<cfif getCosts4.recordcount GT 0><td class="theader" align="center" width="150">$#numberformat(getCosts4.budget_amount)#<cfset total_costs = total_costs + getCosts4.budget_amount></td></cfif>
							<cfif getCosts5.recordcount GT 0><td class="theader" align="center" width="150">$#numberformat(getCosts5.budget_amount)#<cfset total_costs = total_costs + getCosts5.budget_amount></td></cfif>
							<td class="theader" align="center" width="150"><cfif total_costs NEQ 0>$#numberformat(total_costs)#<cfelse>#total_budget#</cfif></td>
						</tr>
					</table>	

				</div>		

				<hr style="border-top: 1px solid ##8c8b8b;">	
				<h5>SUMMARY</h5> 
				<div id="summary">
					<p>
					<cfif justification_need NEQ "">Justification of Need: #highlightKeywords(justification_need, keywords )#<br><br /></cfif>
					<cfif description NEQ "">Description: #highlightKeywords(description, keywords )#<br><br /></cfif>
					<cfif assigned_priority NEQ "">Agency Assigned Priority: #highlightKeywords( assigned_priority, keywords )#<br></cfif>
					<cfif project_department NEQ "">Department: #highlightKeywords( project_department, keywords )#<br></cfif>
					Source Documents: <cfinclude template="spending_documents_inc.cfm"><br>
					<cfif documentpagenum NEQ "">PDF Page Number(s): #documentpagenum#<br></cfif>
					<cfif project_status NEQ "">Document Plan Status: #project_status#<br></cfif>
					Categories: #valuelist(get_tags.tag)#
					</p>
				</div>

				<hr style="border-top: 1px solid ##8c8b8b;">	
				<h5>AGENCY CONTACTS</h5> 
				<div id="contacts">
					<cfif owner_poc_contactname NEQ "">Name: #highlightKeywords( owner_poc_contactname, keywords )#<br></cfif>
					<cfif contact_title NEQ "">Job Title: #highlightKeywords(contact_title, keywords )#<br></cfif>
					<cfif department NEQ "">Department:#highlightKeywords(department, keywords )#<br></cfif>
					<cfif owner_poc_phonenumber NEQ "">Phone:#owner_poc_phonenumber#<br></cfif>
					<cfif owner_poc_faxnumber NEQ "">Phone:#owner_poc_faxnumber#<br></cfif>
					<cfif owner_poc_emailaddress NEQ "">Emailaddress:#owner_poc_emailaddress#<br></cfif>
					<cfif owner NEQ "">Agency:#highlightKeywords(owner, keywords )#<br></cfif>
					<cfif agency_phone NEQ "">Agency Phone:#agency_phone#<br></cfif>
					<cfif owner_url NEQ "">Agency Website:  
					<cfif findnocase("http://",#owner_url#) or findnocase("https://",owner_url)>
						<a href="#owner_url#" target="_blank" >
					<cfelse>
						<a href="http://#owner_url#" target="_blank" >
					</cfif>
						#owner_url#
						</a>
					</cfif>
				</div>	

				
			</div>
			<div>
				 <hr style="border-top: 1px solid ##8c8b8b;">
			</div>				
		</cfoutput>

		<style>
			h3{
				margin-top: 10px !important;
			}													
		</style>
	</cfsavecontent>
	
	
	