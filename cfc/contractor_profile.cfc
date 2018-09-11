<cfcomponent>
<cffunction name="pull_company_details" access="remote" output="true" returntype="Query" returnformat="JSON" >
	<cfargument name="supplierID" type="numeric" required="true" default="0" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
	
<!--- Query the database to get comp details. ---> 
<cfquery name="getContractor">
		SELECT distinct supplier_master.supplierID, supplier_master.companyname,supplier_master.billingaddress,supplier_master.city,supplier_master.postalcode as zipcode,state_master.state,
		supplier_master.phonenumber,supplier_master.faxnumber,supplier_master.emailaddress,supplier_master.stateID,supplier_master.logo,supplier_master.websiteurl
        FROM supplier_master 
        left outer join sup_cat_log on sup_cat_log.supplierid = supplier_master.supplierid 
        left outer join pbt_contractor_type pct on pct.typeID = sup_cat_log.directory
		left outer join state_master on state_master.stateid = supplier_master.stateid
		where sup_cat_log.directory in (1,6,99) and supplier_master.companyname <> ''
		and supplier_master.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
        ORDER BY supplier_master.companyname
		</cfquery>
<cfreturn getContractor />
	
</cffunction>


<cffunction name="get_Additional_industries" access="remote" output="true" returntype="Query"  >
	<cfargument name="supplierID" type="numeric" required="true" default="0" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
	<cfquery name="get_Additional_industries">
		SELECT DISTINCT top 5 pb.tag,count(d.bidID) as numproj
		FROM  dbo.supplier_master AS a 
		INNER JOIN dbo.pbt_award_contractors AS b ON a.supplierID = b.supplierID
		LEFT OUTER JOIN dbo.pbt_project_stage AS c ON c.stageID = b.stageID 
		LEFT OUTER JOIN dbo.pbt_project_master AS d ON d.bidID = c.bidID 
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
				and a.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
				AND (ppc.tagID IN 
				(SELECT DISTINCT dbo.pbt_tags.tagID 
				  FROM dbo.pbt_tags 
				  INNER JOIN dbo.pbt_tag_packages AS pt ON pt.tagID = dbo.pbt_tags.tagID 
				  inner join site_tag_xref x on pbt_tags.tagID = x.tagID 
				  WHERE  (pt.packageID IN (1))  AND (dbo.pbt_tags.tag_typeID = 1) AND (dbo.pbt_tags.tag_parentID <> 0)
			      and x.siteID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.siteID#" />
				  ))
				  group by pb.tag
				  order by numproj desc
		</cfquery>

<cfreturn get_Additional_industries />
	
</cffunction>

<cffunction name="get_CompanyType" access="remote" output="true" returntype="Query"  >
	<cfargument name="supplierID" type="numeric" required="true" default="0" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
	<cfquery name="get_CompanyType">
		SELECT DISTINCT pct.contractor_type,pct.typeID
		FROM supplier_master 
        left outer join sup_cat_log on sup_cat_log.supplierid = supplier_master.supplierid 
        left outer join pbt_contractor_type pct on pct.typeID = sup_cat_log.directory
		left outer join state_master on state_master.stateid = supplier_master.stateid
		where sup_cat_log.directory in (1,6,99) and supplier_master.companyname <> ''
		and supplier_master.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
		</cfquery>

<cfreturn get_CompanyType />
	
</cffunction>

<cffunction name="get_Additional_states" access="remote" output="true" returntype="Query"  >
	<cfargument name="supplierID" type="numeric" required="true" default="0" />
	
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
					and a.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
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

<cffunction name="get_Additional_locations" access="remote" output="true" returntype="Query"  >
	<cfargument name="supplierID" type="numeric" required="true" default="0" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
	<cfquery name="get_Additional_locations">
		SELECT distinct supplier_master.supplierID,supplier_master.city,st.state
		from supplier_master
		left outer join state_master st on st.stateID = supplier_master.stateID
		left outer join sup_cat_log on sup_cat_log.supplierid = supplier_master.supplierid 
		where supplier_master.parentID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
		and supplier_master.supplierID <> <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
		and sup_cat_log.directory in (1,6,99) 
		</cfquery>

<cfreturn get_Additional_locations />
	
</cffunction>


<cffunction name="get_Filter_Industry" access="remote" output="true" returntype="Query"  >
	<cfargument name="structure_field" type="string" required="true" default="0" />
	<cfquery name="get_filter_Industry">
		SELECT pbt_tags.tag
		from pbt_tags
		 inner join site_tag_xref x on pbt_tags.tagID = x.tagID 
		WHERE  tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
		 and siteID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.siteID#" />
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

<cffunction name="get_Filter_CP" access="remote" output="true" returntype="Query"  >
	<cfargument name="company_type_field" type="string" required="true" default="0" />
	<cfquery name="get_filter_CP">
		SELECT contractor_type,typeID
		from pbt_contractor_type
		WHERE  typeID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.company_type_field#" >)
		
	</cfquery>

<cfreturn get_filter_CP />
</cffunction>

