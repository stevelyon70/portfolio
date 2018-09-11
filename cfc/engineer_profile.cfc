<cfcomponent>
<cffunction name="pull_company_details" access="remote" output="true" returntype="Query" returnformat="JSON" >
	<cfargument name="engineerID" type="numeric" required="true" default="0" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
	
<!--- Query the database to get comp details. ---> 
<cfquery name="getEngineer">
		SELECT distinct pbt_project_engineers.engineerID, pbt_project_engineers.companyname,pbt_project_engineers.billingaddress,pbt_project_engineers.city,pbt_project_engineers.postalcode_5 as zipcode,state_master.state,
		pbt_project_engineers.phonenumber,pbt_project_engineers.faxnumber,pbt_project_engineers.emailaddress,pbt_project_engineers.stateID,pct.typeID,pbt_project_engineers.websiteurl
        FROM pbt_project_engineers 
        left outer join sup_cat_log on sup_cat_log.supplierid = pbt_project_engineers.engineerID
        left outer join pbt_contractor_type pct on pct.typeID = sup_cat_log.directory
		left outer join state_master on state_master.stateid = pbt_project_engineers.stateid
		left outer join pbt_project_master b on b.engineerID = pbt_project_engineers.engineerID
		where (pbt_project_engineers.companyname <> '' and pbt_project_engineers.companyname is not null)
		and pbt_project_engineers.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
        ORDER BY pbt_project_engineers.companyname
		</cfquery>
<cfreturn getEngineer />
		
</cffunction>


<cffunction name="pull_company_website" access="remote" output="true" returntype="Query" returnformat="JSON" >
	<cfargument name="engineerID" type="numeric" required="true" default="0" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
	
<!--- Query the database to get comp details. ---> 
<cfquery name="getURL">
		SELECT distinct top 1 f.url as owner_url
        FROM pbt_project_docs f  
		left outer join pbt_project_master b on f.bidID = b.bidID
		left outer join supplier_master on supplier_master.ownerID = b.ownerID
		where (supplier_master.companyname <> '' and supplier_master.companyname is not null)
		and f.doc_typeID = 8
		and supplier_master.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
       
		</cfquery>
<cfreturn getURL />
		
</cffunction>

<cffunction name="get_Additional_industries" access="remote" output="true" returntype="Query"  >
	<cfargument name="engineerID" type="numeric" required="true" default="0" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
	<cfquery name="get_Additional_industries">
		SELECT DISTINCT top 5 pb.tag,count(d.bidID) as numproj
		FROM  pbt_project_engineers AS a 
		LEFT OUTER JOIN dbo.pbt_project_master AS d ON a.engineerID = d.engineerID 
		--INNER JOIN dbo.pbt_award_contractors AS b ON a.supplierID = b.supplierID
		LEFT OUTER JOIN dbo.pbt_project_stage AS c ON c.bidID = d.bidID
		LEFT OUTER JOIN dbo.pbt_project_master_cats AS ppc ON ppc.bidID = d.bidID
		LEFT OUTER JOIN dbo.pbt_tags pb on pb.tagID = ppc.tagID
		
		WHERE  (d .verifiedpaint = 1) 
		       AND (d .status IN (3,5))
		       <!---default year period selection --->
			  and (1 <> 1 
						or (DATEPART(year,d.paintpublishdate) = '2014')
						or (DATEPART(year,d.paintpublishdate) = '2015')
						or (DATEPART(year,d.paintpublishdate) = '2016')
						or (DATEPART(year,d.paintpublishdate) = '2017')
						)
				and a.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
				AND (ppc.tagID IN 
				(SELECT DISTINCT dbo.pbt_tags.tagID 
				  FROM dbo.pbt_tags 
				  INNER JOIN dbo.pbt_tag_packages AS pt ON pt.tagID = dbo.pbt_tags.tagID 
				  WHERE  (pt.packageID IN (1,2))  AND (dbo.pbt_tags.tag_typeID = 1) AND (dbo.pbt_tags.tag_parentID <> 0)
				  ))
				  group by pb.tag
				  order by numproj desc
		</cfquery>

<cfreturn get_Additional_industries />
		
</cffunction>

<cffunction name="get_Agency" access="remote" output="true" returntype="Query"  >
	<cfargument name="engineerID" type="numeric" required="true" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
			<!---cfstoredproc procedure="pbt_contrak_contractor_profile_metrics_projects" datasource="pbt_analytics">
				<cfprocparam type="in" dbvarname="@supplierID" cfsqltype="CF_SQL_INTEGER" value="#supplierID#">
				<cfprocparam type="in" dbvarname="@structure_types" cfsqltype="CF_SQL_VARCHAR" value="1">
				<cfprocparam type="in" dbvarname="@states" cfsqltype="CF_SQL_INTEGER" value="1">
				<cfprocparam type="in" dbvarname="@fromdate" cfsqltype="CF_SQL_DATE" value="1">
				<cfprocparam type="in" dbvarname="@TOdate" cfsqltype="CF_SQL_DATE" value="1">
				<!---cfprocparam type="in" dbvarname="@nl_versionID" cfsqltype="CF_SQL_INTEGER" value="#nl_versionid#"--->
				<cfprocresult name="agency_query" resultset="2">
			</cfstoredproc--->
	<cfquery name="agency_query">	
		select distinct  sm.supplierID,a.owner,sm.companyname as agencyname,st.state,count(distinct a.bidID) as numberofprojects
	from pbt_project_master a 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join state_master st on st.stateID = pd.stateID
	left outer join supplier_master sm on sm.supplierID = a.supplierID
	left outer join supplier_master sm1 on sm1.supplierID = pa.supplierID
	where a.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" > 
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
				<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,a.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,a.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,a.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,a.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,a.paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,a.paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,a.paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,a.paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
	and a.verifiedpaint = 1 
		--and pa.awarded = 1
		and (a.status IN (3, 5))
		--and ps.bidtypeID in (5,6)
	group by sm.supplierID,a.owner,sm.companyname,st.state
	order by numberofprojects desc
	</cfquery>

<cfreturn agency_query />
		
</cffunction>


