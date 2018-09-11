<CFSET DATE = #CREATEODBCDATE(NOW())#> 
<cfparam name="structure_field" default="">
<cfparam name="state_field" default="">
<cfinvoke  
		component="#Application.CFCPath#.agency_profile"  
		method="get_Metrics"  
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
		component="#Application.CFCPath#.agency_profile"  
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
		component="#Application.CFCPath#.agency_profile"  
		method="get_Filter_state"  
		returnVariable="get_Filter_state"> 
				<cfinvokeargument name="state_field" value="#state_field#"/> 
	</cfinvoke>
	<cfif get_Filter_state.recordcount GT 0>	
		<cfset variables.filter_state = valuelist(get_Filter_state.state)>
	<cfelse>
		<cfparam name="variables.filter_state" default="All">	
	</cfif>
<cfparam name="variables.filter_year" default="2012,2013,2014,2015">
<cfparam name="variables.win_rate" default="0">
<cfparam name="variables.volume_bid_shorten" default="0">
<cfparam name="variables.volume_won_shorten" default="0">
<cfparam name="variables.avg_award_shorten" default="0">
<cfparam name="variables.largest_win_shorten" default="0">
<cfparam name="variables.eng_estimate_shorten" default="0">
<cfparam name="variables.leftontable_shorten" default="0">
<cfparam name="variables.suffix" default="">
<cfparam name="variables.suffixwon" default="">
<cfparam name="variables.suffixlargest_win" default="">
<cfparam name="variables.suffixeng_estimate" default="">
<cfparam name="variables.suffixleftontable" default="">

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
<cfif pull_metrics.avg_award NEQ "" and pull_metrics.avg_award GT 1000000>
	<cfset variables.avg_award_shorten = pull_metrics.avg_award/1000000>
	<cfset variables.suffixwon = "M">
<cfelseif pull_metrics.avg_award NEQ "" and pull_metrics.avg_award LT 1000000>
	<cfset variables.avg_award_shorten = pull_metrics.avg_award/1000>
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
<cfif pull_metrics.leftontable NEQ "" and pull_metrics.leftontable GT 1000000>
	<cfset variables.leftontable_shorten = pull_metrics.leftontable/1000000>
	<cfset variables.suffixleftontable = "M">
<cfelseif pull_metrics.leftontable NEQ "" and pull_metrics.leftontable LT 1000000>
	<cfset variables.leftontable_shorten = pull_metrics.leftontable/1000>
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
		<!---i class="fa fa-bar-chart-o"---></i><h4>Agency Key Metrics</h4>
	</div>
<cfoutput>
<div class="pull-right">
<a data-original-title="Applied Filters:" data-content="Year: #variables.filter_year#, State:#variables.filter_state# Industry: #variables.filter_industry#" data-placement="left" data-trigger="hover" href="##responsive" data-toggle="modal" class="demo btn btn-blue popovers">
	<i  class="fa fa-filter"> Filter</i>
	    
</a>			
</div>
 </cfoutput>

<div class="col-sm-7 col-md-8">
												<br>
												<!---p>
													Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas convallis porta purus, pulvinar mattis nulla tempus ut. Curabitur quis dui orci. Ut nisi dolor, dignissim a aliquet quis, vulputate id dui. Proin ultrices ultrices ligula, dictum varius turpis faucibus non. Curabitur faucibus ultrices nunc, nec aliquet leo tempor cursus.
												</p--->
												
									
												<div class="row">
															<ul class="large-stats col-sm-12">
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Volume Bid($): $#numberformat(pull_metrics.volume_bid)#" data-content="Total Agency Spending based on Awarded Projects" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted" >Total Spending ($)</h4>
																		$#numberformat(variables.volume_bid_shorten,"____.__")##variables.suffix#
																		
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Average Low Bid($): $#numberformat(pull_metrics.volume_won)#" data-content="Average Apparent Low Bid" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Average Low Bid ($)</h4>
																		$#numberformat(variables.volume_won_shorten,"____.__")##variables.suffixwon#
																		
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Average Award($): $#numberformat(pull_metrics.avg_award)#" data-content="Average Award" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Average Award ($)</h4>
																		$#numberformat(variables.avg_award_shorten)##variables.suffixwon#
																		
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Largest Win: $#numberformat(pull_metrics.largest_win)#" data-content="Largest Project Awarded by Total Dollars" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Largest Award</h4>
																		$#numberformat(variables.largest_win_shorten,"____.__")##variables.suffixlargest_win#
																		
																	</div>
																</li>
																
															</ul>
												</div>
												<div class="row">
												
															<ul class="large-stats col-sm-12">
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Number of Jobs Bid" data-content="Total number of projects let by this agency." data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">## Lettings</h4>
																		#pull_metrics.numberbid#
																		
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Number of Jobs Won" data-content="Total number of projects awarded by this agency" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">## Awards</h4>
																		#pull_metrics.numberwon#
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Win Rate" data-content="Percentage of jobs awarded. Difference between number of jobs let and number of jobs awarded" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Award %</h4>
																		#numberformat(variables.win_rate)#%
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="Engineer's Estimate Total: $#numberformat(pull_metrics.eng_estimate)#" data-content="Summation of Engineer's Minimum Cost Estimate (where available)" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Engineer's Estimate Total</h4>
																		$#round(variables.eng_estimate_shorten)##variables.suffixeng_estimate#
																		
																	</div>
																	<!---div class="values popovers" data-original-title="Left on Table" data-content="Bid Spread. Difference between winning bid and the 2nd bid." data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Left on Table ($)</h4>
																		$#round(variables.leftontable_shorten)##variables.suffixleftontable#
																	</div--->
																</li>
															</ul>
													
													<!---h6 class="pull-right">
														*Represents Verified Painting Projects
													</h6--->
											</div>
											
	


</cfoutput>