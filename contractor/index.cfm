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
							
						</div>
					</div>
					<!-- end: PAGE HEADER -->
					<!-- start: PAGE CONTENT -->
					<cfset profileAddOnList = '15396,15401,15406,15398,1363,15400,15397,699'/>
					<cfparam default="0" name="session.packages" />			
					<cfif listfind(session.packages, 19) or session.auth.supplierID eq 2972 or listfind(session.packages, 20) or listfind(profileAddOnList, session.auth.userid)>
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