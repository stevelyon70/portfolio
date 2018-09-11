  <cfquery  name="getsid" datasource="#application.datasource#">
select sid from bid_users where userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>
<cfquery name="getfolder" datasource="#application.datasource#">
select distinct bid_user_project_folders.foldername,bid_user_project_folders.description,bid_user_project_folders.userid as original_user
from bid_user_project_folders 
left outer join bid_user_privacy_log on bid_user_privacy_log.folderid = bid_user_project_folders.folderid
where bid_user_project_folders.folderid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#id_mag#">
and bid_user_project_folders.active = 1 and (1 <> 1 
or (bid_user_project_folders.privacy_setting = 1 and bid_user_project_folders.userid in (select userid from bid_users where sid = #getsid.sid#)) 
or (bid_user_project_folders.privacy_setting = 3 and ((bid_user_privacy_log.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#"> and bid_user_privacy_log.userid in (select userid from bid_users where sid in (select sid from bid_users where userid = bid_user_project_folders.userid))) or bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))
or (bid_user_project_folders.privacy_setting is null and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">)
or (bid_user_project_folders.privacy_setting = 2 and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))
</cfquery>

<CFQUERY NAME="Getfolders" datasource="#application.dataSource#">
SELECT distinct  bid_user_project_folders.folderID, bid_user_project_folders.foldername,bid_user_project_folders.datecreated,bid_user_project_folders.privacy_setting,bid_user_project_folders.userid as original_user
FROM bid_user_project_folders
left outer join bid_user_privacy_log on bid_user_privacy_log.folderid = bid_user_project_folders.folderid
where bid_user_project_folders.active = 1 
and (1 <> 1 
or (bid_user_project_folders.privacy_setting = 1 and bid_user_project_folders.userid in (select userid from bid_users where sid = #getsid.sid#)) 
or (bid_user_project_folders.privacy_setting = 3 and ((bid_user_privacy_log.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#"> and bid_user_privacy_log.userid in (select userid from bid_users where sid in (select sid from bid_users where userid = bid_user_project_folders.userid))) or bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">))
or (bid_user_project_folders.privacy_setting is null and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">)
or (bid_user_project_folders.privacy_setting = 2 and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">))
and bid_user_project_folders.folderID not in (select folderID from pbt_user_folders_deletions where userID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">)

ORDER BY <cfif not isdefined("sort")>bid_user_project_folders.datecreated desc</cfif>
<cfif isdefined("sort") and sort is 1 and desc is 2>bid_user_project_folders.foldername asc<cfelseif isdefined("desc") and  desc is 1 and sort is 1>bid_user_project_folders.foldername desc</cfif>
<cfif isdefined("sort") and sort is 2 and desc is 2>bid_user_project_folders.privacy_setting asc<cfelseif isdefined("desc") and  desc is 1 and sort is 2>bid_user_project_folders.privacy_setting desc</cfif>
<cfif isdefined("sort") and sort is 3 and desc is 2>bid_user_project_folders.datecreated asc<cfelseif isdefined("desc") and  desc is 1 and sort is 3>bid_user_project_folders.datecreated desc</cfif>
</CFQUERY>

 <div class="page-header">
  <h3>My Folders - Move Project: <small> <cfoutput>#trim(getfolder.foldername)#</cfoutput></small></h3>
  <span class="tex"><strong>Folder Description:</strong>  
    <cfoutput>#trim(getfolder.description)#</cfoutput>
  </span> <br>
  <br>
  <cfoutput>
  <span class="tex">You are moving Project #url.pgt# Bid #url.bidid# from #trim(getfolder.foldername)# to <CFFORM NAME="RFPManagement" ACTION="#cgi.script.name#?action=620&id_mag=#id_mag#" METHOD="post" onSubmit="return confirm('Are you sure?')"><CFSELECT   size="1" name="changefolder" onChange="location=this.options[this.selectedIndex].value">
          <CFLOOP Query="getfolders">
            <OPTION value="?action=620&userid=#userid#&oldFolder=#id_mag#&bidid=#url.bidid#&newfolder=#folderid#&pgt=#pgt#">#foldername#
          </CFLOOP>
          <Option value="0" selected>- &nbsp;&nbsp;Select folder to move project&nbsp;&nbsp; -</OPTION>
			  </CFSELECT></CFFORM></span> </div>
  </cfoutput>
  
  