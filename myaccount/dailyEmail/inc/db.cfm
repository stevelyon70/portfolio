<cfsetting enablecfoutputonly="true" requesttimeout="3600"/> 
<cfset err1 = '' />
<cfset err2 = '' />
<cfset err3 = '' />
<cfset err4 = '' />
<cfset err5 = '' />
<cfset err6 = '' />

<cfif listfind(scopes, 10000)><!---All Structures--->
    <cfset scopes = listappend(scopes,"8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,31,68,69,70,71,72,73,74,79,92,652")>
</cfif>                                    
<cfif listfind(scopes, 10001)><!---All Industrial Structures--->
    <cfset scopes = listappend(scopes,"8,9,10,11,12,13,14,16,17,18,19,20,21,23,24,70,73,74,79,652")>
</cfif>                                    
<cfif listfind(scopes, 10002)><!---All Commercial Structures--->
    <cfset scopes = listappend(scopes,"14,15,18,21,22,25,26,31,68,69,70,71,72,92")>
</cfif>                                    
<cfif listfind(scopes, 10003)><!---All Scopes--->
    <cfset scopes = listappend(scopes,"34,35,37,39,40,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,82,83,85,89,90,92,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,146,147,148,149,150,151,651")>
</cfif>                                
<cfif listfind(scopes, 10004)><!---All Constuction Scopes--->
    <cfset scopes = listappend(scopes,"27,29,30,31,33,34,35,37,39,40,43,44,45,46,47,48,49,50,51,52,82,83,85,89,90,92,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,146,147,148,149,150,151,651")>
</cfif>
<cfif listfind(scopes, 10005)><!---All Professional Services--->
    <cfset scopes = listappend(scopes,"53,54,55,56,57,58,59,60,61,62,63,64")>
</cfif>
<cfif listfind(scopes, 10006)><!---All Coating Types--->
    <cfset scopes = listappend(scopes,"118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,592,653,655,656,657,660")>
</cfif>
<cfquery name="qTagsDefaultList" datasource="paintsquare_master">	
select pbt_tags.tag,pbt_tags.tagID
    from pbt_tags
		inner join site_tag_xref x on pbt_tags.tagID = x.tagID 
        inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
    where pt.packageID = 5 and pbt_tags.tag_typeID = 2
        and tag_parentID <> 0
		and siteID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.siteID#" />
UNION ALL
    select pbt_tags.tag,pbt_tags.tagID
    from pbt_tags
		inner join site_tag_xref x on pbt_tags.tagID = x.tagID 
        inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
    where pt.packageID = 6 and pbt_tags.tag_typeID = 4
        and tag_parentID <> 0 
		and siteID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.siteID#" />
UNION ALL
    SELECT pbt_tags.tag, pbt_tags.tagID
    FROM [paintsquare].[dbo].[pbt_tags]
		inner join site_tag_xref x on pbt_tags.tagID = x.tagID 
    where tag_parentID <> 0 and tag_typeID =3 and pbt_tags.active = 1 
		and siteID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.siteID#" />
UNION ALL
    SELECT pbt_tags.[tag],pbt_tags.tagID
    FROM [paintsquare].[dbo].[pbt_tags]
		inner join site_tag_xref x on pbt_tags.tagID = x.tagID 
    where tag_parentID <> 0 and tag_typeID =9 and pbt_tags.active = 1	
		and siteID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.siteID#" />
</cfquery>
<cfset dupList = ''/>




<cfif request.emailType is 'bids'> 
      