<cffunction name="get_Metrics" access="remote" output="true" returntype="Query"  >
	<cfargument name="supplierID" type="numeric" required="true" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
			<!---cfstoredproc procedure="pbt_contrak_contractor_profile_metrics" >
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
			where pa.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
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
			group by pc.bidid,amount
			) d 
			on o.bidID = d.bidID 
			and pa.supplierid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
			group by pa.supplierid
		</cfquery>
	
	
	
	<cfquery name="volume_won">
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
	where pa.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
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
	and pa.supplierid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
	group by pa.supplierid
   </cfquery>

    <cfquery name="largest_win">
	--get the largest win
	select max(pa.amount) as winamount
	from pbt_project_master a
	left outer join pbt_project_master_cats pmc on pmc.bidID = a.bidID
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	where pa.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
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
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	where pa.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#supplierID#" >
	and a.verifiedpaint = 1 
	and (a.status IN (3, 5))
	and ps.bidtypeID in (5,6)
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
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	where pa.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#supplierID#" >
	and a.verifiedpaint = 1 
	and pa.awarded = 1
	and (a.status IN (3, 5))
	and ps.bidtypeID in (5,6)
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
		select pa.supplierID, 
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
	where pa.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
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
	and pa.supplierid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
	group by pa.supplierid
	</cfquery>
	
		<cfquery name="eng_estimate">	
			--get the cost estimate sum
			select pa.supplierID, 
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
			where pa.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
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
			group by pc.bidid,a.minimumvalue
			) d 
			on o.bidID = d.bidID 
			and pa.supplierid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
			group by pa.supplierid
		</cfquery>


		<cfset metricQuery = QueryNew("volume_bid,volume_won,largest_win,numberbid,numberwon,leftontable,eng_estimate","Decimal,Decimal,Decimal,integer,integer,Decimal,Decimal")>
		<cfset counter=0>
		
		<cfset newRow = QueryAddRow(metricQuery, 1)>
		<cfset counter=counter+1>
		<cfset temp = QuerySetCell(metricQuery, "volume_bid", "#volume_bid.bidamount#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "volume_won", "#volume_won.bidamount#", #counter#)>
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
	<cfargument name="supplierID" type="numeric" required="true" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
			<!---cfstoredproc procedure="pbt_contrak_contractor_profile_metrics_projects" >
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
	where sm1.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" > 
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

<cffunction name="get_Agency" access="remote" output="true" returntype="Query"  >
	<cfargument name="supplierID" type="numeric" required="true" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
			<!---cfstoredproc procedure="pbt_contrak_contractor_profile_metrics_projects" >
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
	where sm1.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" > 
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
	group by sm.supplierID,a.owner,sm.companyname,st.state
	order by numberofprojects desc
	</cfquery>

<cfreturn agency_query />
	
</cffunction>


<cffunction name="get_Results" access="remote" output="true" returntype="Query"  >
	<cfargument name="supplierID" type="numeric" required="true" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
			<!---cfstoredproc procedure="pbt_contrak_contractor_profile_metrics_projects" >
				<cfprocparam type="in" dbvarname="@supplierID" cfsqltype="CF_SQL_INTEGER" value="#supplierID#">
				<cfprocparam type="in" dbvarname="@structure_types" cfsqltype="CF_SQL_VARCHAR" value="1">
				<cfprocparam type="in" dbvarname="@states" cfsqltype="CF_SQL_INTEGER" value="1">
				<cfprocparam type="in" dbvarname="@fromdate" cfsqltype="CF_SQL_DATE" value="1">
				<cfprocparam type="in" dbvarname="@TOdate" cfsqltype="CF_SQL_DATE" value="1">
				<!---cfprocparam type="in" dbvarname="@nl_versionID" cfsqltype="CF_SQL_INTEGER" value="#nl_versionid#"--->
				<cfprocresult name="results_query" resultset="3">
			</cfstoredproc--->
	<cfquery name="results_query">	
		select distinct a.bidID,a.projectname,a.owner,sm.companyname as agencyname,pd.city,st.state,sm1.companyname as contractor,a.paintpublishdate,pa.amount,sm.supplierID as owner_supplierID
		from pbt_project_master a 
		left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
		left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
		left outer join pbt_project_stage ps on ps.bidid = a.bidid
		left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
		left outer join state_master st on st.stateID = pd.stateID
		left outer join supplier_master sm on sm.supplierID = a.supplierID
		left outer join supplier_master sm1 on sm1.supplierID = pa.supplierID
		where sm1.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" > 
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
						or --(a.paintpublishdate >= '1/1/2012' and a.paintpublishdate < '1/1/2013')
						(DATEPART(year,a.paintpublishdate) = '2014')
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
		order by a.paintpublishdate desc
	</cfquery>
<cfreturn results_query />
	
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


<cffunction name="pull_contractor_results" access="remote" output="true" returntype="Query"  >
	<cfargument name="supplierID" type="numeric" required="false" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="contractorlist" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
			<!---cfstoredproc procedure="pbt_contrak_contractor_profile_metrics_projects" >
				<cfprocparam type="in" dbvarname="@supplierID" cfsqltype="CF_SQL_INTEGER" value="#supplierID#">
				<cfprocparam type="in" dbvarname="@structure_types" cfsqltype="CF_SQL_VARCHAR" value="1">
				<cfprocparam type="in" dbvarname="@states" cfsqltype="CF_SQL_INTEGER" value="1">
				<cfprocparam type="in" dbvarname="@fromdate" cfsqltype="CF_SQL_DATE" value="1">
				<cfprocparam type="in" dbvarname="@TOdate" cfsqltype="CF_SQL_DATE" value="1">
				<!---cfprocparam type="in" dbvarname="@nl_versionID" cfsqltype="CF_SQL_INTEGER" value="#nl_versionid#"--->
				<cfprocresult name="awards_query" resultset="1">
			</cfstoredproc--->
<cfquery name="getContractorResults">	
	select distinct sm1.supplierID,sm1.companyname as contractor,sm1.city,st1.fullname,
	(
	select 
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
	where pa.supplierID = sm1.supplierID
		and a.verifiedpaint = 1 
		and pa.awarded = 1
		and (a.status IN (3, 5))
		and ps.bidtypeID in (5)
				<cfif isdefined("arguments.contractorlist") and arguments.contractorlist NEQ "0">
					and pa.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
		and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
				)		
	group by pc.bidid,amount
	) d 
	on o.bidID = d.bidID 
	and pa.supplierid = sm1.supplierID
	group by pa.supplierid
) AS award_amount
	from pbt_project_master a 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join state_master st on st.stateID = pd.stateID
	left outer join supplier_master sm1 on sm1.supplierID = pa.supplierID
	left outer join state_master st1 on st1.stateID = sm1.stateID
	where a.verifiedpaint = 1 	
				<cfif isdefined("arguments.contractorlist") and arguments.contractorlist NEQ "0">
					and pa.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
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
		group by sm1.companyname,sm1.supplierID,sm1.city,st1.fullname,ppc.tagID 
	order by sm1.companyname
</cfquery>
<cfreturn getContractorResults />
	
</cffunction>


<cffunction name="pull_contacts_server2" access="remote" output="true" returntype="Any" >
<cfquery name = "qfiltered"> 
	select distinct top 3 sm1.supplierID,sm1.companyname as contractor,sm1.city,st1.fullname

	from pbt_project_master a 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join state_master st on st.stateID = pd.stateID
	left outer join supplier_master sm1 on sm1.supplierID = pa.supplierID
	left outer join state_master st1 on st1.stateID = sm1.stateID
	where a.verifiedpaint = 1 	
				
		
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
		group by sm1.companyname,sm1.supplierID,sm1.city,st1.fullname,ppc.tagID 
	order by sm1.companyname
</cfquery>

