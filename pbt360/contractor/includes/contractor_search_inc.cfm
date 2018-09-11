
<cfquery name="state">
	select distinct state_master.stateID,state_master.fullname 
	from state_master
	where countryID = 73
	order by state_master.fullname  
</cfquery>
   <cfquery name="pull_industrial_structures_all">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 1 
	 and tag_parentID <> 0
	 order by pbt_tags.tag
 	</cfquery>
 <cfquery name="pull_company_type">
 	 select distinct typeID,contractor_type
	 from pbt_contractor_type
	 where typeID in (1,3,99)
	 order by pbt_contractor_type.contractor_type
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
						<input type="text" name="contractor_name" placeholder="Search by Company Name" id="contractor_name" class="form-control">

					</div>
					<div class="col-sm-3">
						<label for="company_type_field">
							Company Type
						</label>
						<select name="company_type_field"  placeholder="Search by Company Type" id="company_type_field" class="form-control search-select-contract">
							<option value="10">All Types</option>
							<cfloop query="pull_company_type">
								<option value="#typeID#" <cfif typeID EQ "1">selected</cfif>>#contractor_type#</option>
							</cfloop>
						</select>
					</div>
				</div>

				<div class="form-group">
					<div class="col-sm-3">
						<label for="state_work">
							State
						</label>
						<select name="state_field"  placeholder="Search by State" id="state_work" class="form-control search-select" style="width: 100%">
							<cfloop query="state">
								<option value="#stateID#" <cfif stateID EQ "66">selected</cfif>>#fullname#</option>
							</cfloop>
						</select>
					</div>
					<div class="col-sm-3">
						<label class="control-label">
							Search by: <span class="symbol required"></span>
						</label>
						<div>
							<label class="radio-inline">
								<input type="radio" value="1" name="geo_type" class="grey">
									Area(s) of work
							</label>
							<label class="radio-inline">
								<input type="radio" value="2" name="geo_type" class="grey" checked>
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
							<cfloop query="pull_industrial_structures_all">
								<option value="#tagID#" >#tag#</option>
							</cfloop>
						</select>
					</div>
				</div>

				<div class="form-group">
					<div class="col-xs-1">
					<input class="btn btn-blue" type="submit" value="Search" id="submit">
					</div>
				</div>

				<!---left

					<div class="row">	
							<div class="col-md-6">
								<div class="form-group">
									<label for="contractor_name">
										Company Name
									</label>
										<input type="text" name="contractor_name" placeholder="Search by Company Name" id="contractor_name" class="form-control">
								</div>
								<div class="form-group">
										<label for="state_work">
											State
										</label>
										<select name="state_field"  placeholder="Search by State" id="state_work" class="form-control search-select" style="width: 100%">
												<cfloop query="state">
													<option value="#stateID#" <cfif stateID EQ "66">selected</cfif>>#fullname#</option>
												</cfloop>
										</select>
								</div>
								<div class="form-group">
									<label for="structure_field">
										Structure Type
									</label>
									<select  placeholder="Search by Structure Type" name="structure_field" multiple="multiple" id="structure_field" class="form-control search-select-structure">
													<cfloop query="pull_industrial_structures_all">
														<option value="#tagID#" >#tag#</option>
													</cfloop>
									</select>
								</div>
							</div>


					---right---
						<div class="col-md-6">
									<div class="form-group">
										<label for="contract_type_field">
											Type of Contract
										</label>
											<select name="company_type_field"  placeholder="Search by Company Type" id="company_type_field" class="form-control search-select-contract">
												<option value="10">All Types</option>
												<cfloop query="pull_company_type">
													<option value="#typeID#" <cfif typeID EQ "1">selected</cfif>>#contractor_type#</option>
												</cfloop>
											</select>
									</div>
									<div class="form-group">
										<label class="control-label">
											Search by: <span class="symbol required"></span>
										</label>
										<div>
											<label class="radio-inline">
												<input type="radio" value="1" name="geo_type" class="grey">
												Area(s) of work
											</label>
											<label class="radio-inline">
												<input type="radio" value="2" name="geo_type" class="grey">
												Main office location
											</label>
										</div>
									</div>
						</div>		

								<div class="form-group">
									<div class="col-xs-1">
									<input class="btn btn-blue" type="submit" value="Search" id="submit">
									</div>
								</div>
					</div>--->
			</cfform>
		</cfoutput>
	</div>
</div>