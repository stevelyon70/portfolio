<cfparam default="account" name="url.action" />
<cfparam default="" name="url.function" />
<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 
<CFSET BASEDATE = #createodbcdate(now())#>  
<cfinclude template="../template_inc/design/wrapper_top.cfm">
<cfinclude template="../template_inc/script_inc.cfm">						
					<cfswitch expression="#url.action#">						
						<cfcase value="account">
							<cfinclude template="./includes/account_inc.cfm" />
						</cfcase>
						<cfdefaultcase>
								
						</cfdefaultcase>
					</cfswitch>
							
					
				</div>
			</div>
		</div>
		<cfinclude template="../template_inc/footer_inc.cfm">
		<cfinclude template="../template_inc/feedback.cfm">	
		
		<script>
			jQuery(document).ready(function() {
				Main.init();

			});
		</script>
<cfinclude template="../template_inc/design/wrapper_bot.cfm">