<cfcontent reset="Yes" />
{
"iTotalRecords": <cfoutput>#qfiltered.recordcount#</cfoutput>, 
"iTotalDisplayRecords": <cfoutput>#qfiltered.recordcount#</cfoutput>, 
"aaData": [ 
<cfoutput query="qFiltered" >
<cfif currentRow LT (qFiltered.rownum + 1) and currentrow NEQ 1>,</cfif>
[<cfloop list="#listColumns#" index="thisColumn"><cfif thisColumn neq listFirst(listColumns)>,</cfif><cfif thisColumn is "version"><cfif version eq 0>"-"<cfelse>"#jsStringFormat(version)#"</cfif><cfelse>#serializeJSON(qFiltered[thisColumn][qFiltered.currentRow])#</cfif></cfloop>]
</cfoutput> ] }


	
</cffunction>			

<cffunction name="pull_contacts_server3" access="remote" output="true" returntype="Any" >
	<cfargument name="iDisplayStart" type="numeric" required="true" default="0" />
	<cfargument name="iDisplayLength" type="numeric" required="true" default="10" />
	<cfargument name="sSearch" type="string" required="false" default=""/>
	<cfargument name="iSortingCols" type="numeric" required="false" default="0"/>
	<cfargument name="supplierID" type="numeric" required="false" default="0" />
	<cfargument name="state_field" type="string" required="false" default="66" />
	<cfargument name="contractor_name" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />
	<cfargument name="iSortCol_0" type="numeric" required="false" default="0"/>
	<cfargument name="sSortDir_0" type="string" required="false" default=""/>
	<cfargument name="company_type_field" type="numeric" required="false" default="10" />
	<cfargument name="geo_type" type="numeric" required="true" default="2" />
	<cfset endRow = iDisplayStart + arguments.iDisplayLength>
	<cfparam name="url.iDisplayStart" default="0" type="integer" />
	

	<cfset variables.contractorlist = "">
	 <cfset date = #CREATEODBCDATETIME(NOW())#>
	<cfif isdefined("arguments.sSearch") and arguments.sSearch NEQ "">
		<cfset variables.contractor_name = arguments.sSearch>
	<cfelseif isdefined("arguments.contractor_name") and arguments.contractor_name NEQ "">
		<cfset variables.contractor_name = arguments.contractor_name>
	</cfif>
    <cfif len(trim(arguments.sSearch)) or (isdefined("arguments.contractor_name") and arguments.contractor_name NEQ "")>
		<cfsearch name="contractor_results" collection="contrak_contractor_search" criteria="#variables.contractor_name#">
			<cfif contractor_results.recordcount GT 0>
			   <cfset variables.contractorlist = listappend(contractorlist,valuelist(contractor_results.key))>
			<cfelse>
				<cfset variables.contractorlist = "">
			 </cfif>
	</cfif>	
	<cfif isdefined("arguments.geo_type")>
		<cfset variables.geo_type = arguments.geo_type>
	</cfif>
	
	
	  <cfset listColumns = "rownum,supplierID,companyname,city,state" />
	  <cfset slistColumns = "sm1.supplierID,sm1.companyname,sm1.city,st1.state" />
<!--- Indexed column --->
<cfset sIndexColumn = "supplierID" />
	  
<cfquery name = "qfiltered1"> 
select supplierID,CompanyName,city,state,rownum
			from 
			(
			SELECT  *,ROW_NUMBER() OVER ( 
		ORDER BY 
				<cfif isdefined("arguments.iSortCol_0")>
				<cfswitch expression="#arguments.iSortCol_0#">
					<cfcase value="2">
						CompanyName #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="3">
						city #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="4">
						state #arguments.sSortDir_0#
					</cfcase>
					<cfdefaultcase>
						CompanyName asc
					</cfdefaultcase>
				</cfswitch>
			<cfelse>
				CompanyName asc
			</cfif>
				
			) AS RowNum
			FROM    (
				select distinct sm1.supplierID,sm1.companyname,sm1.city,st1.state
	from pbt_project_master a 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join state_master st on st.stateID = pd.stateID
	left outer join supplier_master sm1 on sm1.supplierID = pa.supplierID
	left outer join state_master st1 on st1.stateID = sm1.stateID
	left outer join sup_cat_log on sup_cat_log.supplierid = sm1.supplierid 
	where a.verifiedpaint = 1 	
				
				<cfif isdefined("variables.contractorlist") and arguments.contractor_name NEQ "0" and arguments.contractor_name NEQ "">
					and pa.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#variables.contractorlist#" >)
				</cfif>
				<cfif len(trim(arguments.sSearch)) and isdefined("arguments.sSearch") and arguments.sSearch NEQ "0" and arguments.sSearch NEQ "">
					and pa.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#variables.contractorlist#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "66" and arguments.state_field NEQ "" and (isdefined("variables.geo_type") and variables.geo_type EQ 1)>
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				<cfelseif isdefined("arguments.state_field") and arguments.state_field NEQ "66" and arguments.state_field NEQ "" and (isdefined("variables.geo_type") and variables.geo_type EQ 2)>
					and sm1.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0" and arguments.structure_field NEQ "">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
				<cfif isdefined("arguments.company_type_field") and arguments.company_type_field NEQ "10" and arguments.company_type_field NEQ "">
					and sup_cat_log.directory in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.company_type_field#" >)
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
		
		      
		group by sm1.companyname,sm1.supplierID,sm1.city,st1.state,ppc.tagID 
	
		 ) AS RowConstrainedResult
			) as filterResult
			
			WHERE   RowNum >= #arguments.iDisplayStart# + 1
    		AND RowNum <= #endRow#
    </cfquery> 

<!--- Total data set length --->
<cfquery name="qCount">
    select distinct sm1.supplierID
	from pbt_project_master a 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join state_master st on st.stateID = pd.stateID
	left outer join supplier_master sm1 on sm1.supplierID = pa.supplierID
	left outer join state_master st1 on st1.stateID = sm1.stateID
	left outer join sup_cat_log on sup_cat_log.supplierid = sm1.supplierid 
	where a.verifiedpaint = 1 	
				<cfif isdefined("variables.contractorlist") and arguments.contractor_name NEQ "0" and arguments.contractor_name NEQ "">
					and pa.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#variables.contractorlist#" >)
				</cfif>
				<cfif len(trim(arguments.sSearch)) and isdefined("arguments.sSearch") and arguments.sSearch NEQ "0" and arguments.sSearch NEQ "">
					and pa.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#variables.contractorlist#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "66" and arguments.state_field NEQ "" and (isdefined("variables.geo_type") and variables.geo_type EQ 1)>
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				<cfelseif isdefined("arguments.state_field") and arguments.state_field NEQ "66" and arguments.state_field NEQ "" and (isdefined("variables.geo_type") and variables.geo_type EQ 2)>
					and sm1.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0" and arguments.structure_field NEQ "">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
				<cfif isdefined("arguments.company_type_field") and arguments.company_type_field NEQ "10" and arguments.company_type_field NEQ "">
					and sup_cat_log.directory in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.company_type_field#" >)
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
		
		group by sm1.supplierID
	--order by sm1.companyname
</cfquery>
		<cfset metricQuery = QueryNew("supplierID,companyname,city,state,rownum","integer,VarChar,VarChar,varchar,integer")>
		<cfset counter=0>
		<cfloop query="qfiltered1">
		
														
		<cfset newRow = QueryAddRow(metricQuery, 1)>
		<cfset counter=counter+1>
		<cfset temp = QuerySetCell(metricQuery, "supplierID", "#qfiltered1.supplierID#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "companyname", "#trim(companyname)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "city", "#trim(city)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "state", "#state#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "rownum", "#rownum#", #counter#)>
		</cfloop>

	<cfquery name="qfiltered" dbtype="query">
		select  rownum,
		   supplierID,
		  companyname,
		  city,
		  state
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
		component="#Application.CFCPath#.contractor_profile"  
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
		component="#Application.CFCPath#.contractor_profile"  
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
		component="#Application.CFCPath#.contractor_profile"  
		method="get_filter_CP"  
		returnVariable="get_filter_CP"> 
				<cfinvokeargument name="company_type_field" value="#arguments.company_type_field#"/> 
	</cfinvoke>	
	<cfif get_filter_CP.recordcount GT 0>
		<cfset variables.filter_company_type = valuelist(get_filter_CP.contractor_type)>
	<cfelse>
		<cfparam name="variables.filter_company_type" default="All">
	</cfif>	
	<cfset filter_data = "Year: #variables.filter_year#, QTR: #variables.filter_quarter#, State:#variables.filter_state#, Structure Type: #variables.filter_industry#, Company Type: #variables.filter_company_type#">
	

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




<cffunction name="pull_contacts_server4" access="remote" output="true" returntype="Any" >
	<cfargument name="iDisplayStart" type="numeric" required="true" default="0" />
	<cfargument name="iDisplayLength" type="numeric" required="true" default="10" />
	<cfargument name="sSearch" type="string" required="false" default=""/>
	<cfargument name="iSortingCols" type="numeric" required="false" default="0"/>
	<cfargument name="supplierID" type="numeric" required="false" default="0" />
	<cfargument name="state_field" type="string" required="false" default="66" />
	<cfargument name="contractor_name" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />
	<cfargument name="iSortCol_0" type="numeric" required="false" default="0"/>
	<cfargument name="sSortDir_0" type="string" required="false" default=""/>
	<cfargument name="company_type_field" type="numeric" required="false" default="" />
	<cfargument name="geo_type" type="numeric" required="true" default="2" />
	<cfset endRow = iDisplayStart + arguments.iDisplayLength>
	<cfparam name="url.iDisplayStart" default="0" type="integer" />

	<cfset variables.contractorlist = "">
	 <cfset date = #CREATEODBCDATETIME(NOW())#>
	<cfif isdefined("arguments.sSearch") and arguments.sSearch NEQ "">
		<cfset variables.contractor_name = arguments.sSearch>
	<cfelseif isdefined("arguments.contractor_name") and arguments.contractor_name NEQ "">
		<cfset variables.contractor_name = arguments.contractor_name>
	</cfif>
    <cfif len(trim(arguments.sSearch)) or (isdefined("arguments.contractor_name") and arguments.contractor_name NEQ "")>
		<cfsearch name="contractor_results" collection="contrak_contractor_search" criteria="#variables.contractor_name#">
			<cfif contractor_results.recordcount GT 0>
			   <cfset variables.contractorlist = listappend(contractorlist,valuelist(contractor_results.key))>
			<cfelse>
				<cfset variables.contractorlist = "">
			 </cfif>
	</cfif>	
	<cfif isdefined("arguments.geo_type")>
		<cfset variables.geo_type = arguments.geo_type>
	</cfif>
	
	
	  <cfset listColumns = "rownum,supplierID,companyname,contactName,billingaddress,city,state,phonenumber,emailaddress,websiteUrl" />
	  <cfset slistColumns = "sm1.supplierID,sm1.companyname,sm1.contactName,sm1.billingaddress,sm1.city,st1.state,sm1.phonenumber,sm1.emailaddress,sm1.websiteUrl" />
<!--- Indexed column --->
<cfset sIndexColumn = "supplierID" />
	  
<cfquery name = "qfiltered1"> 
select supplierID,CompanyName,contactName,billingaddress,city,state,phonenumber,rownum, emailaddress, websiteUrl
			from 
			(
			SELECT  *,ROW_NUMBER() OVER ( 
		ORDER BY 
				<cfif isdefined("arguments.iSortCol_0")>
				<cfswitch expression="#arguments.iSortCol_0#">
					<cfcase value="2">
						CompanyName #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="3">
						contactName #arguments.sSortDir_0#
					</cfcase>		
					<cfcase value="4">
						billingaddress #arguments.sSortDir_0#
					</cfcase>								
					<cfcase value="5">
						city #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="6">
						state #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="7">
						phonenumber #arguments.sSortDir_0#
					</cfcase>								
					<cfcase value="8">
						emailaddress #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="9">
						websiteUrl #arguments.sSortDir_0#
					</cfcase>					
					<cfdefaultcase>
						CompanyName asc
					</cfdefaultcase>
				</cfswitch>
			<cfelse>
				CompanyName asc
			</cfif>
				
			) AS RowNum
			FROM    (
				select distinct sm1.supplierID,sm1.companyname,sm1.contactName,sm1.billingaddress,sm1.city,st1.state,sm1.phonenumber,COALESCE(sm1.emailaddress, 'N/A') as emailaddress,COALESCE(sm1.websiteurl, 'N/A') as websiteurl
	from pbt_project_master a 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
	--left outer join pbt_project_master_cats ppc3 on ppc3.bidID = a.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join state_master st on st.stateID = pd.stateID
	left outer join supplier_master sm1 on sm1.supplierID = pa.supplierID
	left outer join state_master st1 on st1.stateID = sm1.stateID
	left outer join sup_cat_log on sup_cat_log.supplierid = sm1.supplierid 
	where 1 = 1 
		<!--- site default --->
		--and ppc3.tagID in (12) <!---water/wastewater--->
				
				<cfif isdefined("variables.contractorlist") and arguments.contractor_name NEQ "0" and arguments.contractor_name NEQ "">
					and pa.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#variables.contractorlist#" >)
				</cfif>
				<cfif len(trim(arguments.sSearch)) and isdefined("arguments.sSearch") and arguments.sSearch NEQ "0" and arguments.sSearch NEQ "">
					and pa.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#variables.contractorlist#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "66" and arguments.state_field NEQ "" and (isdefined("variables.geo_type") and variables.geo_type EQ 1)>
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				<cfelseif isdefined("arguments.state_field") and arguments.state_field NEQ "66" and arguments.state_field NEQ "" and (isdefined("variables.geo_type") and variables.geo_type EQ 2)>
					and sm1.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0" and arguments.structure_field NEQ "">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#">,12)
				</cfif>
				<cfif isdefined("arguments.company_type_field") and arguments.company_type_field NEQ "10" and arguments.company_type_field NEQ "">
					and sup_cat_log.directory in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.company_type_field#" >)
				</cfif>
		<!---year filters--->
				and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						or (DATEPART(year,a.paintpublishdate) = '2018')
				)
		--and pa.awarded = 1
		and (a.status IN (3, 5))
		and ps.bidtypeID in (5,6)
		and sm1.supplierID <> 9000
		
		      
		group by sm1.companyname,sm1.contactName,sm1.supplierID,sm1.city,st1.state,ppc.tagID, sm1.billingaddress,sm1.phonenumber,COALESCE(sm1.emailaddress, 'N/A'),COALESCE(sm1.websiteurl, 'N/A')
	
		 ) AS RowConstrainedResult
			) as filterResult
			
			WHERE   RowNum >= #arguments.iDisplayStart# + 1
    		AND RowNum <= #endRow#
    </cfquery> 