<cftry>   
	<cfquery name="curBidsUpd" datasource="paintsquare_master"  result="r7" timeout="1800">
	-------
	--  Updated Current Bids (former: Industrial Information Updates)
	-------
	SELECT distinct a.bidID, a.owner, a.projectname, a.stage as bid, a.submittaldate, a.minimum_value as minimumvalue, a.maximum_value as maximumvalue, a.city, a.state,a.county, a.tags as scopeofwork, a.valuetypeid, a.projectsize 
	FROM pbt_project_master_gateway a 
		inner join pbt_project_master_cats b on a.bidid = b.bidid 
		inner join pbt_project_master_cats e on a.bidid = e.bidid 
		inner join pbt_project_master_cats ppmc3 on ppmc3.bidID = a.bidID
		inner join pbt_project_updates ppu on ppu.bidid = a.bidid
		and ppu.pupdateID = (select max(pupdateID) from pbt_project_updates where bidID = a.bidid and updateID in (1,2,3,10)) -- (,5,6,7,8,9)
		inner join pbt_project_stage f on f.bidID = a.bidID and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
		left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1 
		left outer join state_master on c.stateid = state_master.stateid 
		left outer join pbt_tags on pbt_tags.tagID = e.tagID and pbt_tags.tag_typeID in (1,2,3,4,5,9,16)
		left outer join pbt_stage_definer t on t.bidtypeID = f.bidtypeID 
		left outer join pbt_project_updates pu on pu.bidID = a.bidID and pu.updateID = (select max(updateID) from pbt_project_updates where bidID = a.bidid )
	WHERE 1=1 
	--stage
		and f.bidtypeID in (1,4,9,21)--(20,24) 
		and f.bidtypeID in (#user_stage#)
		and f.bidtypeID in (#auth_stage#) 
		--states
		and (1 <> 1 or (c.stateID in (#states#)) ) 

	<!---post date--->   	
			and (convert(varchar(10),ppu.date_entered, 120) >= '#dateformat(cdate, 'yyy-mm-dd')#' 
			and convert(varchar(10),ppu.date_entered, 120) < '#dateformat(dateadd("d",1,cdate), 'yyy-mm-dd')#') 
			and datepart(dd,a.paintpublishdate) <> datepart(dd,ppu.date_entered)
			and pu.updateID <> 4		
	--min/max value
	<cfswitch expression="#getEmailPrefs.budget#">
		<cfcase value="2">
			and (a.minimum_value < '100000' or a.maximum_value < '100000')
		</cfcase>
		<cfcase value="3">
			and (a.minimum_value >= '100000' and a.minimum_value <= '500000' and a.maximum_value <= '500000')
		</cfcase>
		<cfcase value="4">
			and (a.minimum_value >= '500000' and a.minimum_value <= '1000000' and a.maximum_value <= '1000000')
		</cfcase>
		<cfcase value="5">
			and (a.minimum_value >= '1000000' or a.maximum_value >= '1000000')
		</cfcase>
		<cfdefaultcase>

		</cfdefaultcase>
	</cfswitch>				
	<!---project types--->
		and a.valuetypeID in (1,2) and (a.verifiedpaint = 1 or a.verifiedpaint is null)

	<!---TAGS filter--->
		<!--- site default---> 
		and ppmc3.tagID in (#session.default.tagId#)
		
		and pbt_tags.tagID in (#valuelist(session.model.formStructureDropOptions.tagID)#,#valuelist(qTagsDefaultList.tagID)#)
		<cfif listlen(scopes)>and pbt_tags.tagID in (#scopes#)<cfelse>and 0=1</cfif>
		<!---and a.status in (3,5)--->
		<!--- remove dupes--->
		<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
		and pbt_tags.tag is not null
	 order by a.stage, a.submittaldate
	</cfquery>
	
	<!---<cfdump var="#curBidsUpd#"><cfabort>--->
	
	<cfcatch type="Database">
		<cfset err1 = cfcatch/>
		<cfset curBidsUpd = QueryNew("bidID, owner, projectname, bid, submittaldate, minimumvalue, maximumvalue, city, state,county, scopeofwork, valuetypeid, projectsize")>
		<cfdump var="#cfcatch#" /> 
	</cfcatch>
</cftry>

<cfif curBidsUpd.recordcount><cfset dupList = listappend(duplist,valuelist(curBidsUpd.bidid))/></cfif>

<!--- ============================================================================================================ --->

<cftry>   	
	<cfquery name="newBidsNotices" datasource="paintsquare_master"  result="r11" timeout="1800">	
	-------
	--  New Bids Notices (former: General Construction Maintenance Project Bids)
	-------
	SELECT distinct  a.tags, a.bidID, a.owner, a.projectname, a.stage as bid, a.submittaldate, a.minimum_value as minimumvalue, a.maximum_value as maximumvalue, a.city, a.state,a.county, a.tags as scopeofwork, a.valuetypeid, a.projectsize
	FROM pbt_project_master_gateway a
		inner join pbt_project_master_cats b on a.bidid = b.bidid 
		inner join pbt_project_master_cats ppmc3 on ppmc3.bidID = a.bidID
		inner join pbt_project_stage f on f.bidID = a.bidID and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
		left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1 
		left outer join state_master on c.stateid = state_master.stateid 
		left outer join pbt_tags on pbt_tags.tagID = b.tagID
		left outer join pbt_stage_definer t on t.bidtypeID = f.bidtypeID 
		left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
		and ppc.bidlogID = (select max(bidlogID) from pbt_project_master_cats where bidID = a.bidid and tagID in (select tagID from pbt_tags where tag_typeID = 2) )
	WHERE 1=1 
	--stage
		and f.bidtypeID in (1,4,9,21) 
		and f.bidtypeID in (#user_stage#)
		and f.bidtypeID in (#auth_stage#)
	--states
		and (1 <> 1 or (c.stateID in (#states#)) ) 
	<!---post date--->   	
			and (convert(varchar(10),a.paintpublishdate, 120) >= '#dateformat(cdate, 'yyy-mm-dd')#' and convert(varchar(10),a.paintpublishdate, 120) < '#dateformat(dateadd("d",1,cdate), 'yyy-mm-dd')#')
			and (convert(varchar(10),a.submittaldate, 120) >= '#dateformat(cdate, 'yyy-mm-dd')#' or a.submittaldate is null)
	--min/max value
		<cfswitch expression="#getEmailPrefs.budget#">
			<cfcase value="2">
				and (a.minimum_value < '100000' or a.maximum_value < '100000')
			</cfcase>
			<cfcase value="3">
				and (a.minimum_value >= '100000' and a.minimum_value <= '500000' and a.maximum_value <= '500000')
			</cfcase>
			<cfcase value="4">
				and (a.minimum_value >= '500000' and a.minimum_value <= '1000000' and a.maximum_value <= '1000000')
			</cfcase>
			<cfcase value="5">
				and (a.minimum_value >= '1000000' or a.maximum_value >= '1000000')
			</cfcase>
			<cfdefaultcase>

			</cfdefaultcase>
		</cfswitch>		
	<!---project types--->
		and a.valuetypeID in (1,2) and (a.verifiedpaint = 1 or a.verifiedpaint is null)
	
	<!---TAGS filter--->
		<!--- site default---> 
		and ppmc3.tagID in (#session.default.tagId#)
		and b.tagID in (#valuelist(session.model.formStructureDropOptions.tagID)#,#valuelist(qTagsDefaultList.tagID)#)
		
		<cfif listlen(scopes)>and b.tagID in (#scopes#)<cfelse>and 0=1</cfif>
		<!---and a.status in (3,5)	--->
	<!--- remove dupes--->
		<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
		--and ppc.tagID is null
		and a.tags is not null
	 order by a.stage, a.submittaldate
	</cfquery>
	
	<!---<cfdump var="#newBidsNotices#"><cfabort>--->
	
	<cfcatch type="Database">
		<cfset err2 = cfcatch/>
		<cfset newBidsNotices = QueryNew("bidID, owner, projectname, bid, submittaldate, minimumvalue, maximumvalue, city, state,county, scopeofwork, valuetypeid, projectsize")> 
	</cfcatch>
</cftry>

<cfif newBidsNotices.recordcount><cfset dupList = listappend(duplist,valuelist(newBidsNotices.bidid))/></cfif>	

<!--- ============================================================================================================ --->

<cftry>   			
	<cfquery name="engDsgnBids" datasource="paintsquare_master"  result="r12" timeout="1800">
	-------
	--  Engineering & Design Bids	
	-------
	SELECT distinct top 100 a.bidID, a.owner, a.projectname, a.stage as bid, a.submittaldate, a.minimum_value as minimumvalue, a.maximum_value as maximumvalue, a.city, a.state,a.county, a.tags as scopeofwork, a.valuetypeid, a.projectsize,bid_planholders.bidid as planholders
	FROM pbt_project_master_gateway a 
	  left outer join pbt_project_contacts g on g.bidID = a.bidID and g.contact_typeID = 1
	  LEFT OUTER JOIN supplier_master sm on sm.supplierID = a.ownerID
	  LEFT OUTER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
	  left outer join pbt_project_master_cats ppmc3 on ppmc3.bidID = a.bidID
	  left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1
	  left outer join state_master stm on c.stateid = stm.stateid
	  inner join pbt_project_stage f on f.bidID = a.bidID    and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
	  LEFT OUTER JOIN bid_planholders on bid_planholders.bidid = a.bidID and (bid_planholders.companyname is not null or bid_planholders.firstname is not null or bid_planholders.lastname is not null)
	WHERE 1=1 
	--stage
		and f.bidtypeID in (24)
		and f.bidtypeID in (#user_stage#)
		and f.bidtypeID in (#auth_stage#)
	--states
		and (1 <> 1 or (c.stateID in (#states#)) ) 
	<!---post date--->   	
		and (convert(varchar(10),a.paintpublishdate, 120) >= '#dateformat(cdate, 'yyy-mm-dd')#'	and convert(varchar(10),a.paintpublishdate, 120) < '#dateformat(dateadd("d",1,cdate), 'yyy-mm-dd')#')
		and (convert(varchar(10),a.submittaldate, 120) >= '#dateformat(cdate, 'yyy-mm-dd')#' or a.submittaldate is null)
	--min/max value
		<cfswitch expression="#getEmailPrefs.budget#">
			<cfcase value="2">
				and (a.minimum_value < '100000' or a.maximum_value < '100000')
			</cfcase>	
			<cfcase value="3">
				and (a.minimum_value >= '100000' and a.minimum_value <= '500000' and a.maximum_value <= '500000')
			</cfcase>
			<cfcase value="4">
				and (a.minimum_value >= '500000' and a.minimum_value <= '1000000' and a.maximum_value <= '1000000')
			</cfcase>
			<cfcase value="5">
				and (a.minimum_value >= '1000000' or a.maximum_value >= '1000000')
			</cfcase>
			<cfdefaultcase>

			</cfdefaultcase>
		</cfswitch>
		
<!---project types--->
		and a.valuetypeID in (1,2) and (a.verifiedpaint = 1 or a.verifiedpaint is null)
	<!---TAGS filter--->
		<!--- site default---> 
		and ppmc3.tagID in (#session.default.tagId#)
		
		<cfif listlen(scopes)>and ppmc.tagID in (#scopes#)<cfelse>and 0=1</cfif>
		<!---and a.status in (3,5)--->
	<!--- remove dupes--->
		<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
		and a.tags is not null
	 order by a.stage, a.submittaldate
	</cfquery>

	<!---<cfdump var="#engDsgnBids#">--->

	<cfcatch type="Database">
		<cfset err3 = cfcatch/>
		<cfset engDsgnBids = QueryNew("bidID, owner, projectname, bid, submittaldate, minimumvalue, maximumvalue, city, state,county, scopeofwork, valuetypeid, projectsize")> 
	</cfcatch>
</cftry>

<cfif engDsgnBids.recordcount><cfset dupList = listappend(duplist,valuelist(engDsgnBids.bidid))/></cfif>	

<!--- ============================================================================================================ --->

<cftry>   
	<cfquery name="subContrOpp" datasource="paintsquare_master"  result="r13" timeout="1800">
	-------
	--  Subcontracting Opportunities	
	-------
	SELECT distinct top 100 a.bidID, a.owner, a.projectname, a.stage as bid, a.submittaldate, a.minimum_value as minimumvalue, a.maximum_value as maximumvalue, a.city, a.state,a.county, a.tags as scopeofwork, a.valuetypeid, a.projectsize,bid_planholders.bidid as planholders
	FROM pbt_project_master_gateway a 
	  left outer join pbt_project_contacts g on g.bidID = a.bidID and g.contact_typeID = 1
	  LEFT OUTER JOIN supplier_master sm on sm.supplierID = a.ownerID
	  LEFT OUTER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
	  inner join pbt_project_master_cats e on a.bidid = e.bidid 
	  left outer join pbt_project_master_cats ppmc3 on ppmc3.bidID = a.bidID
	  left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1
	  left outer join state_master stm on c.stateid = stm.stateid
		left outer join pbt_tags on pbt_tags.tagID = e.tagID and pbt_tags.tag_typeID in (1,2,3,4,5,9,16)
	  inner join pbt_project_stage f on f.bidID = a.bidID    and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
	  LEFT OUTER JOIN bid_planholders on bid_planholders.bidid = a.bidID and (bid_planholders.companyname is not null or bid_planholders.firstname is not null or bid_planholders.lastname is not null) 
	WHERE 1=1 
	--stage
		and f.bidtypeID in (20)
		and f.bidtypeID in (#user_stage#)
		and f.bidtypeID in (#auth_stage#)
	--states
		and (1 <> 1 or (c.stateID in (#states#)) ) 
	<!---post date--->   	
			and (convert(varchar(10),a.paintpublishdate, 120) >= '#dateformat(cdate, 'yyy-mm-dd')#' and convert(varchar(10),a.paintpublishdate, 120) < '#dateformat(dateadd("d",1,cdate), 'yyy-mm-dd')#')
			and (convert(varchar(10),a.submittaldate, 120) >= '#dateformat(cdate, 'yyy-mm-dd')#' or a.submittaldate is null)
	--min/max value
		<cfswitch expression="#getEmailPrefs.budget#">
			<cfcase value="2">
				and (a.minimum_value < '100000' or a.maximum_value < '100000')
			</cfcase>
			<cfcase value="3">
				and (a.minimum_value >= '100000' and a.minimum_value <= '500000' and a.maximum_value <= '500000')
			</cfcase>
			<cfcase value="4">
				and (a.minimum_value >= '500000' and a.minimum_value <= '1000000' and a.maximum_value <= '1000000')
			</cfcase>
			<cfcase value="5">
				and (a.minimum_value >= '1000000' or a.maximum_value >= '1000000')
			</cfcase>
			<cfdefaultcase>

			</cfdefaultcase>
		</cfswitch>		
		
		<!---project types--->
		and a.valuetypeID in (1,2) and (a.verifiedpaint = 1 or a.verifiedpaint is null)
		
		
		<!---TAGS filter--->
		<!--- site default---> 
		and ppmc3.tagID in (#session.default.tagId#)
		
		and pbt_tags.tagID in (#valuelist(session.model.formStructureDropOptions.tagID)#,#valuelist(qTagsDefaultList.tagID)#)
		<cfif listlen(scopes)>and pbt_tags.tagID in (#scopes#)<cfelse>and 0=1</cfif>		
		
		<!---and a.status in (3,5)--->
	<!--- remove dupes--->
		<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
		and a.tags is not null
	 order by a.stage, a.submittaldate
	</cfquery>

	<!---<cfdump var="#subContrOpp#">--->

	<cfcatch type="Database">
		<cfset err4 = cfcatch/>
		<cfset subContrOpp = QueryNew("bidID, owner, projectname, bid, submittaldate, minimumvalue, maximumvalue, city, state,county, scopeofwork, valuetypeid, projectsize")>
	</cfcatch>
</cftry>
		
		
<!--- ============================================================================================================ --->

<cftry>   
	<cfquery name="awardResultsUpd" datasource="paintsquare_master"  result="r1" timeout="1800">
-------
--  Industrial Painting Awards & Results Project Updates	
-------
SELECT distinct a.bidID, a.owner, a.projectname, a.stage as bid, a.submittaldate, a.minimum_value as minimumvalue, a.maximum_value as maximumvalue, a.city, a.state,a.county, a.tags as scopeofwork, a.valuetypeid, a.projectsize 
FROM pbt_project_master_gateway a 
inner join pbt_project_master_cats b on a.bidid = b.bidid 
inner join pbt_project_stage f on f.bidID = a.bidID and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1 
left outer join state_master on c.stateid = state_master.stateid 
left outer join pbt_tags on pbt_tags.tagID = b.tagID
left outer join pbt_stage_definer t on t.bidtypeID = f.bidtypeID 
left outer join pbt_project_award_stage_detail ppa on ppa.bidID = a.bidID
left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID and ppc.bidlogID = (select max(bidlogID) from pbt_project_master_cats where bidID = a.bidid and tagID in (select tagID from pbt_tags where tag_typeID = 2) )
inner join pbt_project_updates ppu on ppu.bidid = a.bidid and ppu.pupdateID = (select max(pupdateID) from pbt_project_updates where bidID = a.bidid and updateID in (3,6,8,9,10))
left outer join pbt_project_updates pu on pu.bidID = a.bidID and pu.updateID = (select max(updateID) from pbt_project_updates where bidID = a.bidid )
	
WHERE 1=1 and ppc.tagID is not null 
--stage
    and f.bidtypeID in (6,5)--(7,8) 
	and f.bidtypeID in (#user_stage#)
	and f.bidtypeID in (#auth_stage#)
--states
    and (1 <> 1 or (c.stateID in (#states#)) ) 
<!---post date--->   	   	
	 and (convert(varchar(10),ppu.date_entered, 120) >= '#dateformat(cdate, 'yyy-mm-dd')#' and convert(varchar(10),ppu.date_entered, 120) < '#dateformat(dateadd("d",1,cdate), 'yyy-mm-dd')#')
--min/max value
<cfswitch expression="#getEmailPrefs.budget#">
	<cfcase value="2">
		and (a.minimum_value < '100000' or a.maximum_value < '100000')
	</cfcase>
	<cfcase value="3">
		and (a.minimum_value >= '100000' and a.minimum_value <= '500000' and a.maximum_value <= '500000')
	</cfcase>
	<cfcase value="4">
		and (a.minimum_value >= '500000' and a.minimum_value <= '1000000' and a.maximum_value <= '1000000')
	</cfcase>
	<cfcase value="5">
		and (a.minimum_value >= '1000000' or a.maximum_value >= '1000000')
	</cfcase>
	<cfdefaultcase>

	</cfdefaultcase>
</cfswitch>		
<!---project types--->
		
	and a.valuetypeID in (1,2) and a.verifiedpaint = 1

--tags
    and b.tagID in (8,9,10,11,12,13,14,16,17,18,20,21,23,24,70,73,74,75,76,77,78,79,652,22,72,15,68,25,26,69,71,#valuelist(qTagsDefaultList.tagID)#)
	and b.tagID in (#scopes#)
	<!---and a.status in (3,5)--->
<!--- remove dupes--->
<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
 order by a.stage, a.submittaldate
</cfquery>	

	<!---<cfdump var="#subContrOpp#">--->

	<cfcatch type="Database">
		<cfset err5 = cfcatch/>
		<cfset awardResultsUpd = QueryNew("bidID, owner, projectname, bid, submittaldate, minimumvalue, maximumvalue, city, state,county, scopeofwork, valuetypeid, projectsize")>
	</cfcatch>
</cftry>		
		
		
	
</cfif>	




<!---
	project type :<cfif user_projecttypes is not 4>and a.valuetypeID in (#user_projecttypes#)</cfif>		
	stage: and f.bidtypeID in (#user_stage#)
	tags:  and ppmc.tagID in (#scopes#)
	update type:

	--->
		<CFMAIL SUBJECT="email pref email send [#request.emailType#]" FROM="PaintBidtracker@paintsquare.com" to="slyon@technologypub.com,rmahathey@technologypub.com" type="html">
			
			<cfif request.emailType is 'bids'>
			<cfif isdefined('r7')><cfdump var="#r7#" /></cfif>
			<cfif isdefined('r8')><cfdump var="#r8#" /></cfif>
			<cfif isdefined('r9')><cfdump var="#r9#" /></cfif>
			<cfif isdefined('r10')><cfdump var="#r10#" /></cfif>
			<cfif isdefined('r11')><cfdump var="#r11#" /></cfif>
			<cfif isdefined('r12')><cfdump var="#r12#" /></cfif>
			<cfif isdefined('r13')><cfdump var="#r13#" /></cfif>
			<cfif isdefined('err1')><cfdump var="#err1#" /></cfif>
			<cfif isdefined('err2')><cfdump var="#err2#" /></cfif>
			<cfif isdefined('err3')><cfdump var="#err3#" /></cfif>
			<cfif isdefined('err4')><cfdump var="#err4#" /></cfif>
			<cfif isdefined('err5')><cfdump var="#err5#" /></cfif>
			</cfif>
		</cfmail>
		
		