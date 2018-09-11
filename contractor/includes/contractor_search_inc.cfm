
<cfquery name="state">
	select distinct state_master.stateID,state_master.fullname 
	from state_master
	where countryID = 73
	order by state_master.fullname  
</cfquery>


<div class="page-header">
	<h3>Contractor Profiles <small>Search to access contractor bidding history profiles</small></h3>
</div>

<div class="row">
	<div class="col-sm-12">
		<cfoutput>
			<cfform name="searchForm" action="#cgi.script.name#?contractor&results" method="post" enctype="multipart/form-data" role="form" class="form-horizontal">
				<div class="form-group">
					<div class="col-xs-4">
					<label for="contractor_name">
						Company Name
					</label>
						<input type="text" name="contractor_name" placeholder="Search by Company Name" id="contractor_name" class="form-control" autocomplete="off">

					</div>
					<!---<div class="col-sm-3">
						<label for="company_type_field">
							Company Type
						</label>
						<select name="company_type_field"  placeholder="Search by Company Type" id="company_type_field" class="form-control search-select-contract">
							<option value="10">All Types</option>
							<cfloop query="pull_company_type">
								<option value="#typeID#" <cfif typeID EQ "1">selected</cfif>>#contractor_type#</option>
							</cfloop>
						</select>
					</div>--->
				</div>

				<div class="form-group">
					<div class="col-sm-3">
						<label for="state_work">
							State
						</label>
						<select name="state_field"  placeholder="Search by State" id="state_work" class="form-control search-select" style="width: 100%" autocomplete="off">
							<cfloop query="state">
								<option value="#stateID#" <cfif stateID EQ "66">selected</cfif>>#fullname#</option>
							</cfloop>
						</select>
					</div>
					<div class="col-sm-36">
						<label class="control-label">
							Search by: <span class="symbol required"></span>&nbsp;&nbsp;
						</label>
						<div>
							<label class="radio-inline">
								<input type="radio" value="1" name="geo_type" class="grey" checked>
									Area(s) of work
							</label>
							<label class="radio-inline">
								<input type="radio" value="2" name="geo_type" class="grey">
									Office location
							</label>
						</div>
					</div>
				</div>

				<div class="form-group">
					<div class="col-sm-9">
						<label for="structure_field">
							Structure Type
						</label>
						<select  placeholder="Search by Structure Type" name="structure_field" multiple="multiple" id="structure_field" class="form-control search-select-structure">
							<cfloop query="session.model.formStructureDropOptions">
								<cfquery name="check_subs" datasource="#application.datasource#">
								 select pbt_tags.tag,pbt_tags.tagID
								 from pbt_tags
		 						  inner join site_tag_xref x on pbt_tags.tagID = x.tagID 
								 where pbt_tags.tag_parentID = #tagID# and pbt_tags.tag_typeID = 1
								 and tag_parentID <> 0
								  and siteID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.siteID#" />
								 order by pbt_tags.tag
								</cfquery>											
								<option value="#tagID#" >#tag#</option>
								<cfif check_subs.recordcount GT 0>
								   <cfloop query="check_subs">
										<cfoutput><option value="#tagID#">#tag#</option></cfoutput>
								   </cfloop>
								</cfif>									
							</cfloop>
						</select>
					</div>
				</div>

				<div class="form-group">
					<div class="col-xs-1">
					<input class="btn btn-blue" type="submit" value="Search" id="submit">
					</div>
				</div>
			</cfform>
		</cfoutput>
	</div>
</div>