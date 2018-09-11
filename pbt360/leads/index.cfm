
<cfparam default="detail" name="url.action" />
<cfset site_tagID = 50>
<cfset rootpath = '' />
<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 
<CFSET BASEDATE = #createodbcdate(now())#> 
<cfinclude template="../template_inc/design/wrapper_top.cfm">
					<div class="row">
						<div class="col-sm-12">
							<!-- start: STYLE SELECTOR BOX -->
							<!---cfinclude template="template_inc/style_selector_inc.cfm"--->
							<!-- end: STYLE SELECTOR BOX -->
							<!-- start: PAGE TITLE & BREADCRUMB -->
							<!---ol class="breadcrumb">
								<li>
									<cfif isdefined("performance") or isdefined("performance_bridges") or isdefined("performance_tanks") or isdefined("performance_waste")>
										<i class="clip-stats"></i>
										Market Performance
									<cfelseif isdefined("brand_dashboard")>
										<i class="clip-bars"></i>
										Market Specification
									<cfelseif isdefined("brand_share")>
										<i class="clip-bars"></i>
										Market Specification
									<cfelseif isdefined("market_letting")>
										<i class="clip-stats"></i>
										Market Performance
									<cfelseif isdefined("dashboard")>
										<i class="clip-home-3"></i>
										Dashboard
									</cfif>
									
								</li>
								<li class="active">
									<cfif isdefined("performance")>
										Total Market Metrics
									<cfelseif isdefined("performance_bridges")>
										Bridge & Tunnels
									<cfelseif isdefined("performance_tanks")>
										Water Tanks
									<cfelseif isdefined("performance_waste")>
										Water / Waste
									<cfelseif isdefined("brand_dashboard")>
										Brand Dashboard
									<cfelseif isdefined("brand_share")>
										Specification Share Rankings
									<cfelseif isdefined("market_letting")>
										Letting Metrics
									</cfif>
								</li>
								<!---include the search form box--->
								<cfinclude template="../template_inc/main_search_inc.cfm">
							</ol--->
							<!---div class="page-header">
								<!---h1>Blank Page <small>blank page</small></h1--->
							</div--->
							<!-- end: PAGE TITLE & BREADCRUMB -->
						</div>
					</div>
					<!-- end: PAGE HEADER -->
					<!-- start: PAGE CONTENT -->
					<cftry>
					<cfswitch expression="#url.action#">
						<cfcase value="detail2">
							<cfinclude template="includes/detail2.cfm" />
						</cfcase>
						<cfcase value="detail">
							<cfinclude template="includes/detail.cfm" />
						</cfcase>
						<cfcase value="folder">
							<cfinclude template="../includes/folder.cfm" />
						</cfcase>
						<cfcase value="searches">
							<cfinclude template="../includes/searches.cfm" />
						</cfcase>
						<cfcase value="print">
							<cfinclude template="includes/print.cfm" />
						</cfcase>
						<cfcase value="planning">
							<cfinclude template="includes/spending.cfm" />
						</cfcase>
						<cfdefaultcase>
							lead detail
						</cfdefaultcase>
					</cfswitch>
					<cfcatch><cfdump var="#cfcatch#"/></cfcatch></cftry>
					<!---https://technologypublishing.bime.io/dashboard/main_dashboard##year=#application.default_year#&quarter=#application.default_qtr#--->
					<!-- end: PAGE CONTENT-->
				</div>
			</div>
			<!-- end: PAGE -->
		</div>
		<!-- end: MAIN CONTAINER -->
		<!--- start: FOOTER --->
		<cfinclude template="../template_inc/footer_inc.cfm">
		<cfinclude template="../template_inc/feedback.cfm">	
		<cfinclude template="../template_inc/script_inc.cfm">	
		<script>
			jQuery(document).ready(function() {
				Main.init();
			});
		</script>
<cfinclude template="../template_inc/design/wrapper_bot.cfm">