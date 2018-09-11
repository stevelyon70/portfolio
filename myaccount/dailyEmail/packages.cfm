	<cfquery name="getpackages" datasource="paintsquare_master">
		select packageid 
		from bid_subscription_log 
		where userid = #user1# 
			and active = 1 
			and packageid in (1,2,3,4,8,9)  
			and effective_date <= #todaydate# 
			and expiration_date >= #todaydate#
	</cfquery>
	<cfquery name="getcustomercategory" datasource="paintsquare_master"><!---pull categories--->
		select * 
		from bid_user_category 
		where userid = #user1#
	</cfquery>
	<cfset categories = "#valuelist(getcustomercategory.categoryid)#">
	<cfif listcontains(valuelist(getcustomercategory.categoryid),1) >
		<cfset categories1 = "">
	</cfif>
	<cfif listcontains(valuelist(getcustomercategory.categoryid),2) >
		<cfset categories2 = "">
	</cfif>
	<cfif listcontains(valuelist(getcustomercategory.categoryid),3) >
		<cfset categories3 = "">
	</cfif>
	<cfif listcontains(valuelist(getcustomercategory.categoryid),5) >
		<cfset categories5 = "">
	</cfif>
	<cfif listcontains(valuelist(getcustomercategory.categoryid),7) >
		<cfset categories7 = "">
	</cfif>
	<cfset pscategories = "">
	<cfset subcategories = "">
	<cfset scopes = "">
	<cfquery name="getcustomerpscategory" datasource="paintsquare_master"><!---general subcats--->
		select b.tagID 
		from bid_user_ps_subcategory 
		left outer join bid_onvia_categories b on b.ps_catid = bid_user_ps_subcategory.ps_catid
		where userid =  #user1#
	</cfquery>
	<cfset pscategories = "#valuelist(getcustomerpscategory.tagid)#">
	<cfquery name="getcustomersubcategory" datasource="paintsquare_master"><!---pull subcategories--->
		select bid_user_subcategory.subcatid,bid_subcategories.tagID
		from bid_user_subcategory 
		left outer join bid_subcategories on bid_subcategories.bid_subcatid = bid_user_subcategory.subcatid
		where bid_user_subcategory.userid = #user1# 
		and bid_subcategories.categoryid = 1
	</cfquery>
	<cfquery name="getcustomersubcategory2" datasource="paintsquare_master"><!---pull subcategories--->
		select bid_user_subcategory.subcatid,bid_subcategories.tagid 
		from bid_user_subcategory 
		left outer join bid_subcategories on bid_subcategories.bid_subcatid = bid_user_subcategory.subcatid
		where bid_user_subcategory.userid = #user1# and bid_subcategories.categoryid = 2
	</cfquery>
	<cfset subcategories = "#valuelist(getcustomersubcategory.tagid)#">
	<cfset commsubcategories = "#valuelist(getcustomersubcategory2.tagid)#">
	<cfquery name="getcustomerscope" datasource="paintsquare_master"><!---pull categories--->
		select tagid
			from pbt_user_email_tag
			where userID = #user1# 
	</cfquery>	 
	<cfset scopes = "#valuelist(getcustomerscope.tagid)#">
<!-- 
**********************
select bids_scope.tagID
		from bid_user_scope
		left outer join bids_scope on bids_scope.scopeID = bid_user_scope.scopeID
		where userid = #user1# and tagID is not null

package id 1 
**********************
-->


<!---

