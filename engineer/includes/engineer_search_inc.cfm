<!---page submits to function runAgencySearchTable cfc javascript file in assets/table-data-engineer.js--->


	<cfquery name="state">
		select distinct state_master.stateID,state_master.fullname 
		from state_master
		where countryID = 73
		order by state_master.fullname  
	</cfquery>


	<div class="page-header">
		<h3>Architect/Engineer Profiles <small>Search to access architect/engineers</small></h3>
	</div>

	<div class="row">
		<div class="col-sm-12">
				<cfoutput>

					<cfform name="searchForm" action="#cgi.script.name#?engineer&results" method="post" enctype="multipart/form-data" class="form-horizontal">


									<div class="form-group">
							<div class="col-xs-4">
							<label for="contractor_name">
								Architect/Engineer Firm Name
							</label>
									<!---select placeholder="Search by Company Name" class="form-control">
										<cfloop query="getContractorResults">
											<option value="#supplierID#">#contractor#</option>
										</cfloop>
										<!---option value="select2/select2" selected="selected">select2/select2</option--->
									</select--->
									 <!---cfinput name="supplierID"
									type="text"
									autoSuggest="#valueList(getContractorResults.contractor)#"
									autosuggestMinLength="3"
									value="#getContractorResults.supplierID#"
									typeahead="true" /--->
								<input type="text" name="agency_name" placeholder="Search by Architect/Engineer Firm Name" id="agency_name" class="form-control" autocomplete="off">

							</div>
						</div>
						<div class="form-group">
							<div class="col-xs-3">
								<label for="state_work">
								State
							</label>
									<select name="state_field"  placeholder="Search by State" id="state_work" class="form-control search-select" style="width: 100%" autocomplete="off">
										<cfloop query="state">
											<option value="#stateID#" <cfif stateID EQ "66">selected</cfif>>#fullname#</option>
										</cfloop>
									</select>
							</div>
							<!---<div class="col-sm-3">
								<label for="contract_type_field">
								Type of Contract
							</label>
									<select name="contract_type_field"  placeholder="Search by Type of Contract Awarded" id="contract_type_field" class="form-control search-select-contract">
										<option value="4" selected="selected">All Contracts</option>
										<cfloop query="pull_contract_type">
											<option value="#valueID#" >#value_type#</option>
										</cfloop>
									</select>
							</div>--->
					</div>
					<div class="form-group">
							<div class="col-xs-7">
								<label for="structure_field">
								Structure Type
							</label>
							<select  placeholder="Search by Structure Type" name="structure_field" multiple="multiple" id="structure_field" class="form-control search-select-structure" autocomplete="off">
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