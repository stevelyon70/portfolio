
<cftransaction action="begin">
  <CFSET todaydate = #CREATEODBCDATETIME(NOW())#>
  <cfquery name="getcustomerstates" datasource="#application.datasource#">
<!---get the user states--->
select distinct b.stateid from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  and  a.userid in (select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where 0=0 and bid_users.bt_status = 1)
</cfquery>

<cfset states = "#valuelist(getcustomerstates.stateid)#">
  <!---run the stored procedure to pull the industrial bids--->
  <!--- Get information about films from database --->
  <CFQUERY NAME="Getbids" datasource="#application.datasource#" result="r1">
  
SELECT distinct pbt_project_master_gateway.stageID, 
	pbt_project_master_gateway.submittaldate,
	pbt_project_master_gateway.projectname,  
	pbt_project_master_gateway.owner,
	pbt_project_master_gateway.city, 
	pbt_project_master_gateway.state,
	pbt_project_master_gateway.paintpublishdate,
	pbt_project_updates.updateID,
	f.bidtypeID as stageID,
	pbt_project_updates.date_entered as editdate ,
	pbt_project_master_gateway.bidid
FROM pbt_project_master_gateway
	inner join pbt_project_stage f on f.bidID = pbt_project_master_gateway.bidID and f.stageID = (select max(stageID) from pbt_project_stage where bidID = pbt_project_master_gateway.bidid ) 
	left outer join pbt_project_award_stage_detail on pbt_project_award_stage_detail.bidid = pbt_project_master_gateway.bidid 
	left outer join pbt_project_updates on pbt_project_updates.bidid = pbt_project_master_gateway.bidid and pbt_project_updates.pupdateid = (select max(pupdateID) from pbt_project_updates where bidID = pbt_project_master_gateway.bidid )	
where pbt_project_master_gateway.stateid in(#states#) 
	and pbt_project_master_gateway.bidid in (
											select cb.bidid 
											from pbt_project_clipboard cb
											inner join pbt_project_master_cats c on c.bidid = cb.bidid
											inner join site_tag_xref x on c.tagid = x.tagid
											where cb.userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">
											and x.active = 1 
											and c.tagid = <cfqueryPARAM value = "#session.default.tagId#" CFSQLType = "CF_SQL_INTEGER">
											and x.siteID = <cfqueryPARAM value = "#session.auth.siteid#" CFSQLType = "CF_SQL_INTEGER">
											) 
union 
SELECT distinct a.stageID, 
	NULL as submittaldate, 
	a.projectname, 
	a.owner,
	a.city,
	a.state,
	a.paintpublishdate,
	pbt_project_updates.updateID,
	f.bidtypeID as stageID,
	pbt_project_updates.date_entered as editdate ,
	a.bidid
FROM pbt_project_master_gateway_agency a
	inner join pbt_project_stage f on f.bidID = a.bidID and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid ) 
	left outer join pbt_project_award_stage_detail on pbt_project_award_stage_detail.bidid = a.bidid 
	left outer join pbt_project_updates on pbt_project_updates.bidid = a.bidid and pbt_project_updates.pupdateid = (select max(pupdateID) from pbt_project_updates where bidID = a.bidid )	