<!--- Total data set length --->
<cfquery name="qCount">
    select distinct sm1.supplierID
	from pbt_project_master a 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
--	left outer join pbt_project_master_cats ppc3 on ppc3.bidID = a.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join state_master st on st.stateID = pd.stateID
	left outer join supplier_master sm1 on sm1.supplierID = pa.supplierID
	left outer join state_master st1 on st1.stateID = sm1.stateID
	left outer join sup_cat_log on sup_cat_log.supplierid = sm1.supplierid 
	where 1 = 1 
		<!--- site default --->
		--and ppc3.tagID in (12)<!---water/wastewater--->
				<cfif isdefined("variables.contractorlist") and arguments.contractor_name NEQ "0" and arguments.contractor_name NEQ "">
					and pa.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#variables.contractorlist#" >)
				</cfif>
				<cfif len(trim(arguments.sSearch)) and isdefined("arguments.sSearch") and arguments.sSearch NEQ "0" and arguments.sSearch NEQ "">
					and pa.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#variables.contractorlist#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "66" and arguments.state_field NEQ "" and (isdefined("variables.geo_type") and variables.geo_type EQ 1)>
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				<cfelseif isdefined("arguments.state_field") and arguments.state_field NEQ "66" and arguments.state_field NEQ "" and (isdefined("variables.geo_type") and variables.geo_type EQ 2)>
					and sm1.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0" and arguments.structure_field NEQ "">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >,12)
				</cfif>
				<cfif isdefined("arguments.company_type_field") and arguments.company_type_field NEQ "10" and arguments.company_type_field NEQ "">
					and sup_cat_log.directory in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.company_type_field#" >)
				</cfif>
		<!---year filters--->
				and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
						or (DATEPART(year,a.paintpublishdate) = '2018')
				)
		--and pa.awarded = 1
		and (a.status IN (3, 5))
		and ps.bidtypeID in (5,6)
		and sm1.supplierID <> 9000
		
		group by sm1.supplierID
	--order by sm1.companyname
