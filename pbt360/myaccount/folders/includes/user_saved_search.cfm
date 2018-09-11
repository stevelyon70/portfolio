<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<!---
	 ***modified by DS on 12/10/07 --added 2008 to year dropdown for closingdate search
	 
	 ***modified by DS on 4/26/11 added a condition to only pass col=btnew for bid all results 
	  ***modified by DS on 12/14/11 new site launch conversion
--->



 <cfscript>
// *** Restrict Access To Page: Grant or deny access to this page
MM_authorizedUsers="";
MM_authFailedURL="index.cfm";
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



<cfif isdefined("paction") and paction is "deletesearch">
<cfquery name="removesearch" datasource="#the_dsn#">
update pbt_user_saved_searches
set active=NULL
where userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER"> and id = <cfqueryPARAM value = "#searchid#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>
</cfif>
   
	   
	   
	
<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<cfquery name="insert_usage" datasource="#the_dsn#">
INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
VALUES(#userid#,'#cfid#',#date#,46,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
</cfquery>   
<cfquery name="insertcfid" datasource="#the_dsn#">
INSERT INTO CLOG (cfid,cftoken,visitdate,siteid,remoteip,remotehost,localaddress,path)
VALUES('#cfid#','#cftoken#',#date#,'26','#cgi.remote_addr#', '#cgi.remote_host#','#cgi.local_address#','#CGI.CF_Template_Path#')
</cfquery>


<cfquery name="get_user_saved_searches" datasource="#the_dsn#">
select [id]
      ,[userID]
      ,[searchname]
      ,[datecreated]
      ,[qt]
      ,[amount]
      ,[state]
      ,[postfrom]
      ,[postto]
      ,[subfrom]
      ,[subto]
      ,[bidID]
      ,[project_stage]
      ,[all_scopes]
      ,[industrial]
      ,[allprojects]
      ,[generalcontracts]
      ,[paintingprojects]
      ,[qualifications]
      ,[supply]
      ,[structures]
      ,[scopes]
      ,[active]
      ,[pageaction]
      ,[sorting]
      ,[showall]
      ,[display_order]
      ,[commercial]
      ,[all_services],
      [verifiedprojects],
      [contractorname],
      [services],
      [filter]
from pbt_user_saved_searches 
where userid=<cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER"> and active = 1
order by searchname
</cfquery>



			
		 <strong>Saved Search Manager</strong><br><br>	
			
			<span class="tex">
		To view the results of a saved search, click on the name of the search.<br><br>
		
		To modify the criteria used in the search, click on the red 'Modify' link. <br><br>
		
		To remove the search from your profile, click on the red 'Remove' link.<br><br>
		</span>
			
			
<table  bgcolor="black" bordercolor="black" bordercolorlight="black"   bordercolordark="black" width="100%" cellspacing="1" cellpadding="4">
		
		<tr bgcolor="black"><td><span class="tex4"><strong>Search Name</strong></span></td></tr>
		
<CFLOOP QUERY="get_user_saved_searches">
<cfoutput> 

<cfinclude template="../../projectsearch/includes/search_params_inc.cfm">
	
	<tr bgcolor="white"> 
		<td colspan="2" >
			<b>
			
				<a href="../projectsearch/?action=#pageaction#&saved=1&temphref2=#temphref2#">
				<span class="tex2">#searchname#</span>
				</a>
			</b>
			<a href="#cgi.script.name#?action=46&paction=DeleteSearch&SearchID=#id#"><span class="tex5">[remove]</span></a>&nbsp;
			<cfif pageaction NEQ "planningresults">
				<a href="../projectsearch/?action=65&SearchID=#id#">
			<cfelse>
				<a href="../projectsearch/?action=planning_mod&SearchID=#id#">
			</cfif>
			<span class="tex5">[modify]</span></a>
		</td>
	</tr>	
	<tr bgcolor="white"> 
		
			
					<td  valign="top" >
						<span class="tex"><strong>Date Created:</strong>&nbsp;#dateformat(datecreated, "mm/dd/yyyy")#</span><br>
					</td>
			
		
	</tr>
	</cfoutput>
	
</cfloop>
	
</table>



	

				
			
				
				<Cfif get_user_saved_searches.recordcount is 0><b>Your profile has no saved searches available.</b></cfif>
				
                           
		
