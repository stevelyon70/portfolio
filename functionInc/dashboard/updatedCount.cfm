
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

<cfset updateCnt = 0>
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
    <cfif getbids.recordcount is not 0>
       <cfset updateCnt = updateCnt+getstatus.recordcount> 
     </cfif>
</cfoutput>
       