<!--- file from aws ---> 
<!-- slyon 1/17/17 -->

<cfif isdefined("comp")>
 	<cfset adminuserid= adminuserid>
	<cfquery name="get_user" datasource="#application.dataSource#">
		select * from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where userid = #adminuserid# and bid_users.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where reg_users.username = '#session.auth.username#')
	</cfquery>
	<cfif get_user.recordcount is 0 ><cflocation url="?action=91&9" addtoken="Yes"></cfif>
	<cfquery name="get_user1" datasource="#application.dataSource#">
		select * from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where userid = #url.userid# and bid_users.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where reg_users.supplierid = #get_user.supplierid#)
	</cfquery>
	<cfif get_user1.recordcount is 0 ><cflocation url="?action=91&13" addtoken="Yes"></cfif>
<cfelse>
 	<cfset adminuserid = session.auth.userid>
 	<cfquery name="checkprefs" datasource="#application.dataSource#">
 		select top 1 *
 		from pbt_user_email_pref
 		where userid = #session.auth.userid#
	</cfquery>
	<cfif checkprefs.recordcount eq 0>
		<cfquery name="qUserTags" datasource="#application.dataSource#">
			insert into	pbt_user_email_pref
			(userid, dailyUpdates,getSavedSearchEmail,stages,projectTypes,sendInterval,updatedOn, budget,states)
			values
			(<cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">, 1,1,'1,2,3,4,7,8,9',3,1,'#datetimeformat(now(), "yyyy-mm-dd hh:mm:ss")#',1,66)	
		</cfquery>
		<cfquery datasource="#application.dataSource#">
			delete
			FROM pbt_user_email_tag
			where userID= <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">
		</cfquery>	
		<cfquery  datasource="#application.dataSource#">
			INSERT INTO pbt_user_email_tag
			(userID, tagID, active, enteredOn)
			values
			(#session.auth.userid#, '10000', 1, '#dateformat(now(), 'yyyy-mm-dd')#')
		</cfquery>		
	</cfif>
	<cfquery name="get_user1" datasource="#application.dataSource#">
		select reg_userid, name, email, emailaddress, pref.dailyUpdates, pref.getSavedSearchEmail, pref.updatedOn, pref.stages, pref.projectTypes, pref.sendInterval ,pref.budget,bid_users.userid, pref.states
		from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid 
		inner join pbt_user_email_pref pref on pref.userid =  bid_users.userid
		where bid_users.userid = #session.auth.userid# 
			and bid_users.userid in (
								select bid_users.userid 
								from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid 
								where reg_users.username = '#session.auth.username#')
	</cfquery>
	<cfif get_user1.recordcount is 0 ><cflocation url="?action=91&26" addtoken="Yes"></cfif>
</cfif> 
<!---if demo account redirect back to not allow preference changes--->
<cfif session.auth.userid is 584 ><cflocation url="?action=91&29" addtoken="Yes"></cfif> 

<cfif isDefined("get_user")>
	<cfset emails_select = get_user.email>
<cfelse>
	<cfset emails_select = get_user1.email>
</cfif>

<cfset user = session.auth.userid> 
<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<cfquery name="insert_usage" datasource="#application.dataSource#">
INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
VALUES(#session.auth.userid#,'#cfid#',#date#,55,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
</cfquery>
<cfquery name="insertcfid" datasource="#application.dataSource#">
INSERT INTO CLOG (cfid,visitdate,siteid,remoteip,remotehost,localaddress)
VALUES('#cfid#',#date#,'26','#cgi.remote_addr#', '#cgi.remote_host#','#cgi.local_address#')
</cfquery>

<cfparam default="1,2,3,4" name="variable.user_tags" />
			<cfif isdefined("dashboard")>
				<cfset processlink = "account/email_pref_save.cfm?action=103&userid=#user#&adminuserid=#adminuserid#">
			<cfelse>
				<cfset processlink = "email_pref_save.cfm?action=103&userid=#user#&adminuserid=#adminuserid#">
			</cfif>
<!---REMOVE QUERY AFTER DEVELOPMENT--->
		<CFQUERY NAME="GET_TAGS_FOR_TESTING" DATASOURCE="#application.dataSource#">
			select * from pbt_tags
		</cfquery>
	<cfset user_tags = valuelist(get_tags_for_testing.tagID)>

 	<cfquery name="pull_industrial_structures" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 	inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 1 and pbt_tags.tag_typeID = 1
	 	and tag_parentID <> 0
	 order by pbt_tags.tag
 	</cfquery>    
 	
 	<cfquery name="pull_commercial_structures" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 	inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 2 and pbt_tags.tag_typeID = 1
		 and tag_parentID <> 0
	 order by pbt_tags.tag
 	</cfquery>  
 	<cfquery name="pull_gc_scopes" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
		 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 3 and pbt_tags.tag_typeID = 2
		 and tag_parentID <> 0
	 order by pbt_tags.tag
 	</cfquery> 
 	
 	<cfquery name="pull_professional_services" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
		 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 4 and pbt_tags.tag_typeID = 5
		 and tag_parentID <> 0
	 order by pbt_tags.tag
 	</cfquery> 
 	             
 	<cfquery name="pull_supply_ops" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
		 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 5 and pbt_tags.tag_typeID = 2
		 and tag_parentID <> 0
	 order by pbt_tags.tag
 	</cfquery>   
 	<cfquery name="pull_qualifications" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
		 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 6 and pbt_tags.tag_typeID = 4
		 and tag_parentID <> 0
	 order by pbt_tags.tag
 	</cfquery> 	             
 
 <cfquery name="pull_tag_coatingsType" datasource="#application.dataSource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
 	 SELECT [tagID],[tag]
	 FROM [paintsquare].[dbo].[pbt_tags]
	 where tag_parentID <> 0 and tag_typeID =3 and active = 1
	 order by pbt_tags.tag
 </cfquery> 
  
 <cfquery name="pull_tag_coatingsManuf" datasource="#application.dataSource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
 	 SELECT [tagID],[tag]
	 FROM [paintsquare].[dbo].[pbt_tags]
	 where tag_parentID <> 0 and tag_typeID =9 and active = 1
	 order by pbt_tags.tag
 </cfquery>  
 			
 							
<cfquery name="getcustomerstates" datasource="#application.dataSource#"><!---get the user states--->
	select b.stateid 
	from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
	where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  and b.packageid in (1,2,3,4,5,6,7,8,9,12) and a.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where reg_users.username = '#session.auth.username#' and bid_users.bt_status = 1)
</cfquery>
<cfif getcustomerstates.recordcount is 0 ><cflocation url="?action=91&169" addtoken="Yes"></cfif>
<cfset states = "#valuelist(getcustomerstates.stateid)#">
<cfquery name="state" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
	select stateID,fullname 
	from state_master 
	where (stateid in (#states#) and countryid = 73) or stateid in (66)  
	order by fullname  
</cfquery>


<cfquery name="insert_usage" datasource="#application.dataSource#">
INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
VALUES(#session.auth.userid#,'#cfid#',#date#,8,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
</cfquery>

	
<cfquery name="qUserTags" datasource="#application.dataSource#">
	SELECT pk_id, userID, tagID, active, enteredOn 
	FROM pbt_user_email_tag
	where userID= 	<cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">
	order by tagID
</cfquery>	 	
<cfset variable.user_tags = valuelist(qUserTags.tagID)>	
<cfquery name="checkuser" datasource="#application.dataSource#">
	select bid_user_suppliers.supplierid,bid_user_suppliers.basicpkg,bid_user_suppliers.aebids,bid_user_suppliers.awards 
	from bid_user_suppliers inner join bid_users on bid_users.sid = bid_user_suppliers.sid 
	where bid_users.userid = #session.auth.userid#
</cfquery>
<cfif checkuser.supplierid eq 9000> <!--- set eq to supplierid to limit --->
				      
<cfoutput query="get_user1">		   	
			   						
	<div class="page-header">
	<h3>Daily Email Settings for  <small> <b>#name#</b> last updated #datetimeformat(updatedOn,'mmm d @ hh:mm tt')#</small></h3>
	</div>
	<div class="page-header">				
		To resend or view a previous bid notice and award emails with your new settings applied after saving, select the desired date from the calendar and click "Resend Email."<br><br>
		<input type="text" name="reportDate" id="reportDate" placeholder="Select Report Date" /> <button type="button" class="btn btn-primary" id="reportRunBtn">Resend Email</button> 
		<div id="reportRunID"></div><div class="hidden" id="clearmsgdiv"><button name="clearmsg" id="clearmsg" class="btn btn-warning">Clear Result</button></div>
		<br><br>
	</div>
	
	<form name="registration" action="<cfoutput>#processlink#</cfoutput>" method="post" >
		<input type="hidden" name="redir" value="..<cfoutput>#CGI.SCRIPT_NAME#</cfoutput>" />
		<input type="hidden" name="reg_userid" value="#reg_userid#">	
		<div class="container">			
			<div class="col-xs-12 col-sm-12 col-md-12 col-lg-6 pull-left">
				<!--- Email Address --->
				<div class="col-md-12 col-xs-12 pull-left">
					<div class="sectionHead">Email Address</div>
					<div class="sectionBody2">
						<div class="form-row">
							<div class="col-sm-12">
							<input type="text" name="emailaddress" value="#emailaddress#" size="50">
							<cfif isdefined("err")><font color="red" size="1">You have entered an invalid emailaddress.</font></cfif>
							</div>
						</div>
					</div>
				</div>	
				<!--- Email Preferences --->
				<div class="col-md-12 col-sm-12 col-xs-12 pull-left">
					<div class="sectionHead">Email Preferences</div>
					<div class="sectionBody">
						<div class="form-row"><div class="col-sm-12">I would like to...</div></div>
						<div class="form-row"><div class="col-sm-2"><input type="radio" name="emails" id="email1" value="1" checked></div><div class="col-sm-10"><label for="email1">Receive Paint BidTracker Daily Emails</label></div></div>
						<div class="form-row"><div class="col-sm-2"><input type="radio" name="emails" id="email2" value="0"></div><div class="col-sm-10"><label for="email2">Not Receive Emails</label></div></div>	


						<div class="form-row"><div class="col-sm-12">------------</div></div>
						<div class="form-row"><div class="col-sm-2"><input type="radio" name="savedSrchEmail" id="srchemail1" value="1" <cfif isdefined("email") and email is not "111">checked</cfif>></div><div class="col-sm-10"><label for="srchemail1">Receive Paint BidTracker Saved Searches via Email</label></div></div>
						<div class="form-row"><div class="col-sm-2"><input type="radio" name="savedSrchEmail" id="srchemail2" value="0" <cfif isdefined("email") and email is "111">checked</cfif>></div><div class="col-sm-10"><label for="srchemail2">Not Receive Paint BidTracker Saved Searches via Email</label></div></div>	
					</div>
				</div>
				<!--- buttons --->
				<div class="col-md-12 col-xs-12 col-sm-12">
					<div class="sectionButtons">
						<input name="SAVE" type="submit" value="Save" id="ssearch" class="btn btn-primary">
					</div>
					<div class="sProcess hidden">Saving...  <img src='../../assets/images/spinner.svg'></div>
				</div>				
				<!--- Spacer --->
				<div class="col-md-12 col-xs-12 pull-left">&nbsp;</div>
			</div>
			<div class="col-xs-12 col-md-6 pull-left">&nbsp;</div>
			<div class="row">
  				<div class="col-md-8 col-md-offset-2 col-xs-12 col-sm-12">
				<p>
				<b>Please note:</b> Choosing a budget amount, structure type, scope, coating manufacturer, supply opportunity, qualification, or coating type tag(s) will 
				narrow your search results, reducing the number of bids you receive daily. We advise that you utilize the "Resend Email" option at the top of the page after 
				saving your settings to be sure that your setting choices are giving you the results you'd like to see. For assistance, please contact Josiah Lockley at <a href="mailto:jlockley@paintbidtracker.com">jlockley@paintbidtracker.com</a> or 412-697-0268.
				</p>
				</div>
			</div>			
			<div class="col-xs-12 col-sm-12 col-md-6 pull-left">
				<!--- project types --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">
					<div class="sectionHead">Project Types</div>
					<div class="sectionBody">
						<div class="form-row"><div class="col-sm-2"><input name="projecttype" type="radio" value="3" checked></div><div class="col-sm-10">All Contracts (Includes all painting jobs, as well as unverified jobs)</div></div>	
						<div class="form-row"><div class="col-sm-2"><input name="projecttype" type="radio" value="1"></div><div class="col-sm-10">Verified Painting (All verified painting work, includes prime painting)</div></div>
						<div class="form-row"><div class="col-sm-2"><input name="projecttype" type="radio" value="2" ></div><div class="col-sm-10">Prime Painting Contracts Only (Painting is primary scope)</div></div>
						<!---<cfif checkuser.supplierid eq 9000><div class="form-row"><div class="col-sm-2"><input name="projecttype" type="radio" value="4" ></div><div class="col-sm-10">Non-verified projects (no painting/painting not confirmed)  </div></div></cfif>--->
					</div>
				</div>	
				<!--- Spacer --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">&nbsp;</div>				
				<!--- proj budget --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">
					<div class="sectionHead">Total Project Budget<span data-content="To add more than one estimate range, hold down Ctrl key on PC or Command key on Mac while clicking." data-trigger="hover" class="popovers"><i class="fa fa-info-circle fa-lg" aria-hidden="true"></i></span></div>
					<div class="sectionBody">
						<select name="amount" size="4" multiple class="formSelect form-control" id="budgetAmt">
							<option value="1" SELECTED>Any</option>
							<option value="2">< $100,000</option>
							<option value="3">$100,000 - $500,000</option>
							<option value="4">$500,000 - 1 million</option>
							<option value="5">Over 1 million</option>
						</select>
					</div>
				</div>	
				<!--- Spacer --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">&nbsp;</div>					
				<!--- state --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">
					<div class="sectionHead">State(s)<span data-content="To add more than one state, hold down Ctrl key on PC or Command key on Mac while clicking." data-trigger="hover" class="popovers"><i class="fa fa-info-circle fa-lg" aria-hidden="true"></i></span></div>
					<div class="sectionBody">
						<select name="state" size="4" query="state" value="stateid" display="fullname" multiple selected="66" class="formSelect form-control" id="statePrefs">
							<cfloop query="state">
								<option value="#stateid#">#fullname#</option>
							</cfloop>
						</select>
					</div>
				</div>
				<!--- Spacer --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">&nbsp;</div>					
				<!--- stage --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">
					<div class="sectionHead">Project Stage <span class="normal">(select all that apply - minimum 1 )</span><span data-content="To remove a stage, click the 'x'. To restore, reselect the tag by clicking in the white space." data-trigger="hover" class="popovers"><i class="fa fa-info-circle fa-lg" aria-hidden="true"></i></span></div>
					<div class="sectionBody">	
						<select placeholder="Select Stage(s)" name="project_stage" multiple="multiple" id="project_stage" class="form-control search-select-structure">
							<option value="1" <cfif listfind(stages,1)>selected</cfif>>Advanced Notices</option>
							<option value="2" <cfif stages EQ "" OR listfind(stages,2)>selected</cfif>>Current Bids</option>				
							<option value="3" <cfif listfind(stages,3)>selected</cfif>>Current Engineering & Design Notices</option>				
							<option value="4" <cfif listfind(stages,4)>selected</cfif>>Current Subcontracting Notices</option>
							<option value="7" <cfif listfind(stages,7)>selected</cfif>>Apparent Low Bids</option>
							<option value="8" <cfif listfind(stages,8)>selected</cfif>>Awards</option>				
							<option value="9" <cfif listfind(stages,9)>selected</cfif>>Engineering & Design Awards</option>		
						</select>
					</div>
				</div>	
				<!--- Spacer --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">&nbsp;</div>							
				<!--- Structures --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">
					<div class="sectionHead">Structure Types <span class="normal">(select all that apply)</span><span data-content="To remove a structure, click the 'x'. To restore, reselect the tag by clicking in the white space." data-trigger="hover" class="popovers"><i class="fa fa-info-circle fa-lg" aria-hidden="true"></i></span></div>
					<div class="sectionBody">
						<cfoutput>         		
						  <div id="structures">
							<select placeholder="Select Structure Types" name="tags" multiple="multiple" id="structures" class="form-control search-select-structure">
								<option value="10000" <cfif listfind(variable.user_tags,10000)>selected</cfif>>All Structures</option>
								<option value="10001" <cfif listfind(variable.user_tags,10001)>selected</cfif>>All Industrial Structures Below</option>							
								<cfloop query="pull_industrial_structures">
									<option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option>								
									<cfquery name="check_subs" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
									 select pbt_tags.tag,pbt_tags.tagID
									 from pbt_tags
									 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
									 and tag_parentID <> 0
									 order by pbt_tags.tag
									</cfquery>											
									<cfif check_subs.recordcount GT 0>
									   <cfloop query="check_subs">
											<option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option>
									   </cfloop>
									</cfif>	
								</cfloop>
								<option value="10002" <cfif listfind(variable.user_tags,10002)>selected</cfif>>All Commercial Structures Below</option>
								<cfloop query="pull_commercial_structures">
									<option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option>
									<cfquery name="check_subs2" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
									 select pbt_tags.tag,pbt_tags.tagID
									 from pbt_tags
									 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
									 and tag_parentID <> 0
									 order by pbt_tags.tag
									</cfquery>																				
									<cfif check_subs2.recordcount GT 0>
									   <cfloop query="check_subs2">
											<option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option>
									   </cfloop>
									</cfif>	
								</cfloop>
							</select>					  
						  </div>
						</cfoutput>	
					</div>
				</div>				
				<!--- Spacer --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">&nbsp;</div>								
			</div>
			
			
			<div class="col-xs-12 col-sm-12 col-md-6 pull-left">							

				<!--- Scopes --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">				
					<div class="sectionHead">Scopes <span class="normal">(select all that apply) </span></div>
					<div class="sectionBody">
						       
							<div id="scopes">
								<select placeholder="Select Scopes" name="tags" multiple="multiple" id="scopes_field" class="form-control search-select-structure">
									<option value="10003" <cfif listfind(variable.user_tags,10003)>selected</cfif>>All Scopes</option>
									<option value="10004" <cfif listfind(variable.user_tags,10004)>selected</cfif>>All Constuction Scopes</option>	
									<cfloop query="pull_gc_scopes">
										<cfquery name="check_subs3" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
										 select pbt_tags.tag,pbt_tags.tagID
										 from pbt_tags
										 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
										 and tag_parentID <> 0
										 order by pbt_tags.tag
										</cfquery>								
										<cfoutput><option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option></cfoutput>
										<cfif check_subs3.recordcount GT 0>
										   <cfloop query="check_subs3">
												<cfoutput><option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option></cfoutput>
										   </cfloop>
										</cfif>										
									</cfloop>

									<option value="10005" <cfif listfind(variable.user_tags,10005)>selected</cfif>>All Professional Services</option>				
									<cfloop query="pull_professional_services">
										<cfquery name="check_subs4" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
										 select pbt_tags.tag,pbt_tags.tagID
										 from pbt_tags
										 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
										 and tag_parentID <> 0
										 order by pbt_tags.tag
										</cfquery>								
										<cfoutput><option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option></cfoutput>
										<cfif check_subs4.recordcount GT 0>
										   <cfloop query="check_subs4">
												<cfoutput><option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option></cfoutput>
										   </cfloop>
										</cfif>										
									</cfloop>
								</select>
							</div>
											
					</div>
				</div>		
				<!--- Spacer --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">&nbsp;</div>							
				<!--- Coating Manufacturers --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">
					<div class="sectionHead">Coating Manufacturers <span class="normal">(select all that apply)</span></div>
					<div class="sectionBody">
						<cfoutput> 
							<div id="coatingsManuf">
								<select placeholder="Select Coating Manufacturers" name="tags" multiple="multiple" id="tags" class="form-control search-select-structure">
										<cfloop query="pull_tag_coatingsManuf">
											<option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option>
												<cfquery name="check_subs6" datasource="#application.dataSource#">
												 select pbt_tags.tag,pbt_tags.tagID
												 from pbt_tags
												 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
												 and tag_parentID <> 0
												 order by pbt_tags.tag
												</cfquery> 
												<cfif check_subs6.recordcount GT 0>
													<cfloop query="check_subs6">
														<option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option>
													</cfloop>
												</cfif>
										</cfloop>
								</select>							
							</div> 
						</cfoutput>
					</div>
				</div>
				<!--- Spacer --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">&nbsp;</div>					
				<!--- Supply Opps --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">				
					<div class="sectionHead">Supply Opportunities <span class="normal">(select all that apply)</span></div>
					<div class="sectionBody">
						<cfoutput>         
						<div id="supply">
								<select placeholder="Select Supply Opportunities" name="tags" multiple="multiple" id="tags" class="form-control search-select-structure">									
									<cfloop query="pull_supply_ops">
										<option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option>
								
										<cfquery name="check_subs5" datasource="#application.dataSource#">
										 select pbt_tags.tag,pbt_tags.tagID
										 from pbt_tags
										 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 2
										 and tag_parentID <> 0
										 order by pbt_tags.tag
										</cfquery>   
										<cfif check_subs5.recordcount GT 0>
											<cfloop query="check_subs5">
												<option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option>
											</cfloop>
										</cfif>		
									</cfloop>
								</select>							
							</div>
						</cfoutput>	
					</div>
				</div>		
				<!--- Spacer --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">&nbsp;</div>					
				<!--- Qualifications --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">			
					<div class="sectionHead">Qualifications <span class="normal">(select all that apply)</span></div>
					<div class="sectionBody">
						<cfoutput> 
							<div id="qualifications">
								<select placeholder="Select Qualifications" name="tags" multiple="multiple" id="tags" class="form-control search-select-structure">
									<cfloop query="pull_qualifications">
										<option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option>
								
										<cfquery name="check_subs6" datasource="#application.dataSource#">
										 select pbt_tags.tag,pbt_tags.tagID
										 from pbt_tags
										 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
										 and tag_parentID <> 0
										 order by pbt_tags.tag
										</cfquery>   
										<cfif check_subs6.recordcount GT 0>
											<cfloop query="check_subs6">
												<option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option>
											</cfloop>

										</cfif>		
									</cfloop>
								</select>								
							</div>
						</cfoutput>
					</div>
				</div>	
				<!--- Spacer --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">&nbsp;</div>					
				<!--- Coating Types --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">
					<div class="sectionHead">Coating Types <span class="normal">(select all that apply)</span></div>
					<div class="sectionBody">
						<cfoutput> 
							<div id="coatingsType">
								<select placeholder="Select Coating Types" name="tags" multiple="multiple" id="tags" class="form-control search-select-structure">
									<option value="10006" <cfif listfind(variable.user_tags,10006)>selected</cfif>>All Types</option> 
									<cfloop query="pull_tag_coatingsType">
										<option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option>
								
										<cfquery name="check_subs6" datasource="#application.dataSource#">
										 select pbt_tags.tag,pbt_tags.tagID
										 from pbt_tags
										 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
										 and tag_parentID <> 0
										 order by pbt_tags.tag
										</cfquery>   
										<cfif check_subs6.recordcount GT 0>
											<cfloop query="check_subs6">
												<option value="#tagID#" <cfif listfind(variable.user_tags,tagID)>selected</cfif>>#tag#</option>
											</cfloop>
										</cfif>		
									</cfloop>
								</select>																										
							</div>
						</cfoutput>
					</div>
				</div>	
				<!--- Spacer --->
				<div class="col-md-12 col-xs-12 col-sm-12 pull-left">&nbsp;</div>								
			</div>
			<div class="col-xs-12 col-sm-12 col-md-6 pull-left">							
				<!--- buttons --->
				<div class="sectionButtons2 pull-left col-lg-6 col-md-6 col-sm-6 col-xs-12">
					<input name="SAVE" type="submit" value="Save" id="ssearch2" class="btn btn-primary">
				</div>
				<div class="sectionButtons2 pull-right col-lg-6 col-md-6 col-sm-6 col-xs-12">
					<button name="restore" id="restore" class="btn btn-danger">Restore Default Settings</button>
				</div><!------>
				<div class="sProcess2 hidden pull-left">Saving...  <img src='../../assets/images/spinner.svg'></div>				
			</div>			
		</div> 	
	</form>	
</cfoutput>           
                           
					                              
<script>		
	$(function() {
				
		$('#ssearch').on('click', function(){
			$('.sectionButtons').addClass("hidden");
			$('.sProcess').removeClass("hidden");
			$('.sectionButtons2').addClass("hidden");
			$('.sProcess2').removeClass("hidden");			
		});	
		$('#ssearch2').on('click', function(){
			$('.sectionButtons').addClass("hidden");
			$('.sProcess').removeClass("hidden");			
			$('.sectionButtons2').addClass("hidden");
			$('.sProcess2').removeClass("hidden");
		});			
		
		$('input[name="emails"][value="<cfoutput>#get_user1.dailyUpdates#</cfoutput>"]').prop('checked', true);
		$('input[name="savedSrchEmail"][value="<cfoutput>#get_user1.getSavedSearchEmail#</cfoutput>"]').prop('checked', true);	
		$('input[name="projecttype"][value="<cfoutput>#get_user1.projectTypes#</cfoutput>"]').prop('checked', true);

		
		$('#budgetAmt').val([<cfoutput>#get_user1.budget#</cfoutput>]);
		$('#statePrefs').val([<cfoutput>#get_user1.states#</cfoutput>]);
		$('#reportRunBtn').on('click', function(){
			$url = 'dailyEmail/resendDailyEmail.cfm?reportDate=' + $('#reportDate').val() + '&userid=<cfoutput>#get_user1.userid#</cfoutput>';
			if ($('#reportDate').val().length){
				$('#reportRunID').html('');
				$('#clearmsgdiv').addClass('hidden');	
				$(this).removeClass('btn-primary').toggleClass('btn-success').prop('disabled', true).text('Processing');							 
				$('#reportRunID').load($url,callback);
			}else{alert('Please chose a date');}
		});						 
			
		function callback()
		 {
		  $('#reportRunBtn').removeClass('btn-success').toggleClass('btn-primary').prop('disabled', false).text('Resend Email');
		  $('#clearmsgdiv').removeClass('hidden');							 
							 
		  //setTimeout(function(){ $('#reportRunID').html(''); }, 4000);
		 }							 
		
		$('#clearmsg').on('click', function(){	
			$('#reportRunID').html('');
			$('#clearmsgdiv').addClass('hidden');				 
		});				 
							 
							 
		/*
		$( "#structures" ).hide();
		$( "#scopes" ).hide();
		$( "#supply" ).hide();
		$( "#qualifications" ).hide();
		$( "#coatingsType" ).hide();
		$( "#coatingsManuf" ).hide();
		$( "#filter" ).hide();
		*/
		
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
		$( "#coatingmanuf_button" ).click(function() {
			$( "#coatingsManuf" ).toggle();
			$('.coatingmanuf_minus, .coatingmanuf_add').toggle();
			return false;
		});
		$( "#coatingtypes_button" ).click(function() {
			$( "#coatingsType" ).toggle();
			$('.coatingtypes_minus, .coatingtypes_add').toggle();
			return false;
		});

		// set filter toggle
		$( "#filter_button" ).click(function() {
			$( "#filter" ).toggle();
			$('.filter_minus, .filter_add').toggle();
			return false;
		});

		// Restore Confirm
		$( "#restore" ).click(function(e) {
			e.preventDefault();
			if (confirm("Restore Default Settings\n\nBy clicking 'OK' your current settings will be reset to the default settings of a 'New User'.\nDo you wish to reset your current settings?")) {
				$.ajax(
					{
					url: "email_pref_save.cfm?reset", 
					success: function(result){
						window.location.reload();
					}
				});
			}							 
		});
							 

							 

        $( '#selectall' ).on( 'change', function() {
            $( '.currentprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
       
        });
        $( '.currentprojects' ).on( 'change', function() {
            $( '.currentprojects' ).length == $( '.currentprojects:checked' ).length ? $( '#selectall' ).prop( 'checked', 'checked' ).next() : $( '#selectall' ).prop( 'checked', '' ).next();

        });

        $( '#selectall_results' ).on( 'change', function() {
            $( '.resultsprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.resultsprojects' ).on( 'change', function() {
            $( '.resultsprojects' ).length == $( '.resultsprojects:checked' ).length ? $( '#selectall_results' ).prop( 'checked', 'checked' ).next() : $( '#selectall_results' ).prop( 'checked', '' ).next();

        });

        $( '#selectall_expired' ).on( 'change', function() {
            $( '.expiredprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.expiredprojects' ).on( 'change', function() {
            $( '.expiredprojects' ).length == $( '.expiredprojects:checked' ).length ? $( '#selectall_expired' ).prop( 'checked', 'checked' ).next() : $( '#selectall_expired' ).prop( 'checked', '' ).next();

        });

        $( '#selectall_industrial' ).on( 'change', function() {
            $( '.industrialprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.industrialprojects' ).on( 'change', function() {
            $( '.industrialprojects' ).length == $( '.industrialprojects:checked' ).length ? $( '#selectall_industrial' ).prop( 'checked', 'checked' ).next() : $( '#selectall_industrial' ).prop( 'checked', '' ).next();

        });

        $( '#selectall_commercial' ).on( 'change', function() {
            $( '.commercialprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.commercialprojects' ).on( 'change', function() {
            $( '.commercialprojects' ).length == $( '.commercialprojects:checked' ).length ? $( '#selectall_commercial' ).prop( 'checked', 'checked' ).next() : $( '#selectall_commercial' ).prop( 'checked', '' ).next();

        });

        $( '#selectall_construction' ).on( 'change', function() {
            $( '.constructionprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.constructionprojects' ).on( 'change', function() {
            $( '.constructionprojects' ).length == $( '.constructionprojects:checked' ).length ? $( '#selectall_construction' ).prop( 'checked', 'checked' ).next() : $( '#selectall_construction' ).prop( 'checked', '' ).next();

        });


        $( '#selectall_services' ).on( 'change', function() {
            $( '.professionalprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.professionalprojects' ).on( 'change', function() {
            $( '.professionalprojects' ).length == $( '.professionalprojects:checked' ).length ? $( '#selectall_services' ).prop( 'checked', 'checked' ).next() : $( '#selectall_services' ).prop( 'checked', '' ).next();

        });
		
	$(function() {
		var dates = $( "#reportDate" ).datepicker({
			defaultDate: "-1d",
			changeMonth: true,
			numberOfMonths: 6,
			onSelect: function( selectedDate ) {
				var option = this.id == "reportDate" ? "minDate" : "maxDate",
					instance = $( this ).data( "datepicker" ),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings );
				dates.not( this ).datepicker( "option", option, date );
			}
		});
	});
});
	</script>                        
<style>
	.sectionHead{background-color: #D8D8D8;padding:5px;margin:0;width: 100%!important; text-indent: 15px;}
	.sectionBody{background-color: #f5f4f4;width: 100%!important; padding: 0 15px 10px 15px;min-height: 115px;overflow:auto;}
	.sectionBody2{background-color: #f5f4f4;width: 100%!important; padding: 20px 15px 20px 15px;min-height: 70px;}
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
	
	 /* Tooltip container */
	.tooltip {
		position: relative;
		display: inline-block;
	}

	/* Tooltip text */
	.tooltip .tooltiptext {
		visibility: hidden;
		width: 120px;
		background-color: #555;
		color: #fff;
		text-align: center;
		padding: 5px 0;
		border-radius: 6px;

		/* Position the tooltip text */
		position: absolute;
		z-index: 1;
		bottom: 125%;
		left: 50%;
		/*margin-left: -60px;*/

		/* Fade in tooltip */
		opacity: 0;
		transition: opacity 0.3s;
	}

	/* Tooltip arrow 
	.tooltip .tooltiptext::after {
		content: "";
		position: absolute;
		top: 100%;
		left: 50%;
		margin-left: -5px;
		border-width: 5px;
		border-style: solid;
		border-color: #555 transparent transparent transparent;
	}*/

	/* Show the tooltip text when you mouse over the tooltip container */
	.tooltip:hover .tooltiptext {
		visibility: visible;
		opacity: 1;
	} 	
	
</style>  
<cfelse>
	<div class="h4">This feature is currently unavailable.  PBT is doing maintenance and will be back once complete.</div>
</cfif>                     