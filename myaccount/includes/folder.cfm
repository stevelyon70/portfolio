<!---updated on 02/18/04 by D'Juan Stevens 
     changed the est value link took it off--->
<!---
******************************
Updated on 2/22/06 by ty:
adding sort function for project_folders table

Updated on 8/30/11 by DS to fix long running query
******************************
--->

<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<cfquery name="getcustomerstates" datasource="#application.datasource#">
<!---get the user states--->
select distinct b.stateid from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
where a.userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">  and  a.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where 0=0 and bid_users.bt_status = 1)
</cfquery>
<cfif getcustomerstates.recordcount is 0 >
  <cflocation url="?action=91&userid=#userid#" addtoken="Yes">
</cfif>
<cfset states = "#valuelist(getcustomerstates.stateid)#">

<!---check to see if user is auth. to receive paint bids, if not send them back--->
<!---cfquery name="checkuser" datasource="#application.datasource#">select bid_user_suppliers.basicpkg,bid_user_suppliers.aebids,bid_user_suppliers.awards from bid_user_suppliers inner join bid_users on bid_users.sid = bid_user_suppliers.sid where bid_users.userid = #userid#</cfquery--->
<cfquery name="checkuser" datasource="#application.datasource#">
select bid_subscription_log.packageid
from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
where bid_users.userid =  <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">  and bid_subscription_log.effective_date <= #date# and bid_subscription_log.expiration_date >= #date# and bid_subscription_log.active = 1
</cfquery>
<cfif checkuser.recordcount is 0 >
  <cflocation url="?userid=#userid#" addtoken="No">
</cfif>
<cfif isdefined("process") and process is 1>
  <!---delete bids--->
  
  <cfif isdefined("form.SUBMIT.X")>
    <cfif not isdefined("projectid") or projectid is "">
      <cflocation url="?action=38&userid=#userid#&id_mag=#id_mag#">
    </cfif>
    <cfloop index="i" list="#projectid#">
      <cfquery name="deletefolder" datasource="#application.datasource#">
update bid_user_project_bids
set active = 2
where projectid = #i# and userid = #session.userid#
</cfquery>
      <cfquery name="deletecomments" datasource="#application.datasource#">
update bid_user_project_comments
set active = 2
where projectid = #i# and userid = #session.userid#
</cfquery>
    </cfloop>
  </cfif>
  <cfif isdefined("form.SUBMIT2.X") and project_folder is not 0>
    <cfif not isdefined("projectid") or projectid is "">
      <cflocation url="?action=38&userid=#userid#&id_mag=#id_mag#">
    </cfif>
    <cfloop index="i" list="#form.projectid#">
      <cfquery name="updateproject" datasource="#application.datasource#">
update bid_user_project_bids
set folderid = #project_folder#
where projectid = #i# and userid = #session.userid#
</cfquery>
    </cfloop>
  </cfif>
</cfif>
<cftransaction action="begin">
  <CFSET todaydate = #CREATEODBCDATETIME(NOW())#>
  <!---run the stored procedure to pull the industrial bids--->
  <!--- Get information about films from database --->
  <CFQUERY NAME="Getbids" datasource="#application.datasource#" result="r1">
SELECT distinct pbt_project_master_gateway.stageID, bid_user_project_bids.projectID,bid_user_project_bids.userid as original_user,  
bid_user_project_bids.date_entered,bid_user_project_bids.projectname, bid_user_project_bids.folderid,
bid_user_project_bids.bidid, pbt_project_master_gateway.projectname,pbt_project_master_gateway.owner,pbt_project_master_gateway.city,
pbt_project_master_gateway.state,pbt_project_master_gateway.submittaldate,
pbt_project_master_gateway.paintpublishdate,pbt_project_updates.updateID,f.bidtypeID as stageID,pbt_project_updates.date_entered as editdate,bid_user_viewed_log.bidid as viewed
FROM bid_user_project_bids 
inner join pbt_project_master_gateway on pbt_project_master_gateway.bidid = bid_user_project_bids.bidid
inner join pbt_project_stage f on f.bidID = bid_user_project_bids.bidID
			and f.stageID = (select max(stageID) from pbt_project_stage where bidID = bid_user_project_bids.bidid )
