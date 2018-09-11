<cfparam name="startRow" default="1">
<cfparam name="endRow" default="20">
<cfparam name="user_projecttypes" default="">
<cfparam name="user_stage" default="">
<cfparam name="selected_user_tags" default="">
<cfparam name="selected_user_tags_secondary" default="">
<cfparam name="filter" default="or">
<cfparam name="variable.user_tags" default="-1"/>
<CFSET DATE = #createodbcdate(now())#>	

<cfif listcontains(session.packages, 16)>
	  <CFQUERY NAME="GET_Sub_TAGS" DATASOURCE="#application.dataSource#">
		select * 
		from pbt_user_tags
		where userID = <cfqueryPARAM value = "#session.auth.userID#" CFSQLType = "CF_SQL_INTEGER">
		and active = 1 
	  </cfquery>
	  <cfif get_sub_tags.recordcount GT 0>
		<cfset variable.user_tags = valuelist(GET_Sub_TAGS.tagID)>
	  <cfelse>
		<cflocation url="#rootpath#account/?action=104">
	  </cfif>
<cfelse>
	  <CFQUERY NAME="GET_Sub_TAGS" DATASOURCE="#application.dataSource#">
		select * 
		from pbt_tags
	  </cfquery>
	  <cfset variable.user_tags = valuelist(GET_Sub_TAGS.tagID)>
</cfif>


 <cfif isdefined("subfrom") and subfrom NEQ "">
	<cfset project_year = dateformat(subfrom,"yyyy")>
<cfelse>
	<cfset project_year = dateformat('1/1/2018',"yyyy")>
 </cfif>
 <cfif isdefined("subto") and subto NEQ "">
	<cfset project_year2 = dateformat(subto,"yyyy")>
 </cfif>
 	<cfif not isdefined("session.packages") or (isdefined("session.packages") and session.packages EQ "")>
		<cfquery name="checkuserpackage" datasource="#application.dataSource#">
		select distinct bid_subscription_log.packageid
		from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
		where bid_users.userid =  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> 
		and bid_subscription_log.effective_date <= #date# 
		and bid_subscription_log.expiration_date >= #date# 
		and bid_subscription_log.active = 1
		</cfquery> 
		<cfset session.packages = valuelist(checkuserpackage.packageid)>
		<!---run another check to verify user is approved for this package--->
			<cfif not listfind(session.packages, 18)>
				<cflocation url="../account/includes/add_agencyspending.cfm">
			</cfif>
	</cfif>
	
<cfquery name="checkuserpackage" datasource="#application.dataSource#">
	select distinct bid_subscription_log.packageid
	from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
	where bid_users.userid =  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and bid_subscription_log.packageid in (18)  and bid_subscription_log.effective_date <= #date# and bid_subscription_log.expiration_date >= #date# and bid_subscription_log.active = 1
</cfquery> 
<!---zipcode filter--->
 	<cfset zip_packageid = valuelist(checkuserpackage.packageid)>
	<!---cfinclude template="../../modules/zip_module.cfm"--->

<!---run the keyword search if selected--->
<cfif isdefined("qt") and qt NEQ "">
	<cfinclude template="agency_keywordsearch_include.cfm">
</cfif>
<!---run the agency search if selected--->
<cfif isdefined("contractorname") and contractorname NEQ "">
	<cfinclude template="agency_keywordsearch_include.cfm">
</cfif>
<!---translate the project type form values--->
<cfif isdefined("projecttype")>
	<cfswitch expression="#projecttype#">
		<cfcase value="1">
			<cfset verifiedProjects = 1>
		</cfcase>
		<cfcase value="2">
			<cfset paintingProjects = 1>
		</cfcase>
		<cfcase value="3">
			<cfset allProjects = 1>
		</cfcase>
	</cfswitch>
