<cfswitch expression="#url.action#">
	<cfcase value="insert">
		<cfquery datasource="#application.dataSource#" name="q12">
		SELECT *
		FROM pbt_project_clipboard
		where bidID = #url.bid# 
			and userID = #session.auth.userid#
		</cfquery>
		<cfif q12.recordcount eq 0>	
			<cfquery datasource="#application.dataSource#" name="q12">
			insert into pbt_project_clipboard
			(bidID, userID, projectName)
			values
			(#url.bid#, #session.auth.userid#, '#url.name#')
			</cfquery>
		</cfif>
		
	</cfcase>
	<cfcase value="getCount">
		<cfquery datasource="#application.dataSource#" name="q12">
		SELECT distinct cb.bidid
		FROM pbt_project_clipboard cb
			inner join pbt_project_master_cats c on c.bidid = cb.bidid
			inner join site_tag_xref x on c.tagid = x.tagid
		where cb.userID = #session.auth.userid# and x.active = 1 and c.tagid in (12,#session.default.tagId#) and x.siteID = #session.auth.siteid#
		</cfquery>
			<cfoutput>#q12.recordcount#</cfoutput>
	</cfcase>
	<cfcase value="remove">
		<cfquery datasource="#application.dataSource#" name="q12">
		delete
		FROM pbt_project_clipboard
		where bidID = #url.bid# 
			and userID = #session.auth.userid#
		</cfquery>
		
	</cfcase>
	<cfcase value="get">
		<cfquery datasource="#application.dataSource#" name="clipboard">
		SELECT distinct cb.bidid, cast(cb.projectname as varchar) as projectname
		FROM pbt_project_clipboard cb
			inner join pbt_project_master_cats c on c.bidid = cb.bidid
			inner join site_tag_xref x on c.tagid = x.tagid
		where cb.userID = #session.auth.userid# and x.active = 1 and c.tagid in (12,#session.default.tagId#) and x.siteID = #session.auth.siteid#
		</cfquery>
		<ul>
			<li class="row">							
													
				<span class="desc col-sm-2" style="opacity: 1;"> ID</span>
				<span class="desc col-sm-6" style="opacity: 1; text-decoration: none;"> Name</span>
				<span class="col-sm-1" style="opacity: 1;"></span>
				<span class="col-sm-1" style="opacity: 1;"></span>
				<span class="col-sm-1" style="opacity: 1;"></span>
				<!--span class="col-sm-2" style="opacity: 1;">
					<a href="javascript:void(0);" onClick="delAll();"><i class="fa fa-trash-o fa-lg" aria-hidden="true"></i></a>
					<input type="checkbox" class="selAllTrash" />
				</span-->
			</li>
		  <cfoutput query="clipboard">
			<li class="row">												
				<span class="desc col-sm-2" style="opacity: 1; text-decoration: underline; cursor: pointer;" onClick="location='/leads/?bidid=#bidID#'"> #bidID#</span>
				<span class="desc col-sm-6" style="opacity: 1; text-decoration: none;font-size: 12px; font-size-adjust: auto;">#left(projectName, 40)#<cfif len(projectName) gt 40>...</cfif></span>
				<!---<cfif session.auth.userid eq 15210 or session.auth.userid eq 14601>--->
				<span class="label label-danger col-sm-1" style="opacity: 1; cursor: pointer;" onClick="sendProject(#bidID#)"> <i class="fa fa-envelope" aria-hidden="true"></i></span>
				<span class="label label-danger col-sm-1" style="opacity: 1; cursor: pointer;" onClick="folderProject(#bidID#)"> <i class="fa fa-folder-open" aria-hidden="true"></i></span>
				<!---</cfif>--->
				<span class="label label-danger col-sm-1" style="opacity: 1; cursor: pointer;" onClick="delProject(#bidID#, true)"> <i class="fa fa-trash" aria-hidden="true"></i></span>
				<!--span class="desc col-sm-2" style="opacity: 1; text-decoration: underline; cursor: pointer; pull-right;" > <input type="checkbox" class="cliptrashBox" name="folderDel" value="#bidID#" /></span-->
			</li> 
			</cfoutput>
		</ul>	

		<!--- messgae box Modal 
		<div class="modal fade" tabindex="-1" role="dialog" id="clipModalPopup">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
						<h5 class="modal-title detailLabel"></h5>
					</div>							  
					<div class="modal-body"></div>
					<div class="modal-footer"></div>
				</div>
			</div>
		</div>	
		--->	

		<!--- Email Lead Modal --->
		<div class="modal fade" id="emailleadsModalClip" role="dialog">
		<div class="modal-dialog">    
		  <!-- Modal content-->
		  <div class="modal-content">
			<div class="modal-header">
			  <button type="button" class="close" data-dismiss="modal">&times;</button>
			  <h4 class="modal-title">Email this Lead</h4>
			</div>
			<div class="modal-body">
				<p>Email this document (PDF) to a colleague along with your comments</p>

				<form NAME="emailleadClip" id="emailleadClip"  METHOD="post" >
					<cfoutput>

					<table border="0" width="100%">

					<tr>
						<td width="20%">
							Recipient Name:
						</td>
						<td>
							<input size="40" type="text" name="toname" id="toname"/>
						</td>
					</tr>
					<tr>
						<td width="20%">
							Subject:
						</td>
						<td>
							<input size="40" type="text" name="tosubject" id="tosubject" value="" />
						</td>
					</tr>
					<tr>
						<td width="20%">
							Recipient Email*:
						</td>
						<td>
							<input size="40" type="text" name="toemail" id="toemailClip"/>
						</td>
					</tr>
					<tr>
						<td width="20%">
							Message:
						</td>
						<td>		
							<textarea cols="40" rows="2" name="comments"></textarea>
						</td>
					</tr>
					<tr>
						<td colspan="2">
						<input type="submit" value="Send" style="background-color:##ffc303;"  class="btn btn-default"/>&nbsp;<input type="reset" value="Reset" style="background-color:##ffc303;"  class="btn btn-default">
						</td>
					</tr>
					</table>
					<input type="hidden" name="bidID" id="bididEmailClip" value="">
					<input type="hidden" name="userID" value="#userID#">		
					</cfoutput>
				</form>
			</div>
			<div class="modal-footer">
			  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		  </div>      
		</div>
		</div> 	
  
		<!--- Track Lead Modal --->
		<cfquery name="getsid" datasource="#application.datasource#">select sid from bid_users where userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"></cfquery>
		<CFQUERY NAME="Getfolders" datasource="#application.datasource#">
		SELECT distinct  bid_user_project_folders.folderID, bid_user_project_folders.foldername,bid_user_project_folders.privacy_setting
		FROM bid_user_project_folders
		left outer join bid_user_privacy_log on bid_user_privacy_log.folderid = bid_user_project_folders.folderid
		where bid_user_project_folders.active = 1 
		and bid_user_project_folders.siteID = #session.auth.siteid#
		and (1 <> 1 
		or (bid_user_project_folders.privacy_setting = 1 and bid_user_project_folders.userid in (select userid from bid_users where sid = #getsid.sid#)) 
		or (bid_user_project_folders.privacy_setting = 3 and ((bid_user_privacy_log.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#"> and bid_user_privacy_log.userid in (select userid from bid_users where sid in (select sid from bid_users where userid = bid_user_project_folders.userid))) or bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">))
		or (bid_user_project_folders.privacy_setting is null and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">)
		or (bid_user_project_folders.privacy_setting = 2 and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">))
		and bid_user_project_folders.folderID not in (select folderID from pbt_user_folders_deletions where userID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">)
		ORDER BY bid_user_project_folders.foldername
		</CFQUERY>  

		<div class="modal fade" role="dialog" id="leadsModalClip">
			<div class="modal-dialog">    
			  <!-- Modal content-->
			  <div class="modal-content">
				<div class="modal-header">
				  <button type="button" class="close" data-dismiss="modal">&times;</button>
				  <h4 class="modal-title">Track this Lead</h4>
				</div>
				<div class="modal-body">
					<form NAME="trackleadClip" id="trackleadClip">
						<input type="hidden" value="<cfoutput>#session.auth.userid#</cfoutput>" name="userid" id="useridClip">
						<input type="hidden" name="bidid" id="bididClipTrack" value="">
						<cfif isdefined("type")><input type="hidden" name="type" value="<cfoutput>#type#</cfoutput>"></cfif>
						<table width="100%">
							<tr>
								<td align="center">
									Select a folder in which to save the following projects:<br>		
									<strong>
										BidID: "<span class="js-bidListClip"></span>"
									</strong>
								</td>
							</tr>
							<tr>
								<td align="center"><br>
									<select name="project_folder">
										<Option value="0" selected>- &nbsp;&nbsp;Select a Folder&nbsp;&nbsp; -</OPTION>
										<cfoutput query="getfolders">
											<option value="#folderid#">#foldername#</option>
										</cfoutput>
									</select>
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td align="center">
									<input name="savelead" id="saveleadClip" type="button" value="Save" class="btn btn-primary"><!---style="background-color:#ffc303;"--->
									&nbsp;
									<input name="newfolder" id="newfolderClip" type="button" value="Create New Folder"  style="background-color:#ffc303;" class="btn btn-default">
									<!---&nbsp;<input type="reset" value="Reset" style="background-color:#ffc303;" class="btn btn-default">--->
									<div class="js-messageClip" style="color: red;"></div>
								</td>
							</tr>
						</table>			
					</form>        	        	
				</div>
				<div class="modal-footer">
				  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button><input type="hidden" name="holdhididClip" id="holdhididClip" value="">
				</div>
			  </div>      
			</div>
		</div>
	
		<script>	
			$(function(){


				// ALL TRACK LEAD FUNCTION JS

				$("#newfolderClip").click(function(e){	
					var userid = $("#useridClip").val();
					$("#holdhididClip").val($("#bididClipTrack").val());
					$("#leadsModalClip").find('.modal-body').load('../../myaccount/folders/includes/new_project_from_lead.cfm?clip&userid=' + userid + '&bidID=');
				});	

				$("#saveleadClip").click(function(e){
					e.preventDefault();	
					$.ajax({
						url: "../../search/includes/submitSaveFolder.cfm?val=" + Math.random(),
						type: 'POST',
						data: $("#trackleadClip").serialize(),
						success: function() {
							$(".js-messageClip").html("<br>Leads Saved to Folder.");				
							setTimeout(function(){ $('#leadsModalClip').modal('hide');  }, 1500);
						},
						error: function() {
							alert('There has been an error, please alert us immediately');
						}		
						/*error: function (request, status, error) {
							alert(request.responseText);
						}*/
					});	

				});					
				
				// EMAIL LEADS FUNCTIONS JS
				$("#emailleadClip").submit(function(e){	
					e.preventDefault();	
					if($("#toemailClip").val() == ""){
						alert("Recipient Email is Required");			
					}
					else{

						$.ajax({
							url: "../../leads/includes/email_from_clip_process.cfm?val=" + Math.random(),
							type: 'POST',
							data: $("#emailleadClip").serialize(),
							success: function() {
								alert("Email Succesfully Sent.");
								$("#emailleadsModalClip").modal('hide');
							},
							error: function() {
								alert('There has been an error, please alert us immediately');
							}		
							/*error: function (request, status, error) {
								alert(request.responseText);
							}*/

						});	
					}
				});					
				
				$(".selAllTrash").on('click',function(){
					if(this.checked){
						$('.cliptrashBox').each(function(){
							this.checked = true;
						})
					}else{
						$('.cliptrashBox').each(function(){
							this.checked = false;
						})
					}
				});
			});
			
			function folderProject(_bid){
				$("#bididClipTrack").val(_bid);
				$(".js-bidListClip").html(_bid);
				$(".js-messageClip").html("");
				$("#leadsModalClip").modal("show");	
			}	
			
			function sendProject(_bid){		
			  	$("#bididEmailClip").val(_bid);
				$("#emailleadsModalClip").modal("show");	
			}			
		</script>	
	
	
	</cfcase>
</cfswitch>	
		<style>
		.navbar-tools .dropdown-menu {
			max-width: 600px!important;
			}
			.navbar-tools .drop-down-wrapper {
				width: 600px!important;
				overflow-y:auto!important;
			}
			.todo li .label {
				position: inherit!important;	
			}
			.navbar-tools .drop-down-wrapper li a {
			    padding: 0px!important;
    			display: initial!important;
			}
			span 
			.label {margin-left:1px!important;}
		</style>

