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
	
<cfset tmpScopes = scopes />
<!--- clean scopes of defaults --->
	
<cfset dupList = ''/>
<cfif request.emailType is 'awards'>
<cfquery name="indPaintAwdResProjUpds" datasource="paintsquare_master"  result="r1">
-------
--  Industrial Painting Awards & Results Project Updates	
-------
SELECT distinct a.bidID, a.owner, a.projectname, promas.stage as bid, a.submittaldate, promas.minimum_value as minimumvalue, promas.maximum_value as maximumvalue, promas.city, promas.state,promas.county, promas.tags as scopeofwork, a.valuetypeid, a.projectsize 
FROM pbt_project_master a
  LEFT OUTER JOIN pbt_project_master_gateway promas on promas.bidid = a.bidid
inner join pbt_project_master_cats b on a.bidid = b.bidid 
inner join pbt_project_stage f on f.bidID = a.bidID and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1 
left outer join state_master on c.stateid = state_master.stateid 
left outer join pbt_tags on pbt_tags.tagID = b.tagID
left outer join pbt_stage_definer t on t.bidtypeID = f.bidtypeID 
left outer join pbt_project_award_stage_detail ppa on ppa.bidID = a.bidID
left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID and ppc.bidlogID = (select max(bidlogID) from pbt_project_master_cats where bidID = a.bidid and tagID in (select tagID from pbt_tags where tag_typeID = 2) )

    inner join pbt_project_updates ppu on ppu.bidid = a.bidid and ppu.pupdateID = (select max(pupdateID) from pbt_project_updates where bidID = a.bidid and updateID in (1,2,3,5,6,7,8,9,10))
    left outer join pbt_project_updates pu on pu.bidID = a.bidID and pu.updateID = (select max(updateID) from pbt_project_updates where bidID = a.bidid )
	