left outer join pbt_project_award_stage_detail on pbt_project_award_stage_detail.bidid = bid_user_project_bids.bidid
left outer join pbt_project_updates on pbt_project_updates.bidid = bid_user_project_bids.bidid 
and pbt_project_updates.pupdateid = (select max(pupdateID) from pbt_project_updates where bidID = bid_user_project_bids.bidid )
and pbt_project_updates.date_entered >= (select max(date_viewed) from bid_user_project_view_log where userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">) 
LEFT OUTER JOIN bid_user_viewed_log on bid_user_project_bids.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid =  <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">
	
where bid_user_project_bids.folderid =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#id_mag#"> and pbt_project_master_gateway.stateid in (#states#) 
and bid_user_project_bids.active = 1

union
SELECT distinct a.stageID, bid_user_project_bids.projectID,bid_user_project_bids.userid as original_user,  
bid_user_project_bids.date_entered,bid_user_project_bids.projectname, bid_user_project_bids.folderid,
bid_user_project_bids.bidid, a.projectname,a.owner,a.city,
a.state,NULL as submittaldate,
a.paintpublishdate,pbt_project_updates.updateID,f.bidtypeID as stageID,pbt_project_updates.date_entered as editdate,bid_user_viewed_log.bidid as viewed
FROM bid_user_project_bids 
inner join pbt_project_master_gateway_agency a on a.bidid = bid_user_project_bids.bidid
inner join pbt_project_stage f on f.bidID = bid_user_project_bids.bidID
			and f.stageID = (select max(stageID) from pbt_project_stage where bidID = bid_user_project_bids.bidid )
left outer join pbt_project_award_stage_detail on pbt_project_award_stage_detail.bidid = bid_user_project_bids.bidid
left outer join pbt_project_updates on pbt_project_updates.bidid = bid_user_project_bids.bidid 
and pbt_project_updates.pupdateid = (select max(pupdateID) from pbt_project_updates where bidID = bid_user_project_bids.bidid )
and pbt_project_updates.date_entered >= (select max(date_viewed) from bid_user_project_view_log where userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">) 
LEFT OUTER JOIN bid_user_viewed_log on bid_user_project_bids.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid =  <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">
	
where bid_user_project_bids.folderid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#id_mag#"> and a.stateid in (#states#) 
and bid_user_project_bids.active = 1

ORDER BY <cfif not isdefined("sort")>editdate desc,pbt_project_master_gateway.paintpublishdate desc,pbt_project_master_gateway.projectname</cfif>
  <cfif isdefined("sort") and sort is 1 and desc is 2>bid_user_project_bids.bidid asc<cfelseif isdefined("desc") and  desc is 1 and sort is 1>bid_user_project_bids.bidid desc</cfif>
<cfif isdefined("sort") and sort is 2 and desc is 2>bid_user_project_bids.projectname asc<cfelseif isdefined("desc") and  desc is 1 and sort is 2>bid_user_project_bids.projectname desc</cfif>
<cfif isdefined("sort") and sort is 3 and desc is 2>pbt_project_master_gateway.owner asc<cfelseif isdefined("desc") and  desc is 1 and sort is 3>pbt_project_master_gateway.owner desc</cfif>
<cfif isdefined("sort") and sort is 4 and desc is 2>pbt_project_master_gateway.city asc<cfelseif isdefined("desc") and  desc is 1 and sort is 4>pbt_project_master_gateway.city desc</cfif>
<cfif isdefined("sort") and sort is 5 and desc is 2>pbt_project_master_gateway.state asc<cfelseif isdefined("desc") and  desc is 1 and sort is 5>pbt_project_master_gateway.state desc</cfif>		
<cfif isdefined("sort") and sort is 6 and desc is 2>pbt_project_master_gateway.submittaldate asc<cfelseif isdefined("desc") and  desc is 1 and sort is 6>pbt_project_master_gateway.submittaldate desc</cfif>		
<cfif isdefined("sort") and sort is 7 and desc is 2>pbt_project_master_gateway.paintpublishdate asc<cfelseif isdefined("desc") and  desc is 1 and sort is 7>pbt_project_master_gateway.paintpublishdate desc</cfif>		
</CFQUERY>
  <cfquery  name="getsid" datasource="#application.datasource#">
select sid from bid_users where userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>
  <cfquery name="getfolder" datasource="#application.datasource#">
select distinct bid_user_project_folders.foldername,bid_user_project_folders.description,bid_user_project_folders.userid as original_user
from bid_user_project_folders 
left outer join bid_user_privacy_log on bid_user_privacy_log.folderid = bid_user_project_folders.folderid
where bid_user_project_folders.folderid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#id_mag#">
and bid_user_project_folders.active = 1
and siteid = #session.auth.siteID#
and (1 <> 1 
or (bid_user_project_folders.privacy_setting = 1 and bid_user_project_folders.userid in (select userid from bid_users where sid = #getsid.sid#)) 
or (bid_user_project_folders.privacy_setting = 3 and ((bid_user_privacy_log.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#"> and bid_user_privacy_log.userid in (select userid from bid_users where sid in (select sid from bid_users where userid = bid_user_project_folders.userid))) or bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))
or (bid_user_project_folders.privacy_setting is null and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">)
or (bid_user_project_folders.privacy_setting = 2 and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))
</cfquery>
  <cfif getfolder.recordcount is 0 >
    <cflocation url="?userid=#userid#" addtoken="No">
  </cfif>
  
  <!---cfif getbids.recordcount is not 0>
				<cfquery name="querynew" datasource="#application.datasource#"><!---pull results from storedproc--->
				select bidid, projectname,owner,city,state,submittaldate,categoryid from pbt_project_master_gateway where stateid in (#states#) and bidid <> 1 and bidid in (#valuelist(getbids.bidid)#)
				</cfquery>	
			</cfif--->
  
</cftransaction>
<cfquery name="insert_usage" datasource="#application.datasource#">
INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
VALUES(#userid#,'#cfid#',#date#,38,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
</cfquery>
<cfquery name="insertcfid" datasource="#application.datasource#">
INSERT INTO CLOG (cfid,cftoken,visitdate,siteid,remoteip,remotehost,localaddress,path)
VALUES('#cfid#','#cftoken#',#date#,'200','#cgi.remote_addr#', '#cgi.remote_host#','#cgi.local_address#','#CGI.CF_Template_Path#')
</cfquery>
<cfif not isdefined("querynew")>
  <cfquery name="static" datasource="#application.datasource#">
select bidid from bid_award where bidid = 1
</cfquery>
</cfif>
<CFPARAM NAME="mystartrow" DEFAULT="1">
<CFPARAM NAME="realstartrow" DEFAULT="1">
<cfif isdefined("querynew")>
  <cfset request.RCQuery = querynew>
  <cfelse>
  <Cfset request.RCQuery = static>
</cfif>
<CFQUERY NAME="Getfolders" datasource="#application.datasource#">
SELECT distinct  bid_user_project_folders.folderID, bid_user_project_folders.foldername,bid_user_project_folders.privacy_setting
FROM bid_user_project_folders
left outer join bid_user_privacy_log on bid_user_privacy_log.folderid = bid_user_project_folders.folderid
where bid_user_project_folders.active = 1 
and siteid = #session.auth.siteID#
and (1 <> 1 
or (bid_user_project_folders.privacy_setting = 1 and bid_user_project_folders.userid in (select userid from bid_users where sid = #getsid.sid#)) 
or (bid_user_project_folders.privacy_setting = 3 and (bid_user_privacy_log.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#"> or bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))
or (bid_user_project_folders.privacy_setting is null and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">)
or (bid_user_project_folders.privacy_setting = 2 and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#userid#">))
ORDER BY bid_user_project_folders.foldername
</CFQUERY>

<div class="page-header">
  <h3>My Folders - Current Folder: <small> <cfoutput>#trim(getfolder.foldername)#</cfoutput></small></h3>
  <span class="tex"><strong>Folder Description:</strong>
  <cfif getfolder.description is "" >
    <cfif (getfolders.privacy_setting is 1 or getfolders.privacy_setting is 2 or getfolders.privacy_setting is "" or getfolders.privacy_setting is 3) and getfolder.original_user is userid>
     <cfoutput> <a href="?action=58&userid=#userid#&id_mag=#id_mag#"><span class="tex2">- add a description -</span></a></cfoutput>
      <cfelse>
      N/A
    </cfif>
    <cfelse>
    <cfoutput>#trim(getfolder.description)#</cfoutput>
  </cfif>
  </span> <br>
  <br>
  <span class="tex">Here are the projects you are tracking in this folder. To view the details, click a project name. To move a project to a different folder, check the 'Select' box of the project, select the appropriate folder, and click the 'Move Project' button. To delete a project, check the 'Select' box and click the 'Delete Project' button. <br>
  <br>
  To add a new project, use the left-hand menu to view or search for the information you want. On the project detail page, click the "Track Project" button and select this folder." </span> </div>
<CFFORM NAME="RFPManagement" ACTION="#cgi.script.name#?action=folder&id_mag=#id_mag#" METHOD="post" onSubmit="return confirm('Are you sure?')">
  <table class="table table-striped table-bordered table-hover table-full-width">
    <TR id="ignore" bgcolor="white" border="0" align="right">
      <TD valign="bottom" colspan="9"><!---cfselect name="project_folder" query="getfolders" value="folderid" display="foldername" style="font-size:14px;" required="yes" onChange="location=this.options[this.selectedIndex].value"><Option value="0" selected>- &nbsp;&nbsp;View a Different Folder&nbsp;&nbsp; -</OPTION></cfselect---> 
        
        <cfoutput>
          <CFSELECT   size="1" name="changefolder" onChange="location=this.options[this.selectedIndex].value">
          <CFLOOP Query="getfolders">
            <OPTION value="?action=folder&userid=#userid#&id_mag=#folderid#">#foldername#
          </CFLOOP>
          <Option value="0" selected>- &nbsp;&nbsp;View a Different Folder&nbsp;&nbsp; -</OPTION>
          </CFSELECT>
        </cfoutput> 
        
        <!---input type="image" name="submit2" src="move_project.gif"   border="0" >&nbsp;&nbsp;&nbsp;|&nbsp;<input type="image" name="submit" src="delete_project.gif"   border="0" ----></td>
      &nbsp;
      </TD>
    </TR>
  </table>
  <input type="hidden" value="#userid#" name="userid">
  <input type="hidden" value="#getbids.bidid#" name="bidid">
</cfform>
<cfquery name="checkuser2" datasource="#application.datasource#">
select bid_subscription_log.packageid
from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
where bid_users.userid =  #userid# and bid_subscription_log.effective_date <= #date# and bid_subscription_log.expiration_date >= #date#
</cfquery>
<table class="table table-striped table-bordered table-hover table-full-width">
  <tr id="ignore"><cfoutput>
      <td width="7%" align="center"><cfif isdefined("sort") and sort is 1 and desc is 2 >
          <a href="#cgi.script.name#?sort=1&desc=1&userID=#userID#&id_mag=#id_mag#&action=#action#">
          <cfelse>
          <a href="#cgi.script.name#?sort=1&desc=2&userID=#userID#&id_mag=#id_mag#&action=#action#">
        </cfif>
        <span class="tex4"><u><b>BidID</b></u></span></td>
      <td width="15%" align="center"><cfif isdefined("sort") and sort is 2 and desc is 2 >
          <a href="#cgi.script.name#?sort=2&desc=1&userID=#userID#&id_mag=#id_mag#&action=#action#">
          <cfelse>
          <a href="#cgi.script.name#?sort=2&desc=2&userID=#userID#&id_mag=#id_mag#&action=#action#">
        </cfif>
        <span class="tex4"><u><b>Project
        
        Name</b></u></span></a></td>
      <td width="12%" align="center"><cfif isdefined("sort") and sort is 3 and desc is 2 >
          <a href="#cgi.script.name#?sort=3&desc=1&userID=#userID#&id_mag=#id_mag#&action=#action#">
          <cfelse>
          <a href="#cgi.script.name#?sort=3&desc=2&userID=#userID#&id_mag=#id_mag#&action=#action#">
        </cfif>
        <span class="tex4"><u><b>Agency</b></u></span></td>
      <td width="10%" align="center"><cfif isdefined("sort") and sort is 4 and desc is 2 >
          <a href="#cgi.script.name#?sort=4&desc=1&userID=#userID#&id_mag=#id_mag#&action=#action#">
          <cfelse>
          <a href="#cgi.script.name#?sort=4&desc=2&userID=#userID#&id_mag=#id_mag#&action=#action#">
        </cfif>
        <span class="tex4"><u><b>City</b></u></span></td>
      <td width="5%" align="center"><cfif isdefined("sort") and sort is 5 and desc is 2 >
          <a href="#cgi.script.name#?sort=5&desc=1&userID=#userID#&id_mag=#id_mag#&action=#action#">
          <cfelse>
          <a href="#cgi.script.name#?sort=5&desc=2&userID=#userID#&id_mag=#id_mag#&action=#action#">
        </cfif>
        <span class="tex4"><u><b>St.</b></u></span></td>
      <td width="13%" align="center"><cfif isdefined("sort") and sort is 6 and desc is 2 >
          <a href="#cgi.script.name#?sort=6&desc=1&userID=#userID#&id_mag=#id_mag#&action=#action#">
          <cfelse>
          <a href="#cgi.script.name#?sort=6&desc=2&userID=#userID#&id_mag=#id_mag#&action=#action#">
        </cfif>
        <span class="tex4"><u><b>Bid Submittal Date</b></u></span></td>
      <td width="13%" align="center"><cfif isdefined("sort") and sort is 7 and desc is 2 >
          <a href="#cgi.script.name#?sort=7&desc=1&userID=#userID#&id_mag=#id_mag#&action=#action#">
          <cfelse>
          <a href="#cgi.script.name#?sort=7&desc=2&userID=#userID#&id_mag=#id_mag#&action=#action#">
        </cfif>
        <span class="tex4"><u><b>Last Changed</b></u></span></td>
      <td width="13%"  align="center"><span class="tex4"><b>Delete</b></span></td>
      <td width="13%" align="center"><span class="tex4"><b>Move</b></span></td>
      <td>
      	<div class="row1"><a href="javascript:void(0);" onClick="$('##folderForm').submit();"><b>Remove All Checked</b></a></div>
		<div class="row1"><input type="checkbox" class="selAllTrash" />Check All</div>   
   	  </td>
    </cfoutput> </tr>
  <cfif getbids.recordcount is not 0>
   <form action="?action=610" method="post" id="folderForm">
    <cfoutput query="getbids">
      <tr bgcolor="white"> 
        <!---run query to get the date and see if the bid is new--->
        <CFSET todayDATE = #CREATEODBCDATE(NOW())#>        
        <td width="7%"  align="center" ><span class="tex"><b>#bidid#</b></span></td>
        <td width="15%" >
          <cfif dateformat(paintpublishdate) gte dateformat(todaydate)>
            <span style="color: red; font-weight:bold" >New Today!</span><br>
            <cfelseif updateid is not "" and  (updateid is 1 or updateid is 7 or updateid is 8 or updateid is 9 or updateid is 10) >
            <span style="color: red; font-weight:bold" >Updated!</span><br>
            <cfelseif updateid is not "" and updateid is 2 >
            <span style="color: red; font-weight:bold" >Submittal Change!</span><br>
            <cfelseif updateid is not "" and updateid is 3 >
            <span style="color: red; font-weight:bold" >Cancelled!</span><br>
            <!---cfelseif updateid is not "" and updateid is 4 >
				<span style="color: red; font-weight:bold" >Amendment</span><br--->
            <cfelseif updateid is not "" and updateid is 5 >
            <span style="color: red; font-weight:bold" >Award!</span><br>
            <cfelseif updateid is not "" and updateid is 6 >
            <span style="color: red; font-weight:bold" >Bid Results!</span><br>
            <cfelseif updateid is not "" and updateid is 14 >
            <span style="color: red; font-weight:bold" >Pre-Bid Mandatory!</span><br>
            <cfelseif updateid is not "" and updateid is 15 >
            <span style="color: red; font-weight:bold" >No Painting!</span><br>
            <cfelseif updateid is not "" and updateid is 19 >
            <span style="color: red; font-weight:bold" >Rejected!</span><br>
            <cfelseif updateid is not "" and updateid is 20 >
            <span style="color: red; font-weight:bold" >Rebid!</span><br>
            <cfelseif getbids.stageID NEQ "" and getbids.stageID EQ 5>
            <span style="color: red; font-weight:bold" >Award!</span><br>
            <cfelseif getbids.stageID NEQ "" and getbids.stageID EQ 6>
            <span style="color: red; font-weight:bold" >Bid Results!</span><br>
          </cfif>
          <cfif stageID NEQ "26">
            <a href="../../leads/?bidid=#bidid#">
            <cfelse>
            <a href="../../leads/?action=planning&bidid=#bidid#">
          </cfif>
          <span class="tex2">#trim(projectname)#</span></a></td>
        <td width="12%" ><span class="tex">#owner#</span></td>
        <td width="10%" align="center"><span class="tex">#city#</span></td>
        <td width="5%" align="center" ><span class="tex">#state#</span></td>
        <td width="13%" align="center"><span class="tex">#dateformat(submittaldate, "mm/dd/yyyy")#</span>&nbsp;</td>
        <td width="13%" align="center"><span class="tex">
          <cfif paintpublishdate GT editdate>
            #dateformat(paintpublishdate, "mm/dd/yyyy")#
            <cfelse>
            #dateformat(editdate, "mm/dd/yyyy")#
          </cfif>
          </span>&nbsp;</td>
        <td width="13%" align="center"><cfif getbids.original_user is userid>
            <a href="?action=61&pgt=#projectid#&userid=#userid#&id_mag=#id_mag#&bidid=#bidid#" ><span class="tex2">Delete</span></a>
            <cfelse>
            <span class="tex7">Delete</span>
          </cfif>
          &nbsp;</td>
        <td width="13%" align="center"><a href="?action=62&pgt=#projectid#&userid=#userid#&id_mag=#id_mag#&bidid=#bidid#" ><span class="tex2">Move</span></a>&nbsp;</td>
        <td><cfif getbids.original_user is userid><input type="checkbox" class="trashbox" name="bidDel" value="#bidid#" /> </cfif></td>
      </tr>
    </cfoutput> 
</form>
  </cfif>
</table>
<p></p>
<cfif getbids.recordcount is 0>
  <table>
    <tr>
      <td><b><span class="tex">There are no projects listed under this folder.</span></b></td>
    </tr>
  </table>
</cfif>
</div>
<script>					
	$(".selAllTrash").on('click',function(){
			if(this.checked){
				$('.trashbox').each(function(){
					this.checked = true;
				})
			}else{
				$('.trashbox').each(function(){
					this.checked = false;
				})
			}
		});
</script>