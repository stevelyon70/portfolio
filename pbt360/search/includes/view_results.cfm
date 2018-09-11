<cfparam name="startRow" default="1">
<cfparam name="endRow" default="20">
<cfparam name="user_projecttypes" default="">
<cfparam name="user_stage" default="">
<cfparam name="selected_user_tags" default="">
<cfparam name="selected_user_tags_secondary" default="">
<cfparam name="auth_stage" default="">
<cfparam name="authstages" default="">
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


<cfquery name="checkuserpackage" datasource="#application.dataSource#">
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

<cfif isdefined("state") and state is not "66">
		<cfquery name="getpackagestates" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
		select distinct b.stateid 
		from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
		where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> 
		and stateid in (#state#)
		</cfquery>
		<cfset bidstates = valuelist(getpackagestates.stateid)>
	</cfif>
	<cfif not isdefined("state") or state is  "66">
		<cfquery name="getcustomerstates" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
			select distinct b.stateid 
			from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
			where a.userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">  
			and a.userid in 
			(select bid_users.userid from bid_users inner join reg_users on bid_users.reguserid = reg_users.reg_userid where 0=0 and 
			 bid_users.bt_status = 1)
		</cfquery>
		<cfif getcustomerstates.recordcount is 0 ><cflocation url="../index.cfm?nostates"></cfif>
		<cfset states1 = "#valuelist(getcustomerstates.stateid)#">
		<cfquery name="state1" datasource="#application.datasource#" cachedwithin="#CreateTimeSpan(0,0,8,0)#">
			select * 
			from state_master 
			where stateid in (#states1#) and countryid = 73 order by fullname  
		</cfquery>
		<cfset userstates= "#valuelist(state1.stateid)#">
	</cfif>
<!---compile user stage selections--->
	 <cfswitch expression="#ltype#">
	 	  <cfcase value="1">
		   	<cfset stages = "1,4,9">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="2">
		   	<cfset stages = "1,4,9">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="3">
		   	 <cfset stages = "5,6">
	 		 <cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		</cfswitch>

	
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
	
	

	<!---set the user's tag selections--->
	
			<!---check user tags if they have a niche tags package only--->
				<cfif listfind(session.packages, 16)>
				<cfquery name="get_approved_tags" datasource="#application.dataSource#">
					select tagID
					from pbt_user_tags
					where userID = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER"> 
					and tagID in (#variable.user_tags#)
					<cfif isdefined("selected_user_tags") and selected_user_tags NEQ "">and tagID in (#selected_user_tags#)</cfif>
					and active = 1
					 <cfswitch expression="#ltype#">
				 	  <cfcase value="1">
					   and tagID in (#valuelist(pull_industrial_structures_all.tagID)#)
					  </cfcase>
					   <cfcase value="2">
					  and tagID in (#valuelist(pull_commercial_structures.tagID)#)
					  </cfcase>
					  <cfcase value="3">
					  and (tagID in (#valuelist(pull_industrial_structures_all.tagID)#) or tagID in (#valuelist(pull_commercial_structures.tagID)#))
					  </cfcase>
					</cfswitch>
				</cfquery>
				<cfif get_approved_tags.recordcount EQ 0>
				<cflocation url="../index.cfm">
				</cfif>
				<cfset selected_user_tags = valuelist(get_approved_tags.tagID)>
				</cfif>
				<!---include template to include additional tags--->
				<cfinclude template="tag_conversion_inc.cfm">
				
				
<!---	
<cfquery name="total_results" datasource="#application.dataSource#">
	SELECT count(distinct a.bidID) as total_returned
    FROM pbt_project_master_gateway a
    INNER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
   	WHERE 1=1
   	---stages filter---
   	<cfif isdefined("user_stage") and user_stage NEQ "">
	 	and a.stageID in (#user_stage#)
	</cfif>
	<cfif isdefined("auth_stage") and auth_stage NEQ "">
		and a.stageID in (#auth_stage#)
	</cfif>
	---states filter---
		<cfif not isdefined("state") or state is "66">
			and (1 = 1 
			<cfif isdefined("userstates") and userstates is not "">
			or (a.stateid in (#userstates#))</cfif>
			
			)
		</cfif>
		---if user selected a state run check to verify states selected are approved---
		<cfif isdefined("state") and state is not "66">
			and (1 <> 1 
			<cfif isdefined("bidstates") and bidstates is not "">
			or (a.stateid in (#bidstates#))
			</cfif>
			)
		</cfif>

	
	---TAGS filter---
		<cfif isdefined("selected_user_tags") and selected_user_tags NEQ "">
		and ppmc.tagID in (#selected_user_tags#)
		</cfif>
		
	---VERIFIED PAINT filter---
		and a.verifiedpaint = 1
		
		
	---USER TRASH ---
		<cfif user_trash.recordcount GT 0>
		and a.bidID not in (#valuelist(user_trash.bidID)#)
		</cfif>
		<!---filter based on zipcodes--->
		<cfif isdefined("ziplist") and ziplist is not "">
		and ((a.zipcode in (#ziplist#) or a.owner_zipcode in (#ziplist#))  or ((a.owner_zipcode is null and a.zipcode is null) ))
		</cfif>
		
	---filter the structure either industrial or commercial---
	<cfif not listfind(session.packages, 16)>
		 <cfswitch expression="#ltype#">
	 	  <cfcase value="1">
		   and ppmc.tagID in (#valuelist(pull_industrial_structures_all.tagID)#)
		  </cfcase>
		   <cfcase value="2">
		  and ppmc.tagID in (#valuelist(pull_commercial_structures.tagID)#)
		  </cfcase>
		  <cfcase value="3">
		  and (ppmc.tagID in (#valuelist(pull_industrial_structures_all.tagID)#) or ppmc.tagID in (#valuelist(pull_commercial_structures.tagID)#))
		  </cfcase>
		</cfswitch>
	</cfif>
	
	
</cfquery>--->
<!---if show all then set the param for endrow to all records
<cfif isdefined("showall") and showall EQ "yes">
	<cfset endrow = total_results.total_returned>
</cfif>--->
<!---include file to set sort values--->
<cfinclude template="sort_params.cfm">

<cfquery name="search_results" datasource="#application.dataSource#" result="r1"><!--- bid_planholders.contactphone as phonenumber--->
	select *
			from 
			(
			SELECT  *,ROW_NUMBER() OVER ( ORDER BY #sortvalue# ) AS RowNum
			FROM    (
			SELECT distinct g.phonenumber, a.bidID,a.projectname,a.owner,a.ownerID,a.tags,a.submittaldate,a.city,
	 a.state,a.stateID,a.projectsize,a.minimum_value as minimumvalue,a.maximum_value as maximumvalue,a.stage,a.stageID,a.paintpublishdate,a.zipcode,a.valuetypeID as valuetype,a.county,bid_user_viewed_log.bidid as viewed,pbt_project_updates.updateid,a.supplierID,bid_planholders.bidid as planholders, promas.projectnum
    FROM pbt_project_master_gateway a
    INNER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
    left outer join pbt_project_contacts g on g.bidID = a.bidID and g.contact_typeID = 1
    LEFT OUTER JOIN pbt_project_master promas on promas.bidid = a.bidid
    LEFT OUTER JOIN bid_user_viewed_log on a.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid=  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">
	LEFT OUTER JOIN pbt_project_updates on a.bidid = pbt_project_updates.bidid and pbt_project_updates.pupdateid in (select max(pupdateid) from pbt_project_updates where pbt_project_updates.bidid = a.bidid)
	LEFT OUTER JOIN bid_planholders on bid_planholders.bidid = a.bidID 					 
   	WHERE 1=1
   	<!---stages filter--->
   	<cfif isdefined("user_stage") and user_stage NEQ "">
	 	and a.stageID in (#user_stage#)
	</cfif>
	<cfif isdefined("auth_stage") and auth_stage NEQ "">
		and a.stageID in (#auth_stage#)
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
		<cfif isdefined("selected_user_tags") and selected_user_tags NEQ "">
		and ppmc.tagID in (#selected_user_tags#)
		</cfif>
		
		<!---VERIFIED PAINT filter--->
		and a.verifiedpaint = 1
		

		<!---USER TRASH --->
		<cfif user_trash.recordcount GT 0>
		and a.bidID not in (#valuelist(user_trash.bidID)#)
		</cfif>
		<!---filter based on zipcodes--->
		<cfif isdefined("ziplist") and ziplist is not "">
		and ((a.zipcode in (#ziplist#) or a.owner_zipcode in (#ziplist#))  or ((a.owner_zipcode is null and a.zipcode is null) ))
		</cfif>
		
		<!---filter the structure either industrial or commercial--->
		<cfif not listfind(session.packages, 16)>
		 <cfswitch expression="#ltype#">
	 	  <cfcase value="1">
		   and ppmc.tagID in (#valuelist(pull_industrial_structures_all.tagID)#)
		  </cfcase>
		   <cfcase value="2">
		  and ppmc.tagID in (#valuelist(pull_commercial_structures.tagID)#)
		  </cfcase>
		  <cfcase value="3">
		  and (ppmc.tagID in (#valuelist(pull_industrial_structures_all.tagID)#) or ppmc.tagID in (#valuelist(pull_commercial_structures.tagID)#))
		  </cfcase>
		</cfswitch>
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


