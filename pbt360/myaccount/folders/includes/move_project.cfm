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



<cfif isdefined("process") and process is 1><!---delete bids--->

<cfif isdefined("form.SUBMIT") and project_folder is not 0>
<cfif not isdefined("prgt") or prgt is ""><cflocation url="?action=38&userid=#userid#&id_mag=#id_mag#"></cfif>

<cfquery name="updateproject" datasource="#the_dsn#">
update bid_user_project_bids
set folderid = #project_folder#
where projectid = #form.prgt#
</cfquery>

</cfif>

</cfif>







<cfif not isdefined("process") >

<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
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
<cfquery  name="getsid" datasource="#the_dsn#">select sid from bid_users where userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER"></cfquery>

<cfquery name="check_project" datasource="#the_dsn#">
select a.projectid 
from bid_user_project_bids a
inner join bid_user_project_folders on bid_user_project_folders.folderid = a.folderid
left outer join bid_user_privacy_log on bid_user_privacy_log.folderid = bid_user_project_folders.folderid
where a.projectid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#pgt#">

and (1 <> 1 
or (bid_user_project_folders.privacy_setting = 1 and bid_user_project_folders.userid in (select userid from bid_users where sid = #getsid.sid#)) 
or (bid_user_project_folders.privacy_setting = 3 and ((bid_user_privacy_log.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#"> 
and bid_user_project_folders.userid in (select userid from bid_users where sid in (select sid from bid_users where userid = a.userid))) or bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))
or (bid_user_project_folders.privacy_setting is null and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">)
or (bid_user_project_folders.privacy_setting = 2 and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))

</cfquery>

<cfif check_project.recordcount is 0><!---not correct username and project info--->
<cflocation url="?userid=#userid#" addtoken="No">
</cfif>

<CFQUERY NAME="Getbids" datasource="#the_dsn#">
SELECT distinct bid_user_project_bids.projectID, bid_user_project_bids.date_entered,bid_user_project_bids.projectname, bid_user_project_bids.folderid,bid_user_project_bids.bidid, pbt_project_master_gateway.projectname,pbt_project_master_gateway.owner,pbt_project_master_gateway.city,
pbt_project_master_gateway.state,pbt_project_master_gateway.submittaldate,
pbt_project_master_gateway.paintpublishdate,pbt_project_updates.updateID,pbt_project_award_stage_detail.pbt_stageID as awardID,pbt_project_updates.date_entered as editdate,bid_user_viewed_log.bidid as viewed

 	FROM bid_user_project_bids 
  	inner join pbt_project_master_gateway on pbt_project_master_gateway.bidid = bid_user_project_bids.bidid
	left outer join pbt_project_award_stage_detail on pbt_project_award_stage_detail.bidid = bid_user_project_bids.bidid
	left outer join pbt_project_updates on pbt_project_updates.bidid = bid_user_project_bids.bidid 
	and pbt_project_updates.pupdateid = (select max(pupdateID) from pbt_project_updates where bidID = bid_user_project_bids.bidid )
	and pbt_project_updates.date_entered >= (select max(date_viewed) from bid_user_project_view_log where userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">) 
	LEFT OUTER JOIN bid_user_viewed_log on bid_user_project_bids.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid=  <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">
		
  where bid_user_project_bids.projectid = <cfqueryPARAM value = "#pgt#" CFSQLType = "CF_SQL_INTEGER"> 
  and bid_user_project_bids.projectid in (#valuelist(check_project.projectid)#)
  ORDER BY editdate desc,pbt_project_master_gateway.paintpublishdate desc,pbt_project_master_gateway.projectname
</CFQUERY>
<cfif getbids.recordcount is 0><!---not correct username and project info--->
<cflocation url="?userid=#userid#" addtoken="No">
</cfif>

<CFQUERY NAME="Getfolders" datasource="#the_dsn#">
SELECT distinct  bid_user_project_folders.folderID, bid_user_project_folders.foldername,bid_user_project_folders.privacy_setting
FROM bid_user_project_folders
left outer join bid_user_privacy_log on bid_user_privacy_log.folderid = bid_user_project_folders.folderid
where bid_user_project_folders.active = 1 
and (1 <> 1 
or (bid_user_project_folders.privacy_setting = 1 and bid_user_project_folders.userid in (select userid from bid_users where sid = #getsid.sid#)) 
or (bid_user_project_folders.privacy_setting = 3 and (bid_user_privacy_log.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#"> or bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))
or (bid_user_project_folders.privacy_setting is null and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">)
or (bid_user_project_folders.privacy_setting = 2 and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))
ORDER BY bid_user_project_folders.foldername
</CFQUERY>		


</cfif>



<cfif isdefined("process") and process is 1>
<cflocation url="?action=37&userid=#userid#">
<cfelse>

</cfif>

<cfif not isdefined("process")>
<cfoutput query="getbids">
 <CFFORM NAME="RFPManagement" ACTION="#cgi.script.name#?action=62&process=1" METHOD="post" >
	<input type="hidden" value="#getbids.projectid#" name="prgt">
	<input type="hidden" value="#userid#" name="userid">
	<input type="hidden" value="#id_mag#" name="id_mag">
<table width="100%">
<tr><td align="center"><font face="arial" size="2">Please choose a folder to move the <font color="black"><strong>"#projectname#"</strong></font> project into:</font></td></tr>
<tr><td align="center"> <br><cfselect name="project_folder" query="getfolders" value="folderid" display="foldername" style="font-size:14px;" required="yes" ><Option value="0" selected>- &nbsp;&nbsp;Select a Folder&nbsp;&nbsp; -</OPTION></cfselect>
					  </td></tr>
					  <tr><td>&nbsp;</td></tr>
<tr><td align="center"><input name="submit" type="submit" value="Confirm">&nbsp;<input type="reset" value="Cancel" onclick="javascript:history.go(-1)"></td></tr>
<tr><td></td></tr></table>
</cfform>
</cfoutput>
</cfif>

