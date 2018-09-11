<CFSET DATE = #CREATEODBCDATE(NOW())#> 
<cfparam name="variables.pageID" default="1">
<cfparam name="variables.page_name" default="Marketing Unlock Form">
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
<cfparam name="variables.filter_year" default="2013,2014,2015,2016">

<!---set the filter year--->
<cfif isdefined("year_field") and year_field NEQ "">
	<cfset variables.filter_year = year_field>
</cfif>

<cfoutput>
<!---cfdump var="#pull_metrics#"--->
<!---date range picker format---> 	
<cfset lastdate = dateadd("m",-1,date)>
<cfset currentdate = date>

<!---include page view insert--->
<cfinclude template="../../template_inc/page_view_inc.cfm">




	<div class="col-sm-5 col-md-4">
		<!---i class="fa fa-bar-chart-o"---></i><h4>Letting Performance*</h4>
	</div>

	<div class="pull-right">
		<a data-original-title="Applied Filters:" data-content="Year: #variables.filter_year#, State:#variables.filter_state# Industry: #variables.filter_industry#" data-placement="left" data-trigger="hover" href="##responsive" data-toggle="modal" class="demo btn btn-blue popovers" disabled="disabled">
			<i  class="fa fa-filter"> Filter</i>
		</a>			
	</div>