<cffunction name="get_top_Brands" access="remote" output="true" returntype="Query"  >
	<cfargument name="engineerID" type="numeric" required="true" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
	<cfquery name="get_top_Brands">
		SELECT DISTINCT d.tag AS brands, d.tagID AS brand_tagID,count(distinct pc.bidID) as numproj
		FROM  dbo.pbt_tags d
		INNER JOIN pbt_project_master_cats pc on pc.tagID = d.tagID
		LEFT OUTER JOIN pbt_project_master pb on pb.bidID = pc.bidID
		LEFT OUTER JOIN dbo.pbt_project_locations ON pb.bidID = dbo.pbt_project_locations.bidID AND dbo.pbt_project_locations.active = 1 AND dbo.pbt_project_locations.primary_location = 1 
		LEFT OUTER JOIN dbo.state_master ON dbo.pbt_project_locations.stateID = dbo.state_master.stateID
		LEFT OUTER JOIN pbt_project_master_cats pcc on pcc.bidID = pb.bidID 
		LEFT OUTER JOIN dbo.pbt_tags AS c ON c.tagID = pcc.tagID AND c.tag_typeID IN (1, 2)
		where d.tag_typeID IN (9) AND d.tagID NOT IN (380, 381, 382, 383, 384, 385, 378, 379) 
		and pb.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
		<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
						and dbo.pbt_project_locations.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
					</cfif>
					<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
						and c.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
					</cfif>
					<!---year filters--->
					<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
						and (1 <> 1 
					
					
						<cfif listfind(year_field,"2014")>
							or --(a.paintpublishdate >= '1/1/2012' and a.paintpublishdate < '1/1/2013')
							(DATEPART(year,pb.paintpublishdate) = '2014')
						</cfif>
						<cfif listfind(year_field,"2015")>
							or (DATEPART(year,pb.paintpublishdate) = '2015')
						</cfif>
						<cfif listfind(year_field,"2016")>
							or (DATEPART(year,pb.paintpublishdate) = '2016')
						</cfif>
						<cfif listfind(year_field,"2017")>
							or (DATEPART(year,pb.paintpublishdate) = '2017')
						</cfif>
					
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,pb.paintpublishdate) = '2014')
						or (DATEPART(year,pb.paintpublishdate) = '2015')
						or (DATEPART(year,pb.paintpublishdate) = '2016')
						or (DATEPART(year,pb.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,pb.paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,pb.paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,pb.paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,pb.paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
								
			group by d.tag, d.tagID
			order by numproj desc
		</cfquery>

<cfreturn get_top_Brands />
		
</cffunction>

<cffunction name="get_Additional_states" access="remote" output="true" returntype="Query"  >
	<cfargument name="engineerID" type="numeric" required="true" default="0" />
	
		 <cfset date = #CREATEODBCDATETIME(NOW())#>
		<cfquery name="get_Additional_states">
			SELECT DISTINCT top 5 st.state,count(d.bidID) as numproj
			FROM  dbo.supplier_master AS a 
			INNER JOIN dbo.pbt_award_contractors AS b ON a.supplierID = b.supplierID
			LEFT OUTER JOIN dbo.pbt_project_stage AS c ON c.stageID = b.stageID 
			LEFT OUTER JOIN dbo.pbt_project_master AS d ON d.bidID = c.bidID 
			LEFT OUTER JOIN dbo.pbt_project_locations AS pd ON pd.bidID = d .bidID AND pd.active = 1 AND pd.primary_location = 1
			LEFT OUTER JOIN dbo.state_master st on st.stateID = pd.stateID
			
			WHERE  (d .verifiedpaint = 1) AND (d .status IN (3,5))
					and a.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
					 <!---default year period selection --->
			  and (1 <> 1 
						or (DATEPART(year,d.paintpublishdate) = '2014')
						or (DATEPART(year,d.paintpublishdate) = '2015')
						or (DATEPART(year,d.paintpublishdate) = '2016')
						or (DATEPART(year,d.paintpublishdate) = '2017')
						)
			group by st.state
			order by numproj desc
			</cfquery>
	
	<cfreturn get_Additional_states />
		
</cffunction>



<cffunction name="get_Filter_Industry" access="remote" output="true" returntype="Query"  >
	<cfargument name="structure_field" type="string" required="true" default="0" />
	<cfquery name="get_filter_Industry">
		SELECT tag
		from pbt_tags
		WHERE  tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
		and active = 1
	</cfquery>

<cfreturn get_filter_Industry />
</cffunction>

<cffunction name="get_Filter_state" access="remote" output="true" returntype="Query"  >
	<cfargument name="state_field" type="string" required="true" default="0" />
	<cfquery name="get_filter_state">
		SELECT state
		from state_master
		WHERE  stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
		and countryID = 73
	</cfquery>

<cfreturn get_filter_state />
</cffunction>

<cffunction name="get_Filter_CT" access="remote" output="true" returntype="Query"  >
	<cfargument name="contract_type_field" type="string" required="true" default="0" />
	<cfquery name="get_filter_CT">
		SELECT value_type,valueID
		from bids_value_type
		WHERE  valueID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contract_type_field#" >)
		and active = 1
	</cfquery>

<cfreturn get_filter_CT />
</cffunction>

<cffunction name="get_Metrics" access="remote" output="true" returntype="Query"  >
	<cfargument name="engineerID" type="numeric" required="true" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
			<!---cfstoredproc procedure="pbt_contrak_contractor_profile_metrics" datasource="pbt_analytics">
				<cfprocparam type="in" dbvarname="@supplierID" cfsqltype="CF_SQL_INTEGER" value="#supplierID#">
				<cfprocparam type="in" dbvarname="@structure_types" cfsqltype="CF_SQL_VARCHAR" value="1">
				<cfprocparam type="in" dbvarname="@states"  cfsqltype="CF_SQL_VARCHAR" maxlength="4000" value="#arguments.state_field#">
				<cfprocparam type="in" dbvarname="@fromdate" cfsqltype="CF_SQL_DATE" value="1">
				<cfprocparam type="in" dbvarname="@TOdate" cfsqltype="CF_SQL_DATE" value="1">
				<!---cfprocparam type="in" dbvarname="@nl_versionID" cfsqltype="CF_SQL_INTEGER" value="#nl_versionid#"--->
				<cfprocresult name="volume_bid" resultset="1">
				<cfprocresult name="volume_won" resultset="2">
				<cfprocresult name="largest_win" resultset="3">
				<cfprocresult name="numberbid" resultset="4">
				<cfprocresult name="numberwon" resultset="5">
				<cfprocresult name="leftontable" resultset="6">
				<cfprocresult name="eng_estimate" resultset="7">
			</cfstoredproc--->

		<!---get the volume bid--->
		<cfquery name="volume_bid">
			select o.engineerID, 
			sum(cast(amount as numeric(20,3))) as bidAmount 
			from pbt_project_master o 
			left outer join pbt_project_stage ps on ps.bidid = o.bidid
			left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
			inner join
			( 
			select pc.bidID as bidID, amount as bidamount
			from pbt_project_master_cats pc
			left outer join pbt_project_master a on a.bidid = pc.bidid
			left outer join pbt_project_stage ps on ps.bidid = pc.bidid
			left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
			left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
			where a.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
				and a.verifiedpaint = 1 
				and (a.status IN (3, 5))
				and ps.bidtypeID in (5,6)
				and pa.awarded = 1
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
				and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
				and pc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
				
				<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,a.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,a.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,a.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,a.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,a.paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,a.paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,a.paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,a.paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
			group by pc.bidid,amount
			) d 
			on o.bidID = d.bidID 
			and o.engineerid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerid#" >
			and pa.awarded = 1
			group by o.engineerid
		</cfquery>
	
	

   
 <cfquery name="volume_won">
 	select o.engineerid, 
	avg(cast(bidAmount as numeric(20,3))) as bidAmount 
	from pbt_project_master o 
	left outer join pbt_project_stage ps on ps.bidid = o.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	inner join
	( 
	select pc.bidID as bidID, pml.low_bid_amount as bidAmount
	from pbt_project_master_cats pc
	left outer join pbt_project_master a on a.bidid = pc.bidid
	left outer join pbt_project_stage ps on ps.bidid = pc.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join pbt_market_contractor_leaderboard pml on pml.bidID = pc.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	where a.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
		and a.verifiedpaint = 1 
		
		and (a.status IN (3, 5))
		and ps.bidtypeID in (5,6)
		
					<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
						and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
					</cfif>
					<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
						and pc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
					</cfif>
					<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,a.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,a.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,a.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,a.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,a.paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,a.paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,a.paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,a.paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
				
	group by pc.bidid,low_bid_amount
	) d 
	on o.bidID = d.bidID 
	and o.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
	group by o.engineerID
 </cfquery>
   
<cfquery name="avg_award">
		--get the volume won
		select o.engineerID, 
	avg(cast(amount as numeric(20,3))) as bidAmount
	from pbt_project_master o 
	left outer join pbt_project_stage ps on ps.bidid = o.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	inner join
	( 
	select pc.bidID as bidID, amount as bidamount
	from pbt_project_master_cats pc
	left outer join pbt_project_master a on a.bidid = pc.bidid
	left outer join pbt_project_stage ps on ps.bidid = pc.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	where a.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
		and a.verifiedpaint = 1 
		and pa.awarded = 1
		and (a.status IN (3, 5))
		and ps.bidtypeID in (5)
		<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
			and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
		</cfif>
		<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
			and pc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
		</cfif>
			<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,a.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,a.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,a.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,a.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,a.paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,a.paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,a.paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,a.paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
	group by pc.bidid,amount
	) d 
	on o.bidID = d.bidID 
	and o.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
	and pa.awarded = 1
	group by o.engineerID
   </cfquery>
    <cfquery name="largest_win">
	--get the largest win
	select max(pa.amount) as winamount
	from pbt_project_master a
	left outer join pbt_project_master_cats pmc on pmc.bidID = a.bidID
	left outer join pbt_project_stage ps on ps.bidid = a.bidid and ps.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	where a.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
	and a.verifiedpaint = 1 
	and pa.awarded = 1
	and (a.status IN (3, 5))
	and ps.bidtypeID in (5)
	<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
		and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
	</cfif>
	<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
		and pmc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
	</cfif>
	<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,a.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,a.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,a.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,a.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,a.paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,a.paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,a.paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,a.paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
	</cfquery>
	
	<cfquery name="numberbid">
	--get the number of jobs bid
	select count(distinct a.bidID) as numjobsbid
	from pbt_project_master a
	left outer join pbt_project_master_cats pmc on pmc.bidID = a.bidID
	left outer join pbt_project_stage ps on ps.bidid = a.bidid and ps.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	where a.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#engineerID#" >
	and a.verifiedpaint = 1 
	and (a.status IN (3, 5))
	--and ps.bidtypeID in (5,6)
	<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
		and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
	</cfif>
	<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
		and pmc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
	</cfif>
	<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,a.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,a.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,a.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,a.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,a.paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,a.paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,a.paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,a.paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
	</cfquery>
	
	<cfquery name="numberwon">
	--get the number of jobs won
	select count(distinct a.bidID) as numjobswon
	from pbt_project_master a
	left outer join pbt_project_master_cats pmc on pmc.bidID = a.bidID
    left outer join pbt_project_stage ps on ps.bidid = a.bidid and ps.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	where a.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#engineerID#" >
	and a.verifiedpaint = 1 
	and pa.awarded = 1
	and (a.status IN (3, 5))
	and ps.bidtypeID in (5)
	<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
		and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
	</cfif>
	<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
		and pmc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
	</cfif>
	<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,a.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,a.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,a.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,a.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,a.paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,a.paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,a.paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,a.paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
	</cfquery>
	<cfquery name="leftontable">	
	--get the sum of second bid
		select o.engineerID, 
	sum(cast(bidAmount as numeric(20,3))) as bidAmount 
	from pbt_project_master o 
	left outer join pbt_project_stage ps on ps.bidid = o.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	inner join
	( 
	select pc.bidID as bidID, pml.second_bid_amount as bidAmount
	from pbt_project_master_cats pc
	left outer join pbt_project_master a on a.bidid = pc.bidid
	left outer join pbt_project_stage ps on ps.bidid = pc.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join pbt_market_contractor_leaderboard pml on pml.bidID = pc.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	where a.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
		and a.verifiedpaint = 1 
		and pa.awarded = 1
		and (a.status IN (3, 5))
		and ps.bidtypeID in (5)
		<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
			and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
		</cfif>
		<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
			and pc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
		</cfif>
		<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,a.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,a.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,a.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,a.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,a.paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,a.paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,a.paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,a.paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
	group by pc.bidid,second_bid_amount
	) d 
	on o.bidID = d.bidID 
	and o.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
	group by o.engineerID
	</cfquery>
	
		<cfquery name="eng_estimate">	
			--get the cost estimate sum
			select o.engineerID, 
			sum(d.bidAmount) as bidAmount 
			from pbt_project_master o 
			left outer join pbt_project_stage ps on ps.bidid = o.bidid
			left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
			inner join
			( 
			select pc.bidID as bidID, CAST(ROUND(a.minimumvalue, 0) AS numeric) as bidamount
			from pbt_project_master_cats pc
			left outer join pbt_project_master a on a.bidid = pc.bidid
			left outer join pbt_project_stage ps on ps.bidid = pc.bidid
			left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
			left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
			where a.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
				and a.verifiedpaint = 1 
				and (a.status IN (3, 5))
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
					and pc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
				<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,a.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,a.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,a.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,a.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,a.paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,a.paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,a.paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,a.paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
			group by pc.bidid,a.minimumvalue
			) d 
			on o.bidID = d.bidID 
			and o.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
			group by o.engineerID
		</cfquery>


		<cfset metricQuery = QueryNew("volume_bid,volume_won,avg_award,largest_win,numberbid,numberwon,leftontable,eng_estimate","Decimal,Decimal,Decimal,Decimal,integer,integer,Decimal,Decimal")>
		<cfset counter=0>
		
		<cfset newRow = QueryAddRow(metricQuery, 1)>
		<cfset counter=counter+1>
		<cfset temp = QuerySetCell(metricQuery, "volume_bid", "#volume_bid.bidamount#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "volume_won", "#volume_won.bidamount#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "avg_award", "#avg_award.bidamount#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "largest_win", "#largest_win.winamount#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "numberbid", "#numberbid.numjobsbid#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "numberwon", "#numberwon.numjobswon#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "leftontable", "#leftontable.bidamount#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "eng_estimate", "#eng_estimate.bidamount#", #counter#)>
		
		
		
	<cfquery name="pull_metrics" dbtype="query">
			select  * from metricQuery
	</cfquery>

<cfreturn pull_metrics />
		
</cffunction>

<cffunction name="get_Awards" access="remote" output="true" returntype="Query"  >
	<cfargument name="engineerID" type="numeric" required="true" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
			<!---cfstoredproc procedure="pbt_contrak_contractor_profile_metrics_projects" datasource="pbt_analytics">
				<cfprocparam type="in" dbvarname="@supplierID" cfsqltype="CF_SQL_INTEGER" value="#supplierID#">
				<cfprocparam type="in" dbvarname="@structure_types" cfsqltype="CF_SQL_VARCHAR" value="1">
				<cfprocparam type="in" dbvarname="@states" cfsqltype="CF_SQL_INTEGER" value="1">
				<cfprocparam type="in" dbvarname="@fromdate" cfsqltype="CF_SQL_DATE" value="1">
				<cfprocparam type="in" dbvarname="@TOdate" cfsqltype="CF_SQL_DATE" value="1">
				<!---cfprocparam type="in" dbvarname="@nl_versionID" cfsqltype="CF_SQL_INTEGER" value="#nl_versionid#"--->
				<cfprocresult name="awards_query" resultset="1">
			</cfstoredproc--->
<cfquery name="awards_query">	
	select distinct a.bidID,a.projectname,a.owner,sm.companyname as agencyname,pd.city,st.state,sm1.companyname as contractor,a.paintpublishdate,pa.amount,sm.supplierID as owner_supplierID
	from pbt_project_master a 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join state_master st on st.stateID = pd.stateID
	left outer join supplier_master sm on sm.supplierID = a.supplierID
	left outer join supplier_master sm1 on sm1.supplierID = pa.supplierID
	left outer join pbt_project_engineers pe on pe.engineerID = a.engineerID
	where pe.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" > 
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
				<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,a.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,a.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,a.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,a.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,a.paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,a.paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,a.paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,a.paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
	and a.verifiedpaint = 1 
		and pa.awarded = 1
		and (a.status IN (3, 5))
		and ps.bidtypeID in (5)
	order by a.paintpublishdate desc
</cfquery>
<cfreturn awards_query />
		
</cffunction>

<cffunction name="top_contractor_query" access="remote" output="true" returntype="Query"  >
	<cfargument name="engineerID" type="numeric" required="true" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
			<!---cfstoredproc procedure="pbt_contrak_contractor_profile_metrics_projects" datasource="pbt_analytics">
				<cfprocparam type="in" dbvarname="@supplierID" cfsqltype="CF_SQL_INTEGER" value="#supplierID#">
				<cfprocparam type="in" dbvarname="@structure_types" cfsqltype="CF_SQL_VARCHAR" value="1">
				<cfprocparam type="in" dbvarname="@states" cfsqltype="CF_SQL_INTEGER" value="1">
				<cfprocparam type="in" dbvarname="@fromdate" cfsqltype="CF_SQL_DATE" value="1">
				<cfprocparam type="in" dbvarname="@TOdate" cfsqltype="CF_SQL_DATE" value="1">
				<!---cfprocparam type="in" dbvarname="@nl_versionID" cfsqltype="CF_SQL_INTEGER" value="#nl_versionid#"--->
				<cfprocresult name="agency_query" resultset="2">
			</cfstoredproc--->
	<cfquery name="top_contractor_query">
select distinct
 supplier_master.supplierID,
  supplier_master.companyname as contractorname,
  supplier_master.city,
  state_master.state,
  log_counts_won.jobs_won as numberofprojects,
  log_counts_volume_won.volume_won as total_spending
from supplier_master
--get bids won
left outer join (
  select distinct_logs1.supplierid, 
  count(1) as jobs_won
  from (
    select distinct pbt_award_contractors.supplierid, d.bidID
    from  pbt_award_contractors
	LEFT OUTER JOIN
    dbo.pbt_project_stage AS c ON c.stageID = pbt_award_contractors.stageID LEFT OUTER JOIN
    dbo.pbt_project_master AS d ON d.bidID = c.bidID
    left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
    left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5)) AND (d.paintpublishdate >= '1/1/12') 
	and awarded = 1
	and d.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" > 
	<cfif isdefined("arguments.contractorlist") and arguments.contractorlist NEQ "0">
					and pbt_award_contractors.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0" and arguments.state_field NEQ "">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0" and arguments.structure_field NEQ "">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
				<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or --(a.paintpublishdate >= '1/1/2012' and a.paintpublishdate < '1/1/2013')
						(DATEPART(year,d.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,d.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,d.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,d.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,d.paintpublishdate) = '2014')
						or (DATEPART(year,d.paintpublishdate) = '2015')
						or (DATEPART(year,d.paintpublishdate) = '2016')
						or (DATEPART(year,d.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
  ) as distinct_logs1
  group by distinct_logs1.supplierid
) as log_counts_won 
on log_counts_won.supplierID = supplier_master.supplierid
--get volume won
left outer join (
  select distinct_logs3.supplierid, 
  sum(amount) as volume_won
  from (
    select distinct pbt_award_contractors.supplierid, amount, d.bidID
    from  pbt_award_contractors
	LEFT OUTER JOIN
    dbo.pbt_project_stage AS c ON c.stageID = pbt_award_contractors.stageID LEFT OUTER JOIN
    dbo.pbt_project_master AS d ON d.bidID = c.bidID
    left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
    left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5)) AND (d.paintpublishdate >= '1/1/12') 
	and awarded = 1
	and d.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" > 
	<cfif isdefined("arguments.contractorlist") and arguments.contractorlist NEQ "0">
					and pbt_award_contractors.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0" and arguments.state_field NEQ "">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0" and arguments.structure_field NEQ "">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
				<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or --(a.paintpublishdate >= '1/1/2012' and a.paintpublishdate < '1/1/2013')
						(DATEPART(year,d.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,d.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,d.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,d.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,d.paintpublishdate) = '2014')
						or (DATEPART(year,d.paintpublishdate) = '2015')
						or (DATEPART(year,d.paintpublishdate) = '2016')
						or (DATEPART(year,d.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
  ) as distinct_logs3
  group by distinct_logs3.supplierid
) as log_counts_volume_won
on log_counts_volume_won.supplierID = supplier_master.supplierid
left outer join state_master on state_master.stateID = supplier_master.stateID
left outer join pbt_award_contractors pa on pa.supplierID = supplier_master.supplierID
left outer join dbo.pbt_project_stage c ON c.stageID = pa.stageID 
left outer join dbo.pbt_project_master d ON d.bidID = c.bidID
left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
left outer join sup_cat_log on sup_cat_log.supplierid = supplier_master.supplierid 
 left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
where 1=1
and d.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" > 
and (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5)) AND (d.paintpublishdate >= '1/1/12') 
and pa.awarded = 1		
				<cfif isdefined("arguments.cstate_field") and arguments.cstate_field NEQ "0" and arguments.cstate_field NEQ "">
					and supplier_master.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.cstate_field#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0" and arguments.state_field NEQ "">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0" and arguments.structure_field NEQ "">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
				<cfif isdefined("arguments.company_type_field") and arguments.company_type_field NEQ "0" and arguments.company_type_field NEQ "">
					and sup_cat_log.directory in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.company_type_field#" >)
				</cfif>
				<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or --(a.paintpublishdate >= '1/1/2012' and a.paintpublishdate < '1/1/2013')
						(DATEPART(year,d.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,d.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,d.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,d.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,d.paintpublishdate) = '2014')
						or (DATEPART(year,d.paintpublishdate) = '2015')
						or (DATEPART(year,d.paintpublishdate) = '2016')
						or (DATEPART(year,d.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
		order by numberofprojects desc		
	</cfquery>

<cfreturn top_contractor_query />
		
</cffunction>


<cffunction name="get_Results" access="remote" output="true" returntype="Query"  >
	<cfargument name="supplierID" type="numeric" required="true" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
			<!---cfstoredproc procedure="pbt_contrak_contractor_profile_metrics_projects" datasource="pbt_analytics">
				<cfprocparam type="in" dbvarname="@supplierID" cfsqltype="CF_SQL_INTEGER" value="#supplierID#">
				<cfprocparam type="in" dbvarname="@structure_types" cfsqltype="CF_SQL_VARCHAR" value="1">
				<cfprocparam type="in" dbvarname="@states" cfsqltype="CF_SQL_INTEGER" value="1">
				<cfprocparam type="in" dbvarname="@fromdate" cfsqltype="CF_SQL_DATE" value="1">
				<cfprocparam type="in" dbvarname="@TOdate" cfsqltype="CF_SQL_DATE" value="1">
				<!---cfprocparam type="in" dbvarname="@nl_versionID" cfsqltype="CF_SQL_INTEGER" value="#nl_versionid#"--->
				<cfprocresult name="results_query" resultset="3">
			</cfstoredproc--->
	<cfquery name="results_query">	
		select distinct a.bidID,a.projectname,a.owner,sm.companyname as agencyname,pd.city,st.state,a.paintpublishdate,sm.supplierID as owner_supplierID
		from pbt_project_master a 
		left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
		left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
		left outer join pbt_project_stage ps on ps.bidid = a.bidid and ps.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
		left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
		left outer join state_master st on st.stateID = pd.stateID
		left outer join supplier_master sm on sm.supplierID = a.supplierID
		left outer join supplier_master sm1 on sm1.supplierID = pa.supplierID
		left outer join pbt_project_engineers pe on pe.engineerID = a.engineerID
		where pe.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" > 
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
				<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,a.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,a.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,a.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,a.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,a.paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,a.paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,a.paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,a.paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
		and a.verifiedpaint = 1 
			and pa.awarded is null
			and (a.status IN (3, 5))
			and ps.bidtypeID = 6
		order by a.paintpublishdate desc
	</cfquery>
<cfreturn results_query />
		
</cffunction>


<cffunction name="get_Expired" access="remote" output="true" returntype="Query"  >
	<cfargument name="supplierID" type="numeric" required="true" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
			<!---cfstoredproc procedure="pbt_contrak_contractor_profile_metrics_projects" datasource="pbt_analytics">
				<cfprocparam type="in" dbvarname="@supplierID" cfsqltype="CF_SQL_INTEGER" value="#supplierID#">
				<cfprocparam type="in" dbvarname="@structure_types" cfsqltype="CF_SQL_VARCHAR" value="1">
				<cfprocparam type="in" dbvarname="@states" cfsqltype="CF_SQL_INTEGER" value="1">
				<cfprocparam type="in" dbvarname="@fromdate" cfsqltype="CF_SQL_DATE" value="1">
				<cfprocparam type="in" dbvarname="@TOdate" cfsqltype="CF_SQL_DATE" value="1">
				<!---cfprocparam type="in" dbvarname="@nl_versionID" cfsqltype="CF_SQL_INTEGER" value="#nl_versionid#"--->
				<cfprocresult name="results_query" resultset="3">
			</cfstoredproc--->
	<cfquery name="expired_query">	
		select distinct a.bidID,a.owner,a.projectname,sm.companyname as agencyname,pd.city,st.state,a.paintpublishdate
		from pbt_project_master a 
		left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
		left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
		left outer join pbt_project_stage ps on ps.bidid = a.bidid and ps.stageID = (select max(stageID) from pbt_project_stage where bidID = a.bidid )
		left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
		left outer join state_master st on st.stateID = pd.stateID
		left outer join supplier_master sm on sm.ownerID = a.ownerID
		left outer join pbt_project_engineers pe on pe.engineerID = a.engineerID
		where pe.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" > 
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
				<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,a.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,a.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,a.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,a.paintpublishdate) = '2017')
					</cfif>
				
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,a.paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,a.paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,a.paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,a.paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
		and a.verifiedpaint = 1 
			and pa.awarded is null
			and (a.status IN (3, 5))
			and ps.bidtypeID in (22,23,25)
		order by a.paintpublishdate desc
	</cfquery>
<cfreturn expired_query />
		
</cffunction>

<cffunction name="getContractorColBased3" access="remote" returnFormat="JSON" output="false">
	<cfargument name="querySearchString" type="string" required="true" default="" />
	
<cfquery name="getContractor3">	
	select distinct sm1.supplierID,sm1.companyname as contractor,sm1.city,st1.fullname
	from pbt_project_master a 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join state_master st on st.stateID = pd.stateID
	left outer join supplier_master sm1 on sm1.supplierID = pa.supplierID
	left outer join state_master st1 on st1.stateID = sm1.stateID
	where a.verifiedpaint = 1 	
				<cfif isdefined("arguments.querySearchString") and arguments.querySearchString NEQ "">
				and sm1.companyname like <cfqueryparam cfsqltype="CF_SQL_STRING" value="%#arguments.querySearchString#%" >
				</cfif>
		<!---year filters--->
				and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
				)
		--and pa.awarded = 1
		and (a.status IN (3, 5))
		and ps.bidtypeID in (5,6)
		and sm1.supplierID <> 9000
		group by sm1.companyname,sm1.supplierID,sm1.city,st1.fullname
	order by sm1.companyname
</cfquery>
<cfreturn getContractor3 />
		
</cffunction>

	<cffunction name="getContractorRowBased3" access="remote" returnFormat="JSON" output="false" > 
		 <cfargument name="querySearchString" type="string" required="true" default="" />
		<cfset variables.getContractor3 = getContractorColBased3(arguments.querySearchString)>
		<cfset ContractorStruct3 = QueryToStruct(variables.getContractor3) />
		<cfreturn ContractorStruct3>
	</cffunction>


    <cffunction name="QueryToStruct" access="public" returntype="any" output="false"
    hint="Converts an entire query or the given record to a struct. This might return a structure (single record) or an array of structures.">

    <!--- Define arguments. --->
    <cfargument name="Query" type="query" required="true" />
    <cfargument name="Row" type="numeric" required="false" default="0" />

    <cfscript>

    // Define the local scope.
    var LOCAL = StructNew();

    // Determine the indexes that we will need to loop over.
    // To do so, check to see if we are working with a given row,
    // or the whole record set.
    if (ARGUMENTS.Row){

    // We are only looping over one row.
    LOCAL.FromIndex = ARGUMENTS.Row;
    LOCAL.ToIndex = ARGUMENTS.Row;

    } else {

    // We are looping over the entire query.
    LOCAL.FromIndex = 1;
    LOCAL.ToIndex = ARGUMENTS.Query.RecordCount;

    }

    // Get the list of columns as an array and the column count.
    LOCAL.Columns = ListToArray( ARGUMENTS.Query.ColumnList );
    LOCAL.ColumnCount = ArrayLen( LOCAL.Columns );

    // Create an array to keep all the objects.
    LOCAL.DataArray = ArrayNew( 1 );

    // Loop over the rows to create a structure for each row.
    for (LOCAL.RowIndex = LOCAL.FromIndex ; LOCAL.RowIndex LTE LOCAL.ToIndex ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){

    // Create a new structure for this row.
    ArrayAppend( LOCAL.DataArray, StructNew() );

    // Get the index of the current data array object.
    LOCAL.DataArrayIndex = ArrayLen( LOCAL.DataArray );

    // Loop over the columns to set the structure values.
    for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE LOCAL.ColumnCount ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){

    // Get the column value.
    LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];

    // Set column value into the structure.
    LOCAL.DataArray[ LOCAL.DataArrayIndex ][ LOCAL.ColumnName ] = ARGUMENTS.Query[ LOCAL.ColumnName ][ LOCAL.RowIndex ];

    }

    }


    // At this point, we have an array of structure objects that
    // represent the rows in the query over the indexes that we
    // wanted to convert. If we did not want to convert a specific
    // record, return the array. If we wanted to convert a single
    // row, then return the just that STRUCTURE, not the array.
 

    </cfscript>
    
    <cfset jsonPacket = structNew()>
	<cfset jsonPacket.rows = LOCAL.DataArray>
	<cfset jsonPacket.recordCount = arrayLen(LOCAL.DataArray)>
	<cfset temp = arrayAppend(LOCAL.DataArray, 1)>
	
	<cfreturn jsonPacket>
	
    </cffunction>


