<CFSET DATE = #CREATEODBCDATETIME(NOW())#>

<cfquery name="getcustomerstates" datasource="#application.datasource#"><!---get the user states--->
select b.stateid from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
where a.userid = <cfqueryPARAM value = "#Session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  and b.packageid in (1,2,3,4,5,6,7,8,9,10,11,14) and a.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where reg_users.username = '#Session.auth.Username#' and bid_users.bt_status = 1)
</cfquery>
<cfif getcustomerstates.recordcount is 0 ><cflocation url="?action=91&userid=#Session.auth.userid#" addtoken="Yes"></cfif>





<cfif isdefined("process") and process is 21><!---adding new folder and project--->

<cftransaction action="begin">
<cfquery name="insertfolder" datasource="#application.datasource#">
insert into bid_user_project_folders
(foldername,active,datecreated,userid,description,privacy_setting)
values('#form.foldername#',1,#date#,#form.userid#,'#form.description#',#share#)
</cfquery>

<cfquery name="check" datasource="#application.datasource#">
   		select max(folderid) as lastid
   		from bid_user_project_folders
   		where userid = #form.userid#
    	</cfquery>

		<cfset uniqueid = #check.lastid#>	
		
		<cfif share is 3>
		<cfloop index="i" list="#specific_users#">
		<cfquery name="insert_users" datasource="#application.datasource#">
		insert into bid_user_privacy_log
		(folderid,userid)
		values(#uniqueid#,#i#)
		</cfquery>
		</cfloop>
		</cfif>
<cfif isdefined("bidid") and bidid is not "">
<cfquery name="getprojectname" datasource="#application.datasource#">select projectname from bid_edited_live where bidid = #form.bidid#</cfquery>
<cfquery name="insert_bid" datasource="#application.datasource#">
insert into bid_user_project_bids
(bidid,folderid,userid,date_entered,projectname,active)
values(#form.bidid#,#uniqueid#,#form.userid#,#date#,'#getprojectname.projectname#',1)
</cfquery>
	<cfquery name="grablast" datasource="#application.datasource#">
   		select max(projectid) as lastprojectid
   		from bid_user_project_bids
   		where userid = #form.userid# and bidid = #form.bidid#
    	</cfquery>
	<cfset projectid = #grablast.lastprojectid#>	
	
<!---cflocation url="biddetail.cfm?addproject=1&bidid=#form.bidid#&userid=#form.userid#&projectid=#projectid#" addtoken="No"--->	
	<cfelse>
	<!---cflocation url="?userid=#form.userid#&one_loc=1" addtoken="No"--->
	</cfif>
		
</cftransaction>
	<!---cfif isdefined("bidid") and bidid is not "">
	<cfif not isdefined("ref") and not isdefined("awardid")>
	<cflocation url="biddetail.cfm?addproject=1&bidid=#form.bidid#&userid=#form.userid#&projectid=#projectid#" addtoken="No">	
	<cfelseif isdefined("awardid")>
	<cflocation url="../bidwinner/biddetail.cfm?addproject=1&bidid=#form.bidid#&userid=#form.userid#&projectid=#projectid#" addtoken="No">	
	<cfelse>
	<cflocation url="biddetail_p.cfm?addproject=1&bidid=#form.bidid#&userid=#form.userid#&projectid=#projectid#" addtoken="No">	
	</cfif>
	<cfelse>
	<cflocation url="?userid=#form.userid#&one_loc=1" addtoken="No">
	</cfif--->

</cfif>
 


<cfif isdefined("process") and process is 21>
<cflocation url="?action=folders&userid=#userid#">
<cfelse>

</cfif>

	<cfform action="#cgi.script.name#?action=60&process=21" method="POST" enablecab="Yes">
				  <TABLE width="100%" border=0>
				 
				  <tr><td><font size="2" face="arial"><strong>Create a New Folder:</strong></font></td></tr>
				  <tr>
				  <td><font size="2" face="arial"><strong>Name:</strong></font></td>
				   </tr><cfoutput><cfif isdefined("awd")><input type="hidden" name="awardid" value="1"></cfif><cfif isdefined("bidid")><input type="hidden" name="bidid" value="#bidid#"></cfif><input type="hidden" name="userid" value="#userid#"></cfoutput>
				   <tr>
				   <td><cfinput type="Text" name="foldername" message="Please name the folder." required="Yes" size="30"></td>
				</tr>
				<tr>
				   <td><font size="2" face="arial"><strong>Folder Description:</strong></font></td>
				</tr><cfif isdefined("ref") and ref is 2><input type="hidden" name="ref" value="2"></cfif>
			 <tr>
				   <td><textarea cols="30" rows="10" name="description"></textarea></td>
				</tr>
				  <tr><td><br><font size="2" face="arial"><strong>Security Settings:</strong></font><!---img src="images/security_settings.gif"---></td></tr>
				  <tr>
				  <td><font size="2" face="arial">Select the security settings for this folder:</font></td>
				   </tr>
				 <tr>
				   <td><cfinput type="radio" name="share" value="2" checked="Yes">
				   <font size="2" face="arial"> I would like this folder to be private.</font></td>
				</tr>
				   <tr>
				   <td><cfinput type="radio" name="share" value="1" >
				  <font size="2" face="arial">  I would like all users on our account to have access to this folder.</font></td>
				</tr>
				
				 <tr>
				   <td><cfinput type="radio" name="share" value="3" >
				 <font size="2" face="arial">  I would like the following users on our account to have access to this folder.</font></td>
				</tr>
				 <tr> 
				 <!---select bid_users.userid,reg_users.name from bid_users  left outer join reg_users on reg_users.reg_userid = bid_users.reguserid where bid_users.sid in (select sid from bid_users where userid = #userid# and bt_status = 1) and reg_users.name is not null order by reg_users.name--->
				<cfquery name="getusers" datasource="#application.datasource#">
				select distinct reg_users.name,bid_users.userid
				from reg_users 
				inner join bid_users on bid_users.reguserid = reg_users.reg_userid
				left outer join bid_subscription_log on bid_subscription_log.userid = bid_users.userid 
				where bid_users.sid in (select sid from bid_users where userid = #userid# and bt_status = 1) and bid_subscription_log.effective_date <= #date# and bid_subscription_log.expiration_date > #date# and bid_subscription_log.active = 1
				and bid_users.bt_status = 1
				order by reg_users.name
				</cfquery>
				   <td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfselect name="specific_users" query="getusers" value="userid" display="name" multiple size="5"></cfselect></td>
				  
				</tr>
				
				 
				<tr><td><br><input type="submit" name="submit" value="Save"></td></tr>
				  </table>
</cfform>
