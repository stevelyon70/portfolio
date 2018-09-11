<cfquery name="get_user" datasource="#application.dataSource#">
 	select reg_users.name,bid_users.userid,bid_users.admin,bid_users.supplierid 
 	from reg_users inner join  bid_users on reg_users.reg_userid = bid_users.reguserid 
 	where 1=1  
 		and bid_users.userid = #session.auth.userid# 
 		and bid_users.bt_status = 1
 </cfquery>
<cfif get_user.recordcount is 0>
  <cflocation url="../index.cfm" addtoken="No">
</cfif>
<cfquery name="getcustomerstates" datasource="#application.dataSource#">
<!---get the user states--->
	select distinct b.stateid 
	from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
	where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  
		and  a.userid in (
					select bid_users.userid 
					from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid 
					where 1=1 <!---and reg_users.username = '#Session.MM_Username#' --->
						and bid_users.bt_status = 1)
</cfquery>
<cfif getcustomerstates.recordcount is 0 >
  <cflocation url="?action=91&userid=#session.auth.userid#" addtoken="Yes">
</cfif>
<cfset states = "#valuelist(getcustomerstates.stateid)#">
<cfquery name="checkuser" datasource="#application.dataSource#">
select bid_subscription_log.packageid
from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
where bid_users.userid =  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  and bid_subscription_log.effective_date <= #date# and bid_subscription_log.expiration_date >= #date# and bid_subscription_log.active = 1
</cfquery>
<cfif checkuser.recordcount is 0 >
  <cflocation url="../index.cfm" addtoken="No">