<!---cffunction name="pull_engineer_results" access="remote" output="true" returntype="Query"  >
	<cfargument name="engineerID" type="numeric" required="false" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="agencylist" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
			<!---cfstoredproc procedure="pbt_contrak_contractor_profile_metrics_projects" datasource="pbt_analytics">
				<cfprocparam type="in" dbvarname="@supplierID" cfsqltype="CF_SQL_INTEGER" value="#supplierID#">
				<cfprocparam type="in" dbvarname="@structure_types" cfsqltype="CF_SQL_VARCHAR" value="1">
				<cfprocparam type="in" dbvarname="@states" cfsqltype="CF_SQL_INTEGER" value="1">
				<cfprocparam type="in" dbvarname="@fromdate" cfsqltype="CF_SQL_DATE" value="1">
				<cfprocparam type="in" dbvarname="@TOdate" cfsqltype="CF_SQL_DATE" value="1">
				<!---cfprocparam type="in" dbvarname="@nl_versionID" cfsqltype="CF_SQL_INTEGER" value="#nl_versionid#"--->
				<cfprocresult name="awards_query" resultset="1">
			</cfstoredproc--->
<cfquery name="getengineerResults">	
	select distinct sm1.engineerID,sm1.companyname as agencyname,sm1.city,st1.fullname
	from pbt_project_master a 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_project_engineers sm1 on sm1.engineerID = a.engineerID
	left outer join state_master st1 on st1.stateID = sm1.stateID
	where a.verifiedpaint = 1 	
				<cfif isdefined("arguments.agencylist") and arguments.agencylist NEQ "0">
					and a.engineerID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.agencylist#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
		<!---year filters--->
				and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2012')
						or (DATEPART(year,a.paintpublishdate) = '2013')
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
				)
		--and pa.awarded = 1
		and (a.status IN (3, 5))
		and sm1.engineerID <> 9000
		and (sm1.companyname <> '' and sm1.companyname is not null)
		and a.engineerID is not null
		and sm1.engineerID is not null
		group by sm1.companyname,sm1.engineerID,sm1.city,st1.fullname,ppc.tagID 
	order by sm1.companyname
