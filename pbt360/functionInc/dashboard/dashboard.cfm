<!---Last Visit include for Dashboard Module
**update on 4/9/14 by DS to change from last visit to new projects as of 1 day prior
--->
  <cftry>

<CFSET tdate = #CREATEODBCDATE(NOW())#>
<CFSET date = tdate />

<CFQUERY NAME="GET_Sub_TAGS" DATASOURCE="#application.datasource#">
		select * 
		from pbt_tags
	  </cfquery>
	  <cfset variable.user_tags = valuelist(GET_Sub_TAGS.tagID)>
<cfquery name="get_effectivedate" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#" result="r1">
	select bid_user_suppliers.effectivedate 
	from bid_user_suppliers inner join bid_users on bid_users.sid = bid_user_suppliers.sid
	where bid_users.userid = #session.auth.userid#
</cfquery>

<!---cfquery name="set_lastview" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
select max(visitdate) as lastview
from bidtracker_usage_log
where userid = #session.userid# and visitdate < #tdate#
</cfquery--->
<cfset day=dayofweek(tdate)>
<cfset d =#dayofweekasstring(day)#>
<Cfif d is "Sunday">
  <cfset tdate = dateadd("d",-1,tdate)>
  <cfelseif d is "Monday">
  <cfset tdate = dateadd("d",-2,tdate)>
</cfif>
<cfset variables.lastview = dateadd("d",-1,tdate)>
<cfset variables.lastview = dateformat(variables.lastview,"mm/dd/yyyy")>
<cfset packageid = 1>
<cfset qrecord = 4>
<cfstoredproc procedure="getcustomerstates" datasource="#application.datasource#" debug="Yes" returncode="Yes">
  <cfprocparam type="in" dbvarname="@userID" cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">
  <cfprocparam type="in" dbvarname="@packageID" cfsqltype="CF_SQL_INTEGER" value="#packageid#">
  <cfprocparam type="in" dbvarname="@username" cfsqltype="CF_SQL_VARCHAR" value="#Session.auth.username#">
  <cfprocresult name="getcustomerstates" resultset="#qrecord#">
</cfstoredproc>
<cfif getcustomerstates.recordcount is 0 >
  <cflocation url="?action=92&userid=#session.auth.userid#" addtoken="Yes">
</cfif>
<cfset states = "#valuelist(getcustomerstates.stateid)#">
<!---TO DO correct the state function--->
<!---cfquery name="state1" datasource="#application.datasource#">select * from state_master where countryid = 73 order by fullname  </cfquery
<cfset states= "#valuelist(state1.stateid)#">--->

<cfquery name="getuserpackages" datasource="#application.datasource#">
<!--- cachedwithin="#CreateTimeSpan(0,0,30,0)#" --->
	select distinct bid_subscription_log.packageid,bid_subscription.package,bid_subscription.categoryid,bid_subscription.display,bid_subscription.sort
	from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
	inner join bid_subscription on bid_subscription_log.packageid = bid_subscription.packageid
	where bid_users.userid =  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and bid_subscription_log.packageid in (1,2,3,4,5,6,7,9)  and bid_subscription_log.effective_date <= #date# and bid_subscription_log.expiration_date >= #date# and bid_subscription_log.active = 1
	order by bid_subscription.sort
</cfquery>

<!---pull structures to convert and filter tags into previous categories--->
<cfquery name="pull_industrial_structures" datasource="#application.datasource#">
<!--- cachedwithin="#CreateTimeSpan(0,0,30,0)#" --->
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 1 and pbt_tags.tag_typeID = 1
	 and tag_parentID <> 0
	 order by pbt_tags.tag
</cfquery>
<cfquery name="pull_commercial_structures" datasource="#application.datasource#">
<!--- cachedwithin="#CreateTimeSpan(0,0,30,0)#" --->
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 2 and pbt_tags.tag_typeID = 1
	 and tag_parentID <> 0
	 order by pbt_tags.tag
</cfquery>
<cfquery name="pull_other_structures" datasource="#application.datasource#">
<!--- cachedwithin="#CreateTimeSpan(0,0,30,0)#" --->
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID in (1,2) and pbt_tags.tag_typeID = 1
	 and tag_parentID <> 0
	 order by pbt_tags.tag
</cfquery>
<cfinclude template="user_trash.cfm">
<cfset user_trash.recordcount = 0>
<!--table cellpadding="0" cellspacing="0" border="0" width="100%">
  <tr>
    <td class="dashTab" width="300"> New Projects as of <cfoutput>#dateformat(variables.lastview,"m/d/yyyy")#</cfoutput></td>
    <td></td>
  </tr>
  <tr>
    <td class="dashLine" colspan="2"></td>
  </tr>