</cfif>
<cfquery name="insert_usage" datasource="#application.dataSource#">
INSERT INTO bidtracker_usage_log (userid,cfid,visitdate,page_viewid,remoteip,path)
VALUES(#session.auth.userid#,'#cfid#',#date#,37,'#cgi.remote_addr#','#CGI.CF_Template_Path#')
</cfquery>
<cfquery name="insertcfid" datasource="#application.dataSource#">
INSERT INTO CLOG (cfid,cftoken,visitdate,siteid,remoteip,remotehost,localaddress,path)
VALUES('#cfid#','#cftoken#',#date#,'26','#cgi.remote_addr#', '#cgi.remote_host#','#cgi.local_address#','#CGI.CF_Template_Path#')
</cfquery>

<!--- Get list of folders from database --->
<cfquery  name="getsid" datasource="#application.dataSource#">
	select sid 
	from bid_users 
	where userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">
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
  <h3>Project Folders <small><span class="tex">To view the contents of a folder, click on its name. To edit or delete a folder, click the appropriate link. To add a new folder click the 'Add Folder' link at the bottom of the list.</span></small></h3>
</div>

<CFSET todayDATE = #CREATEODBCDATETIME(NOW())#>
<div class="container gridTop">
<cfoutput>
 <div id="ignore" class="row gridRow">
     <div class="col-xs-4  gridRowHead text-center">
     	<cfif isdefined("sort") and sort is 1 and desc is 2 >
          <a href="#cgi.script.name#?sort=1&desc=1&userID=#session.auth.userid#&folderID=#getfolders.folderID#&nextbutton=1">
          <cfelse>
          <a href="#cgi.script.name#?sort=1&desc=2&userID=#session.auth.userid#&folderID=#getfolders.folderID#&nextbutton=1">
        </cfif>
        <u><b>Folder Name</b></u></a>
     </div>
     <div class="col-xs-1  gridRowHead text-center">
     	<cfif isdefined("sort") and sort is 2 and desc is 2 >
          <a href="#cgi.script.name#?sort=2&desc=1&userID=#session.auth.userid#&folderID=#getfolders.folderID#&nextbutton=1">
          <cfelse>
          <a href="#cgi.script.name#?sort=2&desc=2&userID=#session.auth.userid#&folderID=#getfolders.folderID#&nextbutton=1">
        </cfif>
        <u><b>Type</b></u></a>
     </div>
     <div class="col-xs-1  gridRowHead text-center">
     	<b>Projects</b>
     </div>
     <div class="col-xs-1  gridRowHead text-center">
     	<b>Updated</b>
     </div>
     <div class="col-xs-1  gridRowHead text-center">
     	<cfif isdefined("sort") and sort is 3 and desc is 2 >
          <a href="#cgi.script.name#?sort=3&desc=1&userID=#session.auth.userid#&folderID=#getfolders.folderID#&nextbutton=1">
          <cfelse>
          <a href="#cgi.script.name#?sort=3&desc=2&userID=#session.auth.userid#&folderID=#getfolders.folderID#&nextbutton=1">
        </cfif>
        <u><b>Created</b></u></a>
     </div>
     <div class="col-xs-4  gridRowHead text-right">
     	<div class="row1"><a href="javascript:void(0);" onClick="$('##folderForm').submit();"><b>Delete All Checked</b></a></div>
		<div class="row1"><input type="checkbox" class="selAllTrash" />Check All</div>              
     </div>
</div>
</cfoutput>  
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
			<cfparam default="0" name="getbids.recordcount" />
<form action="?action=585" method="post" id="folderForm">
  <cfoutput query="getfolders">
    <CFQUERY NAME="Getbids" datasource="#application.dataSource#">
		SELECT distinct bid_user_project_bids.bidID
		FROM bid_user_project_bids 
	  	where bid_user_project_bids.folderid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#folderID#"> 
	  		and bid_user_project_bids.active = 1
	  		and (bid_user_project_bids.bidid in (select bidid from pbt_project_master_gateway where stateID in (#states#))
	 		or bid_user_project_bids.bidid in (select bidid from pbt_project_master_gateway_agency where stateID in (#states#)))
	</CFQUERY>
  	 <cfif getbids.recordcount is not 0>
		<cfquery name="getstatus" datasource="#application.dataSource#"  cachedwithin="#CreateTimeSpan(0,0,30,0)#">
			select distinct bidid 
			from pbt_project_updates 
			where bidid in (#valuelist(getbids.bidid)#) 
				and date_entered >= (select max(date_viewed) from bid_user_project_view_log where userid =#session.auth.userid# and date_viewed < #date#)
			UNION
			select distinct bidid 
			from pbt_project_award_stage_detail
			where bidid in (#valuelist(getbids.bidid)#) 
				and (post_date >= 
				(select 
				max(date_viewed) 
				from bid_user_project_view_log 
				where userid = #session.auth.userid# and date_viewed < #date#)  )
		</cfquery>
    </cfif>
  <div class="row gridRow">
	  <div class="col-xs-4 gridRowContent"><a href="?action=folder&userid=#session.auth.userid#&id_mag=#folderid#"  ><span class="tex2">#foldername#</span></a></div>
	  <div class="col-xs-1  gridRowContent text-center"><span class="tex">
        <cfif getfolders.privacy_setting is 1>
          Public
          <cfelseif getfolders.privacy_setting is 2>
          Private
          <cfelseif getfolders.privacy_setting is 3>
          Shared
        </cfif>
        </span></div>
	  <div class="col-xs-1  gridRowContent text-center <cfif Getbids.recordcount>warning</cfif>"><span class="tex">#getbids.recordcount#</span></div>
	  <div class="col-xs-1  gridRowContent text-center"><cfif getbids.recordcount is not 0>
          <cfif getstatus.recordcount GT 0>
            <span class="tex5"><strong>
            <cfelse>
            <span class="tex">
          </cfif>
          #getstatus.recordcount#</span>
          <cfelse>
          <span class="tex">0</span>
        </cfif></div>
	  <div class="col-xs-1  gridRowContent text-center"><span class="tex">#dateformat(datecreated, "mm/dd/yyyy")#</span></div>
	  <div class="col-xs-4  gridRowContent text-center">
	  	<div class="col-xs-4">	  		
			<a href="?action=58&userid=#session.auth.userid#&id_mag=#folderid#" ><span class="tex2">Edit</span></a>
	  	</div>
	  	<div class="col-xs-4 <cfif Getbids.recordcount>warning</cfif>">			
			<cfif Getbids.recordcount><i class="clip-warning"></i></cfif><a href="?action=59&id_mag=#folderid#" > <span class="tex2">Delete</span></a>
	  	</div>
	  	<div class="col-xs-4">		
			<input type="checkbox" class="trashbox" name="folderDel" value="#folderid#" />
	  	</div>
	  </div>
  </div>
  </cfoutput>
</form>
<cfquery datasource="#application.dataSource#" name="clipCount">
	SELECT *
	FROM pbt_project_clipboard
	where userID = #session.auth.userid#
</cfquery>
<div class="row gridRow">
	  <div class="col-xs-4 gridRowContent"><a href="?action=clip&id_mag=1"  ><span class="tex2">Clip Board</span></a></div>
	  <div class="col-xs-1  gridRowContent text-center"><span class="tex">        
          Private
        </span></div>
	  <div class="col-xs-1  gridRowContent text-center <cfif Getbids.recordcount>warning</cfif>"><span class="tex"><cfoutput>#clipCount.recordcount#</cfoutput></span></div>
	  <div class="col-xs-1  gridRowContent text-center"></div>
	  <div class="col-xs-1  gridRowContent text-center"></div>
	  <div class="col-xs-4  gridRowContent text-center">
	  	<div class="col-xs-4">	  		
			
	  	</div>
	  	<div class="col-xs-4 <cfif Getbids.recordcount>warning</cfif>">			
			
	  	</div>
	  	<div class="col-xs-4">		
			
	  	</div>
	  </div>
  </div>
</div>

<cfif getfolders.recordcount is 0>
  <table>
    <tr>
      <td><b>No folders saved.</b></td>
    </tr>
  </table>
</cfif>
<cfoutput><a href="?action=60&userid=#session.auth.userid#" ></cfoutput><span class="tex2">-- Add a New Folder -- </span></a>
<!---
<cfquery name="check_view" datasource="#application.dataSource#">
				select max(date_viewed) as viewage from bid_user_project_view_log
				where userid = #session.auth.userid#
				  </cfquery>
<cfif check_view.viewage is "" or check_view.viewage LT cdate>
  <cfquery name="insert_view" datasource="#application.dataSource#">
				  insert into bid_user_project_view_log
				  (userid,date_viewed)
				  values(#session.auth.userid#,#todaydate#)
				  </cfquery>
</cfif>--->
<style>
	.gridRow{padding-top: 5px;border-bottom: 1px solid silver;}
	.gridRowContent{}
	. gridRowHead text-center{font-weight: 600;}
	.gridTop{border-top:1px solid silver;}
	
	.gridTop .row:nth-of-type(even) {
		background-color:#f7f5f5;
		}
	.gridTop .row:nth-of-type(odd) {
		background: #FFFFFF;
		}
	div.warning{
    		background-color: #fffc7a;
	}
	

</style>