</cfquery>
<cfreturn getEngineerResults />
		
</cffunction--->

<cffunction name="pull_engineer_results" access="remote" output="true" returntype="Any" >
	<cfargument name="iDisplayStart" type="numeric" required="true" default="0" />
	<cfargument name="iDisplayLength" type="numeric" required="true" default="10" />
	<cfargument name="sSearch" type="string" required="false" default=""/>
	<cfargument name="iSortingCols" type="numeric" required="false" default="0"/>
	<cfargument name="state_field" type="string" required="false" default="66" />
	<cfargument name="agency_name" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="All" />
	<cfargument name="iSortCol_0" type="numeric" required="false" default="0"/>
	<cfargument name="sSortDir_0" type="string" required="false" default=""/>
	<cfargument name="contract_type_field" type="numeric" required="false" default="4" />
	<cfargument name="specification_field" type="string" required="false" default="0" />
	<cfset endRow = iDisplayStart + arguments.iDisplayLength>
	<cfparam name="url.iDisplayStart" default="0" type="integer" />
	

	<cfset variables.agencylist = "">
	 <cfset date = #CREATEODBCDATETIME(NOW())#>
	<cfif isdefined("arguments.sSearch") and arguments.sSearch NEQ "">
		<cfset variables.agency_name = arguments.sSearch>
	<cfelseif isdefined("arguments.agency_name") and arguments.agency_name NEQ "">
		<cfset variables.agency_name = arguments.agency_name>
	</cfif>
    <cfif len(trim(arguments.sSearch)) or (isdefined("arguments.agency_name") and arguments.agency_name NEQ "")>
		<cfsearch name="engineer_results" collection="contrak_engineer_search" criteria="#variables.agency_name#">
			<cfif engineer_results.recordcount GT 0>
			   <cfset variables.agencylist = listappend(agencylist,valuelist(engineer_results.key))>
			<cfelse>
				<cfset variables.agencylist = "">
			 </cfif>
	</cfif>	


    	
	  <cfset listColumns = "rownum,engineerID,companyname,billingaddress,city,state,phonenumber,emailaddress,websiteurl" />
	  <cfset slistColumns = "pbt_project_engineers.engineerID,pbt_project_engineers.companyname,sm1.billingaddress,pbt_project_engineers.city,state_master.fullname,sm1.phonenumber,sm1.emailaddress,sm1.websiteurl" />
