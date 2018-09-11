
<cfif checktrack_status.recordcount EQ 0>
  <!--- Track Lead Modal --->
  <cfquery name="getsid" datasource="#application.datasource#">select sid from bid_users where userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"></cfquery>
  <CFQUERY NAME="Getfolders" datasource="#application.datasource#">
	SELECT distinct  bid_user_project_folders.folderID, bid_user_project_folders.foldername,bid_user_project_folders.privacy_setting
	FROM bid_user_project_folders
	left outer join bid_user_privacy_log on bid_user_privacy_log.folderid = bid_user_project_folders.folderid
	where bid_user_project_folders.active = 1 
	and (1 <> 1 
	or (bid_user_project_folders.privacy_setting = 1 and bid_user_project_folders.userid in (select userid from bid_users where sid = #getsid.sid#)) 
	or (bid_user_project_folders.privacy_setting = 3 and ((bid_user_privacy_log.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#"> and bid_user_privacy_log.userid in (select userid from bid_users where sid in (select sid from bid_users where userid = bid_user_project_folders.userid))) or bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">))
	or (bid_user_project_folders.privacy_setting is null and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">)
	or (bid_user_project_folders.privacy_setting = 2 and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">))
	and bid_user_project_folders.folderID not in (select folderID from pbt_user_folders_deletions where userID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">)
	ORDER BY bid_user_project_folders.foldername
  </CFQUERY>  
  
  <div class="modal fade" id="leadsModal" role="dialog">
    <div class="modal-dialog">    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Track this Lead</h4>
        </div>
        <div class="modal-body">
			<form NAME="tracklead" id="tracklead">
				<input type="hidden" value="<cfoutput>#session.auth.userid#</cfoutput>" name="userid">
				<cfif isdefined("bidID")><input type="hidden" name="bidid" id="bididDetail" value="<cfoutput>#bidid#</cfoutput>"></cfif>
				<cfif isdefined("type")><input type="hidden" name="type" value="<cfoutput>#type#</cfoutput>"></cfif>
				<table width="100%">
					<tr>
						<td align="center">
							Select a folder in which to save the following projects:<br>		
							<strong>
							BidID: <cfoutput>"#bidID#"</cfoutput>
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
							<input name="savelead" id="savelead" type="button" value="Save" class="btn btn-primary">
							&nbsp;
							<input name="newfolder" id="newfolder" type="button" value="Create New Folder"  style="background-color:#ffc303;" class="btn btn-default">
							<!---&nbsp;<input type="reset" value="Reset" style="background-color:#ffc303;" class="btn btn-default">--->
						</td>
					</tr>
				</table>			
			</form>        	        	
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button><input type="hidden" name="holdhidid" id="holdhidid" value="">
        </div>
      </div>      
    </div>
  </div>

<cfelse> 
 
  <!--- Comment Modal --->
  <div class="modal fade" id="commentModal" role="dialog">
    <div class="modal-dialog">    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Add a Comment</h4>
        </div>
        <div class="modal-body">
			<table width="100%">
				<tr>
					<td align="center">
						<form name="RFPManagement" id="RFPManagement">
						<cfoutput>
						<input type="hidden" name="userid" value="#userid#">
						<input type="hidden" name="bidid" value="#bidid#">
						<input type="hidden" name="projectid" value="#checktrack_status.projectid#">
						<input type="hidden" name="process" value="3">
						</cfoutput>
						<textarea cols="40" rows="5" name="comments"></textarea><br>&nbsp;
						<input type="submit" value="Submit" class="btn btn-primary"/><!---style="background-color:#ffc303;"--->
						</form>
					</td>
				</tr>
			</table>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>      
    </div>
  </div> 
    
</cfif>  
 
  <!--- Email Lead Modal --->
  <div class="modal fade" id="emailleadsModal" role="dialog">
	<div class="modal-dialog">    
	  <!-- Modal content-->
	  <div class="modal-content">
		<div class="modal-header">
		  <button type="button" class="close" data-dismiss="modal">&times;</button>
		  <h4 class="modal-title">Email this Lead</h4>
		</div>
		<div class="modal-body">
			<p>Email this document (PDF) to a colleague along with your comments</p>

			<form NAME="emaillead" id="emaillead"  METHOD="post" >
				<cfoutput>

				<table border="0" width="100%">
				<tr>
					<td width="20%">
						Recipient Email*:
					</td>
					<td>
						<input size="40" type="text" name="toemail" id="toemail"/>
					</td>
				</tr>
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
					<input type="submit" value="Send" class="btn btn-primary"/>&nbsp;<input type="reset" value="Reset" style="background-color:##ffc303;"  class="btn btn-default">
					</td>
				</tr>
				</table>
				<input type="hidden" name="bidID" value="#bidID#">
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
 
  <!--- Request Info Modal --->
	<cfquery name="getname" datasource="#application.datasource#">
	select name,emailaddress,companyname,phonenumber
	from reg_users 
	inner join bid_users on bid_users.reguserID = reg_users.reg_userID
	where bid_users.userID = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">
	</cfquery>  
  
  <div class="modal fade" id="requestinfoModal" role="dialog">
    <div class="modal-dialog">    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Request More Information</h4>
        </div>
        <div class="modal-body">
			<p>
			Submit this form and a member of the Paint BidTracker team will call you within 1 business day.
			</p>

			<form name="requestInfo" id="requestInfo">
				<cfoutput>

				<table border="0" width="100%">
					<tr>
						<td width="20%">
							Your Name*:
						</td>
						<td>
							<input type="text" name="emailname" value="#getname.name#" readonly />
						</td>
					</tr>
					<tr>
						<td  width="20%">  
							Email Address*:
						</td>
						<td>
							<input type="text" name="email" id="email" size="40" value="#getname.emailaddress#" readonly />
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<hr>
						</td>
					</tr>
					<tr>
						<td width="20%">
							Company*:
						</td>
						<td>
							<input type="text" name="company" id="company"  value="#getname.companyname#" readonly />
						</td>
					</tr>
					<tr>
						<td width="20%">
							Phone*:
						</td>
						<td>
							<input type="text" name="phone" id="phone" value="#getname.phonenumber#" />
						</td>
					</tr>
					<tr>
						<td width="20%">
							Message:
						</td>
						<td>
							<textarea cols="40" rows="3" name="comments"></textarea>
						</td>
					</tr>		
					<tr>
						<td>
							<br><input type="submit" value="Submit" class="btn btn-primary" /><!---style="background-color:##ffc303;"--->
						</td>
					</tr>
				</table>
				<input type="hidden" name="bidID" value="#bidID#">
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