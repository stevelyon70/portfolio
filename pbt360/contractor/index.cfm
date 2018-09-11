<cfinclude template="../template_inc/design/wrapper_top.cfm">
					<div class="row">
						<div class="col-sm-12">
							<!-- start: STYLE SELECTOR BOX -->
							<!---cfinclude template="#request.rootpath#template_inc/style_selector_inc.cfm"--->
							<!-- end: STYLE SELECTOR BOX -->
							<cfif isdefined("contractor_leaderboard")>
							<!-- start: FILTER -->
								<cfinclude template="filter_modal_inc.cfm">
							<cfelseif isdefined("supplierID")>
								<cfinclude template="filter_modal_profile_inc.cfm">
							</cfif>
							<!-- end: STYLE SELECTOR BOX -->
							<!-- start: PAGE TITLE & BREADCRUMB -->
							<ol class="breadcrumb">
								<li>
									<cfif isdefined("contractor_leaderboard")><i class="clip-airplane"></i> Contractor Benchmarks<cfelse><i class="clip-user-5"></i> Profiles</cfif>
								</li>
								<li class="active">
									<cfif isdefined("contractor")>
										Contractor Profile
									<cfelseif isdefined("contractor_leaderboard")>
										Contractor Leaderboard
									</cfif>
								</li>
								<!---include the search form box--->
								<!---cfinclude template="#request.rootpath#template_inc/main_search_inc.cfm"--->
							</ol>
							<!---div class="page-header">
								<h1>Contractor Profile</h1>
							</div--->
							<!-- end: PAGE TITLE & BREADCRUMB -->
						</div>
					</div>
					<!-- end: PAGE HEADER -->
					<!-- start: PAGE CONTENT -->
					<cfif isdefined("contractor") and not isdefined("results") and not isdefined("search")><br />
						<cfinclude template="main_inc.cfm">
					<cfelseif isdefined("search")><br />
						<cfinclude template="includes/contractor_search_inc.cfm">
					<cfelseif isdefined("results")><br />
						<cfinclude template="includes/search_results_inc.cfm">
					<cfelseif isdefined("contractor_leaderboard")><br />
						<cfinclude template="includes/lb_search_results_inc.cfm">
					<!---cfoutput>
						<div class="bime-container">
						<iframe frameBorder="0" seamless id="frame1" name="frame1" scroll="no" height=820px width=1500px  src="https://technologypublishing.bime.io/dashboard/contractor_leaderboard?access_token=#session.auth.user_access_token###year=#session.auth.default_year#"></iframe>
						</div>
					</cfoutput--->
					</cfif>		
				</div>
			</div>
		</div>
		<cfinclude template="../template_inc/footer_inc.cfm">
		<cfinclude template="../template_inc/feedback.cfm">	
		<cfinclude template="../template_inc/script_inc.cfm">				
		<script src="<cfoutput>#request.rootpath#</cfoutput>assets/js/table-data.js"></script>
			
			
		<cfif StructKeyExists(session,"auth.access") and session.auth.access EQ "basic">
			<script type="text/javascript" language="javascript">
			  $(function() {
			       $('#unlockmod').modal('show');
			    });
			</script>
		</cfif>
		<!-- end: JAVASCRIPTS REQUIRED FOR THIS PAGE ONLY -->
		<script>
			jQuery(document).ready(function() {
				
				
				try{
				Main.init();}catch(e){}
				try{
				FormElements.init();}catch(e){}
				try{
				FormValidator.init();}catch(e){}
				try{
				TableData.init();}catch(e){}
				try{
				UIModals.init();}catch(e){}
				
			});
		</script>
<cfinclude template="../template_inc/design/wrapper_bot.cfm">