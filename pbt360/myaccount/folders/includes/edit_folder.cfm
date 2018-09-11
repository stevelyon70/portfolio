<CFSET DATE = #CREATEODBCDATETIME(NOW())#>

<cfquery name="getcustomerstates" datasource="#application.datasource#"><!---get the user states--->
select b.stateid from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
where a.userid = <cfqueryPARAM value = "#Session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  and b.packageid in (1,2,3,4,5,6,7,8,9,10,11,14) and a.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where reg_users.username = '#Session.auth.username#' and bid_users.bt_status = 1)
</cfquery>
<cfif getcustomerstates.recordcount is 0 ><cflocation url="?action=91&userid=#Session.auth.userid#" addtoken="Yes"></cfif>

<!---check to see if user is auth. to receive paint bids, if not send them back--->
<!---cfquery name="checkuser" datasource="#application.datasource#">select bid_user_suppliers.basicpkg,bid_user_suppliers.aebids,bid_user_suppliers.awards from bid_user_suppliers inner join bid_users on bid_users.sid = bid_user_suppliers.sid where bid_users.userid = #userid#</cfquery--->                                                  
<cfquery name="checkuser" datasource="#application.datasource#">
select bid_subscription_log.packageid
from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
where bid_users.userid =  <cfqueryPARAM value = "#Session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  and bid_subscription_log.effective_date <= #date# and bid_subscription_log.expiration_date >= #date# and bid_subscription_log.active = 1
</cfquery> 
 
<cfif checkuser.recordcount is 0 >
<cflocation url="?action=91" addtoken="No">
</cfif>		

<cfquery  name="getsid" datasource="#application.datasource#">select sid from bid_users where userid = <cfqueryPARAM value = "#Session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"></cfquery>

<cfif isdefined("process") and process is 21><!---update folder--->