<cfquery name="search_results" datasource="#application.datasource#" result="r1"  >
	select *
			from 
			(
			SELECT  *,ROW_NUMBER() OVER ( ORDER BY #sortvalue# ) AS RowNum
			FROM    (
			SELECT distinct g.PhoneNumber,a.bidID,a.projectname,a.owner,a.ownerID,a.tags,a.submittaldate,a.city,
	 a.state,a.stateID,a.projectsize,a.minimum_value as minimumvalue,a.maximum_value as maximumvalue,a.stage,a.stageID,a.paintpublishdate,a.zipcode,a.valuetypeID as valuetype,a.county,bid_user_viewed_log.bidid as viewed,pbt_project_updates.updateid,a.supplierID,bid_planholders.bidid as planholders, promas.projectnum
    FROM pbt_project_master_gateway a
    LEFT OUTER JOIN pbt_project_master promas on promas.bidid = a.bidid
    left outer join pbt_project_contacts g on g.bidID = a.bidID and g.contact_typeID = 1
 	LEFT OUTER JOIN supplier_master sm on sm.supplierID = a.ownerID
    LEFT OUTER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
    LEFT OUTER JOIN pbt_project_master_cats ppmc2 on ppmc2.bidID = a.bidID
    LEFT OUTER JOIN bid_user_viewed_log on a.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid=  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER">
	LEFT OUTER JOIN pbt_project_updates on a.bidid = pbt_project_updates.bidid and pbt_project_updates.pupdateid in (select max(pupdateid) from pbt_project_updates where pbt_project_updates.bidid = a.bidid and datepart(dd,a.paintpublishdate) <> datepart(dd,pbt_project_updates.date_entered))
	LEFT OUTER JOIN bid_planholders on bid_planholders.bidid = a.bidID and (bid_planholders.companyname is not null or bid_planholders.firstname is not null or bid_planholders.lastname is not null)  			 
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
   		and a.bidid in (#bidid#) -- 463
   </cfif>
   <!---keyword search--->
   	<cfif isdefined("qt") and qt is not "" and bidlist is not "">
	   	and a.bidid in (select bidID
		from pbt_project_master_gateway 
		where bidID in (#bidlist#))
	<cfelseif isdefined("qt") and qt is not "" and bidlist is "">
		and a.bidid = 0 -- 471
    </cfif>
    <!---contractor search--->
   	<cfif isdefined("contractorname") and contractorname is not "" and contractorlist is not "">
	   	and a.bidid in (#contractorlist#)
	<cfelseif isdefined("contractorname") and contractorname is not "" and contractorlist is "">
		and a.bidid = 0 -- 477
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
			</cfif> ppmc2.tagID in (#selected_user_tags_secondary#)) --400
		<!---scopes only--->
		<cfelseif (isdefined("selected_user_tags") and selected_user_tags EQ "") and (isdefined("selected_user_tags_secondary") and selected_user_tags_secondary NEQ "")>
		and ppmc2.tagID in (#selected_user_tags_secondary#) --403
		<cfelse>
		
		</cfif>
		<!--- coatings filter <cfparam name="url.coatingTypes" default=""/>
<cfparam name="url.coatingsManuf" default=""/>
	--->
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
		
		 ) AS RowConstrainedResult
			) as filterResult
			
			WHERE   RowNum >= #startRow#
			
</cfquery>

--->


<cfif listcontains(valuelist(getpackages.packageid),1) >
<cfif isdefined("categories1") and subcategories is not "" and scopes is not "">
<cftry>
	<cfquery name="getcustomerstates_1" datasource="paintsquare_master"><!---get the user states--->
		select distinct b.stateid 
		from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
		where a.userid = #user1#  and b.packageid = 1 
	</cfquery>
	<cfset states_1 = "#valuelist(getcustomerstates_1.stateid)#">
	<cfquery name="industrial" datasource="paintsquare_master" result="r1">
		SELECT distinct 	b.bidid,b.owner,b.projectname,b.bid,b.scopeofwork,b.submittaldate,b.valuetypeid,b.state,b.city,b.minimumvalue,b.maximumvalue,b.categoryid,b.catid,b.projectsize,b.county
		FROM   bid_temp_v4 b
			INNER JOIN pbt_project_master_cats a ON b.bidid = a.bidid
			INNER JOIN pbt_project_master_gateway m on m.bidid = b.bidid
		WHERE   b.stateid in (#states_1#) 
		 <!---cfif getcustomersubcategory.recordcount LT 14> and (a.tagID IN (#subcategories#))</cfif---> 
		 <cfif getcustomerscope.recordcount>
			AND (a.tagid IN (#scopes#))
      	 </cfif>  
		and (1<>1
				<cfif listlen(getEmailPrefs.budget) GT 1>
					<cfif listcontains(getEmailPrefs.budget,2)>
						or (b.minimumvalue < '100000' or b.maximumvalue < '100000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,3)>
						or (b.minimumvalue >= '100000' and b.minimumvalue <= '500000' and b.maximumvalue <= '500000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,4)>
						or (b.minimumvalue >= '500000' and b.minimumvalue <= '1000000' and b.maximumvalue <= '1000000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,5)>
						or (b.minimumvalue >= '1000000' or b.maximumvalue >= '1000000')
					</cfif>
				
				<cfelse>
					<cfswitch expression="#getEmailPrefs.budget#">
					<cfcase value="2">
						or (b.minimumvalue < '100000' or b.maximumvalue < '100000')
					</cfcase>
					<cfcase value="3">
						or (b.minimumvalue >= '100000' and b.minimumvalue <= '500000' and b.maximumvalue <= '500000')
					</cfcase>
					<cfcase value="4">
						or (b.minimumvalue >= '500000' and b.minimumvalue <= '1000000' and b.maximumvalue <= '1000000')
					</cfcase>
					<cfcase value="5">
						or (b.minimumvalue >= '1000000' or b.maximumvalue >= '1000000')
					</cfcase>
					<cfdefaultcase>
						
					</cfdefaultcase>
				</cfswitch>
				</cfif>
				)
      	 	and b.catid = 1
		GROUP BY b.bidid,b.owner,b.projectname,b.bid,b.scopeofwork,b.submittaldate,b.valuetypeid,b.state,b.city,b.minimumvalue,b.maximumvalue,b.categoryid,b.catid,b.projectsize,b.county
		ORDER BY b.submittaldate
	</cfquery>	
	<cfcatch type="Database">
	<CFMAIL SUBJECT="PaintSquare BidTracker Email Problem" FROM="PaintBidtracker@paintsquare.com" to="jbirch@paintbidtracker.com,slyon@technologypub.com" type="html">
		Aborted the database query for Line 192 on new_email.cfm.userid = #userid#
		<cfdump var="#cfcatch#" />
	</cfmail>
	<cfset good = 1>
	</cfcatch>
</cftry>
</cfif>
</cfif> 

<!-- 
**********************
package id 2 
**********************
-->
<cfif listcontains(valuelist(getpackages.packageid),2) >
<cfif isdefined("categories2") and commsubcategories is not "" and scopes is not "">
	<cftry>
		<cfquery name="getcustomerstates_2" datasource="paintsquare_master"><!---get the user states--->
			select distinct b.stateid 
			from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
			where a.userid = #user1#  and b.packageid = 2 
		</cfquery>
		<cfset states_2 = "#valuelist(getcustomerstates_2.stateid)#">
		<cfquery name="commercial" datasource="paintsquare_master"  result="r2">
		SELECT distinct b.bidid,b.owner,b.projectname,b.bid,b.scopeofwork,b.submittaldate,b.valuetypeid,b.state,b.city,b.minimumvalue,b.maximumvalue,b.categoryid,b.catid,b.projectsize,b.county
		FROM   bid_temp_v4  b
			INNER JOIN pbt_project_master_cats a ON b.bidid = a.bidid
			--INNER JOIN pbt_project_master_cats b ON b.bidid = a.bidid
			INNER JOIN pbt_project_master_gateway m on m.bidid = b.bidid
		WHERE   b.catid = 2 and b.stateid in (#states_2#) 
		<!---cfif getcustomersubcategory2.recordcount LT 14> and (a.tagID IN (#commsubcategories#))</cfif---> 
		<cfif getcustomerscope.recordcount>
			AND (a.tagid IN (#scopes#))
      	 </cfif>    
		and (1<>1
				<cfif listlen(getEmailPrefs.budget) GT 1>
					<cfif listcontains(getEmailPrefs.budget,2)>
						or (b.minimumvalue < '100000' or b.maximumvalue < '100000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,3)>
						or (b.minimumvalue >= '100000' and b.minimumvalue <= '500000' and b.maximumvalue <= '500000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,4)>
						or (b.minimumvalue >= '500000' and b.minimumvalue <= '1000000' and b.maximumvalue <= '1000000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,5)>
						or (b.minimumvalue >= '1000000' or b.maximumvalue >= '1000000')
					</cfif>
				
				<cfelse>
					<cfswitch expression="#getEmailPrefs.budget#">
					<cfcase value="2">
						or (b.minimumvalue < '100000' or b.maximumvalue < '100000')
					</cfcase>
					<cfcase value="3">
						or (b.minimumvalue >= '100000' and b.minimumvalue <= '500000' and b.maximumvalue <= '500000')
					</cfcase>
					<cfcase value="4">
						or (b.minimumvalue >= '500000' and b.minimumvalue <= '1000000' and b.maximumvalue <= '1000000')
					</cfcase>
					<cfcase value="5">
						or (b.minimumvalue >= '1000000' or b.maximumvalue >= '1000000')
					</cfcase>
					<cfdefaultcase>
						
					</cfdefaultcase>
				</cfswitch>
				</cfif>
				)
		group by b.bidid,b.owner,b.projectname,b.bid,b.scopeofwork,b.submittaldate,b.valuetypeid,b.state,b.city,b.minimumvalue,b.maximumvalue,b.categoryid,b.catid,b.projectsize,b.county
		ORDER BY  b.submittaldate 
		</cfquery>	
		<cfcatch type="Database">
			<CFMAIL	SUBJECT="PaintSquare BidTracker Bid Insert Problem" FROM="PaintBidtracker@paintsquare.com" to="jbirch@paintbidtracker.com,slyon@technologypub.com" type="html">
				Aborted the database query for Line 227 on new_email.cfm.userid = #userid#
		<cfdump var="#cfcatch#" />
			</cfmail>
			<cfset good = 1>
		</cfcatch>
	</cftry>
</cfif>
</cfif>
<!-- 
**********************
package id 3 
**********************
-->
<cfif listcontains(valuelist(getpackages.packageid),3) >
<cfif isdefined("categories3") and pscategories is not "">
	<cftry>
		<cfquery name="getcustomerstates_3" datasource="paintsquare_master"><!---get the user states--->
			select distinct b.stateid 
			from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
			where a.userid = #user1#  and b.packageid = 3 
		</cfquery>
		<cfset states_3 = "#valuelist(getcustomerstates_3.stateid)#">
		<cfquery name="construction" datasource="paintsquare_master"  result="r3">
		SELECT distinct b.bidid,b.owner,b.projectname,b.psshow,b.submittaldate,b.valuetypeid,b.state,b.city,b.minimumvalue,b.maximumvalue,b.categoryid,b.catid,b.projectsize,b.county
		FROM bid_temp_v4 b
			INNER JOIN pbt_project_master_cats a ON b.bidid = a.bidid
			--INNER JOIN pbt_project_master_cats b ON b.bidid = a.bidid
			INNER JOIN pbt_project_master_gateway m on m.bidid = b.bidid
		WHERE   b.stateid in (#states_3#) 
		and b.catid = 3  
		<cfif getcustomerscope.recordcount>
			AND (a.tagid IN (#scopes#))
      	 </cfif> 
		group by b.bidid,b.owner,b.projectname,b.psshow,b.submittaldate,b.valuetypeid,b.state,b.city,b.minimumvalue,b.maximumvalue,b.categoryid,b.catid,b.projectsize,b.county
		order by b.submittaldate 
		</cfquery>	
		<cfcatch type="Database">
			<CFMAIL SUBJECT="PaintSquare BidTracker Bid Insert Problem" FROM="PaintBidtracker@paintsquare.com"
			to="jbirch@paintbidtracker.com,slyon@technologypub.com" type="html">
				Aborted the database query for Line 235 on new_email.cfm.userid = #userid#
		<cfdump var="#cfcatch#" />
			</cfmail>
			<cfset good = 1>
		</cfcatch>
	</cftry>
</cfif>
</cfif>
<!-- 
**********************
package id 4 
**********************
-->
<cfif listcontains(valuelist(getpackages.packageid),4) >
<cfif isdefined("categories5") and pscategories is not "">
	<cftry>
		<cfquery name="getcustomerstates_4" datasource="paintsquare_master"><!---get the user states--->
			select distinct b.stateid 
			from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
			where a.userid = #user1#  and b.packageid = 4 
		</cfquery>
		<cfset states_4 = "#valuelist(getcustomerstates_4.stateid)#">
		<cfquery name="engineering" datasource="paintsquare_master"  result="r4">
			SELECT distinct b.bidid,b.owner,b.projectname,b.psshow,b.submittaldate,b.valuetypeid,b.state,b.city,b.minimumvalue,b.maximumvalue,b.categoryid,b.catid,b.projectsize,b.county
			FROM         bid_temp_v4 b
				INNER JOIN pbt_project_master_cats a ON b.bidid = a.bidid
			INNER JOIN pbt_project_master_gateway m on m.bidid = b.bidid
			WHERE   b.stateid in (#states_4#) and b.catid = 6  
			<cfif getcustomerscope.recordcount>
				AND (a.tagid IN (#scopes#))
			 </cfif>  
		and (1<>1
				<cfif listlen(getEmailPrefs.budget) GT 1>
					<cfif listcontains(getEmailPrefs.budget,2)>
						or (b.minimumvalue < '100000' or b.maximumvalue < '100000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,3)>
						or (b.minimumvalue >= '100000' and b.minimumvalue <= '500000' and b.maximumvalue <= '500000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,4)>
						or (b.minimumvalue >= '500000' and b.minimumvalue <= '1000000' and b.maximumvalue <= '1000000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,5)>
						or (b.minimumvalue >= '1000000' or b.maximumvalue >= '1000000')
					</cfif>
				
				<cfelse>
					<cfswitch expression="#getEmailPrefs.budget#">
					<cfcase value="2">
						or (b.minimumvalue < '100000' or b.maximumvalue < '100000')
					</cfcase>
					<cfcase value="3">
						or (b.minimumvalue >= '100000' and b.minimumvalue <= '500000' and b.maximumvalue <= '500000')
					</cfcase>
					<cfcase value="4">
						or (b.minimumvalue >= '500000' and b.minimumvalue <= '1000000' and b.maximumvalue <= '1000000')
					</cfcase>
					<cfcase value="5">
						or (b.minimumvalue >= '1000000' or b.maximumvalue >= '1000000')
					</cfcase>
					<cfdefaultcase>
						
					</cfdefaultcase>
				</cfswitch>
				</cfif>
				) 
			group by  b.bidid,b.owner,b.projectname,b.psshow,b.submittaldate,b.valuetypeid,b.state,b.city,b.minimumvalue,b.maximumvalue,b.categoryid,b.catid,b.projectsize,b.county
			order by b.submittaldate 
		</cfquery>	
		<cfcatch type="Database">
			<CFMAIL SUBJECT="PaintSquare BidTracker Bid Email Problem" FROM="PaintBidtracker@paintsquare.com" to="jbirch@paintbidtracker.com,slyon@technologypub.com" type="html">
				Aborted the database query for Line 270 on new_email.cfm.userid = #userid#
		<cfdump var="#cfcatch#" />
			<cfdump var="#cfcatch#" />
			</cfmail>
			<cfset good = 1>
		</cfcatch>
	</cftry>
</cfif>
</cfif>
<!-- 
**********************
package id 9 
**********************
-->
<cfif listcontains(valuelist(getpackages.packageid),9) >
	<cftry>
		<cfquery name="getcustomerstates_9" datasource="paintsquare_master"><!---get the user states--->
			select distinct b.stateid 
			from bid_user_state_log a inner join bid_user_supplier_state_log b on b.id = a.id
			where a.userid = #user1#  and b.packageid = 9 
		</cfquery>
		<cfset states_9 = "#valuelist(getcustomerstates_9.stateid)#">
		<cfquery name="private" datasource="paintsquare_master"  result="r5">
			SELECT distinct 
			b.bidid,b.projectname,b.bid,b.submittaldate,b.valuetypeid,b.state,b.city,b.minimumvalue,b.maximumvalue,b.categoryid,b.catid,b.projectsize,b.bidtypeid,b.county
			FROM    bid_temp_v4  b
				INNER JOIN pbt_project_master_gateway m on m.bidid = b.bidid 
				inner join pbt_project_master_cats a on m.bidid = a.bidid
			WHERE   b.catid = 7 and b.stateid in (#states_9#)  
			<cfif getcustomerscope.recordcount>
				AND (a.tagid IN (#scopes#))
			 </cfif>  
		and (1<>1
				<cfif listlen(getEmailPrefs.budget) GT 1>
					<cfif listcontains(getEmailPrefs.budget,2)>
						or (b.minimumvalue < '100000' or b.maximumvalue < '100000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,3)>
						or (b.minimumvalue >= '100000' and b.minimumvalue <= '500000' and b.maximumvalue <= '500000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,4)>
						or (b.minimumvalue >= '500000' and b.minimumvalue <= '1000000' and b.maximumvalue <= '1000000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,5)>
						or (b.minimumvalue >= '1000000' or b.maximumvalue >= '1000000')
					</cfif>
				
				<cfelse>
					<cfswitch expression="#getEmailPrefs.budget#">
					<cfcase value="2">
						or (b.minimumvalue < '100000' or b.maximumvalue < '100000')
					</cfcase>
					<cfcase value="3">
						or (b.minimumvalue >= '100000' and b.minimumvalue <= '500000' and b.maximumvalue <= '500000')
					</cfcase>
					<cfcase value="4">
						or (b.minimumvalue >= '500000' and b.minimumvalue <= '1000000' and b.maximumvalue <= '1000000')
					</cfcase>
					<cfcase value="5">
						or (b.minimumvalue >= '1000000' or b.maximumvalue >= '1000000')
					</cfcase>
					<cfdefaultcase>
						
					</cfdefaultcase>
				</cfswitch>
				</cfif>
				)
			group by  b.bidid,b.owner,b.projectname,b.bid,b.submittaldate,b.valuetypeid,b.state,b.city,b.minimumvalue,b.maximumvalue,b.categoryid,b.catid,b.projectsize,b.bidtypeid,b.county
			ORDER BY b.submittaldate
		</cfquery>	
		<cfcatch type="Database">
			<CFMAIL	SUBJECT="PaintSquare BidTracker Email Problem" FROM="PaintBidtracker@paintsquare.com" to="jbirch@paintbidtracker.com,slyon@technologypub.com" type="html">
				Aborted the database query for Line 334 on new_email.cfm. userid = #userid#
		<cfdump var="#cfcatch#" />
			</cfmail>
			<cfset good = 1>
		</cfcatch>
	</cftry>
</cfif> 

<!-- 
**********************
package id 1 
**********************
-->
<cfif listcontains(valuelist(getpackages.packageid),1) >
<cfif isdefined("categories1") and subcategories is not "" and scopes is not "">
<cftry>
<cfquery name="Updates_ind" datasource="paintsquare_master"  result="r6">
SELECT  distinct b.bidid,b.owner,b.projectname,b.bid,b.scopeofwork,b.submittaldate,b.psshow,b.valuetypeid,b.state,b.city,b.minimumvalue,b.maximumvalue,b.categoryid,b.catid,b.projectsize,b.county
FROM    bid_temp_v4 b
	INNER JOIN pbt_project_master_cats a ON b.bidid = a.bidid
	--INNER JOIN pbt_project_master_cats b ON b.bidid = a.bidid
	INNER JOIN pbt_project_master_gateway m on m.bidid = b.bidid
WHERE   b.stateid in (#states_1#) and b.catid = 5 

		<cfif getcustomerscope.recordcount>
			AND (a.tagid IN (#scopes#))
      	 </cfif>   
		and (1<>1
				<cfif listlen(getEmailPrefs.budget) GT 1>
					<cfif listcontains(getEmailPrefs.budget,2)>
						or (b.minimumvalue < '100000' or b.maximumvalue < '100000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,3)>
						or (b.minimumvalue >= '100000' and b.minimumvalue <= '500000' and b.maximumvalue <= '500000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,4)>
						or (b.minimumvalue >= '500000' and b.minimumvalue <= '1000000' and b.maximumvalue <= '1000000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,5)>
						or (b.minimumvalue >= '1000000' or b.maximumvalue >= '1000000')
					</cfif>
				
				<cfelse>
					<cfswitch expression="#getEmailPrefs.budget#">
					<cfcase value="2">
						or (b.minimumvalue < '100000' or b.maximumvalue < '100000')
					</cfcase>
					<cfcase value="3">
						or (b.minimumvalue >= '100000' and b.minimumvalue <= '500000' and b.maximumvalue <= '500000')
					</cfcase>
					<cfcase value="4">
						or (b.minimumvalue >= '500000' and b.minimumvalue <= '1000000' and b.maximumvalue <= '1000000')
					</cfcase>
					<cfcase value="5">
						or (b.minimumvalue >= '1000000' or b.maximumvalue >= '1000000')
					</cfcase>
					<cfdefaultcase>
						
					</cfdefaultcase>
				</cfswitch>
				</cfif>
				)
group by  b.bidid,b.owner,b.projectname,b.bid,b.scopeofwork,b.submittaldate,b.psshow,b.valuetypeid,b.state,b.city,b.minimumvalue,b.maximumvalue,b.categoryid,b.catid,b.projectsize,b.county
order by b.submittaldate   
</cfquery>	
<cfcatch type="Database">
<CFMAIL
     
			SUBJECT="PaintSquare BidTracker Email State Insert Problem"
			FROM="PaintBidtracker@paintsquare.com"
			to="jbirch@paintbidtracker.com,slyon@technologypub.com"
			
			type="html">
			Aborted the database query for Line 362 on new_email.cfm.userid = #userid#
		<cfdump var="#cfcatch#" />
			</cfmail>
<cfset good = 1>
</cfcatch>
</cftry>
</cfif>
</cfif>



<cfif listcontains(valuelist(getpackages.packageid),2) >
<cfif isdefined("categories2") and commsubcategories is not "" and scopes is not "">
<cftry>
<cfquery name="Updates_comm" datasource="paintsquare_master"  result="r7">
SELECT  distinct b.bidid,b.owner,b.projectname,b.bid,b.scopeofwork,b.submittaldate,b.psshow,b.valuetypeid,b.state,b.city,b.minimumvalue,b.maximumvalue,b.categoryid,b.catid,b.projectsize,b.county
FROM    bid_temp_v4 b
	INNER JOIN pbt_project_master_cats a ON b.bidid = a.bidid
	--INNER JOIN pbt_project_master_cats b ON b.bidid = a.bidid
	INNER JOIN pbt_project_master_gateway m on m.bidid = b.bidid
WHERE   b.stateid in (#states_2#) and b.catid = 8 
		<cfif getcustomerscope.recordcount>
			AND (a.tagid IN (#scopes#))
      	 </cfif>   
		and (1<>1
				<cfif listlen(getEmailPrefs.budget) GT 1>
					<cfif listcontains(getEmailPrefs.budget,2)>
						or (b.minimumvalue < '100000' or b.maximumvalue < '100000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,3)>
						or (b.minimumvalue >= '100000' and b.minimumvalue <= '500000' and b.maximumvalue <= '500000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,4)>
						or (b.minimumvalue >= '500000' and b.minimumvalue <= '1000000' and b.maximumvalue <= '1000000')
					</cfif>
					<cfif listcontains(getEmailPrefs.budget,5)>
						or (b.minimumvalue >= '1000000' or b.maximumvalue >= '1000000')
					</cfif>
				
				<cfelse>
					<cfswitch expression="#getEmailPrefs.budget#">
					<cfcase value="2">
						or (b.minimumvalue < '100000' or b.maximumvalue < '100000')
					</cfcase>
					<cfcase value="3">
						or (b.minimumvalue >= '100000' and b.minimumvalue <= '500000' and b.maximumvalue <= '500000')
					</cfcase>
					<cfcase value="4">
						or (b.minimumvalue >= '500000' and b.minimumvalue <= '1000000' and b.maximumvalue <= '1000000')
					</cfcase>
					<cfcase value="5">
						or (b.minimumvalue >= '1000000' or b.maximumvalue >= '1000000')
					</cfcase>
					<cfdefaultcase>
						
					</cfdefaultcase>
				</cfswitch>
				</cfif>
				)
group by b.bidid,b.owner,b.projectname,b.bid,b.scopeofwork,b.submittaldate,b.psshow,b.valuetypeid,b.state,b.city,b.minimumvalue,b.maximumvalue,b.categoryid,b.catid,b.projectsize,b.county
order by b.submittaldate   
</cfquery>	
<cfcatch type="Database">
<CFMAIL
     
			SUBJECT="PaintSquare BidTracker Email State Insert Problem"
			FROM="PaintBidtracker@paintsquare.com"
			to="jbirch@paintbidtracker.com,slyon@technologypub.com"
			
			type="html">
			Aborted the database query for Line 388 on new_email.cfm.userid = #userid#
		<cfdump var="#cfcatch#" />
			</cfmail>
<cfset good = 1>

</cfcatch>

</cftry>
</cfif>
</cfif>


<CFMAIL SUBJECT="email pref email send" FROM="PaintBidtracker@paintsquare.com" to="slyon@technologypub.com" type="html">
	<cfif isdefined('r1')><cfdump var="#r1#" /></cfif>
	<cfif isdefined('r2')><cfdump var="#r2#" /></cfif>
	<cfif isdefined('r3')><cfdump var="#r3#" /></cfif>
	<cfif isdefined('r4')><cfdump var="#r4#" /></cfif>
	<cfif isdefined('r5')><cfdump var="#r5#" /></cfif>
	<cfif isdefined('r6')><cfdump var="#r6#" /></cfif>
	<cfif isdefined('r7')><cfdump var="#r7#" /></cfif>
</cfmail>

