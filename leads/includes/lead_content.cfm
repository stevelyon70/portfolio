<!---
********************************
	LEAD BODY 
	CREATED BY RM 02/23/2018
*************************************
--->

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
			a.active = 1 and a.bidID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#b#">
			and a.mediaID in (select contentID from tags_log where tagID = #site_tagID# and content_typeID = 1942)
		group by a.mediaID, a.albumID, b.album_name, b.album_dir, c.profile_dir, a.psuID, a.assetID, c.profile_name, a.asset_type, a.rating_avg, a.rating_total, a.date_posted, a.bidID, d.headline, d.photo_file, e.title, e.video_file, e.yt_embed, e.thumbnail, a.sort
		order by a.date_posted desc
	</cfquery>
	 <cfstoredproc procedure="pbt_project_detail" datasource="#application.datasource#" >
		<cfprocparam type="in" dbvarname="@bidid" cfsqltype="CF_SQL_INTEGER" value="#b#">
		<cfprocresult name="getdetail" resultset="1">
	  </cfstoredproc>
	<cfinvoke  
		component="cfc.documents"  
		method="listDocuments"  
		returnVariable="listDocuments"> 
		<cfif getdetail.bidID NEQ ""><cfinvokeargument name="bidID" value="#getdetail.bidID#"/><cfelse><cfinvokeargument name="bidID" value="0"/></cfif> 
		<cfif getdetail.vendorID NEQ ""><cfinvokeargument name="vendorID" value="#getdetail.vendorID#"/></cfif>
	</cfinvoke>


	 <cfif isdefined("session.auth.userID") and session.auth.userID NEQ ""><!---run if not coming from showcase--->

		<cfif not isdefined("session.packages") or (isdefined("session.packages") and session.packages EQ "")>
			<cfquery name="checkuserpackage" datasource="#application.datasource#">
			select distinct bid_subscription_log.packageid
			from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
			where bid_users.userid =  <cfqueryPARAM value = "#session.auth.userID#" CFSQLType = "CF_SQL_INTEGER"> 
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
			<CFQUERY NAME="GET_Sub_TAGS" DATASOURCE="#application.datasource#">
				select * 
				from pbt_tags
			</cfquery>
		<cfset variable.user_tags = valuelist(GET_Sub_TAGS.tagID)>
		</cfif>


		<cfquery name="check_user_st" datasource="#application.datasource#">
		select distinct * from bid_users where userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userID#"> and bt_status = 1
		</cfquery>

		<cfif check_user_st.recordcount is 0>
		<cfset valid = false>
		<!---<cflocation url="?userid=#session.auth.userID#" addtoken="No">--->
		</cfif>

		<!---check to see if user is auth. to receive paint bids, if not send them back--->
		<cfquery name="checkuser" datasource="#application.datasource#">select distinct bid_user_suppliers.basicpkg,bid_user_suppliers.aebids,bid_user_suppliers.awards from bid_user_suppliers inner join bid_users on bid_users.sid = bid_user_suppliers.sid where bid_users.userid = #session.auth.userID#</cfquery>                                                  

		<cfquery  name="getsid" datasource="#application.datasource#">select sid from bid_users where userid = <cfqueryPARAM value = "#session.auth.userID#" CFSQLType = "CF_SQL_INTEGER"></cfquery>
		<cfquery name="checktrack_status" datasource="#application.datasource#" >
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
		and bid_user_project_folders.folderID not in (select folderID from pbt_user_folders_deletions where userID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userID#">)
		and bid_user_project_bids.active = 1
		</cfquery><!---<cfdump var="#checktrack_status#"><cfabort>--->
			<cfif checktrack_status.recordcount is not 0>
				<cfquery name="checknotes" datasource="#application.datasource#">
					select bid_user_project_comments.bid_commentid
					from bid_user_project_comments inner join bid_user_project_bids on bid_user_project_comments.projectid = bid_user_project_bids.projectid
					where bid_user_project_bids.bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#b#"> and bid_user_project_comments.active = 1 and bid_user_project_comments.projectid = #checktrack_status.projectid# 
					order by bid_user_project_comments.date_entered desc,bid_user_project_comments.bid_commentid desc
				</cfquery>
			</cfif>	
	 </cfif>




		 <cfquery name="insertbid" datasource="#application.datasource#">
		 insert into bid_user_viewed_log
		 (bidid,userid,dateviewed)
		 values('#b#',<cfif isdefined("userID") and userID NEQ "">#session.auth.userID#<cfelse>NULL</cfif>,#date#)
		 </cfquery>


		<cfquery name="insert_usage" datasource="#application.datasource#">
			INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
			VALUES(<cfif isdefined("userID") and userID NEQ "">#session.auth.userID#<cfelse>NULL</cfif>,'#cfid#',#date#,36,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
		</cfquery>

		<!---check to verify user is approved for these tags--->
		<cfif isdefined("variable.user_tags")>
				<cfquery name="get_tags1" datasource="#application.datasource#">
				select distinct pbt_project_master_cats.tagID,pbt_tags.tag
				from pbt_project_master_cats
				left outer join pbt_tags on pbt_tags.tagID = pbt_project_master_cats.tagID
				where pbt_tags.active = 1 and pbt_project_master_cats.bidID = <cfqueryPARAM value = "#b#" CFSQLType = "CF_SQL_INTEGER"> 
				and pbt_project_master_cats.tagID in (#variable.user_tags#)
				--and pbt_tags.tag_typeID <> 9
				order by tag 
				</cfquery>
			<cfif get_tags1.recordcount EQ 0>
				<cfset valid = false>
				<!---<cflocation url="../index.cfm">--->
			</cfif>
		</cfif>

		<cfquery name="get_tags" datasource="#application.datasource#">
				select distinct pbt_project_master_cats.tagID,pbt_tags.tag
				from pbt_project_master_cats
					left outer join pbt_tags on pbt_tags.tagID = pbt_project_master_cats.tagID
				where pbt_tags.active = 1 
					and pbt_project_master_cats.bidID = <cfqueryPARAM value = "#b#" CFSQLType = "CF_SQL_INTEGER">
				--and pbt_tags.tag_typeID <> 9
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
			where pbt_project_stage.bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#b#"> and pbt_award_contractors.supplierid <> 9000 
			and pbt_project_stage.stageID = (select max(stageID) from pbt_project_stage where bidID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#b#">)
			and pbt_award_contractors.typeID <> 3
			order by pbt_award_contractors.awarded desc,pbt_award_contractors.amount
		</cfquery>
		<!---Run check for O results--->
		<cfif getlow.recordcount EQ 0>
			<cfquery name="getlow_text" datasource="#application.datasource#">
				select bidID,companyname,amount,address,city,state,postalcode,emailaddress,firstname + lastname as contactname,lowbidder
				from pbt_project_onvia_award_results
				left outer join state_master on state_master.stateid = pbt_project_onvia_award_results.stateid 
				where bidID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#b#">
			</cfquery>
		</cfif>
		<cfquery name="getnotes" datasource="#application.datasource#">
			select distinct pbt_project_award_stage_detail.award_editornote as editornotes 
			from pbt_project_award_stage_detail 
			where bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#b#">
		</cfquery>
		<cfquery name="getplandate" datasource="#application.datasource#">
			select max(receivedate) as datereceived 
			from bid_planholders 
			where bidid =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#b#"> 
			and bid_planholders.active is null
			and (companyname is not null or firstname is not null or lastname is not null) 
		</cfquery>				

		<cfquery name="getplanlist" datasource="#application.datasource#">
			select distinct companyname,city,bid_planholders.state,contactphone,companyphone,companyfax,state_master.state,
			address1,postalcode,firstname,lastname,emailaddress,bid_planholders.stateid 
			from bid_planholders 
			left outer join state_master on state_master.stateid = bid_planholders.stateid  
			where bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#b#"> 
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

	<cfsavecontent variable="leadDetail_#b#">	
			<cfloop query="getdetail">
				<cfoutput>

					<div class="row">	
						<div class="col-sm-12">
						  <h3>Project: #projectname#</H3>
						  <hr style="border-top: 1px solid ##8c8b8b;">
						</div>	
					</div>	

					<div class="row">						
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-6">
							<table>
								<tr>
									<td width="125">BidID:</td>
									<td>#b#</td>
								</tr>
								<tr>
									<td width="125">Project Number:</td>
									<td>#projectnum#</td>
								</tr>
								<tr>
									<td width="125" valign="top">Owner:</td>
									<td>								
									<cfif isdefined("supplierID") and supplierID NEQ "">
										<a href="#request.rootpath#agency/?agency&supplierID=#supplierID#&userid=#session.auth.userID#"><strong>#owner#</strong></a>
									<cfelse>								
										#owner#
									</cfif>	
									</td>
								</tr>
								<tr>
									<td width="125">Date Posted:</td>
									<td>#dateformat(paintpublishdate, "m/d/yyyy")#</td>
								</tr>
								<CFIF ISDEFINED("EDITDATE")>
									<tr>
										<td>Updated on:</td> 
										<td>
											<cfif dateformat(edate) NEQ dateformat(paintpublishdate)>
												#dateformat(EDATE, "mmmm d, yyyy")#
											</cfif>								
										</td>
									</tr>
								</cfif>	
								<cfif prebid NEQ "">
									<tr>
										<td>Pre-Bid Meeting Date:</td> 
										<td>#prebid#</td>
									</tr>
								</cfif>		
								<cfif prebidnotes NEQ "">
									<tr>	
										<td width="125" valign="top">Pre-Bid Notes:</td> 
										<td>#prebidnotes#</td>
									</tr>
								</cfif>		
								<cfif (minimumvalue NEQ "" and minimumvalue NEQ "0") or (maximumvalue NEQ "" and maximumvalue NEQ "0")>
									<tr>
										<td width="125" valign="top">Cost Estimate:</td> 
										<td>
											<cfif minimumvalue NEQ "" and minimumvalue NEQ "0">
												$#numberformat(minimumvalue)#
											</cfif> 
											<cfif minimumvalue NEQ "" and minimumvalue NEQ "0" and maximumvalue NEQ "" and maximumvalue NEQ "0">-</cfif> 
											<cfif maximumvalue NEQ "" and maximumvalue NEQ "0">$#numberformat(maximumvalue)#</cfif>
										</td>
									</tr>	
								</cfif>
								<tr>		
									<td>Stage:</td> 
									<td>#stage#</td>	
								</tr>	
								<cfif valuetypeid is 1 or valuetypeid is 2>
									<tr>
									<td>Type of Contract:</td> 
									<td>
										<cfif valuetypeid EQ 1>General Contract<cfelseif valuetypeid EQ 2>Painting</cfif>
									</td>
									</tr>
								</cfif>	
								<cfif city NEQ "" or county NEQ "" or primary_location_state NEQ "" or zipcode NEQ "">
									<tr>
										<td width="125" valign="top">Location:</td> 
										<td>
											<cfif city NEQ "">
												#capsfirst(city)#,

											<cfelse> 
												<cfif county NEQ "">
													#capsfirst(county)#

												</cfif>
											</cfif>
											<cfif primary_location_state NEQ "">
												#primary_location_state#

											</cfif> 
											<cfif zipcode NEQ "">
												#zipcode#

											</cfif>										
										</td>
									</tr>
								</cfif>								
								<cfif submittaldate NEQ "">
									<tr>
										<td>Submittal Date:</td> 
										<td>#dateformat(submittaldate, "m/d/yyyy")#</td>
									</tr>
								</cfif>
								<cfif planprice NEQ "">
									<tr>
										<td>Plan Price:</td> 
										<td>#planprice#</td>
									</tr>
								</cfif>
								<cfif projectstartdate NEQ "">
									<tr>
										<td>Project Start Date:</td> 
										<td>#projectstartdate#</td>
									</tr>
								</cfif>
								<cfif projectsize NEQ "">
									<tr>
										<td>Project Size:</td> 
										<td>#projectsize#</td>
									</tr>
								</cfif>	 																																																																																																																																																																																																																	
							</table>																		
						</div>			
					</div>

					<cfif get_tags.recordcount GT 0>
						<div class="row">	
							<div class="col-sm-12">	
								<hr style="border-top: 1px solid ##8c8b8b;">		 	
								<h5>RELEVANT TAGS</h5> 
								<cfloop query="get_tags">							
									<a href="#request.rootpath#search/?search_history=1&action=sresults&state=66&projecttype=1&project_stage=1&project_stage=2&project_stage=3&project_stage=4&tags=#get_tags.tagID#"><span class="tags pull-left">
										#get_tags.tag#</span></a>
								</cfloop>
							</div>
						</div>
					</cfif>

				</cfoutput>

				<div class="demo">
					<cfif isdefined("bidtypeID") and (bidtypeID EQ "5" or bidtypeID EQ "6")  and ((getlow.recordcount GT 0 or getlow_text.recordcount GT 0) or (isdefined("award_editornotes") and award_editornotes NEQ ""))>
						<hr style="border-top: 1px solid #8c8b8b;">
						<h5>BID RESULTS</h5>
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
															<a href="#request.rootpath#contractor/?contractor&supplierID=#getlow.supplierID#&userid=#session.auth.userID#" style="text-decoration:none; font-weight:bold;">
															#companyname#
															</a>
														<cfelse>
															#companyname#
														</cfif>
													</td>
													<td width="213">
														Bid Amount:&nbsp; #dollarformat(amount)#
													</td>
												</tr>

												<cfif billingaddress NEQ "" or city NEQ "" or state NEQ "" or postalcode NEQ "">
													<tr>
														<td width="24" align="right">&nbsp;</td>
														<td width="562" colspan="3" >
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
															Email Address: <cfif emailaddress NEQ ""><a href="mailto:#emailaddress#">#emailaddress#</a><cfelse>Not Available</cfif>
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
																where pbt_project_stage.bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#b#"> and pbt_award_contractors.supplierid <> 9000 
																and pbt_project_stage.stageID = (select max(stageID) from pbt_project_stage where bidID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#b#">)
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
																			<td width="94%" colspan="2">Email Address: <cfif getlow2.emailaddress NEQ ""><a href="mailto:#getlow2.emailaddress#">#getlow2.emailaddress#</a><cfelse>Not Available</cfif></td>
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
						<hr style="border-top: 1px solid #8c8b8b;">	
						<h5>EDITOR NOTE</h5>
						<div id="tabs-1">
								<cfoutput>
									<p>#trim(editornotes)#</p>
								</cfoutput>
						</div>			
					</cfif>

					<hr style="border-top: 1px solid #8c8b8b;">	
					<h5>OWNER DETAILS</h5>
					<div id="tabs-2">
						<cfoutput>
						<p>				
							<table>
								<cfif isdefined("psowner") and psowner is not "">
									<tr>
										<td width="130" valign="top" height="1" style="font-weight: bold;">Owner:</td>
										<td height="1" colspan="2">
											<cfif isdefined("supplierID") and supplierID is not "">
												<a href="#request.rootpath#agency/?agency&supplierID=#supplierID#&userid=#session.auth.userID#" style="color:##2d53ac; text-decoration:none; font-weight:bold;">
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
												<a href="#owner_url#" target="_blank" >
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
														<a href="#request.rootpath#/engineer/?engineer&engineerID=#engineerID#&userid=#session.auth.userID#" style="color:##2d53ac; text-decoration:none; font-weight:bold;" target="_blank">									
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
						<hr style="border-top: 1px solid #8c8b8b;">
						<h5>LINKS</h5>
						<div id="tabs-3">

							<cfoutput>
								<table>

									<cfif isdefined("fbo_url") and fbo_url is not "">
										<tr><td style="font-weight: bold;">FBO Web Site:</td></tr>
										<tr>
											<td>																				
												<cfif fbo_url is not ""> 
													<!---a href="<cfif NOT findnocase('http://',#fbo_url#) or NOT findnocase('https://',fbo_url)>http://</cfif>#fbo_url#" target="_blank" --->
													<a href="#fbo_url#" target="_blank" >
													#fbo_url#
													</a>
												<cfelse>
													Not Available
												</cfif>												
											</td>
										</tr> 
									</cfif>


									<cfif isdefined("url1") and url1 is not "" or isdefined("url2") and url2 is not "" or isdefined("url3") and url3 is not "">
										<tr><tdstyle="font-weight: bold;">Related Documents/Links:</td></tr>
										<tr>											
											<td>
												<cfif url1 is not "">
													<b>
													<cfif isdefined("doctype1") and doctype1 is not "">
														#doctype1# ## 1:
													</cfif>										
													<!---a href="<cfif NOT findnocase('http://',#url1#) or NOT findnocase('https://',#url1#)>http://</cfif>#url1#" target="_blank"--->			<a href="#url1#" target="_blank">														
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
													<a href="#url2#" target="_blank" >
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
													<a href="#url3#" target="_blank" >
														click to open #doctype3# ## 3
													</a>
													</b>
												</cfif>
											</td>
										</tr>
									<cfelseif isdefined("url1") and url1 is not "">							
										<tr><td style="font-weight: bold;">Link:</td></tr>
										<tr>											
											<td>
												<cfif url1 is not "">
													<b>
													<a href="#url1#" target="_blank" >
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
						<hr style="border-top: 1px solid #8c8b8b;">
						<h5>SPECIFICATIONS/DOCUMENTS</h5>
							<cfinclude template="documents_inc.cfm">		
					</cfif>

					<cfif getplanlist.recordcount GT 0>
						<cfset colnum = round(getplanlist.RecordCount/2)>
						<hr style="border-top: 1px solid #8c8b8b;">
							<h5>PLAN HOLDERS</h5>
						<div id="tabs-5">						
							<table>				
								<tr>
									<td width="20%" valign="top" style="font-weight: bold;">Planholders List</td>
									<td  colspan="2">As of <cfoutput>#dateformat(getplandate.datereceived,"mmmm d, yyyy")#</cfoutput>
										<table width="100%" cellpadding=2 cellspacing=0 border=0>
											<tr><td>&nbsp;</td></tr>
											<tr valign="top">								
												<td width="50%" height="20">
													<cfoutput query="getplanlist">											
														<cfif companyphone is not "">			
															<cfset ph = rereplace(companyphone,"[^0-9]","","all")>
															<cfset length = len("#ph#")>
															<cfset phon = mid(#ph#,"1","3")>
															<cfset phon2= mid(#ph#,"4","3")>
															<cfset phon3=mid(#ph#,"7","4")>
															<cfset phonenumber="(#phon#) #phon2#-#phon3#">
														</cfif>	

														<cfif companyphone is "">	
															<cfif contactphone is not "">	
																<cfset ph = rereplace(contactphone,"[^0-9]","","all")>
																<cfset length = len("#ph#")>
																<cfset phon = mid(#ph#,"1","3")>
																<cfset phon2= mid(#ph#,"4","3")>
																<cfset phon3=mid(#ph#,"7","4")>
																<cfset phonenumber="(#phon#) #phon2#-#phon3#">
															</cfif>	
														</cfif>	

														<cfif companyfax is not "">
															<cfset fx = rereplace(companyfax,"[^0-9]","","all")>
															<cfset length = len("#fx#")>
															<cfset fax = mid(#fx#,"1","3")>
															<cfset fax2= mid(#fx#,"4","3")>
															<cfset fax3=mid(#fx#,"7","4")>
															<cfset faxnumber="(#fax#) #fax2#-#fax3#">
														</cfif>

														<cfif companyname is "">
															<strong>Not Available</strong>
														<cfelse>
															<strong>#companyname#</strong>
														</cfif>
														<br>
														<cfif address1 NEQ "">
															#address1#<br>
														</cfif>
														<cfif city NEQ "">
															#city#,
														</cfif>
														<cfif stateid NEQ 66> 
															#state#
															<cfif postalcode NEQ ""> 
																#postalcode#
															</cfif>
															<br>
														</cfif>
														<cfif firstname NEQ "" and lastname NEQ ""> 
															Contact: <cfif firstname NEQ "">#trim(firstname)#</cfif> <cfif lastname NEQ "">#trim(lastname)#</cfif>
															<br>
														</cfif>
														<cfif emailaddress NEQ "">Email: <a href="mailto:#trim(emailaddress)#">#trim(emailaddress)#</a><br></cfif>
														<cfif contactphone NEQ "">Phone: #trim(phonenumber)#<br></cfif>
														<cfif companyfax NEQ "">Fax:  #trim(faxnumber)#<br></cfif>
													<br>
													<cfif currentrow EQ colnum>
														</td><td width="5%">&nbsp;</td><td>
													</cfif>	
													</cfoutput>	
													</td>
											</tr>														   
										</table>
									</td>		
								</tr>
							</table>						
						</div>			
					</cfif>

					<!--- DO NOT UNDERSTAND LOGIC HERE
					<cfif isdefined("bidtypeID") and (bidtypeID EQ "5" or bidtypeID EQ "6")  and ((getlow.recordcount GT 0 or getlow_text.recordcount GT 0) or (isdefined("award_editornotes") and award_editornotes NEQ ""))>
					<li><a href="#tabs-6">Description</a></li>
					<cfelse>
					<li><a href="#tabs-6">Description</a></li>
					</cfif>--->

					<hr style="border-top: 1px solid #8c8b8b;">
					<h5>DESCRIPTION</h5>
					<div id="tabs-6">
							<cfoutput>
								<p>#trim(description)#</p>
							</cfoutput>
					</div>		

					<cfif isdefined("userID") and userID NEQ ""><!---only show if a subscriber--->
						<cfif checktrack_status.recordcount is not 0>		 	
							<hr style="border-top: 1px solid #8c8b8b;">
							<h5>MY REPORT INFO</h5>
							<div id="tabs-7">
								<cfoutput>
									<p>
										<strong>
										You are currently tracking this project in your 
										<a href="../myaccount/folders/?action=folder&userid=#session.auth.userID#&id_mag=#checktrack_status.folderid#" style="color:##2d53ac; text-decoration:none; font-weight:bold;">
										#checktrack_status.foldername#
										</a>
										folder.
										</strong>
									</p>
									<br />
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
													#comment#
												</td>
												<td width="100" height="1" class="#class#">

												</td>
											</tr>
											<tr><td>&nbsp;</td></tr>
										</cfloop>
									</table>
								</cfoutput>
							</div>
						</cfif>
					</cfif>

					 <!---showcase display--->
					 <cfif check_showcase.recordcount is not 0>
						<hr style="border-top: 1px solid #8c8b8b;">
						<h5>PROJECT SHOWCASE</h5>
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

				</div>
				<div>
					 <hr style="border-top: 1px solid #8c8b8b;">
				</div>			
			</cfloop>

		<style>
			h3{
				margin-top: 10px !important;
			}													
		</style>	
	</cfsavecontent>
