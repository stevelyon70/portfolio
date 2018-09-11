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


	<script>
	try{
		$(function() {
			$( "#tabs" ).tabs();
		});

		$(function() {

			$("#saved-folder").dialog({ 
				autoOpen: false,
				height: 300,
				modal: true,
				close: function() {
				} 
				});

			$("#savetofolder").click(function() {
				var values = $('#savefolder').serialize();


					$("ul#list").html(values);
				//$("#saved-folder").dialog('open');
				// prevent the default action, e.g., following a link
				return false;
			});


		}
		);

		submitForm_d = function() {
			ColdFusion.Ajax.submitForm('comment_delete', 'includes/comment_save_inc.cfm?delete', callback,
				errorHandler);
		}

		function callback(text)
		{
			//alert("Callback: " + text);

				//ColdFusion.Window.hide('AddComment')
				window.location.reload()

		}

		function errorHandler(code, msg)
		{
			alert("Error!!! " + code + ": " + msg);
		}
	}catch (e){
		
	}
</script>
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
<cfajaximport tags="cfwindow,cfform">	
<!---Window to launch the Save to Folder option--->
<cfif isdefined("userID") and userID NEQ ""><!---only enable for subscribers--->
<cfwindow  width="500" height="450" 
        name="folderSave" title="Save to Folder" 
        initshow="false"  draggable="false" center="true"  resizable="false" modal="true" bodystyle="background:##FFFFFF"
        source="../projectsearch/includes/savetofolder_inc.cfm?userID=#userid#&projects=#bidID#&ref=2" />
<cfwindow  width="390" height="200" 
        name="AddComment" title="Add a Comment" 
        initshow="false"  draggable="false" center="true"  resizable="false" modal="true" bodystyle="background:##FFFFFF"
        source="includes/comment_inc.cfm?userID=#userid#&bidID=#bidID#&projectID=#checktrack_status.projectID#" />	
<cfwindow  width="400" height="400" 
        name="SentTo" title="Send To" 
        initshow="false"  draggable="false" center="true"  resizable="false" modal="true" bodystyle="background:##FFFFFF"
        source="includes/email_cf_inc.cfm?userID=#userid#&bidID=#bidID#"/>	
<cfwindow  width="400" height="400" 
        name="RequestForm" title="Research Request Form" 
        initshow="false"  draggable="false" center="true"  resizable="false" modal="true" bodystyle="background:##FFFFFF"
        source="includes/research_request_inc.cfm?userID=#userid#&bidID=#bidID#"/>
