
<cfquery name="state">
	select distinct state_master.stateID,state_master.fullname 
	from state_master
	left outer join pbt_project_locations AS pd on pd.stateID = state_master.stateID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_master a on a.bidID = pd.bidID
	left outer join pbt_project_master_cats pmc on pmc.bidID = a.bidID
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	where a.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#supplierID#" >
	and a.verifiedpaint = 1
	and (a.status IN (3, 5))
	and ps.bidtypeID in (1,4,5,6,21,22,23,24) 
	order by state_master.fullname  
</cfquery>
	<cfset variables.form_url = "#cgi.script.name#?agency=&supplierID=#supplierID#">


<cfquery name="state">
	select distinct state_master.stateID,state_master.fullname 
	from state_master
	where countryID = 73
	order by state_master.fullname  
</cfquery>


 	 <cfparam name="year_field" default="2017-#dateformat(now(),'yyyy')#">
 

 <cfparam name="quarter_field" default="All">
 <cfparam name="structure_field" default="0">
 <cfparam name="state_field" default="0">
 <cfparam name="cstate_field" default="0">
 <cfparam name="company_type_field" default="0">


<!--- start: BOOTSTRAP EXTENDED MODALS --->
	<!---<div id="responsive" class="modal fade" tabindex="-1" data-width="760" style="display: none;">--->
<div id="responsive" class="modal fade">
	<div class="modal-dialog modal-lg"> 
		<div class="modal-content">		
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
					&times;
				</button>
				<h4 class="modal-title">Filter</h4>
			</div>
			<div class="modal-body">
								
				<cfform name="searchForm" action="#variables.form_url#" method="post" enctype="multipart/form-data">
					<cfoutput>

					<cfif isdefined("agency")>
						<div class="form-group space12">
							<div class="form-group space12">
								<div class="box-title">Year</div>						
								<div class="btn-group" data-toggle="buttons">
								<cfloop from="2017" to="#dateformat(now(),'yyyy')#" index="yr">
									<label class="btn btn-default <cfif listfind(year_field,yr)>active</cfif>">
										<input type="checkbox" name="year_field" autocomplete="off" value="#yr#" <cfif listfind(year_field,yr)>checked</cfif>> #yr#
									</label>
								</cfloop>									
								</div>
							</div>
						</div>

					</cfif>

					<div class="form-group space12">
						<div class="box-title">Quarter</div>
						<div class="btn-group" data-toggle="buttons">
							<label class="btn btn-default <cfif listfind(quarter_field,"all") or (not listfind(quarter_field,"q1") and not listfind(quarter_field,"q2") and not listfind(quarter_field,"q3") and not listfind(quarter_field,"q4"))>active</cfif>">
								<input type="radio" name="quarter_field" id="option0" autocomplete="off" checked value="all">All
							</label>
							<label class="btn btn-default <cfif listfind(quarter_field,"q1")>active</cfif>">
								<input type="radio" name="quarter_field" id="option1" autocomplete="off" value="q1"> Q1
							</label>
							<label class="btn btn-default <cfif listfind(quarter_field,"q2")>active</cfif>">
								<input type="radio" name="quarter_field" id="option2" autocomplete="off" value="q2"> Q2
							</label>
							<label class="btn btn-default <cfif listfind(quarter_field,"q3")>active</cfif>">
								<input type="radio" name="quarter_field" id="option3" autocomplete="off" value="q3"> Q3
							</label>
							<label class="btn btn-default <cfif listfind(quarter_field,"q4")>active</cfif>">
								<input type="radio" name="quarter_field" id="option4" autocomplete="off" value="q4"> Q4
							</label>
						</div>
					</div>

					<!---div class="form-group space12">
					<div class="box-title">
					Company Location
					</div>
					<div class="input-box">
					<div class="input">
					<div class="form-group">
					<select name="cstate_field" multiple="multiple" id="form-field-select-1" class="form-control search-select" style="width: 100%">
					<cfloop query="state">
						<option value="#stateID#" <cfif listfind(cstate_field,stateID)>selected</cfif>>#fullname#</option>
					</cfloop>
					</select>
					</div>
					</div>
					</div>
					<div class="space12">
					</div>
					</div--->

					<div class="form-group space12">
						<div class="box-title">Location of Job</div>
						<div class="input-box">
							<div class="input">
								<select name="state_field" multiple="multiple" id="form-field-select-1" class="form-control search-select" style="width: 100%">
									<cfloop query="state">
										<option value="#stateID#" <cfif listfind(state_field,stateID)>selected</cfif>>#fullname#</option>
									</cfloop>
								</select>
							</div>
						</div>			
					</div>		

					<div class="form-group space12">
						<div class="box-title">Structure Type</div>
						<div class="input-box">
							<div class="input">
								<select name="structure_field" multiple="multiple" id="form-field-select-3" class="form-control search-select-structure">
									<cfloop query="session.model.formStructureDropOptions">
										<option value="#tagID#" <cfif listfind(structure_field,tagID)>selected</cfif>>#tag#</option>
									</cfloop>
								</select>
							</div>
						</div>
					</div>

					<cfif isdefined("contractor_leaderboard")>
						<div class="form-group space12">	
							<div class="box-title">Company Type</div>
							<div class="input-box">
								<div class="input">
									<select name="company_type_field" multiple="multiple" id="form-field-select-3" class="form-control search-select-comp">
										<cfloop query="pull_company_type">
											<option value="#typeID#" <cfif listfind(company_type_field,typeID)>selected</cfif>>#contractor_type#</option>
										</cfloop>
									</select>
								</div>
							</div>
						</div>
					</cfif>

					<div class="form-group">				
						<button type="button" data-dismiss="modal" class="btn btn-light-grey">Close</button>   
						<input class="btn btn-blue" type="submit" value="Apply" id="submit">
					</div>

					</cfoutput>
				</cfform>
					
			</div>			
		</div>	
	</div>
</div>