<cftransaction action="begin">
<cfquery name="insertfolder" datasource="#application.datasource#">
update bid_user_project_folders
set foldername = <cfqueryPARAM value = "#form.foldername#" CFSQLType="CF_SQL_CHAR">,description= <cfqueryPARAM value = "#form.description#" CFSQLType="CF_SQL_CHAR">,privacy_setting=#share#
where folderid = <cfqueryPARAM value = "#folderid#" CFSQLType = "CF_SQL_INTEGER"> 
and bid_user_project_folders.userid in (select userid from bid_users where sid = #getsid.sid#)
</cfquery>
<cfquery name="deleteprivacy" datasource="#application.datasource#">
delete from bid_user_privacy_log
where folderid = <cfqueryPARAM value = "#folderid#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>

	<cfif share is 3>
		<cfloop index="i" list="#specific_users#">
		<cfquery name="insert_users" datasource="paintsquare">
		insert into bid_user_privacy_log
		(folderid,userid)
		values(#folderid#,#i#)
		</cfquery>
		</cfloop>
		</cfif>

</cftransaction>


</cfif>
 
 
 
<cfif isdefined("process") and process is 21>
<cflocation url="?action=folders&userid=#userid#">
<cfelse>

</cfif>



 <!--- Get list of folders from database --->
<CFQUERY NAME="Getfolders" datasource="#application.datasource#">
SELECT distinct  bid_user_project_folders.folderID, bid_user_project_folders.foldername,description,bid_user_project_folders.privacy_setting,bid_user_project_folders.userid as original_user
FROM bid_user_project_folders
left outer join bid_user_privacy_log on bid_user_privacy_log.folderid = bid_user_project_folders.folderid
where bid_user_project_folders.active = 1 
and (1 <> 1 
or (bid_user_project_folders.privacy_setting = 1 and bid_user_project_folders.userid in (select userid from bid_users where sid = #getsid.sid#)) 
or (bid_user_project_folders.privacy_setting = 3 and ((bid_user_privacy_log.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#"> and bid_user_privacy_log.userid in (select userid from bid_users where sid in (select sid from bid_users where userid = bid_user_project_folders.userid))) or bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))
or (bid_user_project_folders.privacy_setting is null and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">)
or (bid_user_project_folders.privacy_setting = 2 and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))

and bid_user_project_folders.folderid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#id_mag#">
and bid_user_project_folders.userID not in (select userID from pbt_user_folders_deletions where folderID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#id_mag#"> and userID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">)

</CFQUERY>
<!---take of editing permission--->
<!---cfif getfolders.recordcount is 0 or ((getfolders.privacy_setting is 1 and getfolders.original_user is not userid) or (getfolders.privacy_setting is 2 and getfolders.original_user is not userid) or (getfolders.privacy_setting is "" and getfolders.original_user is not userid) ) >
<cflocation url="?userid=#userid#" addtoken="No">
</cfif--->
<cfif getfolders.recordcount is 0 >
<cflocation url="?userid=#userid#" addtoken="No">
</cfif>
	<cfform action="#cgi.script.name#?action=58&process=21&id_mag=#id_mag#" method="POST" enablecab="Yes">
				  <TABLE width="100%" border=0>
				
				  <tr><td><font size="2" face="arial"><strong>Edit Folder:</strong></font></td></tr>
				  <tr>
				  <td><font size="2" face="arial"><strong>Name:</strong></font></td>
				   </tr><cfoutput><cfif isdefined("awd")><input type="hidden" name="awardid" value="1"></cfif><cfif isdefined("bidid")><input type="hidden" name="bidid" value="#bidid#"></cfif><input type="hidden" name="userid" value="#userid#"></cfoutput>
				   <tr>
				   <td><cfinput type="Text" name="foldername" message="Please name the folder." required="Yes" size="30" value="#getfolders.foldername#"></td>
				</tr>
				<tr>
				   <td><font size="2" face="arial"><strong>Folder Description:</strong></font></td>
				</tr><cfif isdefined("ref") and ref is 2><input type="hidden" name="ref" value="2"></cfif>
			 <tr>
				   <td><cfoutput><input type="hidden" name="folderid" value="#getfolders.folderid#"><textarea cols="30" rows="10" name="description">#getfolders.description#</textarea></cfoutput></td>
				</tr>
				   <tr><td><br><font size="2" face="arial"><strong>Security Settings:</strong></font><!---img src="images/security_settings.gif"---></td></tr>
				  <tr>
				  <td><font size="2" face="arial">Select the security settings for this folder:</font></td>
				   </tr>
				    <tr>
				   <td><cfif getfolders.privacy_setting is 2><cfinput type="radio" name="share" value="2" checked="Yes"><cfelse><cfinput type="radio" name="share" value="2" ></cfif>
				   <font size="2" face="arial"> I would like this folder to be private.</font></td>
				</tr>
				   <tr>
				   <td><cfif getfolders.privacy_setting is 1><cfinput type="radio" name="share" value="1" checked="Yes"><cfelse><cfinput type="radio" name="share" value="1" ></cfif>
				  <font size="2" face="arial">  I would like all users on our account to have access to this folder.</font></td>
				</tr>
				
				 <tr>
				   <td><cfif getfolders.privacy_setting is 3><cfinput type="radio" name="share" value="3" checked="Yes"><cfelse><cfinput type="radio" name="share" value="3" ></cfif>
				 <font size="2" face="arial">  I would like the following users on our account to have access to this folder.</font></td>
				</tr>
				 <tr><cfquery name="getusers" datasource="#application.datasource#"> select distinct bid_users.userid,reg_users.name 
				from bid_users 
				inner join bid_subscription_log on bid_subscription_log.userid = bid_users.userid 
				left outer join reg_users on reg_users.reg_userid = bid_users.reguserid 
				where bid_users.sid in (select sid from bid_users where userid = #userid# and bt_status = 1) 
				and reg_users.supplierid = bid_users.supplierid
				and reg_users.name is not null and bid_subscription_log.effective_date <= #date# and bid_subscription_log.expiration_date >= #date#
				order by reg_users.name</cfquery>
				   <td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				     <cfquery name="folder_users" datasource="#application.datasource#">
				     SELECT bid_user_privacy_log.folderid, bid_user_privacy_log.userid
  					 FROM bid_user_privacy_log
  					 where bid_user_privacy_log.folderid = #getfolders.folderid#
				     </cfquery>
				     <CFSET userRefList = valuelist(folder_users.userid)>
				<CFSELECT  multiple size="5" name="specific_users">
				<CFLOOP Query="getusers">
				<cfoutput>
					<CFIF ListFind(userRefList, #userid#) EQ 0>
			    		<OPTION value=#userid#>#name#
					<CFELSE>
			    		<OPTION value=#userid# selected>#name#
					</CFIF></cfoutput>
				</CFLOOP>
				
				</CFSELECT>
				   
				   </td>
				  
				</tr>
				
				
				 
				<tr><td><br><input type="submit" name="submit" value="Save"></td></tr>
				  </table>
</cfform>
	
	
	