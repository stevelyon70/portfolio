<cfparam default="folders" name="url.action" />
<cfparam default="" name="url.function" />
<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 
<CFSET BASEDATE = #createodbcdate(now())#>  
<cfinclude template="../../template_inc/design/wrapper_top.cfm">
					
					<cftry>
					<cfswitch expression="#url.action#">
						<cfcase value="folders">
							<cfinclude template="../includes/folders.cfm" />
						</cfcase>
						<cfcase value="folder">
							<cfinclude template="../includes/folder.cfm" />
						</cfcase>
						<cfcase value="clip">
							<cfinclude template="../includes/clip.cfm" />
						</cfcase>
						<cfcase value="searches">
							<cfinclude template="../includes/searches.cfm" />
						</cfcase>
						<cfcase value="59">
							<cfinclude template="../includes/delFolder.cfm" />
						</cfcase>
						<cfcase value="585">
							<cfinclude template="../includes/delFolders.cfm" />
						</cfcase>
						<cfcase value="61">
							<cfinclude template="../includes/removePjtFrmFolder.cfm" />
						</cfcase>
						<cfcase value="610">
							<cfinclude template="../includes/removePjtsFrmFolder.cfm" />
						</cfcase>
						<cfcase value="62">
							<cfinclude template="../includes/movePjt.cfm" />
						</cfcase>
						<cfcase value="620">
							<cfinclude template="../includes/savePjt.cfm" />
						</cfcase>
						<cfcase value="58">
							<cfinclude template="includes/edit_folder.cfm" />
						</cfcase>
						<cfcase value="60">
							<cfinclude template="includes/new_project.cfm" />
						</cfcase>
						<cfcase value="46">
							<cfinclude template="../includes/delSearch.cfm" />
						</cfcase>
						<cfdefaultcase>
								help
						</cfdefaultcase>
					</cfswitch>
					<cfcatch><cfdump var="#cfcatch#"/></cfcatch></cftry>
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