</cfquery>
		<cfset metricQuery = QueryNew("supplierID,companyname,city,state,rownum,phonenumber,billingaddress,emailaddress,websiteurl,contactName","integer,VarChar,VarChar,varchar,integer,VarChar,VarChar,VarChar,VarChar,varchar")>
		<cfset counter=0>
		<cfloop query="qfiltered1">
		
														
		<cfset newRow = QueryAddRow(metricQuery, 1)>
		<cfset counter=counter+1>
		<cfset temp = QuerySetCell(metricQuery, "supplierID", "#qfiltered1.supplierID#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "companyname", "#trim(companyname)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "city", "#trim(city)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "state", "#state#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "rownum", "#rownum#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "phonenumber", "#trim(phonenumber)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "contactName", "#trim(contactName)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "billingaddress", "#trim(billingaddress)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "emailaddress", "#trim(emailaddress)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "websiteurl", "#trim(websiteurl)#", #counter#)>
		</cfloop>

	<cfquery name="qfiltered" dbtype="query">
		select  rownum,
		   supplierID,
		  companyname,
		  contactName,
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
		component="#Application.CFCPath#.contractor_profile"  
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
		component="#Application.CFCPath#.contractor_profile"  
		method="get_Filter_state"  
		returnVariable="get_Filter_state"> 
				<cfinvokeargument name="state_field" value="#arguments.state_field#"/> 
	</cfinvoke>
	<cfif get_Filter_state.recordcount GT 0>	
		<cfset variables.filter_state = valuelist(get_Filter_state.state)>
	<cfelse>
		<cfparam name="variables.filter_state" default="All">	
	</cfif>
	<!---<cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
		method="get_filter_CP"  
		returnVariable="get_filter_CP"> 
				<cfinvokeargument name="company_type_field" value="#arguments.company_type_field#"/> 
	</cfinvoke>	--->
	<!---<cfif get_filter_CP.recordcount GT 0>
		<cfset variables.filter_company_type = valuelist(get_filter_CP.contractor_type)>
	<cfelse>
		<cfparam name="variables.filter_company_type" default="All">
	</cfif>	--->
	<cfparam name="variables.filter_company_type" default="All">
	<cfset filter_data = "Year: #variables.filter_year#, QTR: #variables.filter_quarter#, State:#variables.filter_state#, Structure Type: #variables.filter_industry#, Company Type: #variables.filter_company_type#">
	

<!--- 
Output
--->
<cfcontent reset="Yes" />
{"sEcho": <cfoutput>#val(url.sEcho)#</cfoutput>, 
"iTotalRecords": <cfoutput>#qCount.recordcount#</cfoutput>, 
"iTotalDisplayRecords": <cfoutput>#qCount.recordcount#</cfoutput>, 
"filterData":"<cfoutput>#filter_data#</cfoutput>",
"aaData": [ 
<cftry>
<cfoutput query="qFiltered" >
<cfif currentRow LT (qFiltered.rownum + 1) and currentrow NEQ 1>,</cfif>
[<cfloop list="#listColumns#" index="thisColumn"><cfif thisColumn neq listFirst(listColumns)>,</cfif><cfif thisColumn is "version"><cfif version eq 0>"-"<cfelse>"#jsStringFormat(version)#"</cfif><cfelse>#serializeJSON(qFiltered[thisColumn][qFiltered.currentRow])#</cfif></cfloop>]
</cfoutput> ] }
<cfcatch></cfcatch></cftry>
</cffunction>	



<cffunction name="pull_contacts_server" access="remote" output="true" returntype="Any" >
	<cfargument name="iDisplayStart" type="numeric" required="true" default="0" />
	<cfargument name="iDisplayLength" type="numeric" required="true" default="10" />
	<cfargument name="sSearch" type="string" required="false" default=""/>
	<cfargument name="iSortingCols" type="numeric" required="false" default="0"/>
	<cfargument name="supplierID" type="numeric" required="false" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="contractorlist" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />
	<cfset endRow = iDisplayStart + arguments.iDisplayLength>
	<cfparam name="url.iDisplayStart" default="0" type="integer" />
	

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
	  <cfset listColumns = "supplierID,companyname,city,fullname,award_amount" />
	  <cfset slistColumns = "sm1.supplierID,sm1.companyname,sm1.city,st1.fullname,award_amount" />
<!--- Indexed column --->
<cfset sIndexColumn = "supplierID" />
	  
<cfquery name = "qfiltered"> 
select *
			from 
			(
			SELECT  *,ROW_NUMBER() OVER ( 
		ORDER BY 
				companyname
			) AS RowNum
			FROM    (
				select distinct sm1.supplierID,sm1.companyname,sm1.city,st1.fullname,
	(
	select 
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
		where pa.supplierID = sm1.supplierID
		and a.verifiedpaint = 1 
		and pa.awarded = 1
		and (a.status IN (3, 5))
		and ps.bidtypeID in (5)
				<cfif isdefined("arguments.contractorlist") and arguments.contractorlist NEQ "0">
					and pa.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
			and (1 <> 1 
						or (DATEPART(year,a.paintpublishdate) = '2014')
						or (DATEPART(year,a.paintpublishdate) = '2015')
						or (DATEPART(year,a.paintpublishdate) = '2016')
						or (DATEPART(year,a.paintpublishdate) = '2017')
				)		
			group by pc.bidid,amount
			) d 
			on o.bidID = d.bidID 
			and pa.supplierid = sm1.supplierID
			group by pa.supplierid
		) AS award_amount
	from pbt_project_master a 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join state_master st on st.stateID = pd.stateID
	left outer join supplier_master sm1 on sm1.supplierID = pa.supplierID
	left outer join state_master st1 on st1.stateID = sm1.stateID
	where a.verifiedpaint = 1 	
				<cfif isdefined("arguments.contractorlist") and arguments.contractorlist NEQ "0">
					and pa.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
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
		
		        <cfif len(trim(arguments.sSearch))>
						and <cfloop list="#slistColumns#" index="thisColumn"><cfif thisColumn neq listFirst(slistColumns)> OR </cfif>#thisColumn# LIKE <cfif thisColumn is "version"><!--- special case ---><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#val(arguments.sSearch)#" /><cfelse><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#trim(arguments.sSearch)#%" /></cfif></cfloop>
				</cfif>
		group by sm1.companyname,sm1.supplierID,sm1.city,st1.fullname,ppc.tagID 
	
		 ) AS RowConstrainedResult
			) as filterResult
			
			WHERE   RowNum >= #arguments.iDisplayStart# + 1
    		AND RowNum <= #endRow#
    </cfquery> 

<!--- Total data set length --->
<cfquery name="qCount">
    select distinct sm1.supplierID
	from pbt_project_master a 
	left outer join pbt_project_master_cats ppc on ppc.bidID = a.bidID
	left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	left outer join state_master st on st.stateID = pd.stateID
	left outer join supplier_master sm1 on sm1.supplierID = pa.supplierID
	left outer join state_master st1 on st1.stateID = sm1.stateID
	where a.verifiedpaint = 1 	
				<cfif isdefined("arguments.contractorlist") and arguments.contractorlist NEQ "0">
					and pa.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
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
		 <cfif len(trim(arguments.sSearch))>
						and <cfloop list="#slistColumns#" index="thisColumn"><cfif thisColumn neq listFirst(slistColumns)> OR </cfif>#thisColumn# LIKE <cfif thisColumn is "version"><!--- special case ---><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#val(arguments.sSearch)#" /><cfelse><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#trim(arguments.sSearch)#%" /></cfif></cfloop>
				</cfif>
		group by sm1.supplierID
	--order by sm1.companyname
</cfquery>
<!--- 
Output
--->
<cfcontent reset="Yes" />
{"sEcho": <cfoutput>#val(url.sEcho)#</cfoutput>, 
"iTotalRecords": <cfoutput>#qCount.recordcount#</cfoutput>, 
"iTotalDisplayRecords": <cfoutput>#qCount.recordcount#</cfoutput>, 
"aaData": [ 
<cfoutput query="qFiltered" >
<cfif currentRow LT (qFiltered.rownum + 1) and currentrow NEQ 1>,</cfif>
[<cfloop list="#listColumns#" index="thisColumn"><cfif thisColumn neq listFirst(listColumns)>,</cfif><cfif thisColumn is "version"><cfif version eq 0>"-"<cfelse>"#jsStringFormat(version)#"</cfif><cfelse>#serializeJSON(qFiltered[thisColumn][qFiltered.currentRow])#</cfif></cfloop>]
</cfoutput> ] }


	
</cffunction>			




<cffunction name="pull_contractor_revenue" access="remote" output="true" returntype="Query"  >
	<cfargument name="supplierID" type="numeric" required="true" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
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
	where pa.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.supplierID#" >
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

<cffunction name="pull_contractor_leaderboard_results" access="remote" output="true" returntype="Any" >
	<cfargument name="iDisplayStart" type="numeric" required="true" default="0" />
	<cfargument name="iDisplayLength" type="numeric" required="true" default="10" />
	<cfargument name="sSearch" type="string" required="false" default=""/>
	<cfargument name="iSortingCols" type="numeric" required="false" default="0"/>
	<cfargument name="supplierID" type="numeric" required="false" default="0" />
	<cfargument name="cstate_field" type="string" required="false" default="0" />
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="contractorlist" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="All" />
	<cfargument name="iSortCol_0" type="numeric" required="false" default="0"/>
	<cfargument name="sSortDir_0" type="string" required="false" default=""/>
	<cfargument name="company_type_field" type="string" required="false" default="1" />
	<cfset endRow = iDisplayStart + arguments.iDisplayLength>
	<cfparam name="url.iDisplayStart" default="0" type="integer" />
	

	 <cfset date = #CREATEODBCDATETIME(NOW())#>

    <cfif len(trim(arguments.sSearch))>
		<cfsearch name="contractor_results" collection="contrak_contractor_search" criteria="#arguments.sSearch#">
			<cfif contractor_results.recordcount GT 0>
			   <cfset contractorlist = listappend(contractorlist,valuelist(contractor_results.key))>
			 </cfif>
	</cfif>	


    	
	  <cfset listColumns = "rownum,supplierID,companyname,city,state,jobs_bid,jobs_won,volume_bid,volume_won,largest_win,engineer_est,win_rate,market_share" />
	  <cfset slistColumns = "supplier_master.supplierID,supplier_master.companyname,supplier_master.city,state_master.fullname,log_counts.jobs_bid,
                             log_counts_won.jobs_won, log_counts_volume_bid.volume_bid, log_counts_volume_won.volume_won,
                             log_counts_largest.largest_win,log_counts_engineer.engineer_est" />
<!--- Indexed column 
<cfset sIndexColumn = "supplierID" />--->
	  
<cfquery name = "qfiltered1"> 
select supplierID,
  companyname,
 city,
  fullname,
  jobs_bid,
  jobs_won,
  volume_bid,
  volume_won,
  largest_win,
  engineer_est,
 jobs_won*100/jobs_bid as win_rate,rownum
			from 
			(
			SELECT  *,ROW_NUMBER() OVER ( 
		ORDER BY 
			<cfif isdefined("arguments.iSortCol_0")>
				<cfswitch expression="#arguments.iSortCol_0#">
					<cfcase value="2">
						companyname #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="3">
						city #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="4">
						fullname #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="5">
						jobs_bid #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="6">
						jobs_won #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="7">
						volume_bid #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="8">
						volume_won #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="9">
						 largest_win #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="10">
						engineer_est #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="11">
						win_rate #arguments.sSortDir_0#
					</cfcase>
					<cfcase value="12">
						volume_won #arguments.sSortDir_0#
					</cfcase>
					
					<cfdefaultcase>
						volume_won desc 
					</cfdefaultcase>
				</cfswitch>
			<cfelse>
				volume_won desc
			</cfif>
				
			) AS RowNum
			FROM    (

select distinct
 supplier_master.supplierID,
  supplier_master.companyname,
  supplier_master.city,
  state_master.fullname,
  log_counts.jobs_bid,
  log_counts_won.jobs_won,
  log_counts_volume_bid.volume_bid,
  log_counts_volume_won.volume_won,
  log_counts_largest.largest_win,
  log_counts_engineer.engineer_est,
  log_counts_won.jobs_won*100/log_counts.jobs_bid as win_rate
from supplier_master
left outer join (
  select distinct_logs.supplierid, 
  count(1) as jobs_bid
  from (
    select distinct pbt_award_contractors.supplierid, d.bidID
    from  pbt_award_contractors
	LEFT OUTER JOIN
    dbo.pbt_project_stage AS c ON c.stageID = pbt_award_contractors.stageID LEFT OUTER JOIN
    dbo.pbt_project_master AS d ON d.bidID = c.bidID
    left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
    left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5, 6)) AND (d.paintpublishdate >= '1/1/12') 
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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
  ) as distinct_logs
  group by distinct_logs.supplierid
) as log_counts 
on log_counts.supplierID = supplier_master.supplierid
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
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5, 6)) AND (d.paintpublishdate >= '1/1/12') 
	and awarded = 1
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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
--get volume bid
left outer join (
  select distinct_logs2.supplierid, 
  sum(amount) as volume_bid
  from (
    select distinct pbt_award_contractors.supplierid, amount, d.bidID
    from  pbt_award_contractors
	LEFT OUTER JOIN
    dbo.pbt_project_stage AS c ON c.stageID = pbt_award_contractors.stageID LEFT OUTER JOIN
    dbo.pbt_project_master AS d ON d.bidID = c.bidID
    left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
    left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5, 6)) AND (d.paintpublishdate >= '1/1/12') 
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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
  ) as distinct_logs2
  group by distinct_logs2.supplierid
) as log_counts_volume_bid 
on log_counts_volume_bid.supplierID = supplier_master.supplierid
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
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5, 6)) AND (d.paintpublishdate >= '1/1/12') 
	and awarded = 1
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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
--get largest win
left outer join (
  select distinct_logs4.supplierid, 
  max(amount) as largest_win
  from (
    select distinct pbt_award_contractors.supplierid, amount, d.bidID
    from  pbt_award_contractors
	LEFT OUTER JOIN
    dbo.pbt_project_stage AS c ON c.stageID = pbt_award_contractors.stageID LEFT OUTER JOIN
    dbo.pbt_project_master AS d ON d.bidID = c.bidID
    left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
    left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5, 6)) AND (d.paintpublishdate >= '1/1/12') 
	and awarded = 1
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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
  ) as distinct_logs4
  group by distinct_logs4.supplierid
) as log_counts_largest 
on log_counts_largest.supplierID = supplier_master.supplierid
--get eng est
left outer join (
  select distinct_logs5.supplierid, 
  sum(minimumvalue) as engineer_est
  from (
    select distinct pbt_award_contractors.supplierid, cast(d .minimumvalue AS numeric(20, 3)) as minimumvalue, d.bidID
    from  pbt_award_contractors
	LEFT OUTER JOIN
    dbo.pbt_project_stage AS c ON c.stageID = pbt_award_contractors.stageID LEFT OUTER JOIN
    dbo.pbt_project_master AS d ON d.bidID = c.bidID
    left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
    left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5, 6)) AND (d.paintpublishdate >= '1/1/12') 
	and awarded = 1
	
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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
  ) as distinct_logs5
  group by distinct_logs5.supplierid
) as log_counts_engineer
on log_counts_engineer.supplierID = supplier_master.supplierid
left outer join state_master on state_master.stateID = supplier_master.stateID
left outer join pbt_award_contractors pa on pa.supplierID = supplier_master.supplierID
left outer join dbo.pbt_project_stage c ON c.stageID = pa.stageID 
left outer join dbo.pbt_project_master d ON d.bidID = c.bidID
left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
left outer join sup_cat_log on sup_cat_log.supplierid = supplier_master.supplierid 
 left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