</table-->


    <cfset pkgArr = ArrayNew(1)>    
    <cfset ArraySet(pkgArr, 1, 9, 0)>
    <cfoutput query="getuserpackages"> <!-- package #packageid# -->
        <cfset zip_packageid = PACKAGEID>
        <cfinclude template="zip_module.cfm">
      <cfif currentrow MOD 2 IS 1>
          <tr>
        
      </cfif>
      <cfif packageid is 1 or packageid is 3 or packageid is 4>
        <cfquery name="pull_project_count" datasource="#application.datasource#" result="r1">
<!--- cachedwithin="#CreateTimeSpan(0,0,30,0)#" --->
			select distinct pbt_project_master_gateway.bidid
			from pbt_project_master_gateway
				inner join pbt_project_master_cats ppc on ppc.bidID = pbt_project_master_gateway.bidID
				where pbt_project_master_gateway.paintpublishdate >= '#variables.lastview#'  and pbt_project_master_gateway.bidid <> 1  
				<cfswitch expression="#categoryid#">
					<cfcase value="1">
						<cfif pull_industrial_structures.recordcount GT 0>
							and ppc.tagID in (#valuelist(pull_industrial_structures.tagID)#)
							and pbt_project_master_gateway.verifiedpaint = 1
						</cfif>
					</cfcase>
					<cfcase value="3">
							and ppc.tagID in (#valuelist(pull_other_structures.tagID)#)
							and pbt_project_master_gateway.verifiedpaint is null
					</cfcase>
				</cfswitch>
				<cfif packageid is 1>
				and pbt_project_master_gateway.stageID in (1,4,9,20,21)
				<cfelseif packageid is 2>
				and pbt_project_master_gateway.stageID in (1,4,9,21)
				<cfelseif packageid is 3>
				and pbt_project_master_gateway.stageID in (1,4,9,21)
				<cfelse>
				and pbt_project_master_gateway.stageID in (24)
				</cfif>
				and pbt_project_master_gateway.stateid in (#states#)
				 <!---filter based on zipcodes--->
				<cfif isdefined("ziplist") and ziplist is not "">
				and (
				(pbt_project_master_gateway.zipcode in (#ziplist#) 

				or pbt_project_master_gateway.owner_zipcode in (#ziplist#)
				)  
				or ((pbt_project_master_gateway.owner_zipcode is null and pbt_project_master_gateway.zipcode is null) ))
				</cfif>	
				<!---USER TRASH --->
				<cfif user_trash.recordcount GT 0>
				and pbt_project_master_gateway.bidID not in (select distinct bidID 
				from pbt_user_projects_trash
				where userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and active = 1)
				</cfif>
				and ppc.tagID in (#variable.user_tags#)
		</cfquery>
        <!---
											<cfdump var="#pull_project_count#" label="query" expand="no"  />
									    	<cfdump var="#r1#" label="results" expand="no" />
									    	--->
        <cfelseif packageid is 2>
        <cfquery name="pull_project_count" datasource="#application.datasource#">
<!--- cachedwithin="#CreateTimeSpan(0,0,30,0)#" --->
			select distinct pbt_project_master_gateway.bidid
			from pbt_project_master_gateway
			inner join pbt_project_master_cats ppc on ppc.bidID = pbt_project_master_gateway.bidID
			where pbt_project_master_gateway.paintpublishdate >= '#variables.lastview#'  
			and pbt_project_master_gateway.bidid <> 1   
			and pbt_project_master_gateway.stateid in (#states#) 
			<cfif pull_commercial_structures.recordcount GT 0>
				and ppc.tagID in (#valuelist(pull_commercial_structures.tagID)#)
				and pbt_project_master_gateway.verifiedpaint = 1
			</cfif>
			and pbt_project_master_gateway.stageID in (1,4,9,21)
			<!---filter based on zipcodes--->
			<cfif isdefined("ziplist") and ziplist is not "">
			and (
			(pbt_project_master_gateway.zipcode in (#ziplist#) 
			<!---cfif isdefined("ziplist2")>
			or a.zipcode in (#ziplist2#) 
			or a.owner_zipcode in (#ziplist2#)
			</cfif--->
			or pbt_project_master_gateway.owner_zipcode in (#ziplist#)
			)  
			or ((pbt_project_master_gateway.owner_zipcode is null and pbt_project_master_gateway.zipcode is null) ))
			</cfif>	
			<!---USER TRASH --->
			<cfif user_trash.recordcount GT 0>
			and pbt_project_master_gateway.bidID not in (select distinct bidID 
			from pbt_user_projects_trash
			where userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and active = 1)
			</cfif>
			and ppc.tagID in (#variable.user_tags#)
			and pbt_project_master_gateway.verifiedpaint = 1
			</cfquery>
        <cfelseif packageid is 5 or packageid is 6 or packageid is 7 or packageid is 12>
        <cfquery name="pull_project_count" datasource="#application.datasource#">
<!--- cachedwithin="#CreateTimeSpan(0,0,30,0)#" --->
			select distinct pbt_project_master_gateway.bidid
			from pbt_project_master_gateway
			inner join pbt_project_master_cats ppc on ppc.bidID = pbt_project_master_gateway.bidID
			left outer join pbt_project_award_stage_detail ppa on ppa.bidID = pbt_project_master_gateway.bidID
			where ppa.post_date >= '#variables.lastview#'  and pbt_project_master_gateway.bidid <> 1  
			<cfswitch expression="#categoryid#">
				<cfcase value="1">
					<cfif pull_industrial_structures.recordcount GT 0>
						and ppc.tagID in (#valuelist(pull_industrial_structures.tagID)#)
						and pbt_project_master_gateway.verifiedpaint = 1
					</cfif>
				</cfcase>
				<cfcase value="3">
					<cfif pull_other_structures.recordcount GT 0>
						and ppc.tagID in (#valuelist(pull_other_structures.tagID)#)
						and pbt_project_master_gateway.verifiedpaint is null
					</cfif>
				</cfcase>
				<cfcase value="7">
					<cfif pull_other_structures.recordcount GT 0>
						and ppc.tagID in (#valuelist(pull_other_structures.tagID)#)
					</cfif>
				</cfcase>
				<cfcase value="2">
					<cfif pull_commercial_structures.recordcount GT 0>
						and ppc.tagID in (#valuelist(pull_commercial_structures.tagID)#)
						and pbt_project_master_gateway.verifiedpaint = 1
					</cfif>
				</cfcase>
			</cfswitch>
			and pbt_project_master_gateway.stateid in (#states#)
			and pbt_project_master_gateway.stageID in (5,6)
				 <!---filter based on zipcodes--->
			<cfif isdefined("ziplist") and ziplist is not "">
			and (
			(pbt_project_master_gateway.zipcode in (#ziplist#) 
			<!---cfif isdefined("ziplist2")>
			or a.zipcode in (#ziplist2#) 
			or a.owner_zipcode in (#ziplist2#)
			</cfif--->
			or pbt_project_master_gateway.owner_zipcode in (#ziplist#)
			)  
			or ((pbt_project_master_gateway.owner_zipcode is null and pbt_project_master_gateway.zipcode is null) ))
			</cfif>	
			<!---USER TRASH --->
			<cfif user_trash.recordcount GT 0>
			and pbt_project_master_gateway.bidID not in (select distinct bidID 
			from pbt_user_projects_trash
			where userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and active = 1)
			</cfif>
			and ppc.tagID in (#variable.user_tags#)
			</cfquery>
        

        
        <cfelseif packageid is 9>
        <cfquery name="pull_project_count" datasource="#application.datasource#">
<!--- cachedwithin="#CreateTimeSpan(0,0,30,0)#" --->
			select distinct pbt_project_master_gateway.bidid
			from pbt_project_master_gateway
			inner join pbt_project_master_cats ppc on ppc.bidID = pbt_project_master_gateway.bidID
			where pbt_project_master_gateway.paintpublishdate >= '#variables.lastview#'  and pbt_project_master_gateway.bidid <> 1  
			and pbt_project_master_gateway.stateid in (#states#) 
			and pbt_project_master_gateway.stageID in (20)
				 <!---filter based on zipcodes--->
			<cfif isdefined("ziplist") and ziplist is not "">
			and (
			(pbt_project_master_gateway.zipcode in (#ziplist#) 
			<!---cfif isdefined("ziplist2")>
			or a.zipcode in (#ziplist2#) 
			or a.owner_zipcode in (#ziplist2#)
			</cfif--->
			or pbt_project_master_gateway.owner_zipcode in (#ziplist#)
			)  
			or ((pbt_project_master_gateway.owner_zipcode is null and pbt_project_master_gateway.zipcode is null) ))
			</cfif>	
			<!---USER TRASH --->
			<cfif user_trash.recordcount GT 0>
			and pbt_project_master_gateway.bidID not in (select distinct bidID 
			from pbt_user_projects_trash
			where userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and active = 1)
			</cfif>
			and ppc.tagID in (#variable.user_tags#)
			</cfquery>
      </cfif>
      
        <cfif isdefined("pull_project_count.recordcount")>             
              <cfset pkgArr[packageID] = numberformat(pull_project_count.recordcount) />
          </cfif>
        
            <cfif (packageid is 1 or packageid is 2) and pull_project_count.recordcount is not 0>
              <cfif packageid is 1>
                <cfset cat= 1>
                <cfelseif packageid is 2>
                <cfset cat = 2>
              </cfif>
              
              <cfelse>
              
            </cfif>
        </td>
     
    </cfoutput> 
    <!---if the query record count is not equally divisible by 2,---> 
    <!---the last row was not close.--->
    <cfif getuserpackages.RecordCount MOD 2 IS NOT 0>
      <CFSET ColsLeft = 2 - (getuserpackages.RecordCount MOD 2)>
      <cfloop from = "1" TO = "#ColsLeft#" INDEX = "i">
         
      </cfloop>
      
    </cfif>
    
<cfquery name="updatedJobs" datasource="#application.datasource#" result="updatedJobs">
	SELECT distinct a.bidID,a.projectname,a.owner,a.ownerID,a.tags,a.submittaldate,a.city,
	 a.state,a.stateID,a.projectsize,a.minimum_value as minimumvalue,a.maximum_value as maximumvalue,a.stage,a.stageID,a.paintpublishdate,a.zipcode,a.valuetypeID as valuetype,a.county,bid_user_viewed_log.bidid as viewed,pbt_project_updates.updateid,a.supplierID,bid_planholders.bidid as planholders
    FROM pbt_project_master_gateway a
    LEFT OUTER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
    LEFT OUTER JOIN pbt_project_master_cats ppmc2 on ppmc2.bidID = a.bidID
    LEFT OUTER JOIN bid_user_viewed_log on a.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid=  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">
	LEFT OUTER JOIN pbt_project_updates on a.bidid = pbt_project_updates.bidid and pbt_project_updates.pupdateid in (select max(pupdateid) from pbt_project_updates where pbt_project_updates.bidid = a.bidid and datepart(dd,a.paintpublishdate) <> datepart(dd,pbt_project_updates.date_entered))
	LEFT OUTER JOIN bid_planholders on bid_planholders.bidid = a.bidID and (companyname is not null or firstname is not null or lastname is not null) 			 
   	WHERE 1=1 
		and bid_user_viewed_log.bidid <> a.bidid 
		and (updateid = 1 or updateID = 10)		
		<!---and a.paintpublishdate >= '#variables.lastview#'  --->
		and a.bidid <> 1 
</cfquery>
<cfquery name="newJobs" datasource="#application.datasource#" result="newJobs">
	SELECT distinct a.bidID,a.projectname,a.owner,a.ownerID,a.tags,a.submittaldate,a.city,
	 a.state,a.stateID,a.projectsize,a.minimum_value as minimumvalue,a.maximum_value as maximumvalue,a.stage,a.stageID,a.paintpublishdate,a.zipcode,a.valuetypeID as valuetype,a.county,bid_user_viewed_log.bidid as viewed,pbt_project_updates.updateid,a.supplierID,bid_planholders.bidid as planholders
    FROM pbt_project_master_gateway a
    LEFT OUTER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
    LEFT OUTER JOIN pbt_project_master_cats ppmc2 on ppmc2.bidID = a.bidID
    LEFT OUTER JOIN bid_user_viewed_log on a.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid=  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">
	LEFT OUTER JOIN pbt_project_updates on a.bidid = pbt_project_updates.bidid and pbt_project_updates.pupdateid in (select max(pupdateid) from pbt_project_updates where pbt_project_updates.bidid = a.bidid and datepart(dd,a.paintpublishdate) <> datepart(dd,pbt_project_updates.date_entered))
	LEFT OUTER JOIN bid_planholders on bid_planholders.bidid = a.bidID and (companyname is not null or firstname is not null or lastname is not null) 			 
   	WHERE 1=1 
		and bid_user_viewed_log.bidid <> a.bidid 			
		and a.paintpublishdate >= '#variables.lastview#'  
		and a.bidid <> 1 
</cfquery>
<cfcatch><cfdump var="#cfcatch#" /></cfcatch></cftry>
