<cfquery name="state">
	select distinct state_master.stateID,state_master.fullname 
	from state_master
	left outer join pbt_project_locations AS pd on pd.stateID = state_master.stateID AND pd.active = 1 AND pd.primary_location = 1
	left outer join pbt_project_master a on a.bidID = pd.bidID
	left outer join pbt_project_master_cats pmc on pmc.bidID = a.bidID
	left outer join pbt_project_stage ps on ps.bidid = a.bidid
	left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
	where pa.supplierID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#supplierID#" >
	and a.verifiedpaint = 1 
	and pa.awarded = 1
	and (a.status IN (3, 5))
	and ps.bidtypeID in (5,6) 
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
 
 <cfparam name="year_field" default="2014">
 <cfparam name="quarter_field" default="All">
 <cfparam name="structure_field" default="0">
 <cfparam name="state_field" default="0">

<cfform name="searchForm" action="#cgi.script.name#?contractor=&supplierID=#supplierID#" method="post" enctype="multipart/form-data">
<div id="filter_selector" class="hidden-xs"><cfoutput>
								<div id="filter_selector_container">
									<div class="filter-main-title">
										Filters
									</div>
									
											<div class="box-title">
												Year
											</div>
											<div class="form-group">
											<div class="btn-group" data-toggle="buttons">
											  <!---label class="btn btn-default">
											    <input type="checkbox" name="year_field" autocomplete="off" checked value="all">All
											  </label--->
											  <label class="btn btn-default <cfif listfind(year_field,"2012")>active</cfif>" >
											    <input type="checkbox" name="year_field"  autocomplete="off" value="2012" <cfif listfind(year_field,"2012")>checked</cfif>> 2012
											  </label>
											  <label class="btn btn-default <cfif listfind(year_field,"2013")>active</cfif>">
											    <input type="checkbox" name="year_field" autocomplete="off" value="2013" <cfif listfind(year_field,"2013")>checked</cfif>> 2013
											  </label>
											  <label class="btn btn-default <cfif listfind(year_field,"2014")>active<cfelseif not listfind(year_field,"2012") and not listfind(year_field,"2013") and not listfind(year_field,"2015")>active</cfif>">
											    <input type="checkbox" name="year_field" autocomplete="off" value="2014" <cfif listfind(year_field,"2014")>checked<cfelseif not listfind(year_field,"2012") and not listfind(year_field,"2013") and not listfind(year_field,"2015")>checked</cfif>> 2014
											  </label>
											  <label class="btn btn-default <cfif listfind(year_field,"2015")>active</cfif>">
											    <input type="checkbox" name="year_field" autocomplete="off" value="2015" <cfif listfind(year_field,"2015")>checked</cfif>> 2015
											  </label>
											</div>
											</div>
												
											<div class="space12">
											</div>
											<div class="box-title">
											Quarter
										</div>
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
										<div class="space12">
										</div>
										<div class="box-title">
											State
										</div>
										<div class="input-box">
										<div class="input">
												<div class="form-group">
													
													<select name="state_field" multiple="multiple" id="form-field-select-1" class="form-control search-select" style="width: 100%">
														<cfloop query="state">
															<option value="#stateID#" <cfif listfind(state_field,stateID)>selected</cfif>>#fullname#</option>
														</cfloop>
														
														
													</select>
												</div>
									</div>
									</div>
									<div class="space12">
									</div>
									<div class="space12">
									</div>
									<div class="space12">
									</div>
									<div class="space12">
									</div>
									<div class="space12">
									</div>
									<div class="space12">
									</div>
									<div class="space12">
									</div>		
									<div class="box-title">
										Industry
									</div>
									<div class="input-box">
										<div class="input">
													<select name="structure_field" multiple="multiple" id="form-field-select-3" class="form-control search-select-structure">
															<cfloop query="pull_industrial_structures_all">
																<option value="#tagID#" <cfif listfind(structure_field,tagID)>selected</cfif>>#tag#</option>
															</cfloop>
													</select>
									
										</div>
									</div>
									<!---div class="box-title">
										Year
									</div>
									
											<!---div class="space12">
												<div class="btn-group btn-group-sm">
													<a class="btn btn-default" href="javascript:;">
														2012
													</a>
													<a class="btn btn-default hidden-xs" href="javascript:;">
														2013
													</a>
													<a class="btn btn-default" href="javascript:;">
														2014
													</a>
													<a class="btn btn-default" href="javascript:;">
														2015
													</a>
												</div>
											</div--->
										<div class="input-group">
										<span class="input-group-addon"><i class="fa fa-calendar"></i> </span>
										<input name="publish_date_field" type="text" class="form-control date-range">
										</div--->
										
										<div class="space12">
											
											</div>
												<div class="space12">
									</div>
									<div class="space12">
									</div>
									<div class="space12">
									</div>
									<div class="space12">
									</div>
									<div class="space12">
									</div>
									<div class="space12">
									</div>
									<div class="space12">
									</div>
				</cfoutput>				
									<div class="space12">
									<div style="height:25px;line-height:25px; text-align: center">
										<input class="btn" type="reset" value="Reset">
										<button class="btn btn-blue">Apply<i class="fa fa-arrow-circle-right"></i></button>

									</div>
									</div>
								</div>
								<div class="filter-toggle close"></div>
							</div>
	</cfform>