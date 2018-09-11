<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<!---
	 ***modified by DS on 12/10/07 --added 2008 to year dropdown for closingdate search
	 
	 ***modified by DS on 4/26/11 added a condition to only pass col=btnew for bid all results 
	  ***modified by DS on 12/14/11 new site launch conversion
--->

<cfif isdefined("paction") and paction is "deletesearch">
<cfquery name="removesearch" datasource="#application.dataSource#">
update pbt_user_saved_searches
set active=NULL
where userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and id = <cfqueryPARAM value = "#searchid#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>
</cfif>
<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<cfquery name="insert_usage" datasource="#application.dataSource#">
INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
VALUES(#session.auth.userid#,'#cfid#',#date#,46,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
</cfquery>
<cfquery name="insertcfid" datasource="#application.dataSource#">
INSERT INTO CLOG (cfid,cftoken,visitdate,siteid,remoteip,remotehost,localaddress,path)
VALUES('#cfid#','#cftoken#',#date#,'26','#cgi.remote_addr#', '#cgi.remote_host#','#cgi.local_address#','#CGI.CF_Template_Path#')
</cfquery>
<cfquery name="get_user_saved_searches" datasource="#application.dataSource#">
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
where userid=<cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and active = 1
order by searchname
</cfquery>
<div class="page-header">
  <h3>Saved Searches</h3>
</div>
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-6">
			To view the results of a saved search, click on the name of the search or <i class="fa fa-link" aria-hidden="true"></i>.	
		</div>
	</div>
	<div class="row">
		<div class="col-sm-6">
			To remove a saved search, click <i class="fa fa-trash-o" aria-hidden="true"></i> next to its name.
		</div>
	</div>
	
	<div class="row">
		<div class="col-sm-6">
			<hr>	
		</div>
	</div>
	<cfoutput QUERY="get_user_saved_searches">
	<cfinclude template="search_params_inc.cfm">
	<div class="row">
		<div class="col-sm-6">
			<div><a href="#request.rootpath#search/?action=#pageaction#&saved=1&temphref2=#temphref2#"> #searchname# <i class="fa fa-link" aria-hidden="true"></i></a> <a href="#cgi.script.name#?action=46&paction=DeleteSearch&SearchID=#id#"><i class="fa fa-trash-o" aria-hidden="true"></i></a></div>
			<div>Date Created:&nbsp;#dateformat(datecreated, "mm/dd/yyyy")#</div>
			<hr>
		</div>
	</div>
  	</cfoutput>
</div>
<Cfif get_user_saved_searches.recordcount is 0>
  <b>Your profile has no saved searches available.</b>
</cfif>
<!---
<table  bgcolor="black" bordercolor="black" bordercolorlight="black"   bordercolordark="black" width="100%" cellspacing="1" cellpadding="4">
  <tr bgcolor="black">
    <td><span class="tex4"><strong>Search Name</strong></span></td>
  </tr>
  <CFLOOP QUERY="get_user_saved_searches">
    <cfoutput>
      <cfinclude template="search_params_inc.cfm">
      <tr bgcolor="white">
        <td colspan="2" ><b> <a href="#request.rootpath#search/?action=#pageaction#&saved=1&temphref2=#temphref2#"> <span class="tex2">#searchname#</span> </a> </b> <a href="#cgi.script.name#?action=46&paction=DeleteSearch&SearchID=#id#"><span class="tex5">[remove]</span></a><!---&nbsp;
          <cfif pageaction NEQ "planningresults">
            <a href="#request.rootpath#search/?action=65&SearchID=#id#">
            <cfelse>
            <a href="#request.rootpath#search/?action=planning_mod&SearchID=#id#">
          </cfif>
          <span class="tex5">[modify]</span></a>---></td>
      </tr>
      <tr bgcolor="white">
        <td  valign="top" ><span class="tex"><strong>Date Created:</strong>&nbsp;#dateformat(datecreated, "mm/dd/yyyy")#</span><br></td>
      </tr>
    </cfoutput>
  </cfloop>
</table>
<Cfif get_user_saved_searches.recordcount is 0>
  <b>Your profile has no saved searches available.</b>
</cfif>
--->