<div class="col-sm-7 col-md-8">
												<br>
												<!---p>
													Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas convallis porta purus, pulvinar mattis nulla tempus ut. Curabitur quis dui orci. Ut nisi dolor, dignissim a aliquet quis, vulputate id dui. Proin ultrices ultrices ligula, dictum varius turpis faucibus non. Curabitur faucibus ultrices nunc, nec aliquet leo tempor cursus.
												</p--->
												
									
												<div class="row">
															<ul class="large-stats col-sm-12">
																<li class="col-sm-3">
																	<div class="values popovers" data-html="true" data-original-title="You must be a Paint BidTracker Plus subscriber to access performance metrics." data-content="Summation of Apparent Low Bids" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted" >Volume Bid ($)</h4>
																		<a href="" data-trigger="hover" data-toggle="modal" data-target="##unlockmod"><h5><i class="fa fa-lock"></i> Unlock Now</h5></a>																		
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="You must be a Paint BidTracker Plus subscriber to access performance metrics." data-content="Summation of Awards" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Volume Won ($)</h4>
																		<a href="" data-trigger="hover" data-toggle="modal" data-target="##unlockmod"><h5><i class="fa fa-lock"></i> Unlock Now</h5></a>																		
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="You must be a Paint BidTracker Plus subscriber to access performance metrics." data-content="Largest Project Awarded by Total Dollars" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Largest Win</h4>
																		<a href="" data-trigger="hover" data-toggle="modal" data-target="##unlockmod"><h5><i class="fa fa-lock"></i> Unlock Now</h5></a>																		
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="You must be a Paint BidTracker Plus subscriber to access performance metrics." data-content="Summation of Engineer's Minimum Cost Estimate (where available)" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Engineer's Estimate Total</h4>
																		<a href="" data-trigger="hover" data-toggle="modal" data-target="##unlockmod"><h5><i class="fa fa-lock"></i> Unlock Now</h5></a>																		
																	</div>
																</li>
															</ul>
												</div>
												<div class="row">
												
															<ul class="large-stats col-sm-12">
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="You must be a Paint BidTracker Plus subscriber to access performance metrics." data-content="Total number of projects where this contractor has placed a bid proposal." data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">## Jobs Bid</h4>
																		<a href="" data-trigger="hover" data-toggle="modal" data-target="##unlockmod"><h5><i class="fa fa-lock"></i> Unlock Now</h5></a>																		
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="You must be a Paint BidTracker Plus subscriber to access performance metrics." data-content="Total number of projects where this contractor was the apparent low bidder and was designated awardee." data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">## Jobs Won</h4>
																		<a href="" data-trigger="hover" data-toggle="modal" data-target="##unlockmod"><h5><i class="fa fa-lock"></i> Unlock Now</h5></a>
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="You must be a Paint BidTracker Plus subscriber to access performance metrics." data-content="Percentage of jobs won. Difference between number of jobs bid and number of jobs won" data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Win Rate %</h4>
																		<a href="" data-trigger="hover" data-toggle="modal" data-target="##unlockmod"><h5><i class="fa fa-lock"></i> Unlock Now</h5></a>
																	</div>
																</li>
																<li class="col-sm-3">
																	<div class="values popovers" data-original-title="You must be a Paint BidTracker Plus subscriber to access performance metrics." data-content="Bid Spread. Difference between winning bid and the 2nd bid." data-placement="top" data-trigger="hover">
																		<h4 class="text-muted">Left on Table ($)</h4>
																		<a href="" data-trigger="hover" data-toggle="modal" data-target="##unlockmod"><h5><i class="fa fa-lock"></i> Unlock Now</h5></a>
																	</div>
																</li>
															</ul>
													<h6 class="pull-right">
														*Represents Verified Painting Projects
													</h6>
													
											</div>
											
	


  <!-- Modal -->
  <div class="modal fade" id="unlockmod" role="dialog">
    <div class="modal-dialog modal-lg">    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Unlock Paint BidTracker Plus</h4>
        </div>
        <div class="modal-body">
			<div class="row">
				<div class="col-sm-6">
					<table width="100%" cellspacing="0" cellpadding="0" border="0">
						<tbody>
							<tr>
								<td valign="top" bgcolor="##ffffff">
								<img width="340" height="169" border="0" src="http://app.paintbidtracker.com/list_sales/marketing/PBT_ConTrakHomePage_033114_1/Contrakpic.jpg" style="display:block" alt="Paint BidTracker Plus helps you gauge market value by industry sector and region, evaluate market trends, and easily perform competitive intelligence." /><br />
								<br />
								<font face="Impact, sans-serif" style="font-size:24px; color:##193d75; line-height:28px">Paint BidTracker Plus</font><br />
								<font face="Impact, sans-serif" style="font-size:16px; color:##d15b1c; line-height:20px">Business Intelligence for the Coatings Industry.</font>
								<br /><br />

								<h4>Detailed Profiles on Painting Contractors</h4><font face="Arial, sans-serif" style="font-size:13px; color:##000000; line-height:16px">
								Features include:<br><br>
								<ul>
								<li>Benchmark Your Performance and Activity against Competitors</li><br>
								<li>Identify Top Agency Relationships</li><br>
								<li>Target Markets for Growth Opportunities</li><br>
								<li>Analyze Award, Planholder, and Bid Result Activity</li>
								</ul>

								</font><br />
								&nbsp;<br />

								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<form action="" role="form" id="upgradeform">
				<div class="col-sm-6">
					<h4> Learn More</h4>
					<p>
						Want to learn more? Simply complete the form below to get additional details on how to add these valuable insights to your account.
						Can't wait? Call your account manager at 1-800-837-8303 to get a free demo.
					</p>
					<hr>					
					<div class="row">
						<div class="col-md-12">
							<div class="errorHandler alert alert-danger no-display">
								<i class="fa fa-times-sign"></i> You have some form errors. Please check below.
							</div>
							<div class="successHandler alert alert-success no-display">
								<i class="fa fa-ok"></i> Your form validation is successful!
							</div>
						</div>
						<div class="msg_box msg_error" id="upgrade_errors" style="display:none">Please, enter data</div>
						<div class="col-md-12 form-group">
							<div class="form-group">
								<label>
									First Name <span class="symbol required"></span>
								</label>
								<input type="text" placeholder="Insert your First Name" class="form-control input-sm" id="firstname" name="firstname" value="#session.auth.firstname#">
							</div>
							<div class="form-group">
								<label>
									Last Name <span class="symbol required"></span>
								</label>
								<input type="text" placeholder="Insert your Last Name" class="form-control input-sm" id="lastname" name="lastname" value="#session.auth.lastname#">
							</div>
							<div class="form-group">
								<label>
									Email Address <span class="symbol required"></span>
								</label>
								<input type="email" placeholder="Text Field" class="form-control input-sm" id="email" name="email" value="#session.auth.userName#">
							</div>
							<div class="form-group">
								<label>
									Phone 
								</label>
								<input type="text" class="form-control input-mask-phone" id="phone" name="phone">
							</div>
							<!---<input type="hidden" id="userID" name="userID" value="#userID#">--->
						</div>
					</div>					
					<div class="row">
						<div class="col-md-12">
							<div>
								<span class="symbol required"></span>Required Fields
								<hr>
							</div>
						</div>
					</div>
					<div class="row">											
						<div class="col-md-12 pull-left">
							<button class="btn btn-blue" type="submit">Learn More <i class="fa fa-arrow-circle-right"></i></button>
						</div>
					</div>					
				</div>
			</div>
        </div>
        <div class="modal-footer">
			<button type="button" data-dismiss="modal" class="btn btn-light-grey">No, thank you. I don't want to grow my business</button>
			<!---<button class="btn btn-blue"  type="submit">Learn More</button>--->
        </div>
        </form>
      </div>      
    </div>
  </div>
<!---End Modal--->


</cfoutput>
<script>
	$(function () {
		$( "#upgradeform" ).validate({
			debug: true,
			rules: {
				email: {
					required: true,
					email: true
				},
				firstname: {
					required: true
				},	
				lastname: {
					required: true
				}			  
			},			
			submitHandler: function() {
				$.ajax({
					url: "includes/unlockProcess.cfm?val=" + Math.random(),
					type: 'POST',
					data: $("#upgradeform").serialize(),
					success: function() {
						$(".modal-body").html("Thank you for your interest in Paint BidTracker Plus.<br>Your information has been submitted and someone will contact you.");
						$(".modal-footer").html('<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>');
					},
					error: function() {
						alert('There has been an error, please alert us immediately');
					}		
					/*error: function (request, status, error) {
						alert(request.responseText);
					}*/

				});	
			}		
		});
	});			 
</script>