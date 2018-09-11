<cfparam name="default_year" default="2016">
<cfparam name="contractorlist" default="">	
	
<cfif isdefined("type")>

<cfswitch expression="#type#">

<cfcase value="1">
	
	<cfset year_field = 2017>
</cfcase>
<cfcase value="2">
	<cfset year_field = 2016>
</cfcase>	
<cfcase value="3">
	<cfset year_field = 2015>
</cfcase>
<cfcase value="4">
	<cfset year_field = 2014>
</cfcase>
</cfswitch>
	
</cfif>

	<!---set the filter year--->
	<cfif isdefined("year_field") and year_field NEQ "">
		<cfset variables.filter_year = year_field>
	</cfif>
	<!---set the filter qtr--->
	<cfif isdefined("quarter_field") and quarter_field NEQ "">
		<cfset variables.filter_quarter = quarter_field>
	</cfif>
	<cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
		method="get_filter_Industry"  
		returnVariable="get_filter_Industry"> 
				<cfinvokeargument name="structure_field" value="#structure_field#"/> 
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
				<cfinvokeargument name="state_field" value="#state_field#"/> 
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
				<cfinvokeargument name="company_type_field" value="#company_type_field#"/> 
	</cfinvoke>	
	<cfif get_filter_CP.recordcount GT 0>
		<cfset variables.filter_company_type = valuelist(get_filter_CP.contractor_type)>
	<cfelse>
		<cfparam name="variables.filter_company_type" default="All">
	</cfif>	
	<div class="row">
						<div class="col-md-12">
							
							<div class="panel panel-default">
								<div class="panel-heading">
									<i class="fa fa-external-link-square"></i>
									Contractor Leaderboard 
									<cfoutput>
										<cfif not isdefined("year_field")>
									- #variables.default_year#
									<cfelseif isdefined("year_field")>
									- #year_field#
									</cfif></cfoutput>
								</div>
								<div class="panel-body"><cfoutput>
								<div class="pull-right">
								<a id="filterInfo" data-original-title="Applied Filters:" data-content="##filterData" data-placement="left" data-trigger="hover" href="##responsive" data-toggle="modal" class="demo btn btn-blue popovers">
									<i  class="fa fa-filter"> Filter</i>
									    
								</a>			
								</div>
								 </cfoutput>
									<div class="row">
										<div class="col-md-12 space20">
											
											<!---div class="btn-group pull-right">
												<button data-toggle="dropdown" class="btn btn-blue dropdown-toggle">
													Export <i class="fa fa-angle-down"></i>
												</button>
												<ul class="dropdown-menu dropdown-light pull-right">
													<li>
														<a href="#" class="export-pdf" data-table="#sample-table-2" data-ignoreColumn ="3,4"> Save as PDF </a>
													</li>
													<li>
														<a href="#" class="export-png" data-table="#sample-table-2" data-ignoreColumn ="3,4"> Save as PNG </a>
													</li>
													<li>
														<a href="#" class="export-csv" data-table="#sample-table-2" data-ignoreColumn ="3,4"> Save as CSV </a>
													</li>
													<li>
														<a href="#" class="export-excel" data-table="#sample-table-2" data-ignoreColumn ="3,4"> Export to Excel </a>
													</li>
												</ul>
											</div--->
										</div>
									</div>
									<div id="resultsGrid" class="table-responsive">
											
									<cfif isdefined("type")>
										<cfswitch expression="#type#">
										<cfcase value="1">
											<table class="table table-striped table-bordered table-hover table-full-width" id="search_resultsLBTable" >
											<thead>
												<tr>
													<th>Rank</th>
													<th>SupplierID</th>
													<th>Company Name</th>
													<th>Company City</th>
													<th>Company State</th>
													<th># Jobs Bid</th>
													<th># Jobs Won</th>
													<th>Volume Bid($)</th>
													<th>Volume Won($)</th>
													<th>Largest Win</th>
													<th>Eng. Est.($)</th>
													<th>Win Rate %</th>
													<th>Market Share %</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td colspan="12" class="dataTables_empty">Loading data from server</td>
												</tr>
											</tbody>
										</table>
										</cfcase>
										<cfcase value="2">
											<table class="table table-striped table-bordered table-hover table-full-width" id="search_resultsLBTable_2016">
											<thead>
												<tr>
													<th>Rank</th>
													<th>SupplierID</th>
													<th>Company Name</th>
													<th>Company City</th>
													<th>Company State</th>
													<th># Jobs Bid</th>
													<th># Jobs Won</th>
													<th>Volume Bid($)</th>
													<th>Volume Won($)</th>
													<th>Largest Win</th>
													<th>Eng. Est.($)</th>
													<th>Win Rate %</th>
													<th>Market Share %</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td colspan="12" class="dataTables_empty">Loading data from server</td>
												</tr>
											</tbody>
										</table>
										</cfcase>	
										<cfcase value="3">
											<table class="table table-striped table-bordered table-hover table-full-width" id="search_resultsLBTable_2015">
											<thead>
												<tr>
													<th>Rank</th>
													<th>SupplierID</th>
													<th>Company Name</th>
													<th>Company City</th>
													<th>Company State</th>
													<th># Jobs Bid</th>
													<th># Jobs Won</th>
													<th>Volume Bid($)</th>
													<th>Volume Won($)</th>
													<th>Largest Win</th>
													<th>Eng. Est.($)</th>
													<th>Win Rate %</th>
													<th>Market Share %</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td colspan="12" class="dataTables_empty">Loading data from server</td>
												</tr>
											</tbody>
										</table>
										</cfcase>
										<cfcase value="4">
											<table class="table table-striped table-bordered table-hover table-full-width" id="search_resultsLBTable_2014">
											<thead>
												<tr>
													<th>Rank</th>
													<th>SupplierID</th>
													<th>Company Name</th>
													<th>Company City</th>
													<th>Company State</th>
													<th># Jobs Bid</th>
													<th># Jobs Won</th>
													<th>Volume Bid($)</th>
													<th>Volume Won($)</th>
													<th>Largest Win</th>
													<th>Eng. Est.($)</th>
													<th>Win Rate %</th>
													<th>Market Share %</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td colspan="12" class="dataTables_empty">Loading data from server</td>
												</tr>
											</tbody>
										</table>
										</cfcase>
										</cfswitch>
									</cfif>
									</div>
										<div id="progress_bar" class="progress progress-striped active" style="display: none;" >
												<div class="progress-bar"  role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100" style="width: 80%">
													 Processing
												</div>
											</div>
								</div>
							</div>

						</div>
					</div>

			