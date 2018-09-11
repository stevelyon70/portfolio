<cfparam default="default" name="url.action" />
<cfparam default="" name="url.function" />
<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 
<CFSET BASEDATE = #createodbcdate(now())#>  
<cfinclude template="../template_inc/design/wrapper_top.cfm">
					
					<cfswitch expression="#url.action#">						
						<cfcase value="91">
							grrrr
						</cfcase>
						<cfdefaultcase>
								<cfinclude template="./includes/email_pref_inc.cfm" />
						</cfdefaultcase>
					</cfswitch>
							
					
				</div>
			</div>
		</div>
		<cfinclude template="../template_inc/footer_inc.cfm">
		<cfinclude template="../template_inc/feedback.cfm">	
		<cfinclude template="../template_inc/script_inc.cfm">	
		<script>
			jQuery(document).ready(function() {
				try{
				Main.init();}catch(e){}
				try{
				FormElements.init();}catch(e){}
			});
		</script>
<cfinclude template="../template_inc/design/wrapper_bot.cfm">