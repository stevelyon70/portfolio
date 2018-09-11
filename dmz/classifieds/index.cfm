<cfset rootpath = "../">
<cfoutput>

	<!---Main content column--->
	<div align="left">
		<cfif not isdefined("fuseaction") or fuseaction is "">
			<cfinclude template="includes/base.cfm">
		<cfelse>
			<cfswitch expression="#fuseaction#">
				<cfcase value="jobs">
					<cfif isdefined("action") and action is not "">
						<cfswitch expression="#claction#">
							<cfcase value="viewall">
								<cfinclude template="includes/jobs_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="view">
								<cfquery name="jobdetail" datasource="#application.dataSource#">
									select a.jobID, a.supplierID, a.confidential, a.positiontitle, a.dateposted, a.lastupdated, a.resumeEmail, 
									a.location, a.description, a.stateID, a.countryID, a.payrate, a.featured_job, a.featuredjob_imagelocation, d.state, e.country, b.companyname, 
									c.companyname as regconame, a.meta_keywords, a.displaycompany, a.featuredjob_expiration, a.cb_DID, a.cb_apply_link, a.cb_detail_link
									from job_master a
									left outer join supplier_master b on b.supplierID = a.supplierID
									left outer join reg_users c on c.reg_userID = a.reg_UserID
									left outer join state_master d on d.stateID = a.stateID
									left outer join country_master e on e.countryID = a.countryID
									where a.jobID = <cfqueryparam value = "#jobID#" cfsqltype = "cf_sql_integer">
								</cfquery>												
								<cfinclude template="includes/jobs_detail_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="post">
								<cfinclude template="includes/jobs_post_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="search">
								<cfinclude template="includes/jobs_search_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="apply">
								<cfinclude template="includes/jobs_apply_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="forward">
								<cfinclude template="includes/jobs_forward_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="edit">
								<cfinclude template="includes/jobs_edit_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="stats">
								<cfinclude template="includes/jobs_stats_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="featco">
								<cfinclude template="includes/jobs_featco_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="featcontact">
								<cfinclude template="includes/jobs_featcontact_inc.cfm"><!---done--->
							</cfcase>
						</cfswitch>
					<cfelse>
						<cfinclude template="includes/jobs_inc.cfm"><!---done--->
					</cfif>
				</cfcase>
				<cfcase value="resumes">
					<cfif isdefined("action") and action is not "">
						<cfswitch expression="#action#">
							<cfcase value="viewall">
								<cfinclude template="includes/resumes_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="view">
								<cfinclude template="includes/resumes_detail_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="contact">
								<cfinclude template="includes/resumes_contact_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="post">
								<cfinclude template="includes/resumes_post_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="search">
								<cfinclude template="includes/resumes_search_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="edit">
								<cfinclude template="includes/resumes_edit_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="stats">
								<cfinclude template="includes/resumes_stats_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="purchase">
								<cfinclude template="includes/resumes_purchase_inc.cfm"><!---done--->
							</cfcase>
						</cfswitch>
					<cfelse>
						<cfinclude template="includes/resumes_inc.cfm"><!---done--->
					</cfif>
				</cfcase>
				<cfcase value="forsale">
					<cfif isdefined("action") and action is not "">
						<cfswitch expression="#action#">
							<cfcase value="viewall">
								<cfinclude template="includes/forsale_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="view">
								<cfinclude template="includes/forsale_detail_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="post">
								<cfinclude template="includes/forsale_post_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="search">
								<cfinclude template="includes/forsale_search_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="edit">
								<cfinclude template="includes/forsale_edit_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="stats">
								<cfinclude template="includes/forsale_stats_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="contact">
								<cfinclude template="includes/forsale_contact_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="forward">
								<cfinclude template="includes/forsale_forward_inc.cfm"><!---done--->
							</cfcase>
						</cfswitch>
					<cfelse>
						<cfinclude template="includes/forsale_inc.cfm"><!---done--->
					</cfif>
				</cfcase>
				<cfcase value="wanted">
					<cfif isdefined("action") and action is not "">
						<cfswitch expression="#action#">
							<cfcase value="viewall">
								<cfinclude template="includes/wanted_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="view">
								<cfinclude template="includes/wanted_detail_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="post">
								<cfinclude template="includes/wanted_post_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="search">
								<cfinclude template="includes/wanted_search_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="edit">
								<cfinclude template="includes/wanted_edit_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="stats">
								<cfinclude template="includes/wanted_stats_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="contact">
								<cfinclude template="includes/wanted_contact_inc.cfm"><!---done--->
							</cfcase>
							<cfcase value="forward">
								<cfinclude template="includes/wanted_forward_inc.cfm"><!---done--->
							</cfcase>
						</cfswitch>
					<cfelse>
						<cfinclude template="includes/wanted_inc.cfm"><!---done--->
					</cfif>
				</cfcase>
				<cfcase value="manage">
					<cfinclude template="includes/manage_inc.cfm"><!---done--->
				</cfcase>
				<cfcase value="faq">
					<cfinclude template="includes/faq_inc.cfm"><!---done--->
				</cfcase>
				<cfdefaultcase>
					<cfinclude template="includes/main_inc.cfm"><!---done--->
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</div>

</cfoutput>