<!--- Indexed column 
<cfset sIndexColumn = "supplierID" />--->
	  
<cfquery name = "qfiltered1"> 
select engineerID,agencyname,billingaddress,city,fullname,rownum,phonenumber, emailaddress, websiteUrl
			from 
			(
			SELECT  *,ROW_NUMBER() OVER ( 
		ORDER BY 
			<cfif isdefined("arguments.iSortCol_0")>
				<cfswitch expression="#arguments.iSortCol_0#">
					<cfcase value="2">
						agencyname #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="3">
						city #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="4">
						fullname #arguments.sSortDir_0#
					</cfcase>
					<cfdefaultcase>
						agencyname asc
					</cfdefaultcase>
				</cfswitch>
			<cfelse>
				agencyname asc
			</cfif>
				
			) AS RowNum
			FROM    (

select distinct sm1.engineerID,sm1.companyname as agencyname,sm1.city,st1.fullname,COALESCE(sm1.billingaddress, 'N/A') as billingaddress,COALESCE(sm1.phonenumber, 'N/A') as phonenumber,COALESCE(sm1.emailaddress, 'N/A') as emailaddress,COALESCE(sm1.websiteurl, 'N/A') as websiteurl
	from pbt_project_master a 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
	left outer join pbt_project_master_cats ppc2 on ppc2.bidID = a.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_project_engineers sm1 on sm1.engineerID = a.engineerID
	left outer join state_master st1 on st1.stateID = sm1.stateID
	where a.verifiedpaint = 1 	
				<cfif isdefined("variables.agencylist") and arguments.agency_name NEQ "0" and arguments.agency_name NEQ "">
					and sm1.engineerID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#variables.agencylist#" >)
				</cfif>
				<cfif len(trim(arguments.sSearch)) and isdefined("arguments.sSearch") and arguments.sSearch NEQ "0" and arguments.sSearch NEQ "">
					and sm1.engineerID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#variables.agencylist#" >)
				</cfif>
				<cfif isdefined("arguments.cstate_field") and arguments.cstate_field NEQ "0" and arguments.cstate_field NEQ "">
					and sm1.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.cstate_field#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "66" and arguments.state_field NEQ "">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0" and arguments.structure_field NEQ "">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
				<cfif isdefined("arguments.contract_type_field") and arguments.contract_type_field NEQ "4" and arguments.contract_type_field NEQ "">
					and a.valuetypeID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contract_type_field#" >)
				</cfif>
				<cfif isdefined("arguments.specification_field") and arguments.specification_field NEQ "0" and arguments.specification_field NEQ "">
					and ppc2.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.specification_field#" >)
				</cfif>
		<!---year filters--->
			<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
				and (1 <> 1 
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,a.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,a.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,a.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,a.paintpublishdate) = '2017')
					</cfif>
				)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
		--and pa.awarded = 1
		and (a.status IN (3, 5))
		and sm1.engineerID <> 9000
		and (sm1.companyname <> '' and sm1.companyname is not null)
		and a.engineerID is not null
		and sm1.engineerID is not null
		
		
		 ) AS RowConstrainedResult
			) as filterResult
			
			WHERE   RowNum >= #arguments.iDisplayStart# + 1
    		AND RowNum <= #endRow#