WHERE 1=1 and ppc.tagID is not null 
--stage
    and f.bidtypeID in (6,5)--(7,8) 
	and f.bidtypeID in (#user_stage#)
	and f.bidtypeID in (#auth_stage#)
--states
    and (1 <> 1 or (c.stateID in (#states#)) ) 
<!---post date--->   	   	
	 and (convert(varchar(10),ppu.date_entered, 120) >= '2018-04-13' and convert(varchar(10),ppu.date_entered, 120) < '2018-04-14')
--min/max value
   					<cfswitch expression="#getEmailPrefs.budget#">
						<cfcase value="2">
							and (promas.minimum_value < '100000' or promas.maximum_value < '100000')
						</cfcase>
						<cfcase value="3">
							and (promas.minimum_value >= '100000' and promas.minimum_value <= '500000' and promas.maximum_value <= '500000')
						</cfcase>
						<cfcase value="4">
							and (promas.minimum_value >= '500000' and promas.minimum_value <= '1000000' and promas.maximum_value <= '1000000')
						</cfcase>
						<cfcase value="5">
							and (promas.minimum_value >= '1000000' or promas.maximum_value >= '1000000')
						</cfcase>
						<cfdefaultcase>
							
						</cfdefaultcase>
					</cfswitch>		
<!---project types--->
		
	and a.valuetypeID in (1,2) and a.verifiedpaint = 1
	<!--- 4 equals all contracts excluding paint--->
--tags
    and b.tagID in (8,9,10,11,12,13,14,16,17,18,20,21,23,24,70,73,74,75,76,77,78,79,652)
	and b.tagID in (#scopes#)
	and a.status in (3,5)
<!--- remove dupes--->
	<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
 order by promas.stage, a.submittaldate
</cfquery>	
<cfif indPaintAwdResProjUpds.recordcount>
	<cfset dupList = listappend(duplist,valuelist(indPaintAwdResProjUpds.bidid))/>	
</cfif>
<cfquery name="comPaintAwdsRsltUpds" datasource="paintsquare_master"  result="r2">
-------
--  Commercial Painting Awards & Results Updates	
-------
SELECT distinct a.bidID, a.owner, a.projectname, promas.stage as bid, a.submittaldate, promas.minimum_value as minimumvalue, promas.maximum_value as maximumvalue, promas.city, promas.state,promas.county, promas.tags as scopeofwork, a.valuetypeid, a.projectsize
FROM pbt_project_master a
   LEFT OUTER JOIN pbt_project_master_gateway promas on promas.bidid = a.bidid
inner join pbt_project_master_cats b on a.bidid = b.bidid 
inner join pbt_project_stage f on f.bidID = a.bidID and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1 
left outer join state_master on c.stateid = state_master.stateid 
left outer join pbt_tags on pbt_tags.tagID = b.tagID
left outer join pbt_stage_definer t on t.bidtypeID = f.bidtypeID 
left outer join pbt_project_award_stage_detail ppa on ppa.bidID = a.bidID
left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID and ppc.bidlogID = (select max(bidlogID) from pbt_project_master_cats where bidID = a.bidid and tagID in (select tagID from pbt_tags where tag_typeID = 2) )

inner join pbt_project_updates ppu on ppu.bidid = a.bidid and ppu.pupdateID = (select max(pupdateID) from pbt_project_updates where bidID = a.bidid and updateID in (1,2,3,5,6,7,8,9,10))
   left outer join pbt_project_updates pu on pu.bidID = a.bidID and pu.updateID = (select max(updateID) from pbt_project_updates where bidID = a.bidid )
WHERE 1=1 
--stage
    and f.bidtypeID in (6,5) --(7,8)
	and f.bidtypeID in (#user_stage#)
	and f.bidtypeID in (#auth_stage#)
	--states
    and (1 <> 1 or (c.stateID in (#states#)) ) 
<!---post date--->   	
   		and (convert(varchar(10),ppu.date_entered, 120) >= '#dateformat(cdate, 'yyy-mm-dd')#' and convert(varchar(10),ppu.date_entered, 120) < '#dateformat(dateadd("d",1,cdate), 'yyy-mm-dd')#') 	
--min/max value
   					<cfswitch expression="#getEmailPrefs.budget#">
						<cfcase value="2">
							and (promas.minimum_value < '100000' or promas.maximum_value < '100000')
						</cfcase>
						<cfcase value="3">
							and (promas.minimum_value >= '100000' and promas.minimum_value <= '500000' and promas.maximum_value <= '500000')
						</cfcase>
						<cfcase value="4">
							and (promas.minimum_value >= '500000' and promas.minimum_value <= '1000000' and promas.maximum_value <= '1000000')
						</cfcase>
						<cfcase value="5">
							and (promas.minimum_value >= '1000000' or promas.maximum_value >= '1000000')
						</cfcase>
						<cfdefaultcase>
							
						</cfdefaultcase>
					</cfswitch>		
<!---project types--->
	
	and a.valuetypeID in (1,2) and a.verifiedpaint = 1	
	<!--- 4 equals all contracts excluding paint--->
--tags
    and b.tagID in (21,22,72,70,15,68,25,18,26,69,71)
	and b.tagID in (#scopes#)
	and a.status in (3,5)
	and promas.tags is not null
<!--- remove dupes--->
	<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
 order by promas.stage, a.submittaldate
</cfquery>	
<cfif  comPaintAwdsRsltUpds.recordcount>
	<cfset dupList = listappend(duplist,valuelist(comPaintAwdsRsltUpds.bidid))/>	
</cfif>
	
<cfquery name="indPaintAwdsRslt" datasource="paintsquare_master"  result="r3">
-------
--  Industrial Painting Awards & Results	
-------
SELECT distinct a.bidID, a.owner, a.projectname, promas.stage as bid, a.submittaldate, promas.minimum_value as minimumvalue, promas.maximum_value as maximumvalue, promas.city, promas.state,promas.county, promas.tags as scopeofwork, a.valuetypeid, a.projectsize  
FROM pbt_project_master a 
LEFT OUTER JOIN pbt_project_master_gateway promas on promas.bidid = a.bidid
inner join pbt_project_master_cats b on a.bidid = b.bidid 
inner join pbt_project_stage f on f.bidID = a.bidID and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1 
left outer join state_master on c.stateid = state_master.stateid 
left outer join pbt_tags on pbt_tags.tagID = b.tagID
left outer join pbt_stage_definer t on t.bidtypeID = f.bidtypeID 
left outer join pbt_project_award_stage_detail ppa on ppa.bidID = a.bidID
WHERE 1=1 
--stage
    and f.bidtypeID in (5,6)--(7,8) 
	and f.bidtypeID in (#user_stage#)
	and f.bidtypeID in (#auth_stage#)
	--states
    and (1 <> 1 or (c.stateID in (#states#)) ) 
<!---post date--->   	
	and ppa.post_date  >=  '#dateformat(cdate, 'yyy-mm-dd')#' 
	and ppa.post_date < '#dateformat(dateadd("d",1,cdate), 'yyy-mm-dd')#'
   			
--min/max value
   <cfswitch expression="#getEmailPrefs.budget#">
						<cfcase value="2">
							and (promas.minimum_value < '100000' or promas.maximum_value < '100000')
						</cfcase>
						<cfcase value="3">
							and (promas.minimum_value >= '100000' and promas.minimum_value <= '500000' and promas.maximum_value <= '500000')
						</cfcase>
						<cfcase value="4">
							and (promas.minimum_value >= '500000' and promas.minimum_value <= '1000000' and promas.maximum_value <= '1000000')
						</cfcase>
						<cfcase value="5">
							and (promas.minimum_value >= '1000000' or promas.maximum_value >= '1000000')
						</cfcase>
						<cfdefaultcase>
							
						</cfdefaultcase>
					</cfswitch>		
<!---project types--->
	and a.valuetypeID in (1,2) and a.verifiedpaint = 1
<!--- 4 equals all contracts excluding paint--->
--tags
    and b.tagID in (8,9,17,20,79,16,11,13,70,19,24,10,23,652,9,12,74,73,14,21,18,75,76,77,78)
	and b.tagID in (#scopes#)
	and a.status in (3,5)
<!--- remove dupes--->
	<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
 order by promas.stage, a.submittaldate
</cfquery>	
<cfif indPaintAwdsRslt.recordcount><cfset dupList = listappend(duplist,valuelist(indPaintAwdsRslt.bidid))/>		
</cfif>	
	
<cfquery name="comPaintAwdsRslt" datasource="paintsquare_master"  result="r4">
-------
--  Commercial Painting Awards & Results	
-------
SELECT distinct a.bidID, a.owner, a.projectname, promas.stage as bid, a.submittaldate, promas.minimum_value as minimumvalue, promas.maximum_value as maximumvalue, promas.city, promas.state,promas.county, promas.tags as scopeofwork, a.valuetypeid, a.projectsize
FROM pbt_project_master a 
	LEFT OUTER JOIN pbt_project_master_gateway promas on promas.bidid = a.bidid
	inner join pbt_project_master_cats b on a.bidid = b.bidid 
	inner join pbt_project_stage f on f.bidID = a.bidID
	and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
	left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1 
	left outer join state_master on c.stateid = state_master.stateid 
	left outer join pbt_tags on pbt_tags.tagID = b.tagID
	left outer join pbt_stage_definer t on t.bidtypeID = f.bidtypeID 
	left outer join pbt_project_award_stage_detail ppa on ppa.bidID = a.bidID
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID and ppc.bidlogID = (select max(bidlogID) from pbt_project_master_cats where bidID = a.bidid and tagID in (select tagID from pbt_tags where tag_typeID = 2) )
	left outer join pbt_project_updates pu on pu.bidID = a.bidID and pu.updateID = (select max(updateID) from pbt_project_updates where bidID = a.bidid )
WHERE 1=1 
--stage
    and f.bidtypeID in (6,5) --(7,8)
	and f.bidtypeID in (#user_stage#)
	and f.bidtypeID in (#auth_stage#)
	--states
    and (1 <> 1 or (c.stateID in (#states#)) ) 
<!---post date--->   	
   	and ppa.post_date  >=  '#dateformat(cdate, 'mm/dd/yyyy')#'  
	and ppa.post_date < '#dateformat(dateadd("d",1,cdate), 'mm/dd/yyy')#' 	
--min/max value
   					<cfswitch expression="#getEmailPrefs.budget#">
						<cfcase value="2">
							and (promas.minimum_value < '100000' or promas.maximum_value < '100000')
						</cfcase>
						<cfcase value="3">
							and (promas.minimum_value >= '100000' and promas.minimum_value <= '500000' and promas.maximum_value <= '500000')
						</cfcase>
						<cfcase value="4">
							and (promas.minimum_value >= '500000' and promas.minimum_value <= '1000000' and promas.maximum_value <= '1000000')
						</cfcase>
						<cfcase value="5">
							and (promas.minimum_value >= '1000000' or promas.maximum_value >= '1000000')
						</cfcase>
						<cfdefaultcase>
							
						</cfdefaultcase>
					</cfswitch>		
<!---project types--->
	
	and a.valuetypeID in (1,2) and a.verifiedpaint = 1	
	<!--- 4 equals all contracts excluding paint--->
--tags
    and b.tagID in (21,22,72,70,15,68,25,18,26,69,71)
	and b.tagID in (#scopes#)
	and a.status in (3,5)
	and promas.tags is not null
<!--- remove dupes--->
	<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
 order by promas.stage, a.submittaldate
</cfquery>	
<cfif comPaintAwdsRslt.recordcount><cfset dupList = listappend(duplist,valuelist(comPaintAwdsRslt.bidid))/>		
</cfif>	
	
<cfquery name="genConsMaintAwdsRslt" datasource="paintsquare_master"  result="r5">
-------
--  General Construction Maintenance Awards & Results
-------
SELECT distinct a.bidID, a.owner, a.projectname, promas.stage as bid, a.submittaldate, promas.minimum_value as minimumvalue, promas.maximum_value as maximumvalue, promas.city, promas.state,promas.county, promas.tags as scopeofwork, a.valuetypeid, a.projectsize
FROM pbt_project_master a 
    LEFT OUTER JOIN pbt_project_master_gateway promas on promas.bidid = a.bidid
inner join pbt_project_master_cats b on a.bidid = b.bidid 
inner join pbt_project_stage f on f.bidID = a.bidID and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1 
left outer join state_master on c.stateid = state_master.stateid 
left outer join pbt_tags on pbt_tags.tagID = b.tagID
left outer join pbt_stage_definer t on t.bidtypeID = f.bidtypeID 
left outer join pbt_project_award_stage_detail ppa on ppa.bidID = a.bidID
WHERE 1=1 and b.tagID in (select distinct pbt_tags.tagID
     from pbt_tags
     inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
     where pt.packageID in (1,2) and pbt_tags.tag_typeID = 1
     and tag_parentID <> 0)
--stage
    and f.bidtypeID in (6,5)--(7,8,9) 
	and f.bidtypeID in (#user_stage#)
	and f.bidtypeID in (#auth_stage#)
	--states
    and (1 <> 1 or (c.stateID in (#states#)) ) 
<!---post date--->   	
   	and ppa.post_date  >=  '#dateformat(cdate, 'yyy-mm-dd')#'  
	and ppa.post_date < '#dateformat(dateadd("d",1,cdate), 'yyy-mm-dd')#'

	
--min/max value
    <cfswitch expression="#getEmailPrefs.budget#">
						<cfcase value="2">
							and (promas.minimum_value < '100000' or promas.maximum_value < '100000')
						</cfcase>
						<cfcase value="3">
							and (promas.minimum_value >= '100000' and promas.minimum_value <= '500000' and promas.maximum_value <= '500000')
						</cfcase>
						<cfcase value="4">
							and (promas.minimum_value >= '500000' and promas.minimum_value <= '1000000' and promas.maximum_value <= '1000000')
						</cfcase>
						<cfcase value="5">
							and (promas.minimum_value >= '1000000' or promas.maximum_value >= '1000000')
						</cfcase>
						<cfdefaultcase>
							
						</cfdefaultcase>
					</cfswitch>		
<!---project types--->
	and a.verifiedpaint is null
<cfif user_projecttypes neq 3>and 0=1</cfif>
--tags
    and b.tagID in (#scopes#)
	and a.status in (3,5)
<!--- remove dupes--->
	<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
 order by promas.stage, a.submittaldate
</cfquery>	
<cfif genConsMaintAwdsRslt.recordcount><cfset dupList = listappend(duplist,valuelist(genConsMaintAwdsRslt.bidid))/>	
</cfif>		
	
<cfquery name="engDsgnAwdRslt" datasource="paintsquare_master"  result="r6">
-------
--  Engineering & Design Awards & Results	
-------
SELECT distinct a.bidID, a.owner, a.projectname, promas.stage as bid, a.submittaldate, promas.minimum_value as minimumvalue, promas.maximum_value as maximumvalue, promas.city, promas.state,promas.county, promas.tags as scopeofwork, a.valuetypeid, a.projectsize  
FROM pbt_project_master a 
    LEFT OUTER JOIN pbt_project_master_gateway promas on promas.bidid = a.bidid
inner join pbt_project_master_cats b on a.bidid = b.bidid 
inner join pbt_project_stage f on f.bidID = a.bidID
and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1 
left outer join state_master on c.stateid = state_master.stateid 
left outer join pbt_tags on pbt_tags.tagID = b.tagID
left outer join pbt_stage_definer t on t.bidtypeID = f.bidtypeID 
left outer join pbt_project_award_stage_detail ppa on ppa.bidID = a.bidID
left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID and ppc.bidlogID = (select max(bidlogID) from pbt_project_master_cats where bidID = a.bidid and tagID in (select tagID from pbt_tags where tag_typeID = 2) )
WHERE 1=1 and ppc.tagID is null and b.tagID in (select distinct pbt_tags.tagID
     from pbt_tags
     inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
     where pbt_tags.tag_typeID = 5
     and tag_parentID <> 0)
--stage
    and f.bidtypeID in (5)
	and f.bidtypeID in (#user_stage#)
	and f.bidtypeID in (#auth_stage#)
--states
    and (1 <> 1 or (c.stateID in (#states#)) ) 
<!---post date--->   	
   	and ppa.post_date  >= '#dateformat(cdate, 'yyy-mm-dd')#'
	and ppa.post_date < '#dateformat(dateadd("d",1,cdate), 'yyy-mm-dd')#'
--min/max value
    <cfswitch expression="#getEmailPrefs.budget#">
						<cfcase value="2">
							and (promas.minimum_value < '100000' or promas.maximum_value < '100000')
						</cfcase>
						<cfcase value="3">
							and (promas.minimum_value >= '100000' and promas.minimum_value <= '500000' and promas.maximum_value <= '500000')
						</cfcase>
						<cfcase value="4">
							and (promas.minimum_value >= '500000' and promas.minimum_value <= '1000000' and promas.maximum_value <= '1000000')
						</cfcase>
						<cfcase value="5">
							and (promas.minimum_value >= '1000000' or promas.maximum_value >= '1000000')
						</cfcase>
						<cfdefaultcase>
							
						</cfdefaultcase>
					</cfswitch>		
<!---project types - all contracts no filter needed--->
	
--tags
    and b.tagID in (#scopes#)
	and a.status in (3,5)
<!--- remove dupes--->
	<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
 order by promas.stage, a.submittaldate
</cfquery>
<cfif engDsgnAwdRslt.recordcount><cfset dupList = listappend(duplist,valuelist(engDsgnAwdRslt.bidid))/>		
</cfif>
	
</cfif>	

	
	
<cfif request.emailType is 'bids'>       
	<cfset _list = queryScope(tmpScopes,'8,9,17,20,79,16,11,13,19,24,10,23,652,9,12,74,73,14,21,70,18,75,76,77,78')/>
<cfquery name="indInfUpd" datasource="paintsquare_master"  result="r7">
-------
--  Industrial Information Updates	
-------
SELECT distinct a.bidID,a.owner, a.projectname, promas.stage as bid, a.submittaldate, promas.minimum_value as minimumvalue, 		promas.maximum_value as maximumvalue, promas.city, promas.state,promas.county, promas.tags as scopeofwork, a.valuetypeid, a.projectsize 
FROM pbt_project_master a 
	LEFT OUTER JOIN pbt_project_master_gateway promas on promas.bidid = a.bidid 
	inner join pbt_project_master_cats e on a.bidid = e.bidid 
	<cfif listlen(_list)>
	<cfloop from="1" to="#listlen(_list)#" index="_c">
			inner join pbt_project_master_cats t#_c# on a.bidid = t#_c#.bidid
	</cfloop>
	</cfif>
	
	inner join pbt_project_updates ppu on ppu.bidid = a.bidid
	and ppu.pupdateID = (select max(pupdateID) from pbt_project_updates where bidID = a.bidid and updateID in (1,2,3,5,6,7,8,9,10)) 
	inner join pbt_project_stage f on f.bidID = a.bidID and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
	left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1 
	left outer join state_master on c.stateid = state_master.stateid 
	left outer join pbt_tags on pbt_tags.tagID = e.tagID and pbt_tags.tag_typeID in (1,2,3,4,5,9)
	left outer join pbt_stage_definer t on t.bidtypeID = f.bidtypeID 
	left outer join pbt_project_updates pu on pu.bidID = a.bidID and pu.updateID = (select max(updateID) from pbt_project_updates where bidID = a.bidid )
WHERE 1=1 
--stage
    and f.bidtypeID in (1,4,9,20,21,24)--(1,2) 
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
							and (promas.minimum_value < '100000' or promas.maximum_value < '100000')
						</cfcase>
						<cfcase value="3">
							and (promas.minimum_value >= '100000' and promas.minimum_value <= '500000' and promas.maximum_value <= '500000')
						</cfcase>
						<cfcase value="4">
							and (promas.minimum_value >= '500000' and promas.minimum_value <= '1000000' and promas.maximum_value <= '1000000')
						</cfcase>
						<cfcase value="5">
							and (promas.minimum_value >= '1000000' or promas.maximum_value >= '1000000')
						</cfcase>
						<cfdefaultcase>
							
						</cfdefaultcase>
					</cfswitch>				
				 
<!---project types--->
	and a.valuetypeID in (1,2) and a.verifiedpaint = 1
	<!--- if user prefs do not have VP selected this query will return 0 results
		  4 equals all contracts excluding paint
	--->
--tags
    and e.tagID in (8,9,17,20,79,16,11,13,19,24,10,23,652,9,12,74,73,14,21,70,18,75,76,77,78)
	<cfif listlen(_list)>
		and (
	<cfloop from="1" to="#listlen(_list)#" index="_c">
			<cfif _c gt 1>and </cfif> t#_c#.tagID = #listgetat(_list,_c)#
	</cfloop>)
	</cfif>
	and a.status in (3,5)
<!--- remove dupes--->
	<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
	and pbt_tags.tag is not null
 order by promas.stage, a.submittaldate
</cfquery>
<cfif indInfUpd.recordcount><cfset dupList = listappend(duplist,valuelist(indInfUpd.bidid))/>		
</cfif>
	
	
	<cfset _list = queryScope(tmpScopes,'14,21,22,72,70,15,68,25,18,26,69,71')/>
<cfquery name="comInfUpd" datasource="paintsquare_master"  result="r8">
-------
--  Commercial Information Updates	
-------
SELECT distinct a.bidID,a.owner, a.projectname, promas.stage as bid, a.submittaldate, promas.minimum_value as minimumvalue, 		promas.maximum_value as maximumvalue, promas.city, promas.state,promas.county, promas.tags as scopeofwork, a.valuetypeid, a.projectsize 
FROM pbt_project_master a 
	LEFT OUTER JOIN pbt_project_master_gateway promas on promas.bidid = a.bidid 
	inner join pbt_project_master_cats e on a.bidid = e.bidid 
	<cfif listlen(_list)>
	<cfloop from="1" to="#listlen(_list)#" index="_c">
			inner join pbt_project_master_cats t#_c# on a.bidid = t#_c#.bidid
	</cfloop>
	</cfif>
 
	inner join pbt_project_updates ppu on ppu.bidid = a.bidid
	and ppu.pupdateID = (select max(pupdateID) from pbt_project_updates where bidID = a.bidid and updateID in (1,2,3,5,6,7,8,9,10)) 
	inner join pbt_project_stage f on f.bidID = a.bidID and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
	left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1 
	left outer join state_master on c.stateid = state_master.stateid 
	left outer join pbt_tags on pbt_tags.tagID = e.tagID and pbt_tags.tag_typeID in (1,2,3,4,5,9)
	left outer join pbt_stage_definer t on t.bidtypeID = f.bidtypeID 
	left outer join pbt_project_updates pu on pu.bidID = a.bidID and pu.updateID = (select max(updateID) from pbt_project_updates where bidID = a.bidid )
WHERE 1=1 
--stage
    and f.bidtypeID in (1,4,9,20,21,24)--(1,2) 
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
							and (promas.minimum_value < '100000' or promas.maximum_value < '100000')
						</cfcase>
						<cfcase value="3">
							and (promas.minimum_value >= '100000' and promas.minimum_value <= '500000' and promas.maximum_value <= '500000')
						</cfcase>
						<cfcase value="4">
							and (promas.minimum_value >= '500000' and promas.minimum_value <= '1000000' and promas.maximum_value <= '1000000')
						</cfcase>
						<cfcase value="5">
							and (promas.minimum_value >= '1000000' or promas.maximum_value >= '1000000')
						</cfcase>
						<cfdefaultcase>
							
						</cfdefaultcase>
					</cfswitch>				
				 
<!---project types--->
	and a.valuetypeID in (1,2) and a.verifiedpaint = 1
	<!--- if user prefs do not have VP selected this query will return 0 results
		  4 equals all contracts excluding paint
	--->
--tags
    and pbt_tags.tagID in (14,21,22,72,70,15,68,25,18,26,69,71)
	<cfif listlen(_list)>
		and (
	<cfloop from="1" to="#listlen(_list)#" index="_c">
			<cfif _c gt 1>and </cfif> t#_c#.tagID = #listgetat(_list,_c)#
	</cfloop>)
	</cfif>
	and a.status in (3,5)
<!--- remove dupes--->
	<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
	and pbt_tags.tag is not null
 order by promas.stage, a.submittaldate
</cfquery>
<cfif comInfUpd.recordcount><cfset dupList = listappend(duplist,valuelist(comInfUpd.bidid))/>		
</cfif>
	
	<cfset _list = queryScope(tmpScopes,'8,9,17,20,79,16,11,13,19,24,10,23,652,78,75,76,77,12,74,73,14,21,70,18')/>
<cfquery name="indPaintPrjBids" datasource="paintsquare_master"  result="r9">
-------
--  Industrial Painting Project Bids	
-------
SELECT distinct a.bidID, a.owner, a.projectname, promas.stage as bid, a.submittaldate, promas.minimum_value as minimumvalue, promas.maximum_value as maximumvalue, promas.city, promas.state,promas.county, promas.tags as scopeofwork, a.valuetypeid, a.projectsize,bid_planholders.bidid as planholders
FROM pbt_project_master a
  LEFT OUTER JOIN pbt_project_master_gateway promas on promas.bidid = a.bidid
  left outer join pbt_project_contacts g on g.bidID = a.bidID and g.contact_typeID = 1
  LEFT OUTER JOIN supplier_master sm on sm.supplierID = a.ownerID
  --LEFT OUTER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
  inner join pbt_project_master_cats e on a.bidid = e.bidid 
	<cfif listlen(_list)>
	<cfloop from="1" to="#listlen(_list)#" index="_c">
			inner join pbt_project_master_cats t#_c# on a.bidid = t#_c#.bidid
	</cfloop>
	</cfif>
  left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1
  left outer join state_master stm on c.stateid = stm.stateid
  inner join pbt_project_stage f on f.bidID = a.bidID    and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
 -- LEFT OUTER JOIN pbt_project_master_cats ppmc2 on ppmc2.bidID = a.bidID
  LEFT OUTER JOIN bid_planholders on bid_planholders.bidid = a.bidID and (bid_planholders.companyname is not null or bid_planholders.firstname is not null or bid_planholders.lastname is not null)
WHERE 1=1 
--stage
    and f.bidtypeID in (1,4,9,20,21,24)--(1,2) 
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
							and (promas.minimum_value < '100000' or promas.maximum_value < '100000')
						</cfcase>
						<cfcase value="3">
							and (promas.minimum_value >= '100000' and promas.minimum_value <= '500000' and promas.maximum_value <= '500000')
						</cfcase>
						<cfcase value="4">
							and (promas.minimum_value >= '500000' and promas.minimum_value <= '1000000' and promas.maximum_value <= '1000000')
						</cfcase>
						<cfcase value="5">
							and (promas.minimum_value >= '1000000' or promas.maximum_value >= '1000000')
						</cfcase>
						<cfdefaultcase>
							
						</cfdefaultcase>
					</cfswitch>		
<!---project types--->		
	and a.valuetypeID in (1,2) and a.verifiedpaint = 1
	<!--- if user prefs do not have VP selected this query will return 0 results
		  4 equals all contracts excluding paint
	--->
--tags
    and e.tagID in (8,9,17,20,79,16,11,13,19,24,10,23,652,78,75,76,77,12,74,73,14,21,70,18)
	<cfif listlen(_list)>
		and (
	<cfloop from="1" to="#listlen(_list)#" index="_c">
			<cfif _c gt 1>and </cfif> t#_c#.tagID = #listgetat(_list,_c)#
	</cfloop>)
	</cfif>

	and a.status in (3,5)
<!--- remove dupes--->
	<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
	and promas.tags is not null
 order by promas.stage, a.submittaldate
</cfquery>
<cfif indPaintPrjBids.recordcount><cfset dupList = listappend(duplist,valuelist(indPaintPrjBids.bidid))/>	
</cfif>	
	
	<cfset _list = queryScope(tmpScopes,'14,21,22,72,70,15,68,25,18,26,69,71')/>
<cfquery name="comPaintPrjBids" datasource="paintsquare_master"  result="r10">
-------
--  Commercial Painting Project Bids	
-------
SELECT distinct a.bidID, a.owner, a.projectname, promas.stage as bid, a.submittaldate, promas.minimum_value as minimumvalue, promas.maximum_value as maximumvalue, promas.city, promas.state,promas.county, promas.tags as scopeofwork, a.valuetypeid, a.projectsize,bid_planholders.bidid as planholders
FROM pbt_project_master a
  LEFT OUTER JOIN pbt_project_master_gateway promas on promas.bidid = a.bidid
  left outer join pbt_project_contacts g on g.bidID = a.bidID and g.contact_typeID = 1
  LEFT OUTER JOIN supplier_master sm on sm.supplierID = a.ownerID
  --LEFT OUTER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
  inner join pbt_project_master_cats e on a.bidid = e.bidid 
	<cfif listlen(_list)>
	<cfloop from="1" to="#listlen(_list)#" index="_c">
			inner join pbt_project_master_cats t#_c# on a.bidid = t#_c#.bidid
	</cfloop>
	</cfif>
  left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1
  left outer join state_master stm on c.stateid = stm.stateid
  inner join pbt_project_stage f on f.bidID = a.bidID    and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
 -- LEFT OUTER JOIN pbt_project_master_cats ppmc2 on ppmc2.bidID = a.bidID
  LEFT OUTER JOIN bid_planholders on bid_planholders.bidid = a.bidID and (bid_planholders.companyname is not null or bid_planholders.firstname is not null or bid_planholders.lastname is not null)
	--inner join pbt_project_updates ppu on ppu.bidid in (select top 1 bidid from pbt_project_updates where updateID in (1,2,3,10) order by date_entered desc )
WHERE 1=1 
--stage
    and f.bidtypeID in (1,4,9,20,21,24)--(1,2) 
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
							and (promas.minimum_value < '100000' or promas.maximum_value < '100000')
						</cfcase>
						<cfcase value="3">
							and (promas.minimum_value >= '100000' and promas.minimum_value <= '500000' and promas.maximum_value <= '500000')
						</cfcase>
						<cfcase value="4">
							and (promas.minimum_value >= '500000' and promas.minimum_value <= '1000000' and promas.maximum_value <= '1000000')
						</cfcase>
						<cfcase value="5">
							and (promas.minimum_value >= '1000000' or promas.maximum_value >= '1000000')
						</cfcase>
						<cfdefaultcase>
							
						</cfdefaultcase>
					</cfswitch>		
<!---project types--->		
	and a.valuetypeID in (1,2) and a.verifiedpaint = 1
	<!--- if user prefs do not have VP selected this query will return 0 results
		  4 equals all contracts excluding paint
	--->
--tags
    and e.tagID in (14,21,22,72,70,15,68,25,18,26,69,71)
	<cfif listlen(_list)>
		and (
	<cfloop from="1" to="#listlen(_list)#" index="_c">
			<cfif _c gt 1>and </cfif> t#_c#.tagID = #listgetat(_list,_c)#
	</cfloop>)
	</cfif>
	and a.status in (3,5)
<!--- remove dupes--->
	<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
	and promas.tags is not null
 order by promas.stage, a.submittaldate
</cfquery>
<cfif comPaintPrjBids.recordcount><cfset dupList = listappend(duplist,valuelist(comPaintPrjBids.bidid))/>		
</cfif>
			
	
<cfquery name="genConstMaintPrjBids" datasource="paintsquare_master"  result="r11">	
-------
--  General Construction Maintenance Project Bids	
-------
SELECT distinct promas.tags, a.bidID, a.owner, a.projectname, promas.stage as bid, a.submittaldate, 
	promas.minimum_value as 	minimumvalue, promas.maximum_value as maximumvalue, promas.city, promas.state,promas.county, promas.tags as scopeofwork, a.valuetypeid, a.projectsize
FROM pbt_project_master a
	LEFT OUTER JOIN pbt_project_master_gateway promas on promas.bidid = a.bidid
	inner join pbt_project_master_cats e on a.bidid = e.bidid
	<cfif listlen(scopes)>
	<cfloop from="1" to="#listlen(scopes)#" index="_c">
			inner join pbt_project_master_cats t#_c# on a.bidid = t#_c#.bidid
	</cfloop>
	</cfif>
	inner join pbt_project_stage f on f.bidID = a.bidID and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
	left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1 
	left outer join state_master on c.stateid = state_master.stateid 
	left outer join pbt_tags on pbt_tags.tagID = e.tagID
	left outer join pbt_stage_definer t on t.bidtypeID = f.bidtypeID 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
	and ppc.bidlogID = (select max(bidlogID) from pbt_project_master_cats where bidID = a.bidid and tagID in (select tagID from pbt_tags where tag_typeID = 2) )
WHERE 1=1 
--stage
    and f.bidtypeID in (1,4,9,20,21,24)--(1,2) 
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
							and (promas.minimum_value < '100000' or promas.maximum_value < '100000')
						</cfcase>
						<cfcase value="3">
							and (promas.minimum_value >= '100000' and promas.minimum_value <= '500000' and promas.maximum_value <= '500000')
						</cfcase>
						<cfcase value="4">
							and (promas.minimum_value >= '500000' and promas.minimum_value <= '1000000' and promas.maximum_value <= '1000000')
						</cfcase>
						<cfcase value="5">
							and (promas.minimum_value >= '1000000' or promas.maximum_value >= '1000000')
						</cfcase>
						<cfdefaultcase>
							
						</cfdefaultcase>
					</cfswitch>		
<!---project types--->
<cfif user_projecttypes neq 3>and 0=1</cfif>
	and a.verifiedpaint is null
--tags
    <cfif listlen(scopes)>
		and (
	<cfloop from="1" to="#listlen(scopes)#" index="_c">
			<cfif _c gt 1>and </cfif> t#_c#.tagID = #listgetat(scopes,_c)#
	</cfloop>)
	</cfif>
	and a.status in (3,5)	
<!--- remove dupes--->
	<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
	--and ppc.tagID is null
	and promas.tags is not null
 order by promas.stage, a.submittaldate
</cfquery>
<cfif genConstMaintPrjBids.recordcount><cfset dupList = listappend(duplist,valuelist(genConstMaintPrjBids.bidid))/>	
</cfif>	
				
<cfquery name="engDsgnBids" datasource="paintsquare_master"  result="r12">
-------
--  Engineering & Design Bids	
-------
SELECT distinct a.bidID, a.owner, a.projectname, promas.stage as bid, a.submittaldate, promas.minimum_value as minimumvalue, promas.maximum_value as maximumvalue, promas.city, promas.state,promas.county, promas.tags as scopeofwork, a.valuetypeid, a.projectsize,bid_planholders.bidid as planholders
FROM pbt_project_master a
  LEFT OUTER JOIN pbt_project_master_gateway promas on promas.bidid = a.bidid
  left outer join pbt_project_contacts g on g.bidID = a.bidID and g.contact_typeID = 1
  LEFT OUTER JOIN supplier_master sm on sm.supplierID = a.ownerID
  inner join pbt_project_master_cats e on a.bidid = e.bidid 
	<cfif listlen(scopes)>
	<cfloop from="1" to="#listlen(scopes)#" index="_c">
			inner join pbt_project_master_cats t#_c# on a.bidid = t#_c#.bidid
	</cfloop>
	</cfif>
  left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1
  left outer join state_master stm on c.stateid = stm.stateid
  inner join pbt_project_stage f on f.bidID = a.bidID    and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
 -- LEFT OUTER JOIN pbt_project_master_cats ppmc2 on ppmc2.bidID = a.bidID
  LEFT OUTER JOIN bid_planholders on bid_planholders.bidid = a.bidID and (bid_planholders.companyname is not null or bid_planholders.firstname is not null or bid_planholders.lastname is not null)
WHERE 1=1 
--stage
    and f.bidtypeID in (24)
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
							and (promas.minimum_value < '100000' or promas.maximum_value < '100000')
						</cfcase>
						<cfcase value="3">
							and (promas.minimum_value >= '100000' and promas.minimum_value <= '500000' and promas.maximum_value <= '500000')
						</cfcase>
						<cfcase value="4">
							and (promas.minimum_value >= '500000' and promas.minimum_value <= '1000000' and promas.maximum_value <= '1000000')
						</cfcase>
						<cfcase value="5">
							and (promas.minimum_value >= '1000000' or promas.maximum_value >= '1000000')
						</cfcase>
						<cfdefaultcase>
							
						</cfdefaultcase>
					</cfswitch>		
<!---project types--->
	
--tags
    <cfif listlen(scopes)>
		and (
	<cfloop from="1" to="#listlen(scopes)#" index="_c">
			<cfif _c gt 1>and </cfif> t#_c#.tagID = #listgetat(scopes,_c)#
	</cfloop>)
	</cfif>
	and a.status in (3,5)
<!--- remove dupes--->
	<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
	and promas.tags is not null
 order by promas.stage, a.submittaldate
</cfquery>
<cfif engDsgnBids.recordcount><cfset dupList = listappend(duplist,valuelist(engDsgnBids.bidid))/>	
</cfif>	
	
	
<cfquery name="subContrOpp" datasource="paintsquare_master"  result="r13">
-------
--  Subcontracting Opportunities	
-------
SELECT distinct a.bidID, a.owner, a.projectname, promas.stage as bid, a.submittaldate, promas.minimum_value as minimumvalue, promas.maximum_value as maximumvalue, promas.city, promas.state,promas.county, promas.tags as scopeofwork, a.valuetypeid, a.projectsize,bid_planholders.bidid as planholders
FROM pbt_project_master a
  LEFT OUTER JOIN pbt_project_master_gateway promas on promas.bidid = a.bidid
  left outer join pbt_project_contacts g on g.bidID = a.bidID and g.contact_typeID = 1
  LEFT OUTER JOIN supplier_master sm on sm.supplierID = a.ownerID
  inner join pbt_project_master_cats e on a.bidid = e.bidid
	<cfif listlen(scopes)>
	<cfloop from="1" to="#listlen(scopes)#" index="_c">
			inner join pbt_project_master_cats t#_c# on a.bidid = t#_c#.bidid
	</cfloop>
	</cfif>
  left outer join pbt_project_locations c on c.bidID = a.bidID and primary_location = 1
  left outer join state_master stm on c.stateid = stm.stateid
  inner join pbt_project_stage f on f.bidID = a.bidID    and f.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
 -- LEFT OUTER JOIN pbt_project_master_cats ppmc2 on ppmc2.bidID = a.bidID
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
							and (promas.minimum_value < '100000' or promas.maximum_value < '100000')
						</cfcase>
						<cfcase value="3">
							and (promas.minimum_value >= '100000' and promas.minimum_value <= '500000' and promas.maximum_value <= '500000')
						</cfcase>
						<cfcase value="4">
							and (promas.minimum_value >= '500000' and promas.minimum_value <= '1000000' and promas.maximum_value <= '1000000')
						</cfcase>
						<cfcase value="5">
							and (promas.minimum_value >= '1000000' or promas.maximum_value >= '1000000')
						</cfcase>
						<cfdefaultcase>
							
						</cfdefaultcase>
					</cfswitch>		
<!---project types--->
	<cfif user_projecttypes neq 3>and a.verifiedpaint = 1</cfif>
--tags
    <cfif listlen(scopes)>
		and (
	<cfloop from="1" to="#listlen(scopes)#" index="_c">
			<cfif _c gt 1>and </cfif> t#_c#.tagID = #listgetat(scopes,_c)#
	</cfloop>)
	</cfif>
	and a.status in (3,5)
<!--- remove dupes--->
	<cfif listlen(dupList)>and a.bidid not in(#dupList#)</cfif>
	and promas.tags is not null
 order by promas.stage, a.submittaldate
</cfquery>		
	
</cfif>	
<!---
	project type :<cfif user_projecttypes is not 4>and a.valuetypeID in (#user_projecttypes#)</cfif>		
	stage: and f.bidtypeID in (#user_stage#)
	tags:  and ppmc.tagID in (#scopes#)
	update type:
--->
	
		<CFMAIL SUBJECT="email pref email send [#request.emailType#]" FROM="PaintBidtracker@paintsquare.com" to="slyon@technologypub.com" type="html">
			<!---cfloop from="1" to="#arraylen(arrQueryNames)#" index="_qInx">
				<cfdump var="#evaluate(arrQueryNames[_qInx])#" />
			</cfloop--->
			#user_projecttypes#
			<cfif request.emailType is 'awards'>
			<cfif isdefined('r1')><cfdump var="#r1#" /></cfif>
			<cfif isdefined('r2')><cfdump var="#r2#" /></cfif>
			<cfif isdefined('r3')><cfdump var="#r3#" /></cfif>
			<cfif isdefined('r4')><cfdump var="#r4#" /></cfif>
			<cfif isdefined('r5')><cfdump var="#r5#" /></cfif>
			<cfif isdefined('r6')><cfdump var="#r6#" /></cfif>
			</cfif>
			<cfif request.emailType is 'bids'>
			<cfif isdefined('r7')><cfdump var="#r7#" /></cfif>
			<cfif isdefined('r8')><cfdump var="#r8#" /></cfif>
			<cfif isdefined('r9')><cfdump var="#r9#" /></cfif>
			<cfif isdefined('r10')><cfdump var="#r10#" /></cfif>
			<cfif isdefined('r11')><cfdump var="#r11#" /></cfif>
			<cfif isdefined('r12')><cfdump var="#r12#" /></cfif>
			<cfif isdefined('r13')><cfdump var="#r13#" /></cfif>
			</cfif>
		</cfmail>