where 1=1

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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
						<cfloop list="#slistColumns#" index="thisColumn"><cfif thisColumn neq listFirst(slistColumns)> OR </cfif>#thisColumn# LIKE <cfif thisColumn is "version"><!--- special case ---><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#val(arguments.sSearch)#" /><cfelse><cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#trim(arguments.sSearch)#%" /></cfif></cfloop>
						)
				</cfif--->
				<cfif len(trim(arguments.sSearch)) and isdefined("contractorlist") and contractorlist NEQ "">
					and supplier_master.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>

		 ) AS RowConstrainedResult
			) as filterResult
			
			WHERE   RowNum >= #arguments.iDisplayStart# + 1
    		AND RowNum <= #endRow#
</cfquery>
<!--- Total data set length --->
<cfquery name="qCount">
select distinct supplier_master.supplierID
from supplier_master
left outer join state_master on state_master.stateID = supplier_master.stateID
left outer join pbt_award_contractors pa on pa.supplierID = supplier_master.supplierID
left outer join dbo.pbt_project_stage c ON c.stageID = pa.stageID 
left outer join dbo.pbt_project_master d ON d.bidID = c.bidID
left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
left outer join sup_cat_log on sup_cat_log.supplierid = supplier_master.supplierid 
left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
where 1=1

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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
				<cfif len(trim(arguments.sSearch)) and isdefined("contractorlist") and contractorlist NEQ "">
					and supplier_master.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
	--order by sm1.companyname
