<!---********************************
	detail page to display bid details
	created by DS on 11/26/11
	
*************************************--->


<!---check project showcase links and if available remove authorization checks--->
<cfquery name="check_showcase" datasource="#application.datasource#">
	select 
		a.mediaID, a.albumID, b.album_name, a.psuID, a.assetID, c.profile_name, a.asset_type, a.rating_avg, a.rating_total, a.date_posted, a.bidID, d.headline as photoheadline, d.photo_file as photofile, e.title as videoheadline, e.video_file as videofile, e.yt_embed as videoyt, e.thumbnail as videothumbnail, b.album_dir, c.profile_dir, a.sort, count(f.pageviewid)as total_views
	from project_showcase_media a
	left outer join project_showcase_album b on b.albumID = a.albumID
	left outer join project_showcase_user c on c.psuID = a.psuID
	left outer join gateway_photos d on d.photoID = a.assetID
	left outer join video e on e.videoID = a.assetID
	left outer join gateway_page_view_log f on f.contentID = a.mediaID and f.pageID = 178
	where 
		a.active = 1 and a.bidID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#">
		and a.mediaID in (select contentID from tags_log where tagID = #site_tagID# and content_typeID = 1942)
	group by a.mediaID, a.albumID, b.album_name, b.album_dir, c.profile_dir, a.psuID, a.assetID, c.profile_name, a.asset_type, a.rating_avg, a.rating_total, a.date_posted, a.bidID, d.headline, d.photo_file, e.title, e.video_file, e.yt_embed, e.thumbnail, a.sort
	order by a.date_posted desc
</cfquery>
 <cfstoredproc procedure="pbt_project_detail" datasource="#application.datasource#" >
	<cfprocparam type="in" dbvarname="@bidid" cfsqltype="CF_SQL_INTEGER" value="#bidid#">
	<cfprocresult name="getdetail" resultset="1">
  </cfstoredproc>
<cfinvoke  
    component="cfc.documents"  
    method="listDocuments"  
    returnVariable="listDocuments"> 
	<cfif getdetail.bidID NEQ ""><cfinvokeargument name="bidID" value="#getdetail.bidID#"/><cfelse><cfinvokeargument name="bidID" value="0"/></cfif> 
	<cfif getdetail.vendorID NEQ ""><cfinvokeargument name="vendorID" value="#getdetail.vendorID#"/></cfif>
</cfinvoke>
<cfif check_showcase.recordcount EQ 0>

	<cfif isUserLoggedIn()>
			<cftry>
			<cfquery name="getuserid" datasource="#application.datasource#">
				select distinct bid_users.userid 
				from bid_users 
					inner join bid_subscription_log on bid_users.userid = bid_subscription_log.userid 
				where bid_subscription_log.effective_date <= #date# 
					and bid_subscription_log.expiration_date >= #date# 
					and bid_subscription_log.active = 1 
					and bid_users.bt_status = 1 
					and bid_users.reguserid = #cookie.bt_user#
			</cfquery>
			<cfif getuserid.recordcount is 0>
					<cfif isdefined("bidid")><cfset addvar = "bidID=#bidid#"><cfelse><cfset addvar = ""></cfif>
					<cflocation url="?type=1&#addvar#" addtoken="No">
			</cfif>	 
			<cfset userid = getuserid.userid>

			<cfcatch>
			<!---cfmail to="slyon@technologypub.com" from="error@paintbidtracker.com" subject="Lead Issue" type="HTML">
				<cfdump var="#cfcatch#" />
			</cfmail>
				<cfif isdefined("bidid")><cfset addvar = "bidID=#bidid#"><cfelse><cfset addvar = ""></cfif>
				<cflocation url="?type=1&#addvar#" addtoken="No"--->
				
			</cfcatch>	
			</cftry>
			
			
	<cfelse>
			 <cfif isdefined("bidid")><cfset addvar = "bidID=#bidid#"><cfelse><cfset addvar = ""></cfif>
			 <cfscript>
			// *** Restrict Access To Page: Grant or deny access to this page
			MM_authorizedUsers="";
			MM_authFailedURL="../index.cfm";
			MM_grantAccess=false;
			MM_Session = IIf(IsDefined("Session.MM_Username"),"Session.MM_Username",DE(""));
			if (MM_Session IS NOT "") {
			  if (true OR (Session.MM_UserAuthorization IS "") OR (Find(Session.MM_UserAuthorization, MM_authorizedUsers) GT 0)) {
			    MM_grantAccess = true;
			  }
			}
			if (NOT MM_grantAccess) {
			  MM_qsChar = "?";
			  if (Find("?",MM_authFailedURL) GT 0) MM_qsChar = "&";
			  MM_referrer = CGI.SCRIPT_NAME;
			  if (CGI.QUERY_STRING IS NOT "") MM_referrer = MM_referrer & "?" & CGI.QUERY_STRING;
			  MM_authFailedURL_Trigger = MM_authFailedURL & MM_qsChar & "accessdenied=" & URLEncodedFormat(MM_referrer);
			}
			</cfscript>
			<cfif IsDefined("MM_authFailedURL_Trigger")>
			<cflocation url="#MM_authFailedURL_Trigger#&type=1&#addvar#" addtoken="no">
			</cfif>
	</cfif>
  

</cfif>
 
 <cfif isdefined("userID") and userID NEQ ""><!---run if not coming from showcase--->

 	<cfif not isdefined("session.packages") or (isdefined("session.packages") and session.packages EQ "")>
		<cfquery name="checkuserpackage" datasource="#application.datasource#">
		select distinct bid_subscription_log.packageid
		from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
		where bid_users.userid =  <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER"> 
		and bid_subscription_log.effective_date <= #date# 
		and bid_subscription_log.expiration_date >= #date# 
		and bid_subscription_log.active = 1
		</cfquery> 
		<cfset session.packages = valuelist(checkuserpackage.packageid)>
	</cfif>
	
		<!--- check for niche tag packages--->
			<cfif listfind(session.packages, 16)>
				<CFQUERY NAME="GET_Sub_TAGS" DATASOURCE="#application.datasource#">
					select * 
					from pbt_user_tags
					where userID = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER"> 
					and active = 1
				</cfquery>
			<cfif get_sub_tags.recordcount GT 0>
				<cfset variable.user_tags = valuelist(GET_Sub_TAGS.tagID)>
			<cfelse>
				<cflocation url="#rootpath#account/?action=104">
			</cfif>
			<cfelse>
				<CFQUERY NAME="GET_Sub_TAGS" DATASOURCE="#application.datasource#">
					select * 
					from pbt_tags
				</cfquery>
			<cfset variable.user_tags = valuelist(GET_Sub_TAGS.tagID)>
			</cfif>
	



 	
	<cfquery name="check_user_st" datasource="#application.datasource#">
	select distinct * from bid_users where userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#"> and bt_status = 1
	</cfquery>
	
	<cfif check_user_st.recordcount is 0>
	<cflocation url="?userid=#userid#" addtoken="No">
	</cfif>
	
	<!---check to see if user is auth. to receive paint bids, if not send them back--->
	<cfquery name="checkuser" datasource="#application.datasource#">select distinct bid_user_suppliers.basicpkg,bid_user_suppliers.aebids,bid_user_suppliers.awards from bid_user_suppliers inner join bid_users on bid_users.sid = bid_user_suppliers.sid where bid_users.userid = #userid#</cfquery>                                                  

	<cfquery  name="getsid" datasource="#application.datasource#">select sid from bid_users where userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER"></cfquery>
	<cfquery name="checktrack_status" datasource="#application.datasource#" >
	select bid_user_project_bids.projectid,bid_user_project_folders.foldername,bid_user_project_folders.folderid 
	from bid_user_project_bids 
	inner join bid_user_project_folders on bid_user_project_folders.folderid = bid_user_project_bids.folderid 
	left outer join bid_user_privacy_log on bid_user_privacy_log.folderid = bid_user_project_folders.folderid
	where  bid_user_project_bids.bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#">
	and bid_user_project_folders.active = 1 and (1 <> 1 
	or (bid_user_project_folders.privacy_setting = 1 and bid_user_project_folders.userid in (select userid from bid_users where sid = #getsid.sid#)) 
	or (bid_user_project_folders.privacy_setting = 3 and ((bid_user_privacy_log.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#"> and bid_user_privacy_log.userid in (select userid from bid_users where sid in (select sid from bid_users where userid = bid_user_project_folders.userid))) or bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))
	or (bid_user_project_folders.privacy_setting is null and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">)
	or (bid_user_project_folders.privacy_setting = 2 and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))
	and bid_user_project_bids.active = 1
	</cfquery>
		<cfif checktrack_status.recordcount is not 0>
			<cfquery name="checknotes" datasource="#application.datasource#">
				select bid_user_project_comments.bid_commentid
				from bid_user_project_comments inner join bid_user_project_bids on bid_user_project_comments.projectid = bid_user_project_bids.projectid
				where bid_user_project_bids.bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#"> and bid_user_project_comments.active = 1 and bid_user_project_comments.projectid = #checktrack_status.projectid# 
				order by bid_user_project_comments.date_entered desc,bid_user_project_comments.bid_commentid desc
			</cfquery>
		</cfif>	
 </cfif>
 
 
<cfparam name="map_address" default="">

	 <cfquery name="insertbid" datasource="#application.datasource#">
	 insert into bid_user_viewed_log
	 (bidid,userid,dateviewed)
	 values('#bidid#',<cfif isdefined("userID") and userID NEQ "">#userid#<cfelse>NULL</cfif>,#date#)
	 </cfquery>
	 
 
	<cfquery name="insert_usage" datasource="#application.datasource#">
		INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
		VALUES(<cfif isdefined("userID") and userID NEQ "">#userid#<cfelse>NULL</cfif>,'#cfid#',#date#,36,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
	</cfquery>

 <!---check to verify user is approved for these tags--->
		<cfif isdefined("variable.user_tags")>
				<cfquery name="get_tags1" datasource="#application.datasource#">
				select distinct pbt_project_master_cats.tagID,pbt_tags.tag
				from pbt_project_master_cats
				left outer join pbt_tags on pbt_tags.tagID = pbt_project_master_cats.tagID
				where pbt_tags.active = 1 and pbt_project_master_cats.bidID = <cfqueryPARAM value = "#bidID#" CFSQLType = "CF_SQL_INTEGER"> 
				and pbt_project_master_cats.tagID in (#variable.user_tags#)
				and pbt_tags.tag_typeID <> 9
				order by tag 
	   			</cfquery>
			<cfif get_tags1.recordcount EQ 0>
				<cflocation url="../index.cfm">
			</cfif>
		</cfif>
		
		<cfquery name="get_tags" datasource="#application.datasource#">
				select distinct pbt_project_master_cats.tagID,pbt_tags.tag
				from pbt_project_master_cats
				left outer join pbt_tags on pbt_tags.tagID = pbt_project_master_cats.tagID
				where pbt_tags.active = 1 and pbt_project_master_cats.bidID = <cfqueryPARAM value = "#bidID#" CFSQLType = "CF_SQL_INTEGER">
				and pbt_tags.tag_typeID <> 9
				order by tag 
	   </cfquery>
	   
		<cfquery name="getlow" datasource="#application.datasource#">
			select supplier_master.companyname,supplier_master.contactname,pbt_project_award_stage_detail.post_date as postdate,pbt_project_award_stage_detail.award_editornote as editornotes,
			supplier_master.websiteurl,supplier_master.billingaddress,supplier_master.city,supplier_master.postalcode,
			supplier_master.emailaddress,supplier_master.phonenumber,supplier_master.faxnumber,state_master.state,
			pbt_award_contractors.amount,pbt_award_contractors.awarded,pbt_award_contractors.supplierid 
			from pbt_project_stage
			left outer join pbt_project_award_stage_detail on pbt_project_award_stage_detail.stageID = pbt_project_stage.stageID
			left outer join pbt_award_contractors on pbt_project_stage.stageID = pbt_award_contractors.stageID 
			left outer join supplier_master on supplier_master.supplierid = pbt_award_contractors.supplierid 
			left outer join state_master on state_master.stateid = supplier_master.stateid 
			where pbt_project_stage.bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#"> and pbt_award_contractors.supplierid <> 9000 
			and pbt_project_stage.stageID = (select max(stageID) from pbt_project_stage where bidID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#">)
			and pbt_award_contractors.typeID <> 3
			order by pbt_award_contractors.awarded desc,pbt_award_contractors.amount
		</cfquery>
		<!---Run check for O results--->
		<cfif getlow.recordcount EQ 0>
			<cfquery name="getlow_text" datasource="#application.datasource#">
				select bidID,companyname,amount,address,city,state,postalcode,emailaddress,firstname + lastname as contactname,lowbidder
				from pbt_project_onvia_award_results
				left outer join state_master on state_master.stateid = pbt_project_onvia_award_results.stateid 
				where bidID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#">
			</cfquery>
		</cfif>
		<cfquery name="getnotes" datasource="#application.datasource#">
			select distinct pbt_project_award_stage_detail.award_editornote as editornotes 
			from pbt_project_award_stage_detail 
			where bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#">
		</cfquery>
		<cfquery name="getplandate" datasource="#application.datasource#">
			select max(receivedate) as datereceived 
			from bid_planholders 
			where bidid =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#"> 
			and bid_planholders.active is null
			and (companyname is not null or firstname is not null or lastname is not null) 
		</cfquery>				
							
		<cfquery name="getplanlist" datasource="#application.datasource#">
			select distinct companyname,city,bid_planholders.state,contactphone,companyphone,companyfax,state_master.state,
			address1,postalcode,firstname,lastname,emailaddress,bid_planholders.stateid 
			from bid_planholders 
			left outer join state_master on state_master.stateid = bid_planholders.stateid  
			where bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#"> 
			and bid_planholders.active is null 
			and (companyname is not null or firstname is not null or lastname is not null) 
			order by companyname
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
	
<cfif isdefined("userID") and userID NEQ ""><!---only enable for subscribers--->
	<cfinclude template="function_modals.cfm">
</cfif>	
	
<!---begin heading--->
<div class="pull-right">	
	<cfif isdefined("userID") and userID NEQ "">	
		<cfoutput>
				<!---<cftooltip 
						autoDismissDelay="5000" 
						hideDelay="250" 
						preventOverlap="true" 
						showDelay="200" 
						tooltip="Add a photo or video to this project"> 
						<a href="#rootpath#showcase/?fuseaction=media&action=create&bidID=#bidID#" alt="Add a photo or video to project" >
						<i class="fa fa-camera fa-2x fa-details" aria-hidden="true"></i></a>&nbsp;
				</cftooltip>--->
				<cfif checktrack_status.recordcount EQ 0>
					<cftooltip 
						autoDismissDelay="5000" 
						hideDelay="250" 
						preventOverlap="true" 
						showDelay="200" 
						tooltip="Track this Lead"> 
						<a href="javaScript:ColdFusion.Window.show('folderSave')" alt="Track Project" ></a>
						<i class="fa fa-file fa-2x fa-details" aria-hidden="true"></i><a href="" data-toggle="modal" data-target="##trackModal"></a>
					</cftooltip>
				<cfelse>
					<cftooltip 
						autoDismissDelay="5000" 
						hideDelay="250" 
						preventOverlap="true" 
						showDelay="200" 
						tooltip="Tracking Lead"> 
						<a href="../myaccount/folders/?action=folder&userid=#userid#&id_mag=#checktrack_status.folderid#">
						<i class="fa fa-file-text fa-2x fa-details" aria-hidden="true"></i></a>
					</cftooltip>
					<cftooltip 
						autoDismissDelay="5000" 
						hideDelay="250" 
						preventOverlap="true" 
						showDelay="200" 
						tooltip="Add a Comment or Note to this Lead"> 
						<a href="javaScript:ColdFusion.Window.show('AddComment')" alt="Add Note" >
						<i class="fa fa-sticky-note fa-2x fa-details" aria-hidden="true"></i></a>
					</cftooltip>
				</cfif>
				<cftooltip 
						autoDismissDelay="5000" 
						hideDelay="250" 
						preventOverlap="true" 
						showDelay="200" 
						tooltip="Print Lead"> 
						<a href="?action=print&bidID=#getdetail.bidid#" target="_blank">
						<i class="fa fa-print fa-2x fa-details" aria-hidden="true"></i></a>
				</cftooltip>
				<cftooltip 
						autoDismissDelay="5000" 
						hideDelay="250" 
						preventOverlap="true" 
						showDelay="200" 
						tooltip="Email this Lead"> 
						<a href="javaScript:ColdFusion.Window.show('SentTo')">
						<i class="fa fa-envelope fa-2x fa-details" aria-hidden="true"></i></a>
				</cftooltip>
				<cftooltip 
						autoDismissDelay="5000" 
						hideDelay="250" 
						preventOverlap="true" 
						showDelay="200" 
						tooltip="Request More Information on this Lead"> 
						<a href="javaScript:ColdFusion.Window.show('RequestForm')">
						<i class="fa fa-commenting fa-2x fa-details" aria-hidden="true"></i></a>
				</cftooltip>
		</cfoutput>
	  </cfif>	  
</div>

		
		<script>
		$(function () {
			// Track File hover
			$(".fa-file").hover(function() {
				$(this).css('cursor','pointer');
			}, function() {
				$(this).css('cursor','auto');
			});			
			 

			//Modal handler
			$(".fa-file").click(function(){
			  //var bidID = $(this).attr('data-bidid');
			  //var full = "<a href='../leads/?bidid=" + bidID + "'>View full details</a>"
			  //$(".modal-body").html("Content loading please wait...  <img src='../assets/images/spinner.svg'>");
			  //$(".modal-title").html("QUICK VIEW - BidID: " + bidID);

			  //$(".modal-footer").html(full);		
			  $("#trackModal").modal("show");
			  $(".modal-body").load('../../search/includes/savetofolder_inc.cfm?userID=' + <cfoutput>#userid#</cfoutput> + '&projects=' + <cfoutput>#bidID#</cfoutput> + '&ref=2');
			});	

		});		
		</script>	