</cfif>
<!---compile user stage selections--->
	
	<cfif isdefined("project_stage") and project_stage NEQ "">
	<cfloop list="#project_stage#" index="i">
	 <cfswitch expression="#i#">
	 	  <cfcase value="1">
		   	<cfset stages = "21">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="2">
		   	<cfset stages = "1,4,9">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="3">
		   	 <cfset stages = "24">
	 		 <cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="4">
		   	<cfset stages = "20">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="5">
		   	<cfset stages = "20">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="6">
		   	<cfset stages = "5,6">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="7">
		   	<cfset stages = "6">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="8">
		   	<cfset stages = "5">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="9">
		   	<cfset stages = "5">
	 		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="10">
		   	<cfset stages = "22">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="11">
		   	<cfset stages = "23">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="12">
		   	<cfset stages = "1,4,9,20,21,24">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="13">
		   	<cfset stages = "5,6">
	 		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="14">
		   	 <cfset stages = "22,23">
	  		 <cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="15">
		   	 <cfset stages = "25">
	  		 <cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		</cfswitch>
	</cfloop>
	</cfif>
	 <!---all stages in current status--->
	<!---cfif isdefined("CURRENTCONTRACTS")>
		<cfset stages = "1,4,9,20">
	  <cfset user_stage = listappend(user_stage,stages)>
	</cfif>
	<cfif isdefined("bidresults")>
		<cfset stages = "5,6">
	  <cfset user_stage = listappend(user_stage,stages)>
	</cfif>
	<cfif isdefined("reportarchive")>
	 <cfset stages = "22,23">
	  <cfset user_stage = listappend(user_stage,stages)>
	</cfif>
	<cfif isdefined("ADVANCEDNOTICES")>
	 <cfset stages = "21">
	  <cfset user_stage = listappend(user_stage,stages)>
	</cfif>
    <cfif isdefined("CURRENTBIDS")>
		<cfset stages = "1,4,9">
	  <cfset user_stage = listappend(user_stage,stages)>
	</cfif>
   	<cfif isdefined("CURRENTENGINEERING")>
		<cfset stages = "4">
	  <cfset user_stage = listappend(user_stage,stages)>
	</cfif>
	<cfif isdefined("CURRENTSUBCONTRACTING")>
		<cfset stages = "20">
	  <cfset user_stage = listappend(user_stage,stages)>
	</cfif>
	<cfif isdefined("allCURRENTSUBCONTRACTING")>
		<cfset stages = "20">
	  <cfset user_stage = listappend(user_stage,stages)>
	</cfif>
	<cfif isdefined("ALLRESULTS")>
		<cfset stages = "5,6">
	  <cfset user_stage = listappend(user_stage,stages)>
	</cfif>
	<cfif isdefined("LOWBIDS")>
		<cfset stages = "6">
	  <cfset user_stage = listappend(user_stage,stages)>
	</cfif>
	<cfif isdefined("AWARDS")>
		<cfset stages = "5">
	  <cfset user_stage = listappend(user_stage,stages)>
	</cfif>
	<cfif isdefined("ENGINEERINGAWARDS")>
		<cfset stages = "5">
	  <cfset user_stage = listappend(user_stage,stages)>
	</cfif>
	<cfif isdefined("EXPIREDBIDS")>
		<cfset stages = "22">
	  <cfset user_stage = listappend(user_stage,stages)>
	</cfif>
	<cfif isdefined("EXPIREDSUBCONTRACTING")>
		<cfset stages = "20">
	  <cfset user_stage = listappend(user_stage,stages)>
	</cfif--->
	
	
	<!---set the user's project type selections--->
	
	<cfif isdefined("allprojects") and allprojects NEQ "">
	  		<cfset user_projecttypes = 4>
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
			<cfif isdefined("industrial") and industrial NEQ "">
	  			<cfset selected_user_tags = listappend(selected_user_tags,valuelist(pull_industrial_structures.tagID))>
			</cfif>
			<cfif isdefined("commercial") and commercial NEQ "">
	  			<cfset selected_user_tags = listappend(selected_user_tags,valuelist(pull_commercial_structures.tagID))>
			</cfif>
			<cfif isdefined("structures") and structures NEQ "">
	  			<cfset selected_user_tags = listappend(selected_user_tags,structures)>
			</cfif>
			
			
			<cfif isdefined("all_scopes") and all_scopes NEQ "">
	  			<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,valuelist(pull_gc_scopes.tagID))>
			</cfif>
			<cfif isdefined("all_services") and all_services NEQ "">
	  			<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,valuelist(pull_professional_services.tagID))>
			</cfif>
			<cfif isdefined("services") and services NEQ "">
	  			<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,services)>
			</cfif>
			<cfif isdefined("scopes") and scopes NEQ "">
	  			<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,scopes)>
			</cfif>
			<cfif isdefined("supply") and supply NEQ ""><!---user selected a supply criteria--->
	  			<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,supply)>
			<cfelse>
			</cfif>
		   <cfif isdefined("qualifications") and qualifications NEQ "">
	  			<cfset selected_user_tags_secondary = listappend(selected_user_tags_secondary,qualifications)>
			</cfif>
			
			<!---check user tags if they have a niche tags package only--->
				<cfif listcontains(session.packages, 16)>
					<cfquery name="get_approved_tags" datasource="#application.dataSource#">
						select tagID
						from pbt_user_tags
						where userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and tagID in (#variable.user_tags#)
						<cfif isdefined("selected_user_tags") and selected_user_tags NEQ "">and tagID in (#selected_user_tags#)</cfif>
						and active = 1
					</cfquery>
					<cfif isdefined("selected_user_tags") and selected_user_tags NEQ "">
					<cfset selected_user_tags = valuelist(get_approved_tags.tagID)>
					<cfelse>
						<cfset selected_user_tags = "">
					</cfif>
					<cfquery name="get_approved_tags_secondary" datasource="#application.dataSource#">
						select tagID
						from pbt_user_tags
						where userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and tagID in (#variable.user_tags#)
						<cfif isdefined("selected_user_tags_secondary") and selected_user_tags_secondary NEQ "">and tagID in (#selected_user_tags_secondary#)</cfif>
						and active = 1
					</cfquery>
					<cfif (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary NEQ "") >
						<cfset selected_user_tags_secondary = valuelist(get_approved_tags_secondary.tagID)>
					<cfelse>
						<cfset selected_user_tags_secondary = "">
					</cfif>
					<cfif isdefined("selected_user_tags") and selected_user_tags EQ "" and isdefined("selected_user_tags_secondary") and selected_user_tags_secondary EQ "">
					<cfset selected_user_tags = valuelist(get_approved_tags.tagID)>
					<cfset selected_user_tags_secondary = valuelist(get_approved_tags_secondary.tagID)>	
					</cfif>
				</cfif>
				
				
				<!---include template to include additional tags--->
				<cfinclude template="tag_conversion_inc.cfm">
				
				
	<cfif isdefined("state") and state is not "66">
		<cfquery name="getpackagestates" datasource="#application.dataSource#">
		select distinct b.stateid 
		from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
		where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> 
		and stateid in (#state#)
		</cfquery>
		<cfset bidstates = valuelist(getpackagestates.stateid)>
	</cfif>
	<cfif not isdefined("state") or state is  "66">
		<cfquery name="getcustomerstates" datasource="#application.dataSource#">
		select distinct b.stateid 
		from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
		where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  
		and a.userid in 
		(select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where reg_users.username = '#Session.auth.username#' 
		and bid_users.bt_status = 1)
		</cfquery>
		<cfif getcustomerstates.recordcount is 0 ><cflocation url="../index.cfm?nostates"></cfif>
		<cfset states1 = "#valuelist(getcustomerstates.stateid)#">
		<cfquery name="state1" datasource="#application.dataSource#">select * from state_master where stateid in (#states1#) and countryid = 73 order by fullname  </cfquery>
		<cfset userstates= "#valuelist(state1.stateid)#">
	</cfif>
<!---cfquery name="total_results" datasource="#application.dataSource#">
	SELECT count(distinct a.bidID) as total_returned
    FROM pbt_project_master_gateway_agency a
    INNER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
    INNER JOIN pbt_project_master_cats ppmc2 on ppmc2.bidID = a.bidID
   	WHERE 1=1
   	
	<!---bidID filter--->
   <cfif isdefined("bidid") and bidid is not "">
   		and a.bidid in (#bidid#)
   </cfif>
   <!---keyword search--->
   	<cfif isdefined("qt") and qt is not "" and bidlist is not "">
	   	and a.bidid in (#bidlist#)
	<cfelseif isdefined("qt") and qt is not "" and bidlist is "">
		and a.bidid = 0
    </cfif>
    <!---contractor search--->
   	<cfif isdefined("contractorname") and contractorname is not "" and contractorlist is not "">
	   	and a.bidid in (#contractorlist#)
	<cfelseif isdefined("contractorname") and contractorname is not "" and contractorlist is "">
		and a.bidid = 0
    </cfif>
    <!---post date--->
   	<cfif isdefined("postfrom") and postfrom NEQ "">
   		and a.paintpublishdate >= '#postfrom#'
		   <cfif isdefined("postto") and postto NEQ ""> 
		   	AND a.paintpublishdate <= '#postto#'
		   </cfif>
	</cfif>
	 <!---project date--->
   	<cfif isdefined("subfrom") and subfrom NEQ ""></cfif>
   		and a.project_startdate >= '#project_year#'
		   <cfif isdefined("subto") and subto NEQ ""> 
		   	AND a.project_enddate <= '#project_year2#'
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
	<!---Cost Estimate field--->
			<cfif isdefined("amount") and amount NEQ "1">
				and (1<>1
				<cfif listlen(amount) GT 1>
					<cfif listcontains(amount,2)>
						or  (a.total_budget < '100000')
					</cfif>
					<cfif listcontains(amount,3)>
						or (a.total_budget >= '100000' and a.total_budget <= '500000')
					</cfif>
					<cfif listcontains(amount,4)>
						or  (a.total_budget >= '500000' and a.total_budget <= '1000000')
					</cfif>
					<cfif listcontains(amount,5)>
						or (a.total_budget >= '1000000')
					</cfif>
				
				<cfelse>
					<cfswitch expression="#amount#">
					<cfcase value="2">
						or (a.total_budget < '100000')
					</cfcase>
					<cfcase value="3">
						or (a.total_budget >= '100000' and a.total_budget <= '500000')
					</cfcase>
					<cfcase value="4">
						or (a.total_budget >= '500000' and a.total_budget <= '1000000')
					</cfcase>
					<cfcase value="5">
						or (a.total_budget >= '1000000' or a.total_budget >= '1000000')
					</cfcase>
					<cfdefaultcase>
						
					</cfdefaultcase>
				</cfswitch>
				</cfif>
				)
				
			</cfif>
	
	
	<!---TAGS filter--->
		<!---structures only--->
		<cfif isdefined("selected_user_tags") and selected_user_tags NEQ "" and (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary EQ "")>
		and ppmc.tagID in (#selected_user_tags#)
		
		<!---structures and scopes--->
		<cfelseif isdefined("selected_user_tags") and selected_user_tags NEQ "" and (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary NEQ "")>
		and (ppmc.tagID in (#selected_user_tags#) 
			<cfif isdefined("selected_user_tags") and selected_user_tags NEQ "">
				#filter#
			<cfelse>
				and
			</cfif> ppmc2.tagID in (#selected_user_tags_secondary#))
		<!---scopes only--->
		<cfelseif (isdefined("selected_user_tags") and selected_user_tags EQ "") and (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary NEQ "")>
		and ppmc2.tagID in (#selected_user_tags_secondary#)
		<cfelse>
		
		</cfif>
		
	
	<!---USER TRASH --->
		<cfif user_trash.recordcount GT 0>
		and a.bidID not in (select distinct bidID 
		from pbt_user_projects_trash
		where userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and active = 1)
		</cfif>
	
		
		<!---FILTER ON PACKAGES TO VERIFY ALLOWED TAGS
		<cfif not listfind(valuelist(checkuserpackage.packageid),"1") and not listfind(valuelist(checkuserpackage.packageid),"5")>
		and ppmc.tagID in 
				(
				 select pbt_tags.tagID
			 from pbt_tags
			 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
			 where pt.packageID = 2 and tag_parentID = 1
			 and tag_parentID <> 0 
			 <cfif isdefined("selected_user_tags") and selected_user_tags NEQ "">
				and ppmc.tagID in (#selected_user_tags#)
			</cfif>
			 )
		</cfif>
		<cfif not listfind(valuelist(checkuserpackage.packageid),"2") and not listfind(valuelist(checkuserpackage.packageid),"12")>
		and ppmc.tagID in 
				(
				 select pbt_tags.tagID
			 from pbt_tags
			 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
			 where pt.packageID = 1 and tag_parentID = 1
			 and tag_parentID <> 0
			  <cfif isdefined("selected_user_tags") and selected_user_tags NEQ "">
				and ppmc.tagID in (#selected_user_tags#)
			</cfif>
			 )
		</cfif>--->
</cfquery--->
<!---if show all then set the param for endrow to all records--->
<cfif isdefined("showall") and showall EQ "yes">
	<cfset endrow = total_results.total_returned>
</cfif>
<!---include file to set sort values--->
<cfinclude template="sort_params_agency.cfm">

<cfquery name="search_results" datasource="#application.dataSource#" result="r1">
	select *
			from 
			(
			SELECT  *,ROW_NUMBER() OVER ( ORDER BY #sortvalue# ) AS RowNum
			FROM    (
			SELECT distinct a.bidID,a.projectname,a.owner,a.tags,a.city,
	 a.state,a.stateID,a.stage,a.stageID,a.paintpublishdate,a.zipcode,a.county,bid_user_viewed_log.bidid as viewed,pbt_project_updates.updateid,a.project_startdate,a.project_enddate,a.total_budget
    FROM pbt_project_master_gateway_agency a
    INNER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
    INNER JOIN pbt_project_master_cats ppmc2 on ppmc2.bidID = a.bidID
    LEFT OUTER JOIN bid_user_viewed_log on a.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid=  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">
	LEFT OUTER JOIN pbt_project_updates on a.bidid = pbt_project_updates.bidid and pbt_project_updates.pupdateid in (select max(pupdateid) from pbt_project_updates where pbt_project_updates.bidid = a.bidid and datepart(dd,a.paintpublishdate) <> datepart(dd,pbt_project_updates.date_entered))
	
   	WHERE 1=1
   	<!---stages filter--->
   	<cfif isdefined("user_stage") and user_stage NEQ "">
	 	and a.stageID in (#user_stage#)
	</cfif>
	<!---bidID filter--->
   <cfif isdefined("bidid") and bidid is not "">
   		and a.bidid in (#bidid#)
   </cfif>
   <!---keyword search--->
   	<cfif isdefined("qt") and qt is not "" and bidlist is not "">
	   	and a.bidid in (#bidlist#)
	<cfelseif isdefined("qt") and qt is not "" and bidlist is "">
		and a.bidid = 0
    </cfif>
     <!---contractor search--->
   	<cfif isdefined("contractorname") and contractorname is not "" and contractorlist is not "">
	   	and a.bidid in (#contractorlist#)
	<cfelseif isdefined("contractorname") and contractorname is not "" and contractorlist is "">
		and a.bidid = 0
    </cfif>
    <!---post date--->
   	<cfif isdefined("postfrom") and postfrom NEQ "">
   		and a.paintpublishdate >= '#postfrom#'
		   <cfif isdefined("postto") and postto NEQ ""> 
		   	AND a.paintpublishdate <= '#postto#'
		   </cfif>
	</cfif>
	 <!---project date--->
   	<cfif isdefined("subfrom") and subfrom NEQ ""></cfif>
   		and a.project_startdate >= '#project_year#'
		   <cfif isdefined("subto") and subto NEQ ""> 
		   	AND a.project_enddate <= '#project_year2#'
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
	<!---Cost Estimate field--->
			<cfif isdefined("amount") and amount NEQ "1">
				and (1<>1
				<cfif listlen(amount) GT 1>
					<cfif listcontains(amount,2)>
						or  (a.total_budget < '100000')
					</cfif>
					<cfif listcontains(amount,3)>
						or (a.total_budget >= '100000' and a.total_budget <= '500000')
					</cfif>
					<cfif listcontains(amount,4)>
						or  (a.total_budget >= '500000' and a.total_budget <= '1000000')
					</cfif>
					<cfif listcontains(amount,5)>
						or (a.total_budget >= '1000000')
					</cfif>
				
				<cfelse>
					<cfswitch expression="#amount#">
					<cfcase value="2">
						or (a.total_budget < '100000')
					</cfcase>
					<cfcase value="3">
						or (a.total_budget >= '100000' and a.total_budget <= '500000')
					</cfcase>
					<cfcase value="4">
						or (a.total_budget >= '500000' and a.total_budget <= '1000000')
					</cfcase>
					<cfcase value="5">
						or (a.total_budget >= '1000000' or a.total_budget >= '1000000')
					</cfcase>
					<cfdefaultcase>
						
					</cfdefaultcase>
				</cfswitch>
				</cfif>
				)
				
			</cfif>
	
	<!---TAGS filter--->
		<!---structures only--->
		<cfif isdefined("selected_user_tags") and selected_user_tags NEQ "" and (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary EQ "")>
		and ppmc.tagID in (#selected_user_tags#)
		
		<!---structures and scopes--->
		<cfelseif isdefined("selected_user_tags") and selected_user_tags NEQ "" and (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary NEQ "")>
		and (ppmc.tagID in (#selected_user_tags#) 
			<cfif isdefined("selected_user_tags") and selected_user_tags NEQ "">
				#filter#
			<cfelse>
				and
			</cfif> ppmc2.tagID in (#selected_user_tags_secondary#))
		<!---scopes only--->
		<cfelseif (isdefined("selected_user_tags") and selected_user_tags EQ "") and (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary NEQ "")>
		and ppmc2.tagID in (#selected_user_tags_secondary#)
		<cfelse>
		
		</cfif>
		
	
		<!---USER TRASH --->
		<cfif user_trash.recordcount GT 0>
		and a.bidID not in (select distinct bidID 
		from pbt_user_projects_trash
		where userID = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and active = 1)
		</cfif>
		
		<!---FILTER ON PACKAGES TO VERIFY ALLOWED TAGS
		<cfif not listfind(valuelist(checkuserpackage.packageid),"1") and not listfind(valuelist(checkuserpackage.packageid),"5")>
		and ppmc.tagID in 
				(
				 select pbt_tags.tagID
			 from pbt_tags
			 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
			 where pt.packageID = 2 and tag_parentID = 1
			 and tag_parentID <> 0 
			 <cfif isdefined("selected_user_tags") and selected_user_tags NEQ "">
				and ppmc.tagID in (#selected_user_tags#)
			</cfif>
			 )
		</cfif>
		<cfif not listfind(valuelist(checkuserpackage.packageid),"2") and not listfind(valuelist(checkuserpackage.packageid),"12")>
		and ppmc.tagID in 
				(
				 select pbt_tags.tagID
			 from pbt_tags
			 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
			 where pt.packageID = 1 and tag_parentID = 1
			 and tag_parentID <> 0
			  <cfif isdefined("selected_user_tags") and selected_user_tags NEQ "">
				and ppmc.tagID in (#selected_user_tags#)
			</cfif>
			 )
		</cfif>--->
		
		 ) AS RowConstrainedResult
			) as filterResult
			
			WHERE   RowNum >= #startRow#
    		<!---AND RowNum <= #endRow#--->
			
</cfquery>
<cfif isdefined('url.showmethesql')>
<cfdump var="#search_results#" />
<cfdump var="#r1#" />
</cfif>
<cfif search_results.recordcount EQ 0>
	<cfset startrow = 0>
</cfif>