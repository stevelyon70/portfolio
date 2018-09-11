<cfinclude template="../template_inc/design/wrapper_top.cfm">
					<div class="row">
						<div class="col-sm-12">
						<!-- start: STYLE SELECTOR BOX -->
							<!---cfinclude template="#Application.rootpath#template_inc/style_selector_inc.cfm"--->
							<!-- end: STYLE SELECTOR BOX -->
							<cfif isdefined("engineerID")>
								<cfinclude template="filter_modal_profile_inc.cfm">
							</cfif>
							<!-- end: STYLE SELECTOR BOX -->
							<!-- start: PAGE TITLE & BREADCRUMB -->
							<!---ol class="breadcrumb">
								<li>
									<i class="clip-user-5"></i>									
										Profiles									
								</li>
								<li class="active">
									<cfif isdefined("engineer")>
										Engineer Profiles									
									</cfif>
								</li>
							</ol--->
						</div>
					</div>
					<cfset profileAddOnList = '15396,15401,15406,15398,1363,15400,15397,699'/>
					<cfif listfind(session.packages, 19) or session.auth.supplierID eq 2972 or listfind(session.packages, 20) or listfind(profileAddOnList, session.auth.userid)>
						<cfif isdefined("engineer") and not isdefined("results") and not isdefined("search")><br />
							<cfinclude template="main_inc.cfm">
						<cfelseif isdefined("search")><br />
							<cfinclude template="includes/engineer_search_inc.cfm">
						<cfelseif isdefined("results")><br />
							<cfinclude template="includes/search_results_inc.cfm">
						<cfelse>
							<cfinclude template="includes/engineer_search_inc.cfm">
						</cfif>	
					<cfelse>
							<div class="row">
								<div class="col-sm-3"></div>
								<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/##contact" >sales rep</a> directly.
								</div>
								<div class="col-sm-3"></div>
							</div>
					</cfif>
							
				</div>
			</div>
		</div>
		<cfinclude template="../template_inc/footer_inc.cfm">
		<cfinclude template="../template_inc/feedback.cfm">	
		<cfinclude template="../template_inc/script_inc.cfm">			
			<script src="<cfoutput>#request.rootpath#</cfoutput>assets/js/table-data-engineer.js"></script>
		<cfif isdefined("session.auth.access") and session.auth.access EQ "basic">
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
				TableData.init();}catch(e){}
				try{
				UIModals.init();}catch(e){}
				
			});
		</script>
<cfinclude template="../template_inc/design/wrapper_bot.cfm">