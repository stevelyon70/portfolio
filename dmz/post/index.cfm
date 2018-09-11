
<cfparam default="" name="url.function" />
<cfparam default="" name="url.action" />
<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 
<CFSET BASEDATE = #createodbcdate(now())#>  
<cfinclude template="../../template_inc/design/wrapper_top.cfm">
					
			<cftry>
				<cfswitch expression="#url.action#">
					<!---include the signup landing page for profiles--->
						<cfcase value="confirm">
							<cfinclude template="includes/bid_posting_form_confirm.cfm">
						</cfcase>
						<cfdefaultcase>
							<cfinclude template="includes/bid_posting_form.cfm">
						</cfdefaultcase>
					</cfswitch>
				<cfcatch><cfdump var="#cfcatch#"/></cfcatch>
			</cftry>
		</div>
	</div>
</div>
<cfinclude template="../../template_inc/footer_inc.cfm">
<cfinclude template="../../template_inc/feedback.cfm">	
<cfinclude template="../../template_inc/script_inc.cfm">	
<script>
	jQuery(document).ready(function() {
		Main.init();
	});
</script>
<cfinclude template="../../template_inc/design/wrapper_bot.cfm">