</cfquery>
<cfquery name="getTotalVolume">
select distinct supplier_master.supplierID,log_counts_volume_won.volume_won
from supplier_master
--get volume won
inner join (
  select distinct supplierid, 
  sum(amount) as volume_won
  from (
    select distinct pbt_award_contractors.supplierid, amount, d.bidID
    from  pbt_award_contractors
	LEFT OUTER JOIN
    dbo.pbt_project_stage AS c ON c.stageID = pbt_award_contractors.stageID LEFT OUTER JOIN
    dbo.pbt_project_master AS d ON d.bidID = c.bidID
    left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
    left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5, 6)) AND (d.paintpublishdate >= '1/1/12') 
	and awarded = 1
				
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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
			
	--order by sm1.companyname
</cfquery>
	<cfquery name="get_total_bid1" dbtype="query">
		select sum(volume_won) as total_volume
		from getTotalVolume
	</cfquery>
	<cfset variables.total_volume = get_total_bid1.total_volume>

		<cfset metricQuery = QueryNew("supplierID,companyname,city,state,jobs_bid,jobs_won,volume_bid,volume_won,largest_win,engineer_est,win_rate,market_share,rownum","integer,VarChar,VarChar,VarChar,integer,integer,VarChar,VarChar,VarChar,VarChar,integer,decimal,integer")>
		<cfset counter=0>
		<cfloop query="qfiltered1">
			<cfif volume_won NEQ "" and volume_won NEQ 0 and variables.total_volume NEQ "">
				<cfset market_share = volume_won/variables.total_volume>
			<cfelse>
				<cfset market_share = "0">
			</cfif>
														
		<cfset newRow = QueryAddRow(metricQuery, 1)>
		<cfset counter=counter+1>
		<cfset temp = QuerySetCell(metricQuery, "supplierID", "#qfiltered1.supplierID#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "companyname", "#companyname#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "city", "#city#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "state", "#fullname#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "jobs_bid", "#jobs_bid#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "jobs_won", "#jobs_won#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "volume_bid", "#numberformat(volume_bid)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "volume_won", "#numberformat(volume_won)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "largest_win", "#numberformat(largest_win)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "engineer_est", "#numberformat(engineer_est)#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "win_rate", "#win_rate#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "market_share", "#numberformat(market_share,"0.000")#", #counter#)>
		<cfset temp = QuerySetCell(metricQuery, "rownum", "#rownum#", #counter#)>
		</cfloop>

	<cfquery name="qfiltered" dbtype="query">
		select  rownum,
		   supplierID,
		  companyname,
		  city,
		  state,
		  jobs_bid,
		  jobs_won,
		  volume_bid,
		  volume_won,
		  largest_win,
		  engineer_est,
		  win_rate,
		  market_share
		  from metricQuery
	</cfquery>

<!---set filters--->

	<!---set the filter year--->
	<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "">
		<cfset variables.filter_year = arguments.year_field>
	<cfelse>
		<cfset variables.filter_year = "2017">
	</cfif>
	<!---set the filter qtr--->
	<cfif isdefined("arguments.quarter_field") and arguments.quarter_field NEQ "">
		<cfset variables.filter_quarter = arguments.quarter_field>
	<cfelse>
		<cfset variables.filter_quarter = "All">
	</cfif>
	<cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
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
		component="#Application.CFCPath#.contractor_profile"  
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
		component="#Application.CFCPath#.contractor_profile"  
		method="get_filter_CP"  
		returnVariable="get_filter_CP"> 
				<cfinvokeargument name="company_type_field" value="#arguments.company_type_field#"/> 
	</cfinvoke>	
	<cfif get_filter_CP.recordcount GT 0>
		<cfset variables.filter_company_type = valuelist(get_filter_CP.contractor_type)>
	<cfelse>
		<cfparam name="variables.filter_company_type" default="All">
	</cfif>	
	<cfset filter_data = "Year: #variables.filter_year#, QTR: #variables.filter_quarter#, State:#variables.filter_state#, Industry: #variables.filter_industry#, Company Type: #variables.filter_company_type#">
	

<!--- 
Output
--->
<cfcontent reset="Yes" />
{"sEcho": <cfoutput>#val(url.sEcho)#</cfoutput>, 
"iTotalRecords": <cfoutput>#qCount.recordcount#</cfoutput>, 
"iTotalDisplayRecords": <cfoutput>#qCount.recordcount#</cfoutput>, 
"totalvolume":<cfoutput><cfif get_total_bid1.total_volume EQ "">0<cfelse>#get_total_bid1.total_volume#</cfif></cfoutput>,
"filterData":"<cfoutput>#filter_data#</cfoutput>",
"aaData": [ 
<cfoutput query="qFiltered" >
<cfif currentRow LT (qFiltered.rownum + 1) and currentrow NEQ 1>,</cfif>
[<cfloop list="#listColumns#" index="thisColumn"><cfif thisColumn neq listFirst(listColumns)>,</cfif><cfif thisColumn is "version"><cfif version eq 0>"-"<cfelse>"#jsStringFormat(version)#"</cfif><cfelse>#serializeJSON(qFiltered[thisColumn][qFiltered.currentRow])#</cfif></cfloop>]
</cfoutput> ] }
	
</cffunction>			


<cffunction name="pull_contractor_leaderboard_results1" access="remote" output="true" returntype="Query"  >
	<cfargument name="state_field" type="string" required="false" default="0" />
	<cfargument name="structure_field" type="string" required="false" default="0" />
	<cfargument name="year_field" type="string" required="false" default="current" />
	<cfargument name="quarter_field" type="string" required="false" default="all" />
	<cfargument name="company_type_field" type="numeric" required="false" default="0" />

	 <cfset date = #CREATEODBCDATETIME(NOW())#>
		
<cfquery name="getContractorLBResults">	
select distinct
 supplier_master.supplierID,
  supplier_master.companyname,
  supplier_master.city,
  state_master.state,
  log_counts.jobs_bid,
  log_counts_won.jobs_won,
  log_counts_volume_bid.volume_bid,
  log_counts_volume_won.volume_won,
  log_counts_largest.largest_win,
  log_counts_engineer.engineer_est,
  log_counts_won.jobs_won*100/log_counts.jobs_bid as win_rate,
  pct.contractor_type
from supplier_master
join (
  select distinct_logs.supplierid, 
  count(1) as jobs_bid
  from (
    select distinct pbt_award_contractors.supplierid, d.bidID
    from  pbt_award_contractors
	LEFT OUTER JOIN
    dbo.pbt_project_stage AS c ON c.stageID = pbt_award_contractors.stageID LEFT OUTER JOIN
    dbo.pbt_project_master AS d ON d.bidID = c.bidID
    left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
    left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5, 6)) AND (d.paintpublishdate >= '1/1/12') 
		<cfif isdefined("arguments.contractorlist") and arguments.contractorlist NEQ "0">
					and pbt_award_contractors.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
  ) as distinct_logs
  group by distinct_logs.supplierid
) as log_counts 
on log_counts.supplierID = supplier_master.supplierid
--get bids won
join (
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
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5, 6)) AND (d.paintpublishdate >= '1/1/12') 
	and awarded = 1
	<cfif isdefined("arguments.contractorlist") and arguments.contractorlist NEQ "0">
					and pbt_award_contractors.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
