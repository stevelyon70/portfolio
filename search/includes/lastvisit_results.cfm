<cfparam name="startRow" default="1">
<cfparam name="endRow" default="20">
<cfparam name="user_projecttypes" default="">
<cfparam name="user_stage" default="">
<cfparam name="selected_user_tags" default="">
<cfparam name="variable.user_tags" default=""/>
<CFSET DATE = #createodbcdate(now())#>	
<cfquery name="checkuserpackage" datasource="#application.datasource#">
	select distinct bid_subscription_log.packageid
	from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
	where bid_users.userid =  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> 
		--and bid_subscription_log.packageid in (#packageid#)  
		and bid_subscription_log.effective_date <= #date# 
		and bid_subscription_log.expiration_date >= #date# 
		and bid_subscription_log.active = 1
</cfquery> 
<!---zipcode filter--->
 	<cfset zip_packageid = valuelist(checkuserpackage.packageid)>
	<cfinclude template="zip_module.cfm">

<!---run the keyword search if selected--->
<cfif isdefined("qt") and qt NEQ "">
	<cfinclude template="bt_search_include.cfm">
</cfif>

<CFSET tdate = #CREATEODBCDATE(NOW())#>
<cfquery name="set_lastview" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
select max(visitdate) as lastview
from bidtracker_usage_log
where userid = #session.auth.userid# and visitdate < #tdate#
</cfquery>
<cfset day=dayofweek(tdate)>
<cfset d =dayofweekasstring(day)>
<Cfif d is "Sunday"><cfset tdate = dateadd("d",-1,tdate)><cfelseif d is "Monday"><cfset tdate = dateadd("d",-2,tdate)></cfif>
<cfset variables.lastview = dateadd("d",-1,tdate)>
<cfset variables.lastview = dateformat(variables.lastview,"mm/dd/yyyy")>

<!---compile user stage selections--->
	
	<cfif isdefined("packageID") and packageID NEQ "">
	<cfloop list="#packageID#" index="i">
	 <cfswitch expression="#i#">
	 	  <cfcase value="1">
		   	<cfset stages = "1,4,9,20,21">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="2">
		   	<cfset stages = "1,4,9,21">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="3">
		   	 <cfset stages = "1,4,9,21">
	 		 <cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="4">
		   	<cfset stages = "24">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="5">
		   	<cfset stages = "5,6">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="6">
		   	<cfset stages = "5,6">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="7">
		   	<cfset stages = "5,6">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="9">
		   	<cfset stages = "20">
	 		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="10">
		   	<cfset stages = "22">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="11">
		   	<cfset stages = "20">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="12">
		   	<cfset stages = "5,6">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		  <cfcase value="15">
		   	<cfset stages = "5,6">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		</cfswitch>
	</cfloop>
	</cfif>
	 <!---all stages in current status--->
	
	
	
	<!---set the user's project type selections--->
	
	<cfif isdefined("allprojects") and allprojects NEQ "">
		<cfset types = "1,2">
		<cfif not listcontains(user_projecttypes,types)>
	  		<cfset user_projecttypes = listappend(user_projecttypes,types)>
		</cfif>
	</cfif>
	<cfif isdefined("paintingprojects") and paintingprojects NEQ "">
		<cfset types = "2">
		<cfif not listcontains(user_projecttypes,types)>
	  		<cfset user_projecttypes = listappend(user_projecttypes,types)>
		</cfif>
	</cfif>
	<cfif isdefined("generalcontracts") and generalcontracts NEQ "">
		<cfset types = "1">
		<cfif not listcontains(user_projecttypes,types)>
	  		<cfset user_projecttypes = listappend(user_projecttypes,types)>
	    </cfif>
	</cfif>
	<!---set the user's tag selections--->
		<!---structures--->
			
				
			<cfif isdefined("industrial")>
	  			<cfset selected_user_tags = listappend(selected_user_tags,valuelist(pull_industrial_structures_all.tagID))>
			</cfif>
			<cfif isdefined("commercial")>
	  			<cfset selected_user_tags = listappend(selected_user_tags,valuelist(pull_commercial_structures.tagID))>
			</cfif>
			<cfif isdefined("structures") and structures NEQ "">
	  			<cfset selected_user_tags = listappend(selected_user_tags,structures)>
			<!---cfelseif not isdefined("industrial") and not isdefined("commercial")>
					<cfquery name="get_approved_tags_s" datasource="#application.datasource#">
					select tagID
					from pbt_user_tags
					where userID = #userID#
				</cfquery>
	  			<cfset user_tags = listappend(user_tags,valuelist(get_approved_tags_s.tagID))--->  
			</cfif>
			<cfif isdefined("all_scopes") and all_scopes NEQ "">
	  			<cfset selected_user_tags = listappend(selected_user_tags,valuelist(pull_gc_scopes.tagID))>
			</cfif>
			<cfif isdefined("all_services") and all_services NEQ "">
	  			<cfset selected_user_tags = listappend(selected_user_tags,valuelist(pull_professional_services.tagID))>
			</cfif>
			<cfif isdefined("services") and services NEQ "">
	  			<cfset selected_user_tags = listappend(selected_user_tags,services)>
			</cfif>
			<cfif isdefined("scopes") and scopes NEQ "">
	  			<cfset selected_user_tags = listappend(selected_user_tags,scopes)>
			</cfif>
			<cfif isdefined("supply") and supply NEQ ""><!---user selected a supply criteria--->
	  			<cfset selected_user_tags = listappend(selected_user_tags,supply)>
			<cfelse>
				<!---user didn't select a tag default to their selections
				<cfquery name="get_approved_tags5" datasource="#application.datasource#">
					select tagID
					from pbt_user_tags
					where userID = #userID# and tagID in (#valuelist(pull_supply_ops.tagID)#)
				</cfquery>
	  			<cfset user_tags = listappend(user_tags,valuelist(get_approved_tags5.tagID))>--->
			</cfif>
		   <cfif isdefined("qualifications") and qualifications NEQ "">
	  			<cfset selected_user_tags = listappend(selected_user_tags,qualifications)>
			</cfif>
			<!---check user tags if they have a niche selection--->
				<!---TO DO ADD THE NICHE PACKAGE CHECK CODE
				<cfquery name="get_approved_tags" datasource="#application.datasource#">
					select tagID
					from pbt_user_tags
					where userID = #userID# and tagID in (#user_tags#)
				</cfquery>
				<cfset selected_user_tags = valuelist(get_approved_tags.tagID)>
			--->
	
	<cfif isdefined("state") and state is not "66">
		<cfquery name="getpackagestates" datasource="#application.datasource#">
		select distinct b.stateid 
		from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
		where a.userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER"> 
		and stateid in (#state#)
		</cfquery>
		<cfset bidstates = valuelist(getpackagestates.stateid)>
	</cfif>
	<cfif not isdefined("state") or state is  "66">
		<cfquery name="getcustomerstates" datasource="#application.datasource#">
		select distinct b.stateid 
		from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
		where a.userid = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">  
		and a.userid in 
		(select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where reg_users.username = '#Session.auth.username#' 
		and bid_users.bt_status = 1)
		</cfquery>
		<cfif getcustomerstates.recordcount is 0 ><cflocation url="../index.cfm?nostates"></cfif>
		<cfset states1 = "#valuelist(getcustomerstates.stateid)#">
		<cfquery name="state1" datasource="#application.datasource#">select * from state_master where stateid in (#states1#) and countryid = 73 order by fullname  </cfquery>
		<cfset userstates= "#valuelist(state1.stateid)#">
	</cfif>
	<!---cfquery name="pull_general" datasource="#application.datasource#"><!--- cachedwithin="#CreateTimeSpan(0,0,30,0)#">--->
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 	inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
		 inner join site_tag_xref x on pbt_tags.tagID = x.tagID 
	 where pt.packageID in (1,2) and pbt_tags.tag_typeID = 1
		 and tag_parentID <> 0
		 and siteID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.siteID#" />
	 order by pbt_tags.tag
 	</cfquery --->  

<!---if show all then set the param for endrow to all records
<cfif isdefined("showall") and showall EQ "yes">
	<cfset endrow = total_results.total_returned>
</cfif>--->
<!---include file to set sort values--->
<cfinclude template="sort_params.cfm">

<cfquery name="search_results" datasource="#application.datasource#" result="r1">
	select *
			from 
			(
			SELECT  *,ROW_NUMBER() OVER ( ORDER BY #sortvalue# ) AS RowNum
			FROM    (
			SELECT distinct g.phonenumber as PhoneNumber,a.bidID,a.projectname,a.owner,a.ownerID,a.tags,a.submittaldate,a.city,
	 a.state,a.stateID,a.projectsize,a.minimum_value as minimumvalue,a.maximum_value as maximumvalue,a.stage,a.stageID,a.paintpublishdate,a.zipcode,a.valuetypeID as valuetype,a.county,bid_user_viewed_log.bidid as viewed,pbt_project_updates.updateid,a.supplierID, promas.projectnum
    FROM pbt_project_master_gateway a
    INNER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
    LEFT OUTER JOIN pbt_project_master_cats ppmc3 on ppmc3.bidID = a.bidID 
    LEFT OUTER JOIN pbt_project_master promas on promas.bidid = a.bidid
    left outer join pbt_project_contacts g on g.bidID = a.bidID and g.contact_typeID = 1
    LEFT OUTER JOIN bid_user_viewed_log on a.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid=  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">
	LEFT OUTER JOIN pbt_project_updates on a.bidid = pbt_project_updates.bidid and pbt_project_updates.pupdateid in (select max(pupdateid) from pbt_project_updates where pbt_project_updates.bidid = a.bidid)
	LEFT OUTER JOIN supplier_master sm on sm.supplierID = a.supplierID
    <cfif isdefined("packageID") and (packageID EQ 5 or packageID EQ 12 or packageID EQ 6 or packageID EQ 7)>
    left outer join pbt_project_award_stage_detail ppa on ppa.bidID = a.bidID
	</cfif>
											
   	WHERE 1=1
   	<!---stages filter--->
   	<cfif isdefined("user_stage") and user_stage NEQ "">
	 	and a.stageID in (#user_stage#)
	</cfif>
	
    <!---post date--->
   	<cfif isdefined("packageID") and (packageID EQ 5 or packageID EQ 12 or packageID EQ 6 or packageID EQ 7)>
    	and ppa.post_date >= '#variables.lastview#'
    <cfelse>
   		and a.paintpublishdate >= '#variables.lastview#'
	</cfif>
   		
		  

	<!---states filter--->
		<cfif not isdefined("state") or state is "66">
			and (1 <> 1 
			<cfif isdefined("userstates") and userstates is not "">
			or (a.stateid in (#userstates#))</cfif>
			
			)
		</cfif>
		<!---if user selected a state run check to verify states selected are approved--->
		<cfif isdefined("state") and state is not "66">
			and (1 <> 1 
			<cfif isdefined("bidstates") and bidstates is not "">
			or (a.stateid in (#bidstates#))
			</cfif>
			)
		</cfif>
		<!---TAGS filter--->
			<!--- site default---> 
			and ppmc3.tagID in (#session.default.tagId#)		
			<cfswitch expression="#packageID#">
			<cfcase value="1">
				
			</cfcase>
			<cfcase value="2">
				
			</cfcase>
			<cfcase value="3,6">
				<cfif session.model.formStructureDropOptions.recordcount GT 0>
					and ppmc.tagID in (#valuelist(session.model.formStructureDropOptions.tagID)#)
					and a.verifiedpaint is null
				</cfif>
			</cfcase>
			<cfcase value="4,7,9">
				<cfif session.model.formStructureDropOptions.recordcount GT 0>
					and ppmc.tagID in (#valuelist(session.model.formStructureDropOptions.tagID)#)
				</cfif>	
			</cfcase>			
			<cfcase value="5">
				
			</cfcase>
			<cfcase value="12">
				<cfif pull_commercial_structures.recordcount GT 0>
					and ppmc.tagID in (#valuelist(pull_commercial_structures.tagID)#)
					and a.verifiedpaint = 1
				</cfif>
			</cfcase>
			<!---<cfcase value="6">
				<cfif session.model.formScopesDropOptions.recordcount GT 0 and len(session.model.formScopesDropOptions.tagID)>
					and ppmc.tagID in (#valuelist(session.model.formScopesDropOptions.tagID)#,#session.default.tagId#)
					--and a.verifiedpaint is null
				</cfif>
			</cfcase>--->
			<cfdefaultcase>			
				and ppmc.tagID in (#session.user_tags#)
			</cfdefaultcase>
		</cfswitch>
		<!---add filter for niche tag package--->
		<cfif listcontains(session.packages, 16) and len(variable.user_tags)>
			and ppmc.tagID in (#session.user_tags#)
		</cfif>
		
		--and ppmc.tagid = #session.default.tagId#
		<!---USER TRASH --->
		<cfif user_trash.recordcount GT 0>
		and a.bidID not in (select distinct bidID 
		from pbt_user_projects_trash
		where userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and active = 1)
		</cfif>
		<!---filter based on zipcodes--->
		<cfif isdefined("ziplist") and ziplist is not "">
		and ((a.zipcode in (#ziplist#) or a.owner_zipcode in (#ziplist#))  or ((a.owner_zipcode is null and a.zipcode is null) ))
		</cfif>
		
		 ) AS RowConstrainedResult
			) as filterResult
			
			WHERE   RowNum >= #startRow#
    		<!---AND RowNum <= #endRow#--->
			
			
</cfquery>

<cfif search_results.recordcount EQ 0>
	<cfset startrow = 0>
</cfif>
<cfif isdefined('url.showmethesql')>
<cfdump var="#r1#" />
</cfif>