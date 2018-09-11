<cfparam name="startRow" default="1">
<cfparam name="endRow" default="20">
<cfparam name="user_projecttypes" default="">
<cfparam name="user_stage" default="">
<cfparam name="selected_user_tags" default="">
<cfparam name="selected_user_tags_secondary" default="">
<cfparam name="auth_stage" default="">
<cfparam name="authstages" default="">
<CFSET DATE = #createodbcdate(now())#>	
<cfparam name="url.coatingTypes" default=""/>
<cfparam name="url.coatingsManuf" default=""/>
<cfparam name="url.tags" default=""/>
<cfparam name="url.project_stage" default="1,2,3,4,5,6,7,8,9,10,11,15" />

<cfquery name="checkuserpackage" datasource="#application.datasource#">
	select distinct bid_subscription_log.packageid
	from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
	where bid_users.userid =  <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER"> 
	--and bid_subscription_log.packageid in (1,2,3,4,5,6,7,8,12) 
	and bid_subscription_log.effective_date <= #date# 
	and bid_subscription_log.expiration_date >= #date# 
	and bid_subscription_log.active = 1
</cfquery> 
<!---zipcode filter--->
 	<cfset zip_packageid = valuelist(checkuserpackage.packageid)>
	<cfinclude template="zip_module.cfm">

<!---run the keyword search if selected--->
<cfif isdefined("qt") and qt NEQ "">
<cfset url.newsolr = 3 /><cfif isdefined("url.oldsolr")><cfset url.newsolr = 0 /></cfif>
	<cfif url.newSolr eq 1>
		<cfinclude template="bt_search.cfm">
	<cfelseif url.newSolr eq 3>
		<cfinclude template="bt_search3.cfm">
	<cfelse>	
		<cfinclude template="bt_search_include.cfm">
	</cfif>