--get volume bid
join (
  select distinct_logs2.supplierid, 
  sum(amount) as volume_bid
  from (
    select distinct pbt_award_contractors.supplierid, amount, d.bidID
    from  pbt_award_contractors
	LEFT OUTER JOIN
    dbo.pbt_project_stage AS c ON c.stageID = pbt_award_contractors.stageID LEFT OUTER JOIN
    dbo.pbt_project_master AS d ON d.bidID = c.bidID
    left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
    left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5, 6)) AND (d.paintpublishdate >= '1/1/12') 
	<cfif isdefined("arguments.contractorlist") and arguments.contractorlist NEQ "0">
					and pbt_award_contractors.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
  ) as distinct_logs2
  group by distinct_logs2.supplierid
) as log_counts_volume_bid 
on log_counts_volume_bid.supplierID = supplier_master.supplierid
--get volume won
join (
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
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5, 6)) AND (d.paintpublishdate >= '1/1/12') 
	and awarded = 1
	<cfif isdefined("arguments.contractorlist") and arguments.contractorlist NEQ "0">
					and pbt_award_contractors.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
--get largest win
join (
  select distinct_logs4.supplierid, 
  max(amount) as largest_win
  from (
    select distinct pbt_award_contractors.supplierid, amount, d.bidID
    from  pbt_award_contractors
	LEFT OUTER JOIN
    dbo.pbt_project_stage AS c ON c.stageID = pbt_award_contractors.stageID LEFT OUTER JOIN
    dbo.pbt_project_master AS d ON d.bidID = c.bidID
    left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
    left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5, 6)) AND (d.paintpublishdate >= '1/1/12') 
	and awarded = 1
	<cfif isdefined("arguments.contractorlist") and arguments.contractorlist NEQ "0">
					and pbt_award_contractors.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
  ) as distinct_logs4
  group by distinct_logs4.supplierid
) as log_counts_largest 
on log_counts_largest.supplierID = supplier_master.supplierid
--get eng est
join (
  select distinct_logs5.supplierid, 
  sum(minimumvalue) as engineer_est
  from (
    select distinct pbt_award_contractors.supplierid, cast(d .minimumvalue AS numeric(20, 3)) as minimumvalue, d.bidID
    from  pbt_award_contractors
	LEFT OUTER JOIN
    dbo.pbt_project_stage AS c ON c.stageID = pbt_award_contractors.stageID LEFT OUTER JOIN
    dbo.pbt_project_master AS d ON d.bidID = c.bidID
    left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
    left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
	where (d.verifiedpaint = 1) AND (d.status IN (3, 5)) AND (c.bidtypeID IN (5, 6)) AND (d.paintpublishdate >= '1/1/12') 
	and awarded = 1
	<cfif isdefined("arguments.contractorlist") and arguments.contractorlist NEQ "0">
					and pbt_award_contractors.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
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
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
  ) as distinct_logs5
  group by distinct_logs5.supplierid
) as log_counts_engineer
on log_counts_engineer.supplierID = supplier_master.supplierid
left outer join state_master on state_master.stateID = supplier_master.stateID
left outer join pbt_award_contractors pa on pa.supplierID = supplier_master.supplierID
left outer join dbo.pbt_project_stage c ON c.stageID = pa.stageID 
left outer join dbo.pbt_project_master d ON d.bidID = c.bidID
left outer join pbt_project_master_cats ppc on ppc.bidID = d.bidID
left outer join sup_cat_log on sup_cat_log.supplierid = supplier_master.supplierid 
 left outer join pbt_project_locations AS pd ON pd.bidID = d.bidID AND pd.active = 1 AND pd.primary_location = 1
  left outer join pbt_contractor_type pct on pct.typeID = sup_cat_log.directory
where 1=1

				<cfif isdefined("arguments.contractorlist") and arguments.contractorlist NEQ "0">
					and supplier_master.supplierID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.contractorlist#" >)
				</cfif>
				<cfif isdefined("arguments.state_field") and arguments.state_field NEQ "0">
					and pd.stateID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.state_field#" >)
				</cfif>
				<cfif isdefined("arguments.structure_field") and arguments.structure_field NEQ "0">
					and ppc.tagID in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.structure_field#" >)
				</cfif>
				<cfif isdefined("arguments.company_type_field") and arguments.company_type_field NEQ "0">
					and sup_cat_log.directory in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#arguments.company_type_field#" >)
				</cfif>
				<!---year filters--->
				<cfif isdefined("arguments.year_field") and arguments.year_field NEQ "current">
					and (1 <> 1 
					
					<cfif listfind(year_field,"2014")>
						or (DATEPART(year,paintpublishdate) = '2014')
					</cfif>
					<cfif listfind(year_field,"2015")>
						or (DATEPART(year,paintpublishdate) = '2015')
					</cfif>
					<cfif listfind(year_field,"2016")>
						or (DATEPART(year,paintpublishdate) = '2016')
					</cfif>
					<cfif listfind(year_field,"2017")>
						or (DATEPART(year,paintpublishdate) = '2017')
					</cfif>
				
					)
				<cfelse>
					<!---default year period selection --->
					and (1 <> 1 
						or (DATEPART(year,paintpublishdate) = '2016')
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
order by log_counts_volume_won.volume_won desc
</cfquery>

<cfreturn getContractorLBResults />
	
</cffunction>

</cfcomponent>