</cfquery>
<!--- Total data set length --->
<cfquery name="qCount">
select distinct sm1.engineerID
	from pbt_project_master a 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
	left outer join pbt_project_master_cats ppc2 on ppc2.bidID = a.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_project_engineers sm1 on sm1.engineerID = a.engineerID
	left outer join state_master st1 on st1.stateID = sm1.stateID
	where a.verifiedpaint = 1 
				<cfif isdefined("variables.agencylist") and arguments.agency_name NEQ "0" and arguments.agency_name NEQ "">
					and sm1.engineerID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#variables.agencylist#" >)
				</cfif>
				<cfif len(trim(arguments.sSearch)) and isdefined("arguments.sSearch") and arguments.sSearch NEQ "0" and arguments.sSearch NEQ "">
					and sm1.engineerID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#variables.agencylist#" >)
				</cfif>
				<cfif isdefined("arguments.cstate_field") and arguments.cstate_field NEQ "0" and arguments.cstate_field NEQ "">
					and sm1.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.cstate_field#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "66" and arguments.state_field NEQ "">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0" and arguments.structure_field NEQ "">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
				<cfif isdefined("arguments.contract_type_field") and arguments.contract_type_field NEQ "4" and arguments.contract_type_field NEQ "">
					and a.valuetypeID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contract_type_field#" >)
				</cfif>
				<cfif isdefined("arguments.specification_field") and arguments.specification_field NEQ "0" and arguments.specification_field NEQ "">
					and ppc2.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.specification_field#" >)
				</cfif>
				<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
					and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,a.paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,a.paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,a.paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,a.paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						)
				</cfif>
				<!---qtr filters--->
				<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "all">
				and (1 <> 1 
					
					<cfif listfind(quarter_field,"q1")>
						or (DATEPART(quarter,paintpublishdate) = 1)
					</cfif>
					<cfif listfind(quarter_field,"q2")>
						or (DATEPART(quarter,paintpublishdate) = 2)
					</cfif>
					<cfif listfind(quarter_field,"q3")>
						or (DATEPART(quarter,paintpublishdate) = 3)
					</cfif>
					<cfif listfind(quarter_field,"q4")>
						or (DATEPART(quarter,paintpublishdate) = 4)
					</cfif>
				
				)
				</cfif>
				   <!---cfif len(trim(arguments.sSearch))>
						and 
						(
						<cfloop list="#slistColumns2#" index="thisColumn"><cfif thisColumn neq listFirst(slistColumns2)> OR </cfif>#thisColumn# LIKE <cfif thisColumn is "version"><!--- special case ---><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#val(arguments.sSearch)#" /><cfelse><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#trim(arguments.sSearch)#%" /></cfif></cfloop>
						)
				  </cfif--->
				
				and (a.status IN (3, 5))
		and sm1.engineerID <> 9000
		and (sm1.companyname <> '' and sm1.companyname is not null)
		and a.engineerID is not null
		and sm1.engineerID is not null 
	--order by sm1.companyname
