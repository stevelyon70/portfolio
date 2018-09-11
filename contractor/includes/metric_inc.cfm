<CFSET DATE = #CREATEODBCDATE(NOW())#> 
<cfparam name="structure_field" default="">
<cfparam name="state_field" default="">
<cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
		method="get_Metrics_wbt"  
		returnVariable="pull_metrics"> 
				<cfinvokeargument name="supplierID" value="#supplierID#"/> 
				<cfif isdefined("state_field") and state_field NEQ "">
				<cfinvokeargument name="state_field" value="#state_field#"/> 
				</cfif>
				<cfif isdefined("structure_field") and structure_field NEQ "">
				<cfinvokeargument name="structure_field" value="#structure_field#"/> 
				</cfif>
				<cfif isdefined("form.year_field") and form.year_field NEQ "">
				<cfinvokeargument name="year_field" value="#form.year_field#"/> 
				</cfif>
				<cfif isdefined("quarter_field") and quarter_field NEQ "">
				<cfinvokeargument name="quarter_field" value="#quarter_field#"/> 
				</cfif>
</cfinvoke>	

	<cfinvoke  
		component="#Application.CFCPath#.contractor_profile"  
		method="get_filter_Industry"  
		returnVariable="get_filter_Industry"> 
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
<cfparam name="variables.filter_year" default="2014,2015,2016,2017,2018">
<cfparam name="variables.win_rate" default="0">
<cfparam name="variables.volume_bid_shorten" default="0">
<cfparam name="variables.volume_won_shorten" default="0">
<cfparam name="variables.largest_win_shorten" default="0">
<cfparam name="variables.eng_estimate_shorten" default="0">
<cfparam name="variables.leftontable_shorten" default="0">
<cfparam name="variables.suffix" default="">
<cfparam name="variables.suffixwon" default="">
<cfparam name="variables.suffixlargest_win" default="">
<cfparam name="variables.suffixeng_estimate" default="">
<cfparam name="variables.suffixleftontable" default="">
<cfparam name="variables.leftontable_diff" default="">
<cfparam name="variables.leftontable_bid_percentage" default="">
<cfif pull_metrics.numberbid NEQ 0>
	<cfset variables.bidonly = pull_metrics.numberbid>
<cfset variables.win_rate = pull_metrics.numberwon*100/variables.bidonly>
</cfif>
<cfif pull_metrics.volume_bid GT 1000000>
	<cfset variables.volume_bid_shorten = pull_metrics.volume_bid/1000000>
	<cfset variables.suffix = "M">
<cfelseif pull_metrics.volume_bid NEQ "" and pull_metrics.volume_bid LT 1000000>
	<cfset variables.volume_bid_shorten = pull_metrics.volume_bid/1000>
	<cfset variables.suffix = "K">
</cfif>
<cfif pull_metrics.volume_won NEQ "" and pull_metrics.volume_won GT 1000000>
	<cfset variables.volume_won_shorten = pull_metrics.volume_won/1000000>
	<cfset variables.suffixwon = "M">
<cfelseif pull_metrics.volume_won NEQ "" and pull_metrics.volume_won LT 1000000>
	<cfset variables.volume_won_shorten = pull_metrics.volume_won/1000>
	<cfset variables.suffixwon = "K">
</cfif>
<cfif pull_metrics.largest_win NEQ "" and pull_metrics.largest_win GT 1000000>
	<cfset variables.largest_win_shorten = pull_metrics.largest_win/1000000>
	<cfset variables.suffixlargest_win = "M">
<cfelseif pull_metrics.largest_win NEQ "" and pull_metrics.largest_win LT 1000000>
	<cfset variables.largest_win_shorten = pull_metrics.largest_win/1000>
	<cfset variables.suffixlargest_win = "K">
</cfif>
<cfif pull_metrics.eng_estimate NEQ "" and pull_metrics.eng_estimate GT 1000000>
	<cfset variables.eng_estimate_shorten = pull_metrics.eng_estimate/1000000>
	<cfset variables.suffixeng_estimate = "M">
<cfelseif pull_metrics.eng_estimate NEQ "" and pull_metrics.eng_estimate LT 1000000>
	<cfset variables.eng_estimate_shorten = pull_metrics.eng_estimate/1000>
	<cfset variables.suffixeng_estimate = "K">
