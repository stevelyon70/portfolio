<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

  <cfscript>
// *** Restrict Access To Page: Grant or deny access to this page
MM_authorizedUsers="";
MM_authFailedURL="index.cfm?nt=1";
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


<cfif isdefined("form.SUBMIT")>
<cfif not isdefined("prgt") or prgt is "">
	<cflocation url="?action=38&userid=#userid#&id_mag=#id_mag#">
</cfif>

<cfquery name="deletefolder" datasource="#the_dsn#">
update bid_user_project_bids
set active = 2
where projectid = #form.prgt# and userid = #form.userid#
</cfquery>
<cfquery name="deletecomments" datasource="#the_dsn#">
update bid_user_project_comments
set active = 2
where projectid = #form.prgt# and userid = #form.userid#
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

<cfquery name="check_project" datasource="#the_dsn#">
select a.projectid 
from bid_user_project_bids a
where a.userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">  and  a.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where reg_users.username = '#Session.MM_Username#' and bid_users.bt_status = 1)
</cfquery>

<cfif check_project.recordcount is 0><!---not correct username and project info--->
<cflocation url="?userid=#userid#" addtoken="No">
</cfif>

<CFQUERY NAME="Getbids" datasource="#the_dsn#">
SELECT distinct bid_user_project_bids.projectID, bid_user_project_bids.date_entered,bid_user_project_bids.projectname, bid_user_project_bids.folderid,bid_user_project_bids.bidid, pbt_project_master_gateway.projectname,pbt_project_master_gateway.owner,pbt_project_master_gateway.city,pbt_project_master_gateway.state,pbt_project_master_gateway.submittaldate,pbt_project_master_gateway.paintpublishdate
  FROM bid_user_project_bids 
  inner join pbt_project_master_gateway on pbt_project_master_gateway.bidid = bid_user_project_bids.bidid
  where bid_user_project_bids.projectid = <cfqueryPARAM value = "#pgt#" CFSQLType = "CF_SQL_INTEGER"> and bid_user_project_bids.userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">
  and bid_user_project_bids.projectid in (#valuelist(check_project.projectid)#)
  ORDER BY pbt_project_master_gateway.paintpublishdate desc,pbt_project_master_gateway.projectname

</CFQUERY>
<cfif getbids.recordcount is 0><!---not correct username and project info--->
<cflocation url="?userid=#userid#" addtoken="No">
</cfif>



</cfif>


<cfif isdefined("process") and process is 1>
<cflocation url="?action=37&userid=#userid#">
<cfelse>

</cfif>

<cfif not isdefined("process")>
<cfoutput query="getbids">
 <CFFORM NAME="RFPManagement" ACTION="#cgi.script.name#?action=61&process=1" METHOD="post" >
	<input type="hidden" value="#getbids.projectid#" name="prgt">
	<input type="hidden" value="#userid#" name="userid">
	<input type="hidden" value="#id_mag#" name="id_mag">
<table width="100%">
<tr><td align="center"><font face="arial" size="2">Are you sure you want to remove the <font color="black"><strong>"#projectname#"</strong></font> project from this folder?</font></td></tr>
<tr><td></td></tr>
<tr><td align="center"><input name="submit" type="submit" value="Confirm">&nbsp;<input type="reset" value="Cancel"></td></tr>
</table>
</cfform>
</cfoutput>
</cfif>