</cfif>		
<table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                      <td width="100%" align="left" valign="top" colspan="3">
                        <div align="left">
                          <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                              <td align="left" valign="bottom">
                              <span class="h2">Project Details</span>
                              </td>
                              <td width="200" valign="top" align="right">
							<cfoutput>
							<cfif isdefined("userID") and userID NEQ "">	
							<p align="right">
									<cftooltip 
										    autoDismissDelay="5000" 
										    hideDelay="250" 
										    preventOverlap="true" 
										    showDelay="200" 
										    tooltip="Add a photo or video to this project"> 
									 	<a href="#rootpath#showcase/?fuseaction=media&action=create&bidID=#bidID#" alt="Add a photo or video to project" >
									 		<img src="http://app.paintbidtracker.com/images/icons/photography16.png">
										</a>
									</cftooltip>
									<cfif checktrack_status.recordcount EQ 0>
										<cftooltip 
										    autoDismissDelay="5000" 
										    hideDelay="250" 
										    preventOverlap="true" 
										    showDelay="200" 
										    tooltip="Track this Lead"> 
									 	<a href="javaScript:ColdFusion.Window.show('folderSave')" alt="Track Project" >
									 		<img src="http://app.paintbidtracker.com/images/icons/project16.png">
										</a>
										</cftooltip>
									<cfelse>
										<cftooltip 
										    autoDismissDelay="5000" 
										    hideDelay="250" 
										    preventOverlap="true" 
										    showDelay="200" 
										    tooltip="Tracking Lead"> 
										<a href="../folders/?action=38&id_mag=#checktrack_status.folderid#" >
									 		<img src="http://app.paintbidtracker.com/images/icons/finished-work16.png">
										</a>
										</cftooltip>
										<cftooltip 
										    autoDismissDelay="5000" 
										    hideDelay="250" 
										    preventOverlap="true" 
										    showDelay="200" 
										    tooltip="Add a Comment or Note to this Lead"> 
										<a href="javaScript:ColdFusion.Window.show('AddComment')" alt="Add Note" >
										<img src="http://app.paintbidtracker.com/images/icons/Notes.png"  width="16" height="16">
										</a>
										</cftooltip>
									</cfif>
									<cftooltip 
										    autoDismissDelay="5000" 
										    hideDelay="250" 
										    preventOverlap="true" 
										    showDelay="200" 
										    tooltip="Print Lead"> 
									<a href="">
									<img src="http://app.paintbidtracker.com/images/icons/print16.png">
									</a>
									</cftooltip>
									<cftooltip 
										    autoDismissDelay="5000" 
										    hideDelay="250" 
										    preventOverlap="true" 
										    showDelay="200" 
										    tooltip="Email this Lead"> 
									<a href="javaScript:ColdFusion.Window.show('SentTo')">
										<img src="http://app.paintbidtracker.com/images/icons/email16.png">
									</a>
									</cftooltip>
									<cftooltip 
										    autoDismissDelay="5000" 
										    hideDelay="250" 
										    preventOverlap="true" 
										    showDelay="200" 
										    tooltip="Request More Information on this Lead"> 
									<a href="javaScript:ColdFusion.Window.show('RequestForm')">
									<img src="http://app.paintbidtracker.com/images/icons/ResearchRequest.png" width="16" height="16">	
									</a>
									</cftooltip>
									<!---img src="../images/icons/Adobe_Acrobat_PDF16.png"><a href="javascript:DownLoadPdf('SingleLeadDocument.aspx?did=7e6b0feb-a2f9-4ce6-81e1-037dc3524e3f&&dname=2011%20Njdot%20Road%20Resurfacing%20Program&Download=true');"></a--->
							       
                              </p>
							  </cfif>
							  </cfoutput>
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
	
		<cfloop query="getdetail">
			<cfoutput>
			<div class="page-header col-sm-12">
			  <span class="h3">#projectname#</span>
			</div>		
			<div class="col col-sm-12">
				<div class="section col-sm-4 pull-left">
					<div id="content">
						<div class="col-sm-6">BidID: #bidID#</div>
						<div class="col-sm-6"><cfif projectnum NEQ "">Project Number: #projectnum#</cfif></div>
						<div class="col-sm-6">
						<cfif owner is not "">Owner: 
							<cfif isdefined("supplierID") and supplierID is not "">
								<a href="#request.rootpath#agency/?agency&supplierID=#supplierID#&userid=#userid#"><strong>#owner#</strong></a>
							<cfelse>								
								#owner#
							</cfif>							
						</cfif>
						</div>
						<div class="col-sm-6">Date Posted: #dateformat(paintpublishdate, "m/d/yyyy")#	</div>
						<div class="col-sm-6"><CFIF ISDEFINED("EDITDATE") >
							Updated on:<cfif dateformat(edate) is not dateformat(paintpublishdate)>#dateformat(EDATE, "mmmm d, yyyy")#</cfif>		
						</cfif>
						</div>
						<div class="col-sm-6"><cfif prebid NEQ "">Pre-Bid Meeting Date: #prebid#</cfif></div>
						<div class="col-sm-6"><cfif prebidnotes NEQ "">Pre-Bid Notes: #prebidnotes#</cfif></div>
						<div class="col-sm-6"><cfif (minimumvalue is not "" and minimumvalue NEQ "0") or (maximumvalue is not "" and maximumvalue NEQ "0")>
							Cost Estimate: <cfif minimumvalue is not "" and minimumvalue NEQ "0">$#numberformat(minimumvalue)#</cfif> <cfif minimumvalue is not "" and minimumvalue NEQ "0" and maximumvalue is not "" and maximumvalue NEQ "0">-</cfif> <cfif maximumvalue is not "" and maximumvalue NEQ "0">$#numberformat(maximumvalue)#</cfif></cfif>	
						</div>			 	
					</div>	
				</div>		
				<div class="section col-sm-4">
					<div id="secondcolumn">			
							<div class="col-sm-6">Stage: #stage#</div>
							<div class="col-sm-6">
								<cfif valuetypeid is 1 or valuetypeid is 2>Type of Contract: <cfif valuetypeid is 1>General Contract<cfelseif valuetypeid is 2>Painting</cfif></cfif>
							</div>
							<div class="col-sm-6">
							<cfif city NEQ "" or county NEQ "" or primary_location_state NEQ "" or zipcode NEQ "">
								Location: 
								<cfif city is not "">
									#capsfirst(city)#,
									<cfset map_address = listappend(map_address,city)>
								<cfelse> 
									<cfif county is not "">
										#capsfirst(county)#
										<cfset map_address = listappend(map_address,county)>
									</cfif>
								</cfif>
								<cfif primary_location_state is not "">
									#primary_location_state#
									<cfset map_address = listappend(map_address,primary_location_state)>
								</cfif> 
								<cfif zipcode is not "">
									#zipcode#
									<cfset map_address = listappend(map_address,zipcode)>
								</cfif>

							</cfif>
							</div>
							<div class="col-sm-6"><cfif submittaldate NEQ "">Submittal Date: #dateformat(submittaldate, "m/d/yyyy")#</cfif></div>
							<div class="col-sm-6"><cfif planprice NEQ "">Plan Price: #planprice#</cfif></div>
							<div class="col-sm-6"><cfif projectstartdate NEQ "">Project Start Date: #projectstartdate#</cfif></div>
							<div class="col-sm-6"><cfif projectsize NEQ "">Project Size: #projectsize#</cfif></div>

						</div>
				</div>	
			</div>	
			<div class="row">	
				<div class="col-sm-12">	<br><br>			 	
				   <cfif isdefined("map_address") and map_address NEQ "">
						<cfmap height="200" width="400" centeraddress="#map_address#" zoomlevel="11" showCenterMarker="false">
							<cfmapitem address="#map_address#" tip="#map_address#">
						</cfmap>
				   </cfif>						
				</div>
			</div>
			<div class="row">	
				<div class="col-sm-12">				 	
				<div id="tags"><h3>Relevant Tags:</h3> <cfif get_tags.recordcount GT 0>#valuelist(get_tags.tag)#</cfif></div>					
				</div>
			</div>
			</cfoutput>

			<div class="demo">
			<div id="tabs">
				<ul>	
					<cfif isdefined("bidtypeID") and (bidtypeID EQ "5" or bidtypeID EQ "6")  and ((getlow.recordcount GT 0 or getlow_text.recordcount GT 0) or (isdefined("award_editornotes") and award_editornotes NEQ ""))>
						<h3>Bid Results</h3>
						<cfif isdefined("bidtypeID") and (bidtypeID EQ "5" or bidtypeID EQ "6")  and ((getlow.recordcount GT 0) or (isdefined("award_editornotes") and award_editornotes NEQ ""))>
							<div id="tabs-4">
							<p>
								<cfif isdefined("getdetail.awarddate") and getdetail.awarddate NEQ "">
									<cfoutput>
									Award Date: #dateformat(awarddate, "m/d/yyyy")#<br><br>
									</cfoutput>
								</cfif>
								<cfif isdefined("getlow.supplierid") and getlow.supplierid NEQ "" and getlow.supplierid NEQ 9000>
									<h3>Apparent Low Bidders:</h3>
								</cfif>

								<table cellpadding="0" cellspacing="0" border="0" >

									<cfif isdefined("getlow.supplierid") and getlow.supplierid NEQ "" and getlow.supplierid NEQ 9000>
										<cfoutput query="getlow"> 
											<cfif supplierid NEQ 9000>
												<tr>
													<td colspan="2"><cfif awarded is "1"><img border="0" src="http://app.paintbidtracker.com/images/bidwinner.gif" ></cfif></td>
												</tr>
												<tr>
													<!---cfquery name="checkcsc" datasource="#application.datasource#">select supplierid from csc_reference_log where supplierid = #supplierid#</cfquery--->
													<td width="24" style="font-weight: bold;">#currentrow#.&nbsp;</td>
													<td width="386">
														<cfif isdefined("getlow.supplierID") and getlow.supplierID NEQ "">
															<a href="#request.rootpath#/contractor/?contractor&supplierID=#getlow.supplierID#&userid=#userid#" style="text-decoration:none; font-weight:bold;">
															#companyname#
															</a>
														<cfelse>
															<font face="Arial" size="2">#companyname#
														</cfif>
													</td>
													<td width="213">
														Bid Amount:&nbsp; #dollarformat(amount)#
													</td>
												</tr>

												<cfif billingaddress NEQ "" or city NEQ "" or state NEQ "" or postalcode NEQ "">
													<tr>
														<td width="24" align="right">&nbsp;</td>
														<td width="562" colspan="3" ><font face="Arial" size="2">
															<cfif billingaddress NEQ "">
																#billingaddress#<br>
															</cfif>
															<cfif city NEQ "">
																#city#,
															</cfif>
															<cfif state NEQ ""> 
																#state#
															</cfif>
															<cfif postalcode NEQ "">
																&nbsp; #postalcode#
															</cfif>
														</td>
													</tr>
												</cfif>

												<cfif contactname NEQ "">
													<tr>
														<td width="24"  align="right">&nbsp;</td>
														<td width="562" colspan="3">
															Contact Name: #contactname#<cfif contactname EQ "">Not Available</cfif>
														</td>
													</tr>
												</cfif> 

												<cfif phonenumber NEQ "">
													<tr>
														<td width="24"  align="right">&nbsp;</td>
														<td width="562" colspan="3" >
															Telephone: #phonenumber#<cfif phonenumber EQ "">Not Available</cfif>
														</td>
													</tr>
												</cfif>

												<cfif faxnumber NEQ "">
													<tr>
														<td width="24"  align="right">&nbsp;</td>
														<td width="562" colspan="3">
															Fax: #faxnumber#<cfif faxnumber EQ "">Not Available</cfif>
														</td>
													</tr>
												</cfif>

												<cfif emailaddress NEQ "">
													<tr>
														<td width="24"  align="right">&nbsp;</td>
														<td width="562" colspan="3" >
															Email Address: <a href="mailto:#emailaddress#">#emailaddress#</a><cfif emailaddress EQ "">Not Available</cfif>
														</td>
													</tr><!---cfif websiteurl is not ""><cfif findnocase("http://",#websiteurl#)><a href="#websiteurl#" target="_blank" ><cfelse><a href="http://#websiteurl#" target="_blank" ></cfif--->
												</cfif>

												<cfif currentrow EQ 1>			  
													<tr>
														<td width="24"  align="right">&nbsp;</td>
														<td width="562" colspan="3" >
															<cfquery name="getlow2" datasource="#application.datasource#">
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
																and pbt_award_contractors.typeID = 3
																order by pbt_award_contractors.awarded desc,pbt_award_contractors.amount
															</cfquery>
															<cfif getlow2.recordcount is not 0 and getlow2.supplierid is not "" and getlow2.supplierid is not 9000>		
																<table border="0" width="100%">
																	<tr><!---cfquery name="checkcsc" datasource="#application.datasource#">select supplierid from csc_reference_log where supplierid = #supplierid#</cfquery--->
																		<td width="100%" colspan="3"><h3>Painting Subcontractor:</h3></td>
																	</tr>

																	<tr>
																		<td width="6%"></td>
																		<td width="59%"><!---cfif checkcsc.recordcount is not 0><a href="../prequal/Contractor_PQ_Detail.cfm?id=#supplierid#&view=2"><b><font face="Arial" size="2" color="0000FF"><u>#getlow2.companyname#</u></font></a></b><cfelse--->#getlow2.companyname#<!---/cfif---></td>
																		<td width="41%">Painting Amount: <cfif getlow2.amount is "">N/A<cfelse>#dollarformat(getlow2.amount)#</cfif></td>
																	</tr>

																	<cfif getlow2.billingaddress is not "" or getlow2.city is not "" or getlow2.state is not "" or getlow2.postalcode is not "">
																		<tr>
																			<td width="6%"></td>
																			<td width="94%" colspan="2">
																				<cfif getlow2.billingaddress NEQ "">#getlow2.billingaddress#<br></cfif>
																				<cfif getlow2.city NEQ ""> #getlow2.city#,</cfif>
																				<cfif getlow2.state NEQ ""> #getlow2.state#</cfif>
																				<cfif getlow2.postalcode NEQ "">&nbsp; #getlow2.postalcode#</cfif>
																			</td>
																		</tr>
																	</cfif>

																	<cfif getlow2.contactname is not " ">
																		<tr>
																			<td width="24"  align="right">&nbsp;</td>
																			<td width="562" colspan="3" >Contact Name: #getlow2.contactname#<cfif getlow2.contactname is " ">Not Available</cfif></td>
																		</tr>
																	</cfif>

																	<cfif getlow2.phonenumber is not "">
																		<tr>
																			<td width="6%"></td>
																			<td width="94%" colspan="2" >Telephone:	#getlow2.phonenumber#<cfif getlow2.phonenumber is "">Not Available</cfif></td>
																		</tr>
																	</cfif>

																	<cfif getlow2.faxnumber is not "">
																		<tr>
																			<td width="6%"><</td>
																			<td width="94%" colspan="2">Fax: #getlow2.faxnumber#<cfif getlow2.faxnumber is "">Not Available</cfif></td>
																		</tr>
																	</cfif>

																	<cfif getlow2.emailaddress is not "">
																		<tr>
																			<td width="6%"></td>
																			<td width="94%" colspan="2">Email Address: <a href="mailto:#getlow2.emailaddress#">#getlow2.emailaddress#</a><cfif getlow2.emailaddress is "">Not Available</cfif></td>
																		</tr>
																	</cfif>
																</table>
															</cfif>
														</td>
													</tr>
												</cfif>
												<tr><td colspan="4"><hr></td></tr>
											</cfif>
										</cfoutput>  
									</cfif>
								</table>	
								<cfif isdefined("award_editornotes") and award_editornotes NEQ "">
									<cfoutput>
										<p>Award Note: #award_editornotes#</p>
									</cfoutput>
								</cfif>
							</p>
							</div>

						<cfelseif getlow.recordcount EQ 0 and getlow_text.recordcount GT 0>
							<div id="tabs-4">
							<p>
								<strong>Apparent Low Bidders:</strong>
								<table cellpadding="0" cellspacing="0" border="0" >
									<cfoutput query="getlow_text"> 
										<tr>
											<td width="24" style="font-weight: bold;">#currentrow#.&nbsp;</td>
											<td width="386">#companyname#<cfif lowbidder is "Yes"><img border="0" src="http://app.paintbidtracker.com/images/bidwinner.gif" ></cfif></td>
											<td width="213">Bid Amount:&nbsp; #dollarformat(amount)#
											</td>
										</tr>

										<cfif address NEQ "" or city NEQ "" or state NEQ "" or postalcode NEQ "">
											<tr>
												<td width="24"  align="right">&nbsp;</td>
												<td width="562" colspan="3" >
													<cfif address NEQ "">#address#<br></cfif>
													<cfif city NEQ ""> #city#,</cfif>
													<cfif state NEQ ""> #state#</cfif>
													<cfif postalcode NEQ "">&nbsp; #postalcode#</cfif>
												</td>
											</tr>
										</cfif>

										<cfif contactname NEQ " ">
											<tr>
												<td width="24"  align="right">&nbsp;</td>
												<td width="562" colspan="3" >Contact Name: #contactname#<cfif contactname EQ "">Not Available</cfif></td>
											</tr>
										</cfif> 

										<cfif emailaddress NEQ "">
											<tr>
												<td width="24"  align="right">&nbsp;</td>
												<td width="562" colspan="3" >
													Email Address: <a href="mailto:#emailaddress#">#emailaddress#</a><cfif emailaddress EQ "">Not Available</cfif></td>
											</tr><!---cfif websiteurl is not ""><cfif findnocase("http://",#websiteurl#)><a href="#websiteurl#" target="_blank" ><cfelse><a href="http://#websiteurl#" target="_blank" ></cfif--->
										</cfif>

										<tr>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>
									</cfoutput>  
								</table>	

							</p>
							</div>
						</cfif>		 	
					</cfif>

					<cfif isdefined("editornotes") and trim(editornotes) NEQ "">
						<hr>
						<h3>Editor Note</h3>
						<div id="tabs-1">
								<cfoutput>
									<p>#trim(editornotes)#</p>
								</cfoutput>
						</div>			
					</cfif>

					<hr>
					<h3>Owner Details</h3>
					<div id="tabs-2">
						<cfoutput>
						<p>				
							<table>
								<cfif isdefined("psowner") and psowner is not "">
									<tr>
										<td width="130" valign="top" height="1" style="font-weight: bold;">Owner:</td>
										<td width="476" height="1" colspan="2">
											<cfif isdefined("supplierID") and supplierID is not "">
												<a href="#request.rootpath#/agency/?agency&supplierID=#supplierID#&userid=#userid#" style="color:##2d53ac; text-decoration:none; font-weight:bold;" target="_blank">
												<cfif psowner is not "">
													<strong>#psowner#</strong>
												<cfelse>
													Not Available
												</cfif>
												</a>
											<cfelse>
												<cfif psowner is not "">
													#psowner#
												<cfelse>
													Not Available
												</cfif>
											</cfif>
										</td>
									</tr> 
								</cfif>

								<cfif owner_address NEQ "" or owner_state NEQ "" or owner_zipcode NEQ "">
									<tr>
										<td width="130" valign="top" height="1" style="font-weight: bold;">Location:</td>
										<td width="476" height="1" colspan="2">
										<cfif owner_address is not "">
										#capsfirst(owner_address)#, 
										</cfif>
										<cfif owner_city is not "">
										#capsfirst(owner_city)#, 
										</cfif>
										<cfif owner_state is not "">
										#owner_state#
										</cfif> 
										<cfif owner_zipcode is not "">
										#owner_zipcode#</cfif>
										</td>
									</tr> 
								</cfif>

								<cfif trim(owner_poc_contactname) is not "">
									<tr>
										<td width="130" valign="top" height="1" style="font-weight: bold;"><cfif stageID EQ 20>Prime Bidder POC<cfelse>Contact Name:</cfif></td>
										<td width="476"  height="1" colspan="2">
											<cfif owner_poc_contactname is not "" >
												#owner_poc_contactname#
											<cfelse>
												Not Available
											</cfif>
										</td>
									</tr>
								</cfif>

								<cfif isdefined("owner_poc_phonenumber") and owner_poc_phonenumber is not "">
									<tr>
										<td width="130" valign="top" height="1" style="font-weight: bold;">Telephone Number:</td>
										<td width="476" height="1" colspan="2">
											<cfif owner_poc_phonenumber is not "">
												#owner_poc_phonenumber#
											<cfelse>
												Not Available
											</cfif>
										</td>
									</tr>
								</cfif>

								<cfif isdefined("owner_poc_faxnumber") and owner_poc_faxnumber is not "">
									<tr>
										<td width="130" valign="top"  height="1" style="font-weight: bold;">Fax Number:</td>
										<td width="476"  height="1" colspan="2">
											<cfif owner_poc_faxnumber is not "">
												#owner_poc_faxnumber#
											<cfelse>
												Not Available
											</cfif>
										</td>
									</tr> 
								</cfif>

								<cfif isdefined("owner_poc_emailaddress") and owner_poc_emailaddress is not "">
									<tr>
										<td width="130" valign="top" height="1" style="font-weight: bold;">Email Address:</td>
										<td width="476" height="1" colspan="2">
											<cfif owner_poc_emailaddress is not "">
												#owner_poc_emailaddress#
											<cfelse>
												Not Available
											</cfif>
										</td>
									</tr> 
								</cfif>

								<cfif isdefined("owner_url") and owner_url is not "">
									<tr>
										<td width="130" valign="top" height="1" style="font-weight: bold;">Web Site:</td>
										<td width="476" height="1" colspan="2">
											<cfif owner_url is not ""> 
												<a href="<cfif NOT findnocase('http://',#owner_url#) or NOT findnocase('https://',owner_url)>http://</cfif>#owner_url#" target="_blank" >
												#owner_url#
												</a>
											<cfelse>
												Not Available
											</cfif>
										</td>
									</tr> 
								</cfif>

							</table>

							<cfif tech_poc_firstname is not "" or tech_poc_lastname is not "" or isdefined("tech_poc_phonenumber") and tech_poc_phonenumber is not "" or isdefined("tech_poc_emailaddress") and tech_poc_emailaddress is not "">
								<hr>
								<h3>Technical Contact Details</h3>
								<table>
									<cfif tech_poc_contactname is not "">
										<tr>
											<td width="130" valign="top" height="1" style="font-weight: bold;">Owner Contact Name:</td>
											<td width="476"  height="1" colspan="2">
											<cfif tech_poc_contactname is not "" >
												#tech_poc_contactname#
											<cfelse>
												Not Available
											</cfif>
											</td>
										</tr> 
									</cfif>

									<cfif isdefined("tech_poc_phonenumber") and tech_poc_phonenumber is not "">
										<tr>
											<td width="130" valign="top" height="1" style="font-weight: bold;">Technical POC Telephone Number:</td>
											<td width="476" height="1" colspan="2">
												<cfif tech_poc_phonenumber is not "">
													#tech_poc_phonenumber#
												<cfelse>
													Not Available
												</cfif>
											</td>
										</tr>
									</cfif>

									<cfif isdefined("tech_poc_faxnumber") and tech_poc_faxnumber is not "">
										<tr>
											<td width="130" valign="top"  height="1" style="font-weight: bold;">Technical POC Fax Number:</td>
											<td width="476"  height="1" colspan="2">
												<cfif tech_poc_faxnumber is not "">
													#tech_poc_faxnumber#
												<cfelse>
													Not Available
												</cfif>
											</td>
										</tr> 
									</cfif>

									<cfif isdefined("tech_poc_emailaddress") and tech_poc_emailaddress is not "">
										<tr>
											<td width="130" valign="top" height="1" style="font-weight: bold;">Technical POC Email Address:</td>
											<td width="476" height="1" colspan="2">
												<cfif tech_poc_emailaddress is not "">
													#tech_poc_emailaddress#
												<cfelse>
													Not Available
												</cfif><
											</td>
										</tr> 
									</cfif>
								</table>
							</cfif>

							<cfif isdefined("arch_poc_companyname") and arch_poc_companyname is not "" or  arch_poc_contactname is not ""  or isdefined("arch_poc_phonenumber") and arch_poc_phonenumber is not "" or isdefined("arch_poc_emailaddress") and arch_poc_emailaddress is not "" or isdefined("arch_poc_faxnumber") and arch_poc_faxnumber is not "">
								<hr>
								<h3>Engineer Contact Details</h3>
									<table>
										<cfif isdefined("arch_poc_companyname") and arch_poc_companyname is not "">
											<tr>
												<td width="130" valign="top" height="1" style="font-weight: bold;">Architect/Engineer:</td>
												<td width="476" height="1" colspan="2">
													<cfif isdefined("engineerID") and engineerID is not "">
														<a href="#request.rootpath#/engineer/?engineer&engineerID=#engineerID#&userid=#userid#" style="color:##2d53ac; text-decoration:none; font-weight:bold;" target="_blank">									
														<cfif arch_poc_companyname is not "">
															<strong>#arch_poc_companyname#</strong>
														<cfelse>
															Not Available
														</cfif>
														</a>
													<cfelse>
														<cfif arch_poc_companyname is not "">
															#arch_poc_companyname#
														<cfelse>
															Not Available
														</cfif>
													</cfif>
												</td>
											</tr> 
										</cfif>

										<cfif arch_poc_address NEQ "" or arch_state NEQ "">
											<tr>
												<td width="130" valign="top" height="1" style="font-weight: bold;">Location:</td>
												<td width="476" height="1" colspan="2">
													<cfif arch_poc_address is not "">#capsfirst(arch_poc_address)#, </cfif>
													<cfif arch_state is not "">#arch_state#</cfif>
													<cfif arch_poc_zipcode is not "">#arch_poc_zipcode#</cfif>
												</td>
											</tr> 
										</cfif>

										<cfif arch_poc_contactname is not "" >
											<tr>
												<td width="130" valign="top" height="1" style="font-weight: bold;">Contact Name:</td>
												<td width="476"  height="1" colspan="2">
													<cfif arch_poc_contactname is not "">
														#arch_poc_contactname#
													<cfelse>
														Not Available
													</cfif>
												</td>
											</tr> 
										</cfif>

										<cfif isdefined("arch_poc_phonenumber") and arch_poc_phonenumber is not "">
											<tr>
												<td width="130" valign="top" height="1" style="font-weight: bold;">Telephone Number:</td>
												<td width="476" height="1" colspan="2">
													<cfif arch_poc_phonenumber is not "">
														#arch_poc_phonenumber#
													<cfelse>
														Not Available
													</cfif>
												</td>
											</tr>
										</cfif>

										<cfif isdefined("arch_poc_faxnumber") and arch_poc_faxnumber is not "">
											<tr>
												<td width="130" valign="top"  height="1" style="font-weight: bold;">Fax Number:</td>
												<td width="476"  height="1" colspan="2">
													<cfif arch_poc_faxnumber is not "">
														#arch_poc_faxnumber#
													<cfelse>
														Not Available
													</cfif>
												</td>
											</tr> 
										</cfif>

										<cfif isdefined("arch_poc_emailaddress") and arch_poc_emailaddress is not "">
											<tr>
												<td width="130" valign="top" height="1" style="font-weight: bold;">Email Address:</td>
												<td width="476" height="1" colspan="2">
													<cfif arch_poc_emailaddress is not "">
														#arch_poc_emailaddress#
													<cfelse>
														Not Available
													</cfif>
												</td>
											</tr> 
										</cfif>
									</table>
							</cfif>
						</p>
						</cfoutput>
					</div>		

					<cfif url1 NEQ "" or url2 NEQ "" or url3 NEQ "" or fbo_url NEQ "">
						<hr>
						<h3>Links</h3>
						<div id="tabs-3">

							<cfoutput>
								<table>

									<cfif isdefined("fbo_url") and fbo_url is not "">
										<tr>
											<td width="130" valign="top" height="1">
												<font face="arial, Arial, Helvetica" size="2"><b>FBO Web Site:<br></b></font>
											</td>
											<td width="476" height="1" colspan="2">								
												<font face="arial, Arial, Helvetica" size="2">
													<cfif fbo_url is not ""> 
														<a href="<cfif NOT findnocase('http://',#fbo_url#) or NOT findnocase('https://',fbo_url)>http://</cfif>#fbo_url#" target="_blank" >
														#fbo_url#
														</a>
													<cfelse>
														Not Available
													</cfif>
												</font>
											</td>
										</tr> 
									</cfif>

									<cfif isdefined("url1") and url1 is not "" or isdefined("url2") and url2 is not "" or isdefined("url3") and url3 is not "">

										<tr>
											<td valign="top" width="200" style="font-weight: bold;">Related Documents/Links</td>
											<td colspan="2">
												<cfif url1 is not "">
													<b>
													<cfif isdefined("doctype1") and doctype1 is not "">
														#doctype1# ## 1:
													</cfif>										
													<a href="<cfif NOT findnocase('http://',#url1#) or NOT findnocase('https://',#url1#)>http://</cfif>#url1#" target="_blank">																	
														click to open #doctype1# ## 1										
													</a>	
													</b>									
												<cfelse>
													Not Available
												</cfif>

												<!---additional urls--->
												<cfif url2 is not "">
													<br>
													<b>
													<cfif isdefined("doctype2") and doctype2 is not "">
														#doctype2# ## 2: 
													</cfif>										
													<a href="<cfif NOT findnocase('http://',#url2#) or NOT findnocase('https://',#url2#)>http://</cfif>#url2#" target="_blank" >
														click to open #doctype2# ## 2
													</a>
													</b>
												</cfif>

												<cfif url3 is not "">
													<br>
													<b>	
													<cfif isdefined("doctype3") and doctype3 is not "">
														#doctype3# ## 3:
													</cfif>										
													<a href="<cfif NOT findnocase('http://',#url3#) or NOT findnocase('https://',#url3#)>http://</cfif>#url3#" target="_blank" >
														click to open #doctype3# ## 3
													</a>
													</b>
												</cfif>
											</td>
										</tr>

									<cfelseif isdefined("url1") and url1 is not "">

										<tr>
											<td width="130" valign="top" style="font-weight: bold;">Link</td>
											<td width="476" colspan="2">
												<cfif url1 is not "">
													<b>
													<a href="<cfif NOT findnocase('http://',url1) or NOT findnocase('https://',url1)>http://</cfif>#url1#" target="_blank" >
														#Left(url1,65)#
													</a>	
													</b>
												<cfelse>
													Not Available
												</cfif>
												<cfif url1 is not "" AND len(url1) gte 65>
													(cont.)
												</cfif>
											</td>
										</tr>

									</cfif>	
								</table>
							</cfoutput>
						</div>
					</cfif>

					<cfif listDocuments.recordcount GT 0 and listfind(session.packages, 17)>
						<hr>
						<h3>Specifications/Documents</h3>
							<cfinclude template="documents_inc.cfm">		
					</cfif>

					<cfif getplanlist.recordcount GT 0>
						<h3>Plan Holders</h3>
						<div id="tabs-5">
							<cfoutput>
								<table>				
									<tr>
										<td width="130" valign="top" style="font-weight: bold;">Planholders List</td>
										<td width="500" colspan="2">As of #dateformat(getplandate.datereceived,"mmmm d, yyyy")#
											<table width="100%" cellpadding=2 cellspacing=0 border=0>
												<tr><td>&nbsp;</td></tr>
												<cfif getplanlist.recordcount gt 6> 
													<br>There are #getplanlist.recordcount# planholders listed for this project.
													<br><a href="plan_list.cfm?userid=#userid#&bidid=#bidid#" target="_blank"><strong>Click here to view the full list.</strong></a>		   
												<cfelse>

													<cfloop query="getplanlist">		
														<cfif currentrow MOD 2 IS 1> 
															<tr valign="top">
														</cfif>

														<cfif companyphone NEQ "">			
															<cfset ph = rereplace(companyphone,"[^0-9]","","all")>
															<cfset length = len("#ph#")>
															<cfset phon = mid(#ph#,"1","3")>
															<cfset phon2= mid(#ph#,"4","3")>
															<cfset phon3=mid(#ph#,"7","4")>
															<cfset phonenumber="(#phon#) #phon2#-#phon3#">
														</cfif>	

														<cfif companyfax NEQ "">
															<cfset fx = rereplace(companyfax,"[^0-9]","","all")>
															<cfset length = len("#fx#")>
															<cfset fax = mid(#fx#,"1","3")>
															<cfset fax2= mid(#fx#,"4","3")>
															<cfset fax3=mid(#fx#,"7","4")>
															<cfset faxnumber="(#fax#) #fax2#-#fax3#">
														</cfif>				

														<td width="50%" height="20">
															<span class="tex"><strong>#companyname#</strong></span><br>
															<span class="tex">
																<cfif address1 NEQ "">#address1#<br></cfif>
																<cfif city NEQ "">#city#,</cfif>
																<cfif stateid NEQ 66> #state#</cfif>
																<cfif postalcode NEQ ""> #postalcode#</cfif>
															</span>
															<span class="tex">
																<cfif firstname NEQ "" and lastname NEQ "">
																	Contact: <cfif firstname NEQ "">#trim(firstname)#</cfif> <cfif lastname NEQ "">#trim(lastname)#</cfif><br>
																</cfif>
															</span>
															<cfif emailaddress NEQ ""><span class="tex">Email: #trim(emailaddress)#</span><br><cfelse></cfif>
															<cfif companyphone NEQ ""><span class="tex">Phone: #trim(phonenumber)#</span><br></cfif>
															<cfif companyfax NEQ ""><span class="tex">Fax:  #trim(faxnumber)#</span><br></cfif>
															<hr>
														</td>

														<cfif CurrentRow MOD 2 IS 0>
															</tr>
														</cfif>	
													</cfloop>  

													<!---if the query record count is not equally divisible by 2,--->
													<!---the last row was not close.--->
													<cfif getplanlist.RecordCount MOD 2 IS NOT 0>
														<CFSET ColsLeft = 2 - (getplanlist.RecordCount MOD 2)>
														<cfloop from = "1" TO = "#ColsLeft#" INDEX = "i">
														</td>
														<TD>&nbsp;</td><td>&nbsp;</td>
														</cfloop>
														</TR>
													</cfif>

												</cfif>					   
											</table>
										</td>		
									</tr>
								</table>
							</cfoutput>
						</div>			
					</cfif>

					<!--- DO NOT UNDERSTAND LOGIC HERE
					<cfif isdefined("bidtypeID") and (bidtypeID EQ "5" or bidtypeID EQ "6")  and ((getlow.recordcount GT 0 or getlow_text.recordcount GT 0) or (isdefined("award_editornotes") and award_editornotes NEQ ""))>
					<li><a href="#tabs-6">Description</a></li>
					<cfelse>
					<li><a href="#tabs-6">Description</a></li>
					</cfif>--->

					<hr>
					<h3>Description</h3>
					<div id="tabs-6">
							<cfoutput>
								<p>#trim(description)#</p>
							</cfoutput>
					</div>		

					<cfif isdefined("userID") and userID NEQ ""><!---only show if a subscriber--->
						<cfif checktrack_status.recordcount is not 0>		 	
							<h3>My Report Info</h3>
							<div id="tabs-7">
								<cfoutput>
									<p>
										<strong>
										You are currently tracking this project in your 
										<a href="../folders/?action=38&userid=#userid#&id_mag=#checktrack_status.folderid#" style="color:##2d53ac; text-decoration:none; font-weight:bold;">
										#checktrack_status.foldername#
										</a>
										folder.
										</strong>
									</p>
									<br /><br />
									<cfquery name="getcomments" datasource="#application.datasource#">
										select bid_user_project_comments.bid_commentid,bid_user_project_comments.projectid,bid_user_project_comments.comment,bid_user_project_comments.date_entered,bid_user_project_comments.userid as posted_userid,reg_users.name as posted_user
										from bid_user_project_comments inner join bid_user_project_bids on bid_user_project_comments.projectid = bid_user_project_bids.projectid
										left outer join bid_users on bid_users.userid = bid_user_project_comments.userid
										left outer join reg_users on reg_users.reg_userid = bid_users.reguserid
										where bid_user_project_bids.bidid = #bidid# and bid_user_project_comments.active = 1 and bid_user_project_comments.projectid = #checktrack_status.projectid# 
										order by bid_user_project_comments.date_entered desc,bid_user_project_comments.bid_commentid desc
									</cfquery>		
									<table>
										<cfloop query="getcomments"> 
											<cfset class = IIF(getcomments.CurrentRow MOD 2 EQ 0, "'DataA'", "'DataB'")>		
											<tr>
												<td width="130" valign="top" height="1" class="#class#"><b>Comment #currentrow#</b><br><br></td>
												<td width="376" height="1" valign="top" class="#class#">
													<strong>Posted On:</strong> #dateformat(date_entered, "mmmm d, yyyy")#<br>
													<strong>Posted By:</strong> #posted_user#<br>
													#comment#<
												</td>
												<td width="100" height="1" class="#class#">
													<FORM NAME="comment_delete" >
														<input type="hidden" value="#userid#" name="userid">
														<input type="hidden" value="#bidid#" name="bidid">
														<input type="hidden" name="projectid" value="#projectid#">
														<input type="hidden" name="deletecomment" value="#bid_commentid#">
														<input type="image" name="submit5" src="../images/delete_comment.gif" align="center" onclick="javascript:submitForm_d()" border="0" >
													</form>
												</td>
											</tr>
										</cfloop>
									</table>
								</cfoutput>
							</div>
						</cfif>
					</cfif>

					 <!---showcase display--->
					 <cfif check_showcase.recordcount is not 0>
							<h3>Project Showcase</h3>
							<div id="tabs-8">
								<cfoutput>
									<table border="0" cellpadding="5" cellspacing="0" width="100%">
										<cfloop query="check_showcase">
											<cfif currentrow mod 3 is 1>
												<tr>
											</cfif>
											<!---Left or Right column--->
											<td valign="top" width="33%">
												<table width="100%" height="225px">
													<tr>
														<td valign="top">
															<cfswitch expression="#asset_type#">
																<cfcase value="1"><!---display if photo--->
																	<!---Create on-the-fly thumbnail of the image--->
																	<cfimage action="read" name="myImage" source="d://JRun4/servers/cfusion/cfusion-ear/cfusion-war/www.paintsquare.com/photo_gallery/#photofile#">
																	<cfset maxht = 190><cfset maxwd = 130>
																	<cfset newimg = ImageNew("",maxht, maxwd, "rgb", "ffffff")>
																	<cfset ImageSetAntialiasing(newimg,"on")>
																	<cfif myImage.width GTE myImage.height>
																		<cfset ImageScaleToFit(myImage,"",maxht)>
																		<cfset ImagePaste(newimg, myImage, 0, 0)>
																	<cfelse>
																		<cfset ImageScaleToFit(myImage,maxwd,"")>
																		<cfset ImagePaste(newimg, myImage, 0, 0)>
																	</cfif>
																	<a href="#rootpath#showcase/#profile_dir#/#album_dir#/?mediaID=#mediaID#">
																		<cfimage source="#newimg#" action="writeToBrowser">
																		<cfif photoheadline is not ""><br>#photoheadline#</cfif>
																	</a>
																</cfcase>

																<cfcase value="2"><!---display if video--->
																	<cfif videothumbnail is "">
																		<a href="#rootpath#showcase/#profile_dir#/#album_dir#/?mediaID=#mediaID#">
																			<cfimage source="d:/JRun4/servers/cfusion/cfusion-ear/cfusion-war/www.paintsquare.com/video/assets/blnkvidthumb.png" action="writeToBrowser">
																			<cfif videoheadline is not ""><br>#videoheadline#</cfif>
																		</a>
																	<cfelse>
																		<cfimage action="read" name="myImage" source="d://JRun4/servers/cfusion/cfusion-ear/cfusion-war/www.paintsquare.com/video/assets/#videothumbnail#">
																		<!---cfset maxht = 190><cfset maxwd = 130>
																		<cfset newimg = ImageNew("",maxht, maxwd, "rgb", "ffffff")>
																		<cfset ImageSetAntialiasing(newimg,"on")>
																		<cfif myImage.width GTE myImage.height>
																		<cfset ImageScaleToFit(myImage,"",maxht)>
																		<cfset ImagePaste(newimg, myImage, 0, 0)>
																		<cfelse>
																		<cfset ImageScaleToFit(myImage,maxwd,"")>
																		<cfset ImagePaste(newimg, myImage, 0, 0)>
																		</cfif--->
																		<a href="#rootpath#showcase/#profile_dir#/#album_dir#/?mediaID=#mediaID#">
																		<cfimage source="#myImage#" action="writeToBrowser">
																		<cfif videoheadline is not ""><br>#videoheadline#</cfif>
																		</a>
																	</cfif>
																</cfcase>
															</cfswitch>
															<p class="smaller" style="margin-top: 0; margin-bottom: 3;">
																From <a href="#rootpath#showcase/#profile_dir#/#album_dir#">#album_name#</a> by <a href="#rootpath#showcase/#profile_dir#">#profile_name#</a>
															</p>									
															<cfif rating_total gt 0>
																<p class="smaller" style="margin-top: 0; margin-bottom: 3;">
																	Rating: #numberformat(rating_avg, '_._')#/5; #rating_total# total rating<cfif rating_total is not 1>s</cfif>
																</p>
															</cfif>
															<p class="smaller" style="margin-top: 0; margin-bottom: 3;">
																#total_views# total views
															</p>
														</td>
													</tr>
												</table>
											</td>

											<cfif currentrow mod 3 is 0>
												</tr>
											<cfelseif currentrow is recordcount>
												<cfset cspan = 3 - (currentrow mod 3)>
												<!---Spacer column--->
												<td colspan="#cspan#"></td>
												</tr>
											</cfif>
										</cfloop>
									</table>
								</cfoutput>	
							</div>
					 </cfif>
				</ul>
			</div>
			</div>
		</cfloop>