</cfif>
<cfif pull_metrics.leftontable NEQ "" and pull_metrics.volume_won NEQ "">
	<!---cfset variables.leftontable_diff = pull_metrics.leftontable-pull_metrics.volume_won>
	<cfset variables.leftontable_bid_percentage = variables.leftontable_diff/pull_metrics.volume_won*100--->
	<cfset variables.leftontable_diff = pull_metrics.leftontable>
	<cfset variables.leftontable_bid_percentage = variables.leftontable_diff/pull_metrics.volume_won*100>
</cfif>

<cfif variables.leftontable_diff NEQ "" and variables.leftontable_diff GT 1000000>
	<cfset variables.leftontable_shorten = variables.leftontable_diff/1000000>
	<cfset variables.suffixleftontable = "M">
<cfelseif variables.leftontable_diff NEQ "" and variables.leftontable_diff LT 1000000>
	<cfset variables.leftontable_shorten = variables.leftontable_diff/1000>
	<cfset variables.suffixleftontable = "K">
</cfif>
<!---set the filter year--->
<cfif isdefined("year_field") and year_field NEQ "">
	<cfset variables.filter_year = year_field>
</cfif>

<cfoutput><!---cfdump var="#pull_metrics#"--->
<!---date range picker format---> 	
<cfset lastdate = dateadd("m",-1,date)>
<cfset currentdate = date>
<!--div>
	<br>
</div-->

	<div class="col-sm-5 col-md-4">
		<!---i class="fa fa-bar-chart-o"---></i><h4>Letting Performance</h4>
	</div>
<cfoutput>
<div class="pull-right">
<a id="filterInfo" data-original-title="Applied Filters:" data-content="Year: #variables.filter_year#, State:#variables.filter_state# Structure Tags: #variables.filter_industry#" data-placement="left" data-trigger="hover" href="##responsive" data-toggle="modal" class="demo btn btn-blue popovers">
	<i  class="fa fa-filter"> Filter</i>
	    
</a>			
</div>
 </cfoutput>

<div class="col-sm-7 col-md-8">
												<br>
												
									
												<div class="row">
															<ul class="large-stats col-sm-12">
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Volume Bid($): $#numberformat(pull_metrics.volume_bid)#" data-content="Summation of Apparent Low Bids" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted" >Volume Bid ($)</h4>
																		$#numberformat(variables.volume_bid_shorten,"____.__")##variables.suffix#
																		
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Volume Won($): $#numberformat(pull_metrics.volume_won)#" data-content="Summation of Awards" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Volume Won ($)</h4>
																		$#numberformat(variables.volume_won_shorten,"____.__")##variables.suffixwon#
																		
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Largest Win: $#numberformat(pull_metrics.largest_win)#" data-content="Largest Project Awarded by Total Dollars" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Largest Win</h4>
																		$#numberformat(pull_metrics.largest_win)#
																		
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Engineer's Estimate Total: $#numberformat(pull_metrics.eng_estimate)#" data-content="Summation of Engineer's Minimum Cost Estimate (where available)" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Engineer's Estimate Total</h4>
																		$#round(variables.eng_estimate_shorten)##variables.suffixeng_estimate#
																		
																	</div>
																</li>
															</ul>
												</div>
												<div class="row">
												
															<ul class="large-stats col-sm-12">
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Number of Jobs Bid" data-content="Total number of projects where this contractor has placed a bid proposal." data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">## Jobs Bid</h4>
																		#pull_metrics.numberbid#
																		
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Number of Jobs Won" data-content="Total number of projects where this contractor was the apparent low bidder and was designated awardee." data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">## Jobs Won</h4>
																		#pull_metrics.numberwon#
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Win Rate" data-content="Percentage of jobs won. Difference between number of jobs bid and number of jobs won" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Win Rate %</h4>
																		#numberformat(variables.win_rate)#%
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Left on Table: $#numberformat(variables.leftontable_diff)# (% of Bid: #numberformat(variables.leftontable_bid_percentage)#%)" data-content="Bid Spread. Difference between winning bid and the 2nd bid." data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Left on Table ($)</h4>
																		$#numberformat(variables.leftontable_diff)#
																	</div>
																</li>
															</ul>
													<!---<h6 class="pull-right">
														*Represents Verified Painting Projects
													</h6>--->
													
											</div>
											
	


</cfoutput>