</cfquery>
	

		<cfset metricQuery = QueryNew("engineerID,companyname,city,state,rownum,phonenumber,billingaddress,emailaddress,websiteurl","integer,VarChar,VarChar,varchar,integer,VarChar,VarChar,VarChar,VarChar")>
		<cfset counter=0>
		<cfloop query="qfiltered1">
			
														
		<cfset newRow = QueryAddRow(metricQuery, 1)>
		<cfset counter=counter+1>
		<cfset temp = QuerySetCell(metricQuery, "engineerID", "#qfiltered1.engineerID#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "companyname", "#agencyname#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "city", "#city#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "state", "#fullname#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "rownum", "#rownum#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "phonenumber", "#trim(phonenumber)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "billingaddress", "#trim(billingaddress)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "emailaddress", "#trim(emailaddress)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "websiteurl", "#trim(websiteurl)#", #counter#)>
		</cfloop>

	<cfquery name="qfiltered" dbtype="query">
		select  rownum,
		   engineerID,
		  companyname,
		  city,
		  state,
		  phonenumber,
		  billingaddress,
		  emailaddress,
		  websiteurl
		  from metricQuery
	</cfquery>

<!---set filters--->

	<!---set the filter year--->
	<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "">
		<cfset variables.filter_year = arguments.year_field>
	<cfelse>
		<cfset variables.filter_year = "2016">
	</cfif>
	<!---set the filter qtr--->
	<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "">
		<cfset variables.filter_quarter = arguments.quarter_field>
	<cfelse>
		<cfset variables.filter_quarter = "All">
	</cfif>
	<cfinvoke  
		component="#Application.CFCPath#.engineer_profile"  
		method="get_filter_Industry"  
		returnVariable="get_filter_Industry"> 
				<cfinvokeargument name="structure_field" value="#arguments.structure_field#"/> 
	</cfinvoke>	
	<cfif get_filter_Industry.recordcount GT 0>
		<cfset variables.filter_industry = valuelist(get_filter_industry.tag)>
	<cfelse>
		<cfparam name="variables.filter_industry" default="All">
	</cfif>		
		
	<cfinvoke  
		component="#Application.CFCPath#.engineer_profile"  
		method="get_Filter_state"  
		returnVariable="get_Filter_state"> 
				<cfinvokeargument name="state_field" value="#arguments.state_field#"/> 
	</cfinvoke>
	<cfif get_Filter_state.recordcount GT 0>	
		<cfset variables.filter_state = valuelist(get_Filter_state.state)>
	<cfelse>
		<cfparam name="variables.filter_state" default="All">	
	</cfif>
	<cfinvoke  
		component="#Application.CFCPath#.engineer_profile"  
		method="get_filter_CT"  
		returnVariable="get_filter_CT"> 
				<cfinvokeargument name="contract_type_field" value="#arguments.contract_type_field#"/> 
	</cfinvoke>	
	<cfif get_filter_CT.recordcount GT 0>
		<cfset variables.filter_contract_type = valuelist(get_filter_CT.value_type)>
	<cfelse>
		<cfparam name="variables.filter_contract_type" default="All">
	</cfif>	
	<cfset filter_data = "Year: #variables.filter_year#, QTR: #variables.filter_quarter#, State:#variables.filter_state#, Structure Type: #variables.filter_industry#, Contract Type: #variables.filter_contract_type#">
	
	
<!--- 
Output
--->
<cfcontent reset="Yes" />
{"sEcho": <cfoutput>#val(url.sEcho)#</cfoutput>, 
"iTotalRecords": <cfoutput>#qCount.recordcount#</cfoutput>, 
"iTotalDisplayRecords": <cfoutput>#qCount.recordcount#</cfoutput>, 
"filterData":"<cfoutput>#filter_data#</cfoutput>",
"aaData": [ 
<cfoutput query="qFiltered" >
<cfif currentRow LT (qFiltered.rownum + 1) and currentrow NEQ 1>,</cfif>
[<cfloop list="#listColumns#" index="thisColumn"><cfif thisColumn neq listFirst(listColumns)>,</cfif><cfif thisColumn is "version"><cfif version eq 0>"-"<cfelse>"#jsStringFormat(version)#"</cfif><cfelse>#serializeJSON(qFiltered[thisColumn][qFiltered.currentRow])#</cfif></cfloop>]
</cfoutput> ] }
	
</cffunction>			


<cffunction name="pull_contacts" access="remote" output="true" returntype="Query"  >
	<cfargument name="engineerID" type="numeric" required="false" default="0" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
		
<cfquery name="getContactResults">	
	select distinct a.name,a.emailaddress,e.contact_type,a.contact_title,a.department,a.phonenumber,a.faxnumber
	from  pbt_project_contacts a
	left outer join pbt_project_master b on b.bidID = a.bidID
	left outer join pbt_project_engineers c on c.engineerID = b.engineerID
	left outer join pbt_contact_types e on e.contact_typeID = a.contact_typeID
	where c.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
	and a.active = 1 
	and b.verifiedpaint = 1	
		<!---year filters--->
				and (1 <> 1 
						or (DATEPART(year,b.paintpublishdate) = '2014')
						or (DATEPART(year,b.paintpublishdate) = '2015')
						or (DATEPART(year,b.paintpublishdate) = '2016')
						or (DATEPART(year,b.paintpublishdate) = '2017')
				)
		--and pa.awarded = 1
		and (b.status IN (3, 5))
		and c.engineerID <> 9000
		and a.name is not null
		and a.name <> ''
		and e.contact_typeID = 3
		group by a.name,a.emailaddress,e.contact_type,a.contact_title,a.department,a.phonenumber,a.faxnumber
	order by a.name
</cfquery>
<cfreturn getContactResults />
		
</cffunction>




<cffunction name="pull_contractor_revenue" access="remote" output="true" returntype="Query"  >
	<cfargument name="supplierID" type="numeric" required="true" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="engineerID" type="numeric" required="false" default="0" />
<cfquery name="total_revenue">
		--get the volume won
	select pa.supplierID, 
	sum(cast(amount as numeric(20,3))) as bidAmount
	from pbt_project_master o 
	left outer join pbt_project_stage ps on ps.bidid = o.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	inner join
	( 
	select pc.bidID as bidID, amount as bidamount
	from pbt_project_master_cats pc
	left outer join pbt_project_master a on a.bidid = pc.bidid
	left outer join pbt_project_stage ps on ps.bidid = pc.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	where a.engineerID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.engineerID#" >
		and a.verifiedpaint = 1 
		and pa.awarded = 1
		and (a.status IN (3, 5))
		and ps.bidtypeID in (5)
		<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
			and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
		</cfif>
		<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
			and pc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
		</cfif>
		<cfif isdefined("arguments.owner_supplierID") and arguments.owner_supplierID NEQ "0">
			and  a.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.owner_supplierID#" >
		</cfif>
		
		<!---year filters--->
				and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
				)
	group by pc.bidid,amount
	) d 
	on o.bidID = d.bidID 
	and pa.supplierid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
	group by pa.supplierid
   </cfquery>
<cfreturn total_revenue />	
</cffunction>


</cfcomponent>