</cfif>
<!---run the contractor search if selected--->
<cfif isdefined("contractorname") and contractorname NEQ "">
	<cfinclude template="contractor_search_include.cfm">
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
		   	<cfset stages = "20">
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
	
		<!---designate authorized stages based on packages--->
	<cfif listfind(valuelist(checkuserpackage.packageid),"1") or listfind(valuelist(checkuserpackage.packageid),"2") or listfind(valuelist(checkuserpackage.packageid),"3")>
			<cfset authstages = "1,4,9,20,21,22,23,24">
	  		<cfset auth_stage = listappend(auth_stage,authstages)>
	</cfif>
	<cfif listfind(valuelist(checkuserpackage.packageid),"5") or listfind(valuelist(checkuserpackage.packageid),"6") or listfind(valuelist(checkuserpackage.packageid),"15") or listfind(valuelist(checkuserpackage.packageid),"12")  >
			<cfset authstages = "5,6">
	 		<cfset auth_stage = listappend(auth_stage,authstages)>
	</cfif>
	<cfif listfind(valuelist(checkuserpackage.packageid),"4") >
			<cfset authstages = "24,25">
	 		<cfset auth_stage = listappend(auth_stage,authstages)>
	</cfif>
	<cfif listfind(valuelist(checkuserpackage.packageid),"7") >
			<cfset authstages = "25">
	 		<cfset auth_stage = listappend(auth_stage,authstages)>
	</cfif>
	<cfif listfind(valuelist(checkuserpackage.packageid),"9") >
			<cfset authstages = "20,23">
	 		<cfset auth_stage = listappend(auth_stage,authstages)>
	</cfif>

	
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
				<cfquery name="get_approved_tags" datasource="#application.datasource#">
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
				<cfquery name="get_approved_tags_secondary" datasource="#application.datasource#">
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
		<cfquery name="getpackagestates" datasource="#application.datasource#">
		select distinct b.stateid 
		from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
		where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> 
		and stateid in (#state#)
		</cfquery>
		<cfset bidstates = valuelist(getpackagestates.stateid)>
	</cfif>
	<cfif not isdefined("state") or state is  "66">
		<cfquery name="getcustomerstates" datasource="#application.datasource#">
			select distinct b.stateid 
			from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
			where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  
			and a.userid in 
			(select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where 0=0 and 
			 bid_users.bt_status = 1)
		</cfquery>
		<cfif getcustomerstates.recordcount is 0 ><cflocation url="../index.cfm?nostates"></cfif>
		<cfset states1 = "#valuelist(getcustomerstates.stateid)#">
		<cfquery name="state1" datasource="#application.datasource#">
			select * 
			from state_master 
			where stateid in (#states1#) and countryid = 73 order by fullname  
		</cfquery>
		<cfset userstates= "#valuelist(state1.stateid)#">
	</cfif>
<!---set the sort options
,+ a.minimum_value + ' - ' + a.maximum_value as value--->
<!---include file to set sort values--->
<cfinclude template="sort_params.cfm">

<cfquery name="search_results" datasource="#application.datasource#">
	SELECT distinct a.stageID,a.bidID,a.projectname,a.stage,a.owner,a.city,a.state,a.tags,a.submittaldate,a.minimum_value as minimumvalue,a.maximum_value as maximumvalue,a.projectsize,a.valuetypeID as valuetype
    FROM pbt_project_master_gateway a
    INNER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
    INNER JOIN pbt_project_master_cats ppmc2 on ppmc2.bidID = a.bidID
    INNER JOIN pbt_project_master_cats ppmc3 on ppmc3.bidID = a.bidID
   	WHERE 1=1
   	<!---stages filter--->
   	<cfif isdefined("user_stage") and user_stage NEQ "">
	 	and a.stageID in (#user_stage#)
	</cfif>
	<cfif isdefined("auth_stage") and auth_stage NEQ "">
		and a.stageID in (#auth_stage#)
	</cfif>
	<!---bidID filter--->
   <cfif isdefined("bidid") and bidid is not "">
   		and a.bidid in (#bidid#)
   </cfif>
   <!---keyword search--->
   	<cfif isdefined("qt") and qt is not "" and bidlist is not "">
	   	and a.bidid in (select bidID
		from pbt_project_master_gateway 
		where bidID in (#bidlist#))
	<cfelseif isdefined("qt") and qt is not "" and bidlist is "">
		and a.bidid = 0
    </cfif>
    <!---contractor search--->
   	<cfif isdefined("contractorname") and contractorname is not "" and contractorlist is not "">
	   	and a.bidid in (#contractorlist#)
	<cfelseif isdefined("contractorname") and contractorname is not "" and contractorlist is "">
		and a.bidid = 0
    </cfif>
    <!---planholder search--->
   	<cfif isdefined("planholders")>
	   	and a.bidid in (select bidID from bid_planholders)
    </cfif>
    <!---post date--->
   	<cfif isdefined("postfrom") and postfrom NEQ "">
   		and a.paintpublishdate >= '#postfrom#'
		   <cfif isdefined("postto") and postto NEQ ""> 
		   	AND a.paintpublishdate <= '#postto#'
		   </cfif>
	</cfif>
	 <!---submittal date--->
   	<cfif isdefined("subfrom") and subfrom NEQ "">
   		and a.submittaldate >= '#subfrom#'
		   <cfif isdefined("subto") and subto NEQ ""> 
		   	AND a.submittaldate <= '#subto#'
		   </cfif>
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
						or  (a.minimum_value < '100000' or a.maximum_value < '100000')
					</cfif>
					<cfif listcontains(amount,3)>
						or (a.minimum_value >= '100000' and a.minimum_value <= '500000' and a.maximum_value <= '500000')
					</cfif>
					<cfif listcontains(amount,4)>
						or  (a.minimum_value >= '500000' and a.minimum_value <= '1000000' and a.maximum_value <= '1000000')
					</cfif>
					<cfif listcontains(amount,5)>
						or (a.minimum_value >= '1000000' or a.maximum_value >= '1000000')
					</cfif>
				
				<cfelse>
					<cfswitch expression="#amount#">
					<cfcase value="2">
						or (a.minimum_value < '100000' or a.maximum_value < '100000')
					</cfcase>
					<cfcase value="3">
						or (a.minimum_value >= '100000' and a.minimum_value <= '500000' and a.maximum_value <= '500000')
					</cfcase>
					<cfcase value="4">
						or (a.minimum_value >= '500000' and a.minimum_value <= '1000000' and a.maximum_value <= '1000000')
					</cfcase>
					<cfcase value="5">
						or (a.minimum_value >= '1000000' or a.maximum_value >= '1000000')
					</cfcase>
					<cfdefaultcase>
						
					</cfdefaultcase>
				</cfswitch>
				</cfif>
				)
				
			</cfif>
	<!---project types--->
	<cfif isdefined("user_projecttypes") and user_projecttypes is not 4 and user_projecttypes is not "">
		and a.valuetypeID in (#user_projecttypes#)
	</cfif>	
	
	<!---TAGS filter--->
		<!--- site default --->
		and ppmc3.tagID in (#session.default.tagID#) 	
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
		
		<cfif len(url.coatingTypes)>
			and ppmc2.tagID in (#url.coatingTypes#) --411
		</cfif>
		
		<cfif len(url.coatingsManuf)>
			and ppmc2.tagID in (#url.coatingsManuf#) --415
		</cfif>
		
		<cfif len(url.tags)>
			and ppmc2.tagID in (#url.tags#) --419
		</cfif>		
		<!---filter Engineering Awards--->
		<cfif isdefined("project_stage") and (project_stage EQ "9" or project_stage EQ "3")>
			and ppmc.tagID in (53,54,55,56,57,58,59,60,61,62,63,64)
		</cfif>
		
		<!---VERIFIED PAINT filter--->
		<cfif isdefined("verifiedProjects") and verifiedProjects NEQ "">
		and a.verifiedpaint = 1
		</cfif>	
		
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
		<!---FILTER ON PACKAGES TO VERIFY ALLOWED TAGS--->
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
		</cfif>
		order by submittaldate	
</cfquery>

<cfset bidder1 = "">
<cfset bidder1amount = "">
<cfset bidder2 = "">
<cfset bidder2amount = "">
<cfset bidder3 = "">
<cfset bidder3amount = "">

<cfset projectQuery = QueryNew("bidID,projectname,stage,owner,city,state,tags,submittaldate,estimated_value,projectsize,bidder1,bidder1amount,bidder2,bidder2amount,bidder3,bidder3amount", 
 "integer, varchar, varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar")>
<cfset counter=0>

<cfloop query="search_results">
<cfif stageID EQ 5 or stageID EQ 6>
	<cfstoredproc procedure="get_low" datasource="#application.datasource#" >
		<cfprocparam type="in" dbvarname="@bidid" cfsqltype="CF_SQL_INTEGER" value="#bidid#">
		<cfprocresult name="getlow" resultset="1">
		<cfprocresult name="getlow2" resultset="2">
	</cfstoredproc>
	<cfif (stageID EQ 5 or stageID EQ 6) and getlow.recordcount GT 0>
							
	<cfloop query="getlow" startrow="1" endrow="3">
		<cfif currentrow EQ 1>
			<cfset bidder1 = companyname>
			<cfset bidder1amount = #dollarformat(amount)#>
		</cfif>
		<cfif currentrow EQ 2>
			<cfset bidder2 = companyname>
			<cfset bidder2amount = #dollarformat(amount)#>
		</cfif>
		<cfif currentrow EQ 3>
			<cfset bidder3 = companyname>
			<cfset bidder3amount = #dollarformat(amount)#>
		</cfif>
	</cfloop>			
													
	<cfelseif (stageID EQ 5 or stageID EQ 6) and getlow2.recordcount GT 0>
		<cfloop query="getlow2" startrow="1" endrow="3">
		<cfif currentrow EQ 1>
			<cfset bidder1 = companyname>
			<cfset bidder1amount = #dollarformat(amount)#>
		</cfif>
		<cfif currentrow EQ 2>
			<cfset bidder2 = companyname>
			<cfset bidder2amount = #dollarformat(amount)#>
		</cfif>
		<cfif currentrow EQ 3>
			<cfset bidder3 = companyname>
			<cfset bidder3amount = #dollarformat(amount)#>
		</cfif>
	</cfloop>								
	</cfif>
</cfif>
<cfif valuetype is 1>
	<cfset valueT = "Total Contract">
<cfelseif valuetype is 2>
	<cfset valueT = "Painting Only">
<cfelse>
	<cfset valueT = "">
</cfif>	
<cfif minimumvalue is not "" and minimumvalue is not "0" and maximumvalue is not "0">
		<cfset bidvalue = "#dollarformat(minimumvalue)# - #dollarformat(maximumvalue)# #valueT#">
<cfelseif minimumvalue is not "" and minimumvalue is not "0">
		<cfset bidvalue= "#dollarformat(minimumvalue)# #valueT#">
<cfelseif minimumvalue is not "" and minimumvalue is "0" and maximumvalue is not "0">
		<cfset bidvalue= "#dollarformat(maximumvalue)# #valueT#">
<cfelse>
		<cfset bidvalue = "">
</cfif>

<!---Removal of WBT specific tags--->
<cfset clean_tags = replaceNoCase(tags, 'WBT,', '', "all")>
<cfset clean_tags = replaceNoCase(clean_tags, 'Water/Wastewater,', '', "all")>                                                    
<cfset clean_tags = replaceNoCase(clean_tags, 'WBT', '', "all")>
<cfset clean_tags = replaceNoCase(clean_tags, 'Water/Wastewater', '', "all")>

<cfset newRow = QueryAddRow(projectQuery, 1)>
<cfset counter=counter+1>
<cfset temp = QuerySetCell(projectQuery, "bidID", "#bidID#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "projectname", "#projectname#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "stage", "#stage#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "owner", "#owner#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "city", "#city#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "state", "#state#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "tags", "#clean_tags#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "submittaldate", "#submittaldate#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "estimated_value", "#bidvalue#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "projectsize", "#projectsize#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "bidder1", "#bidder1#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "bidder1amount", "#bidder1amount#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "bidder2", "#bidder2#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "bidder2amount", "#bidder2amount#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "bidder3", "#bidder3#", #counter#)>
<cfset temp = QuerySetCell(projectQuery, "bidder3amount", "#bidder3amount#", #counter#)>
<cfset bidder1 = "">
<cfset bidder1amount = "">
<cfset bidder2 = "">
<cfset bidder2amount = "">
<cfset bidder3 = "">
<cfset bidder3amount = "">
</cfloop>

<cfquery name="projectQuery" dbtype="query">
		select * from projectQuery
</cfquery>


<CFSET todaydate = #CREATEODBCDATETIME(NOW())#>
<!---insert log of export actions--->
<cfquery name="insert_export_log" datasource="#application.datasource#">
	insert into pbt_user_excel_exports
	(
	qt,
	date_created,
	userid,
	amount,
	state,
	postfrom,
	postto,
	subfrom,
	subto,
	bidID,
	project_stage,
	all_scopes,
	industrial,
	commercial,
	paintingprojects,
	qualifications,
	supply,
	structures,
	scopes,
	action,
	generalcontracts,
	allprojects,
	all_services,
	services,
	verifiedprojects,
	contractorname,
	remoteIP,
	total_results)
	values
	(
	<cfif isdefined("qt") and qt NEQ "">'#qt#'<cfelse>NULL</cfif>,
	#todaydate#,
	#userid#,
	<cfif isdefined("amount") and amount NEQ "">'#amount#'<cfelse>NULL</cfif>,
	<cfif isdefined("state") and state NEQ "">'#state#'<cfelse>NULL</cfif>,
	<cfif isdefined("postfrom") and postfrom NEQ "">'#postfrom#'<cfelse>NULL</cfif>,
	<cfif isdefined("postto") and postto NEQ "">'#postto#'<cfelse>NULL</cfif>,
	<cfif isdefined("subfrom") and subfrom NEQ "">'#subfrom#'<cfelse>NULL</cfif>,
	<cfif isdefined("subto") and subto NEQ "">'#subto#'<cfelse>NULL</cfif>,
	<cfif isdefined("bidID") and bidID NEQ "">#bidID#<cfelse>NULL</cfif>,
	<cfif isdefined("project_stage") and project_stage NEQ "">'#project_stage#'<cfelse>NULL</cfif>,
	<cfif isdefined("all_scopes") and all_scopes NEQ "">'#all_scopes#'<cfelse>NULL</cfif>,
	<cfif isdefined("industrial") and industrial NEQ "">'#industrial#'<cfelse>NULL</cfif>,
	<cfif isdefined("commercial") and commercial NEQ "">'#commercial#'<cfelse>NULL</cfif>,
	<cfif isdefined("paintingprojects") and paintingprojects NEQ "">'#paintingprojects#'<cfelse>NULL</cfif>,
	<cfif isdefined("qualifications") and qualifications NEQ "">'#qualifications#'<cfelse>NULL</cfif>,
	<cfif isdefined("supply") and supply NEQ "">'#supply#'<cfelse>NULL</cfif>,
	<cfif isdefined("structures") and structures NEQ "">'#structures#'<cfelse>NULL</cfif>,
	<cfif isdefined("scopes") and scopes NEQ "">'#scopes#'<cfelse>NULL</cfif>,
	<cfif isdefined("action") and action NEQ "">'#action#'<cfelse>NULL</cfif>,
	<cfif isdefined("generalcontracts") and generalcontracts NEQ "">'#generalcontracts#'<cfelse>NULL</cfif>,
	<cfif isdefined("allprojects") and allprojects NEQ "">'#allprojects#'<cfelse>NULL</cfif>,
	<cfif isdefined("all_services") and all_services NEQ "">'#all_services#'<cfelse>NULL</cfif>,
	<cfif isdefined("services") and services NEQ "">'#services#'<cfelse>NULL</cfif>,
	<cfif isdefined("verifiedprojects") and verifiedprojects NEQ "">'#verifiedprojects#'<cfelse>NULL</cfif>,
	<cfif isdefined("contractorname") and contractorname NEQ "">'#contractorname#'<cfelse>NULL</cfif>,
	'#cgi.remote_addr#',
	#search_results.recordcount#
	)
	</cfquery>
