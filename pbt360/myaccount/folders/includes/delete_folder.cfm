<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

  <cfscript>
// *** Restrict Access To Page: Grant or deny access to this page
MM_authorizedUsers="";
MM_authFailedURL="../index.cfm?nt=1";
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
<cflocation url="#MM_authFailedURL_Trigger#" addtoken="no">
</cfif>

<CFSET DATE = #CREATEODBCDATETIME(NOW())#>


 <cfif isdefined("form.SUBMIT") and isdefined("form.id_mag")><!---delete existing folder--->
 <cftransaction action="begin">
 <cfif id_mag is ""><cflocation url="?userid=#userid#&one_loc2=1"></cfif>

<cfquery name="pull_owner" datasource="#the_dsn#">
	select userID 
	from bid_user_project_folders
	where folderID = <cfqueryPARAM value = "#form.id_mag#" CFSQLType = "CF_SQL_INTEGER"> 
</cfquery>

<cfif pull_owner.userID EQ userID>
		<cfquery name="deleteprojectname" datasource="#the_dsn#">
		update bid_user_project_folders 
		set active = 2 
		where folderid = <cfqueryPARAM value = "#form.id_mag#" CFSQLType = "CF_SQL_INTEGER"> 
		and userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">
		</cfquery>
		<cfquery name="deletecomments" datasource="#the_dsn#">
		update bid_user_project_comments
		set active = 2
		where projectid in (select projectid from bid_user_project_bids where folderid = <cfqueryPARAM value = "#form.id_mag#" CFSQLType = "CF_SQL_INTEGER">) and userid = <cfqueryPARAM value = "#form.userid#" CFSQLType = "CF_SQL_INTEGER">
		</cfquery>
		<cfquery name="deletefolder" datasource="#the_dsn#">
		update bid_user_project_bids
		set active = 2
		where folderid = <cfqueryPARAM value = "#form.id_mag#" CFSQLType = "CF_SQL_INTEGER"> 
		and userid = <cfqueryPARAM value = "#form.userid#" CFSQLType = "CF_SQL_INTEGER">
		</cfquery>
<cfelse>
	<cfquery name="deleteprojectname" datasource="#the_dsn#">
	insert into pbt_user_folders_deletions
	(userID,folderID,active,dateadded)
	values(
	<cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">,
	<cfqueryPARAM value = "#form.id_mag#" CFSQLType = "CF_SQL_INTEGER">,
	1,
	#date#
	)
	</cfquery>
	
</cfif>


</cftransaction>

	
<!---cfelseif isdefined("form.SUBMIT.X") >
<cflocation url="new_project.cfm?userid=#form.userid#" addtoken="No"--->	


</cfif>



<cfif not isdefined("process") >


<cfquery name="getcustomerstates" datasource="#the_dsn#"><!---get the user states--->
select distinct b.stateid from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
where a.userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">  and  a.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where reg_users.username = '#Session.MM_Username#' and bid_users.bt_status = 1)
</cfquery>
<cfif getcustomerstates.recordcount is 0 ><cflocation url="?action=91&userid=#userid#" addtoken="Yes"></cfif>
<cfset states = "#valuelist(getcustomerstates.stateid)#">
<!---check to see if user is auth. to receive paint bids, if not send them back--->
<!---cfquery name="checkuser" datasource="#the_dsn#">select bid_user_suppliers.basicpkg,bid_user_suppliers.aebids,bid_user_suppliers.awards from bid_user_suppliers inner join bid_users on bid_users.sid = bid_user_suppliers.sid where bid_users.userid = #userid#</cfquery--->                                                  
<cfquery name="checkuser" datasource="#the_dsn#">
select bid_subscription_log.packageid
from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
where bid_users.userid =  <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">  and bid_subscription_log.effective_date <= #date# and bid_subscription_log.expiration_date >= #date# and bid_subscription_log.active = 1
</cfquery> 
 
<cfif checkuser.recordcount is 0 >
<cflocation url="?userid=#userid#" addtoken="No">
</cfif>

<cfquery name="check_folder" datasource="#the_dsn#">
select a.folderid 
from bid_user_project_folders a
left outer join bid_user_privacy_log on bid_user_privacy_log.folderid = a.folderid
where a.active = 1 
and (1 <> 1 
or (a.privacy_setting = 1 and a.userid in (select userid from bid_users where sid = #getsid.sid#)) 
or (a.privacy_setting = 3 and ((bid_user_privacy_log.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#"> 
and a.userid in (select userid from bid_users where sid in (select sid from bid_users where userid = a.userid))) or a.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))
or (a.privacy_setting is null and a.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">)
or (a.privacy_setting = 2 and a.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))
and a.folderID not in (select folderID from pbt_user_folders_deletions where userID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">)
</cfquery>

<cfif check_folder.recordcount is 0><!---not correct username and project info--->
<cflocation url="?userid=#userid#" addtoken="No">
</cfif>

 <!--- Get list of folders from database --->
<CFQUERY NAME="Getfolders" datasource="#the_dsn#">
SELECT distinct  bid_user_project_folders.folderID, bid_user_project_folders.foldername,description
FROM bid_user_project_folders
where bid_user_project_folders.active = 1 
and  bid_user_project_folders.userid in (select userid from bid_users where sid = #getsid.sid#)
and bid_user_project_folders.folderid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#id_mag#"> 
and bid_user_project_folders.folderid in (#valuelist(check_folder.folderid)#)
and bid_user_project_folders.userID not in (select userID from pbt_user_folders_deletions where folderID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#id_mag#"> and userID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">)
</CFQUERY>




</cfif>

<cfif isdefined("process") and process is 1>
<cflocation url="?action=37&userid=#userid#">
<cfelse>

</cfif>

<cfif not isdefined("process")>
<cfoutput query="getfolders">
 <CFFORM NAME="RFPManagement" ACTION="#cgi.script.name#?action=59&process=1" METHOD="post" >
	<input type="hidden" value="#userid#" name="userid">
	<input type="hidden" value="#id_mag#" name="id_mag">
<table width="100%">
<tr><td align="center"><font face="arial" size="2">Are you sure you want to remove the folder named <font color="black"><strong>"#foldername#"</strong> and all the projects you are tracking in it?</font></font></td></tr>
<tr><td></td></tr>
<tr><td align="center"><input name="submit" type="submit" value="Confirm">&nbsp;<input type="reset" value="Cancel" onclick="javascript:history.go(-1)"></td></tr>
</table>
</cfform>
</cfoutput>
</cfif>