where a.stateid in (#states#) 
	and a.bidid in (
					select cb.bidid 
					from pbt_project_clipboard cb
					inner join pbt_project_master_cats c on c.bidid = cb.bidid
					inner join site_tag_xref x on c.tagid = x.tagid
					where cb.userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">
					and x.active = 1 
					and c.tagid = <cfqueryPARAM value = "#session.default.tagId#" CFSQLType = "CF_SQL_INTEGER">
					and x.siteID = <cfqueryPARAM value = "#session.auth.siteid#" CFSQLType = "CF_SQL_INTEGER">					
					) 
ORDER BY <cfif not isdefined("sort")>editdate desc,pbt_project_master_gateway.paintpublishdate desc,pbt_project_master_gateway.projectname</cfif>
  <cfif isdefined("sort") and sort is 1 and desc is 2>bid_user_project_bids.bidid asc<cfelseif isdefined("desc") and  desc is 1 and sort is 1>bid_user_project_bids.bidid desc</cfif>
<cfif isdefined("sort") and sort is 2 and desc is 2>bid_user_project_bids.projectname asc<cfelseif isdefined("desc") and  desc is 1 and sort is 2>bid_user_project_bids.projectname desc</cfif>
<cfif isdefined("sort") and sort is 3 and desc is 2>pbt_project_master_gateway.owner asc<cfelseif isdefined("desc") and  desc is 1 and sort is 3>pbt_project_master_gateway.owner desc</cfif>
<cfif isdefined("sort") and sort is 4 and desc is 2>pbt_project_master_gateway.city asc<cfelseif isdefined("desc") and  desc is 1 and sort is 4>pbt_project_master_gateway.city desc</cfif>
<cfif isdefined("sort") and sort is 5 and desc is 2>pbt_project_master_gateway.state asc<cfelseif isdefined("desc") and  desc is 1 and sort is 5>pbt_project_master_gateway.state desc</cfif>		
<cfif isdefined("sort") and sort is 6 and desc is 2>pbt_project_master_gateway.submittaldate asc<cfelseif isdefined("desc") and  desc is 1 and sort is 6>pbt_project_master_gateway.submittaldate desc</cfif>		
<cfif isdefined("sort") and sort is 7 and desc is 2>pbt_project_master_gateway.paintpublishdate asc<cfelseif isdefined("desc") and  desc is 1 and sort is 7>pbt_project_master_gateway.paintpublishdate desc</cfif>	

<!---
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
	and pbt_project_updates.date_entered >= (select max(date_viewed) from bid_user_project_view_log where userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">) 
	LEFT OUTER JOIN bid_user_viewed_log on bid_user_project_bids.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid =  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">
	
where pbt_project_master_gateway.stateid in (#states#) 
and bid_user_project_bids.active = 1
and bid_user_project_bids.bidid in (select bidid from pbt_project_clipboard where userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">)

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
and pbt_project_updates.date_entered >= (select max(date_viewed) from bid_user_project_view_log where userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">) 
LEFT OUTER JOIN bid_user_viewed_log on bid_user_project_bids.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid =  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">
	
where a.stateid in (#states#) 
and bid_user_project_bids.active = 1
and bid_user_project_bids.bidid in (select bidid from pbt_project_clipboard where userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">)

ORDER BY <cfif not isdefined("sort")>editdate desc,pbt_project_master_gateway.paintpublishdate desc,pbt_project_master_gateway.projectname</cfif>
  <cfif isdefined("sort") and sort is 1 and desc is 2>bid_user_project_bids.bidid asc<cfelseif isdefined("desc") and  desc is 1 and sort is 1>bid_user_project_bids.bidid desc</cfif>
<cfif isdefined("sort") and sort is 2 and desc is 2>bid_user_project_bids.projectname asc<cfelseif isdefined("desc") and  desc is 1 and sort is 2>bid_user_project_bids.projectname desc</cfif>
<cfif isdefined("sort") and sort is 3 and desc is 2>pbt_project_master_gateway.owner asc<cfelseif isdefined("desc") and  desc is 1 and sort is 3>pbt_project_master_gateway.owner desc</cfif>
<cfif isdefined("sort") and sort is 4 and desc is 2>pbt_project_master_gateway.city asc<cfelseif isdefined("desc") and  desc is 1 and sort is 4>pbt_project_master_gateway.city desc</cfif>
<cfif isdefined("sort") and sort is 5 and desc is 2>pbt_project_master_gateway.state asc<cfelseif isdefined("desc") and  desc is 1 and sort is 5>pbt_project_master_gateway.state desc</cfif>		
<cfif isdefined("sort") and sort is 6 and desc is 2>pbt_project_master_gateway.submittaldate asc<cfelseif isdefined("desc") and  desc is 1 and sort is 6>pbt_project_master_gateway.submittaldate desc</cfif>		
<cfif isdefined("sort") and sort is 7 and desc is 2>pbt_project_master_gateway.paintpublishdate asc<cfelseif isdefined("desc") and  desc is 1 and sort is 7>pbt_project_master_gateway.paintpublishdate desc</cfif>		
--->
</CFQUERY>


  
  
</cftransaction>

<!---cfdump var="#r1#"/ --->

<div class="page-header">
  <h3>My Folders - Current Folder: <small> Clipboard</small></h3>
  <span class="tex"><strong>Folder Description:</strong>  
    This is the default folder to hold any of the bids/projects you have saved to your clipboard.
  </span> <br>
  <br>
  <span class="tex">Here are the projects you are tracking in this folder. To view the details, click a project name. To move a project to a different folder, check the 'Select' box of the project, select the appropriate folder, and click the 'Move Project' button. To delete a project, check the 'Select' box and click the 'Delete Project' button. <br>
  <br>
  To add a new project, use the left-hand menu to view or search for the information you want. On the project detail page, click the "Track Project" button and select this folder." </span> </div>

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
    </cfoutput> </tr>
  <cfif getbids.recordcount is not 0>
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
        <td width="13%" align="center">
            <a href="?action=61&pgt=&userid=#userid#&id_mag=#id_mag#&bidid=#bidid#&fromClip=1" ><span class="tex2">Delete</span></a>
          &nbsp;</td>
        <td width="13%" align="center"><a href="?action=62&pgt=&userid=#userid#&id_mag=#id_mag#&bidid=#bidid#" ><span class="tex2">Move</span></a>&nbsp;</td>
      </tr>
    </cfoutput> <cfoutput> </cfoutput>
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
