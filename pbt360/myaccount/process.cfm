<!--- This will be the area where variables are stored from referring pages--->
<cfif isdefined("tempHRef")><cfset tempHRef = tempHref></cfif>

<CFSET DATE = #CREATEODBCDATETIME(NOW())#>

<cfif isdefined("updateacct") and updateacct is 1>
	<cftransaction action="begin">
		<cfparam name="freshaddress" default = "passed"><!---Temporary bypass of FreshAddress code--->
		<cfset variables.date="#createodbcdatetime(now())#">
		<cfset variables.list_sourceID = 23>
		<!---Form field operations here--->
			<!---Identify all the possible form fields for the landing page--->
			<cfquery name="get_list_optins" datasource="#application.dataSource#">
				select e.name as field_name, 'list' as field_src, '1' as field_st, e.list_sourceID as fieldID
				from listman_source e 
				where e.list_sourceID in (1,3)
			</cfquery>
			<cfquery name="get_formfields" datasource="#application.dataSource#">
				select b.standard_fieldID as fieldID, b.standard_field as field_name, b.display_question, b.field_typeID, d.field_type, 'standard' as field_src, '2' as field_st, b.ref_tablefield 
				from listman_formfield_standard_definer b
				left outer join listman_field_types d on d.field_typeID = b.field_typeID
				where b.standard_fieldID in (1,2,3,4,6,7,8,9,10,11)
				
				union
				
				select c.custom_fieldID as fieldID, c.custom_field as field_name, c.display_question, c.field_typeID, d.field_type, 'custom' as field_src, '2' as field_st, NULL as ref_tablefield
				from listman_custom_fields_definer c
				left outer join listman_field_types d on d.field_typeID = c.field_typeID
				where c.custom_fieldID in (96, 103)	
				order by field_st
			</cfquery>
			
			<!---Loop through fields and set error redirect values--->
			<cfset variables.tempHRef = "">
			<cfloop query="get_list_optins">
				<cfif isdefined("ff_#field_src##fieldID#")>
					<cfset tempvar = #evaluate("ff_#field_src##fieldID#")#>
					<cfset variables.tempHRef = variables.tempHRef & "&ff_#field_src##fieldID#=#tempvar#">
				</cfif>
			</cfloop>
			<cfloop query="get_formfields">
				<cfif isdefined("ff_#field_src##fieldID#")>
					<cfset tempvar = #evaluate("ff_#field_src##fieldID#")#>
					<cfset variables.tempHRef = variables.tempHRef & "&ff_#field_src##fieldID#=#tempvar#">
				</cfif>
			</cfloop>
			<cfif isdefined("password")><cfset variables.tempHRef = variables.tempHRef & "password=#password#"></cfif>
			<cfif isdefined("password_confirm")><cfset variables.tempHRef = variables.tempHRef & "password_confirm=#password_confirm#"></cfif>
			<cfif isdefined("accept_terms")><cfset variables.tempHRef = variables.tempHRef & "accept_terms=#accept_terms#"></cfif>
			
			<!---Verify Password--->
			<cfif isdefined("password") and isdefined("password_confirm") and password is not "" and password_confirm is not "" and password is not  "#password_confirm#">
				<cflocation url="#rootpath#register/?fuseaction=profile&proc_error=password#tempHRef#" addtoken="false">
			<cfelseif isdefined("password") and isdefined("password_confirm") and password is not "" and password_confirm is not "" and password is  "#password_confirm#">
				<cfset update_password = "#password_confirm#">
			</cfif>
		
			<!---Process form if e-mail address is defined (otherwise no idea who to subscribe)--->
			<cfif isdefined("ff_standard3") and ff_standard3 is not "">
				<cfset email_var = #ff_standard3#>
				<!---Verify e-mail address--->	
				<cfquery name="get_invalids" datasource="#application.dataSource#">
					select distinct emailaddress
					from listman_invalid_emails
					where emailaddress = <cfqueryparam value="#email_var#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<!---Get previous e-mail address--->
				<cfquery name="grab_email" datasource="#application.dataSource#">
					select emailaddress 
					from reg_users
					where reg_userID = <cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfset orig_email = #grab_email.emailaddress#>
				<!---If email address is different, check for dupes--->
				<cfif email_var is not "#orig_email#">
					<cfquery name="ck_reg_email" datasource="#application.dataSource#">
						select reg_userID
						from reg_users
						where emailaddress = <cfqueryparam value="#email_var#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfquery name="ck_list_email" datasource="#application.dataSource#">
						select listID
						from listman_contacts
						where emailaddress = <cfqueryparam value="#email_var#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif ck_reg_email.recordcount gt 0 or ck_list_email.recordcount gt 0>
						<cfset variables.emailCheck_result = "bad">
						<cfset variables.proc_error = "dupeemail">
					</cfif>
				</cfif>	
				<cfif get_invalids.recordcount EQ 0>
					<!---Run the fresh address check--->
						
					<!---If fresh address email is bad set code--->
					<!---cfif freshaddress EQ "failed">
						<cfset variables.emailCheck_result = "bad">
						<cfquery name="insert_bad_email" datasource="#application.dataSource#">
						insert into listman_invalid_emails
						(emailaddress,code,date_processed)
						values(<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_var#">,#code#,#date#)
						</cfquery>
					<!---Else email is good--->
					<cfelseif freshaddress EQ "passed">
						<cfset variables.emailCheck_result = "good">
					</cfif--->	
					<!---*********For now, just verify for structure, not deliverability--->
					<CF_EmailVerify Email="#email_var#"> 
					<cfif emailerror is 1>
						<cfset variables.proc_error = "bademail">
						<cfset variables.emailCheck_result = "bad">
					<cfelse>
						<cfset variables.emailCheck_result = "good">
					</cfif>
				<cfelse>
					<!---We already have processed this email and marked as bad, no need to run api just mark as bad--->
					<cfset variables.emailCheck_result = "bad">
				</cfif>
				<cfif variables.emailCheck_result is "good">
					<!---Update reg_users--->
					<cfquery name="updateuser" datasource="#application.dataSource#">
						update reg_users
						set
						firstname=<cfif isdefined("ff_standard1") and ff_standard1 is not ""><cfqueryparam value="#ff_standard1#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>, 
						lastname=<cfif isdefined("ff_standard2") and ff_standard2 is not ""><cfqueryparam value="#ff_standard2#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>, 
						name=<cfif isdefined("ff_standard1") and ff_standard1 is not "" and isdefined("ff_standard2") and ff_standard2 is not ""><cfqueryparam value="#ff_standard1# #ff_standard2#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>, 
						companyname=<cfif isdefined("ff_standard4") and ff_standard4 is not ""><cfqueryparam value="#ff_standard4#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,  
						billingaddress=<cfif isdefined("ff_standard6") and ff_standard6 is not ""><cfqueryparam value="#ff_standard6#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>, 
						city=<cfif isdefined("ff_standard7") and ff_standard7 is not ""><cfqueryparam value="#ff_standard7#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,  
						stateID=<cfif isdefined("ff_standard8") and ff_standard8 is not ""><cfqueryparam value="#ff_standard8#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>, 
						postalcode=<cfif isdefined("ff_standard9") and ff_standard9 is not ""><cfqueryparam value="#ff_standard9#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>, 
						countryID=<cfif isdefined("ff_standard10") and ff_standard10 is not ""><cfqueryparam value="#ff_standard10#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>, 
						phonenumber=<cfif isdefined("ff_standard11") and ff_standard11 is not ""><cfqueryparam value="#ff_standard11#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,  
						emailaddress=<cfif isdefined("ff_standard3") and ff_standard3 is not ""><cfqueryparam value="#ff_standard3#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,  
						username=<cfif isdefined("ff_standard3") and ff_standard3 is not ""><cfqueryparam value="#ff_standard3#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>, 
						<cfif isdefined("update_password") and update_password is not "">password=<cfqueryparam value="#update_password#" cfsqltype="cf_sql_varchar">,</cfif>
						<cfif isdefined("accept_terms") and accept_terms is not "">accept_terms=<cfqueryparam value="#accept_terms#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
						modifiedon=<cfqueryparam value="#variables.date#" cfsqltype="cf_sql_timestamp">
						where reg_userID = <cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer">
					</cfquery>
					
					<!---Check for existing in EMP--->
					<cfquery name="check_contacts" datasource="#application.dataSource#" maxrows="1">
						select distinct emailaddress,listID
						from listman_contacts
						where emailaddress = <cfqueryparam value="#orig_email#" cfsqltype="cf_sql_varchar">
					</cfquery>	
					<!---If existing--->
					<cfif check_contacts.recordcount gt 0>
						<!---Update listman_contacts--->
						<cfquery name="updatecontact" datasource="#application.dataSource#">
							update listman_contacts
							set
							emailaddress=<cfif isdefined("ff_standard3") and ff_standard3 is not ""><cfqueryparam value="#ff_standard3#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
							firstname=<cfif isdefined("ff_standard1") and ff_standard1 is not ""><cfqueryparam value="#ff_standard1#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>, 
							lastname=<cfif isdefined("ff_standard2") and ff_standard2 is not ""><cfqueryparam value="#ff_standard2#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>, 
							companyname=<cfif isdefined("ff_standard4") and ff_standard4 is not ""><cfqueryparam value="#ff_standard4#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,  
							address=<cfif isdefined("ff_standard6") and ff_standard6 is not ""><cfqueryparam value="#ff_standard6#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>, 
							city=<cfif isdefined("ff_standard7") and ff_standard7 is not ""><cfqueryparam value="#ff_standard7#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,  
							stateID=<cfif isdefined("ff_standard8") and ff_standard8 is not ""><cfqueryparam value="#ff_standard8#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>, 
							postalcode=<cfif isdefined("ff_standard9") and ff_standard9 is not ""><cfqueryparam value="#ff_standard9#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>, 
							countryID=<cfif isdefined("ff_standard10") and ff_standard10 is not ""><cfqueryparam value="#ff_standard10#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>, 
							phonenumber=<cfif isdefined("ff_standard11") and ff_standard11 is not ""><cfqueryparam value="#ff_standard11#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>
							where listID = <cfqueryparam value="#check_contacts.listID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfset variables.listID = #check_contacts.listID#>
					<!---If not existing, create and get listID for contact--->
					<cfelse>
						<cfquery name="get_stand_fields" dbtype="query">
							select * from get_formfields
							where field_src = 'standard'
						</cfquery>
						<cfset listval_var = "#valuelist(get_stand_fields.ref_tablefield)#">
						<cfset listval_var = replace(listval_var, "listman.contacts.", "", "all")>
						<cfquery name="add_contact" datasource="#application.dataSource#">
							insert into listman_contacts
							(#listval_var#)
							values
							(<cfloop query="get_stand_fields">
								<cfset fieldcol_var = replace(ref_tablefield, "listman_contacts.", "", "all")>
								<cfswitch expression="#field_typeID#">
									<cfcase value="3"><cfset sql_var = "cf_sql_timestamp"></cfcase>
									<cfcase value="5"><cfset sql_var = "cf_sql_integer"></cfcase>
									<cfdefaultcase><cfset sql_var = "cf_sql_varchar"></cfdefaultcase>
								</cfswitch>
								<cfif isdefined("ff_#field_src##fieldID#") and #evaluate("ff_#field_src##fieldID#")# is not "">
									<cfqueryparam value="#evaluate("ff_#field_src##fieldID#")#" cfsqltype="#sql_var#">
								<cfelse>
									NULL
								</cfif>
								<cfif currentrow is not #recordcount#>,</cfif>
							</cfloop>
							)
						</cfquery>
						<cfquery name="grab_listID" datasource="#application.dataSource#" maxrows="1">
							select max(listID) as listID
							from listman_contacts
							order by listID desc
						</cfquery>
						<cfset variables.listID = #grab_listID.listID#>
					</cfif>	
					<!---Loop through all selected list_sourceIDs to add contact to list(s)--->		
					<cfquery name="get_formfield_values" datasource="#application.dataSource#">
						select custom_fieldID as fieldID, list_sourceID, field_typeID
						from listman_custom_fields_definer
						where list_sourceID in (23)
					</cfquery>
					<cfloop query="get_formfield_values">	
							<cfif isdefined("ff_custom#fieldID#")>
								<cfquery name="get_custom_fields" dbtype="query">
									select * from get_formfields
									where field_src = 'custom'
								</cfquery>
								<cfquery name="check_list_log" datasource="#application.dataSource#">
									select logID 
									from listman_contacts_log
									where listID = <cfqueryparam value="#variables.listID#" cfsqltype="cf_sql_integer">
									and list_sourceID = <cfqueryparam value="#list_sourceID#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfif check_list_log.recordcount is 0>
									<cfquery name="insert_list_log" datasource="#application.dataSource#">
										insert into listman_contacts_log
										(listID, list_sourceID, start_date)
										values
										(<cfqueryparam value="#variables.listID#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#list_sourceID#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#variables.date#" cfsqltype="cf_sql_timestamp">
										)
									</cfquery>
									<cfquery name="check_list_log" datasource="#application.dataSource#" maxrows="1">
										select max(logID) as logID
										from listman_contacts_log
										order by logID desc
									</cfquery>
								</cfif>
								<cfset logID_var = #check_list_log.logID#>
								<!---cfloop query="get_custom_fields"--->
								<cfif isdefined("ff_custom#fieldID#")>
									<cfquery name="check_custom_field" datasource="#application.dataSource#">
										select ID
										from listman_custom_fields_log
										where logID = <cfqueryparam value="#logID_var#" cfsqltype="cf_sql_integer">
										and custom_fieldID = <cfqueryparam value="#fieldID#" cfsqltype="cf_sql_integer">
									</cfquery>
									<cfif check_custom_field.recordcount gt 0>
										<cfquery name="update_custom" datasource="#application.dataSource#">
											update listman_custom_fields_log
											set 
											<cfswitch expression="#field_typeID#">
												<cfcase value="3">custom_field_date = <cfqueryparam value="#evaluate("ff_custom#fieldID#")#" cfsqltype="cf_sql_timestamp"></cfcase>
												<cfcase value="7">custom_field_area = <cfqueryparam value="#evaluate("ff_custom#fieldID#")#" cfsqltype="cf_sql_varchar"></cfcase>
												<cfdefaultcase>custom_field_value = <cfqueryparam value="#evaluate("ff_custom#fieldID#")#" cfsqltype="cf_sql_longvarchar"></cfdefaultcase>
											</cfswitch>
											where ID = <cfqueryparam value="#check_custom_field.ID#" cfsqltype="cf_sql_integer">
										</cfquery>
									<cfelse>
										<cfquery name="insert_custom" datasource="#application.dataSource#">
											insert into listman_custom_fields_log
											(logID, custom_fieldID, custom_field_value, custom_field_date, custom_field_area, active)
											values
											(<cfqueryparam value="#logID_var#" cfsqltype="cf_sql_integer">,
											<cfqueryparam value="#fieldID#" cfsqltype="cf_sql_integer">,
											<cfif evaluate("ff_custom#fieldID#") is not 3 and evaluate("ff_custom#fieldID#") is not 7><cfqueryparam value="#evaluate("ff_custom#fieldID#")#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
											<cfif evaluate("ff_custom#fieldID#") is 3><cfqueryparam value="#evaluate("ff_custom#fieldID#")#" cfsqltype="cf_sql_timestamp"><cfelse>NULL</cfif>,
											<cfif evaluate("ff_custom#fieldID#") is 7><cfqueryparam value="#evaluate("ff_custom#fieldID#")#" cfsqltype="longvarchar"><cfelse>NULL</cfif>,
											1)
										</cfquery>
									</cfif>
								</cfif>
								<!---/cfloop--->
							</cfif>
					</cfloop>
					<!---Send e-mail notifications--->
						<!---To the user--->
							<!---cfif get_page.user_email_html is not "">
								<cfinclude template="landing_email_user.cfm">
							</cfif--->
						<!---To the internal staff--->
							<!---cfinclude template="landing_email_internal.cfm"--->
				<cfelse>
					<cfset variables.proc_error ="bademail">
				</cfif>
			<cfelse>
				<cfset variables.proc_error = "noemail">
			</cfif>
	</cftransaction>
	<!---Redirects--->
	<cfif isdefined("proc_error")>
		<cflocation url="../myaccount/?proc_error=#variables.proc_error#" addtoken="false">
		<!---cfoutput><a href="#rootpath#register/?fuseaction=profile&proc_error=#variables.proc_error#">Click to continue...</a></cfoutput--->
	<cfelse>
		<cflocation url="../myaccount/?show_confirm=1" addtoken="false">
		<!---cfoutput><a href="#rootpath#register/?fuseaction=profile&show_confirm=1">Click to continue...</a></cfoutput--->
	</cfif>
</cfif>

