<cfinclude template="../template_inc/design/wrapper_top.cfm">
					<div class="row">
						<div class="col-sm-12">
							<cfif isdefined("supplierID")>
								<cfinclude template="filter_modal_profile_inc.cfm">
							</cfif>
							<!-- start: PAGE TITLE & BREADCRUMB -->
							<ol class="breadcrumb">
								<li>
									<i class="clip-user-5"></i>									
										Profiles									
								</li>
								<li class="active">
									<cfif isdefined("agency")>
										Agency Profiles									
									</cfif>
								</li>
							</ol>
						</div>
					</div>
					<cfif isdefined("agency") and not isdefined("results") and not isdefined("search")><br />
						<cfinclude template="main_inc.cfm">
					<cfelseif isdefined("search")><br />
						<cfinclude template="includes/agency_search_inc.cfm">
					<cfelseif isdefined("results")><br />
						<cfinclude template="includes/search_results_inc.cfm">
					<cfelse>
						<cfinclude template="includes/agency_search_inc.cfm">
					</cfif>	
				</div>
			</div>
		</div>
		<cfinclude template="../template_inc/footer_inc.cfm">
		<cfinclude template="../template_inc/feedback.cfm">	
		<cfinclude template="../template_inc/script_inc.cfm">	
		
		<script src="<cfoutput>#request.rootpath#</cfoutput>assets/js/table-data-agency.js"></script>
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