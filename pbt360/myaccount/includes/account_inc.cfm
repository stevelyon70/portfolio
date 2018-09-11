<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<cfset site_lists = "14,3,6,16">
<!---Check for current login--->
<!---cfif not isdefined("getuser")>
	<cflocation url="#rootpath#register/?fuseaction=login" addtoken="false">
</cfif--->
<!---Get user full details--->
<cfquery name="getuser" datasource="#application.dataSource#">
	select reg_userID, firstname, lastname, companyname, billingaddress, city, stateID, postalcode, countryID, phonenumber, emailaddress, accept_terms
	from reg_users
	inner join bid_users on reg_users.reg_userid = bid_users.reguserid
	where bid_users.userid = <cfqueryparam value="#session.auth.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<!---Get current list status and demographics--->
<!---Check for existing in EMP--->
<cfquery name="check_contacts" datasource="#application.dataSource#">
	select distinct emailaddress,listID
	from listman_contacts
	where emailaddress = <cfqueryparam value="#getuser.emailaddress#" cfsqltype="cf_sql_varchar">
</cfquery>	
<cfif check_contacts.listID is not "">
	<cfquery name="check_list_log" datasource="#application.dataSource#">
		select logID 
		from listman_contacts_log
		where listID in (<cfqueryparam value="#valuelist(check_contacts.listID)#" cfsqltype="cf_sql_integer" list="true">)
		and list_sourceID in (23)
	</cfquery>
	<cfif check_list_log.logID is not "">
		<cfquery name="check_custom_field" datasource="#application.dataSource#">
			select *
			from listman_custom_fields_log
			where logID in (<cfqueryparam value="#valuelist(check_list_log.logID)#" cfsqltype="cf_sql_integer" list="true">)
			and custom_fieldID in (96, 103)
		</cfquery>
	</cfif>
	<cfquery name="get_list_optins" datasource="#application.dataSource#">
		select e.display_list_name as field_name, 'list' as field_src, '1' as field_st, e.list_sourceID as fieldID
		from listman_source e 
		where e.list_sourceID in (<cfqueryparam value="#site_lists#" cfsqltype="cf_sql_integer" list="true">)
	</cfquery>
	<cfquery name="check_status" datasource="#application.dataSource#">
		select a.logID, b.listID, b.list_sourceID, a.statusID, d.status, e.name, a.date_processed
		from listman_status a
		inner join listman_contacts_log b on b.logID = a.logID
		inner join listman_contacts c on c.listID = b.listID
		left outer join listman_status_definer d on d.statusID = a.statusID
		left outer join listman_source e on e.list_sourceID = b.list_sourceID
		where c.emailaddress = <cfqueryparam value="#getuser.emailaddress#" cfsqltype="cf_sql_varchar">
	</cfquery>
</cfif>

	<cfquery name="get_states" datasource="#application.dataSource#">
		select stateID, fullname, countryid
		from state_master
		where stateID <> '66'
		order by sort
	</cfquery>
	<cfquery name="get_countries" datasource="#application.dataSource#">
		SELECT countryID, country, countrycode
		FROM country_master
		WHERE sort <> ''
		ORDER BY sort
	</cfquery>

	<cfquery name="get_all_formfields" datasource="#application.dataSource#">
		select a.*, b.custom_field_tagID, b.custom_field_tag
		from listman_custom_fields_definer a
		left outer join  listman_custom_fields_value_definer b on b.custom_fieldID = a.custom_fieldID
		where 
		 (
			(a.list_sourceID = 23 and a.custom_fieldID in (96, 103))
			<!--- or 
			(a.list_sourceID = 1 and a.custom_fieldID in (32))--->
		 )
		and a.active = 1
		and (b.active = 1 or b.active is null)
		order by a.list_sourceID desc, a.custom_fieldID, b.sort
	</cfquery>
	<cfquery name="get_formfields" dbtype="query">
		select distinct custom_fieldID as fieldID, custom_field as field_name, display_question, field_typeID, 'custom' as field_src, '2' as required
		from get_all_formfields
	</cfquery>

<CFSET DATE = #CREATEODBCDATETIME(NOW())#>

<cfoutput>
	<div class="page-header">
	<h3>Account Profile for <small><b>#getuser.firstname# #getuser.lastname#</b></small></h3>
	</div>

	<div class="col-xs-12 col-sm-12 col-md-6 col-lg-5 pull-left" style="background: linear-gradient(to top,transparent,##f9f8f8);">
		<div>		
		<table border="0" cellpadding="5" cellspacing="0" width="100%">

			<tr>
				<td colspan="2">
				<h2>Contact Info</h2>
					<cfif isdefined("proc_error") and proc_error is not "">
						<p style="color:red;background-color:##f7ff6d;padding-top:10px; padding-bottom:10px;" align="center">
						<cfswitch expression="#proc_error#">
							<cfcase value="bademail">
								The email address you entered was not valid. Please try again.
							</cfcase>
							<cfcase value="noemail">
								A valid e-mail address is required. Please try again.
							</cfcase>
							<cfcase value="dupeemail">
								The e-mail address you entered already exists in our system, so the changes could not be saved. Please try again.
							</cfcase>
							<cfcase value="password">
								The password you submitted did not match the confirming value. Please try again.
								<cfset password = "">
								<cfset password_confirm = "">
							</cfcase>
						</cfswitch>
						</p>
					</cfif>
					<cfif isdefined("show_confirm")>
						<p style="background-color:##f7ff6d;padding-top:10px; padding-bottom:10px;" align="center">Your changes have been saved.</p>
					</cfif>
					<p>
						Your current information is shown below. To update, make any changes and click the 'Save changes' button at the bottom of the page.
					</p>
					<p class="bold"><em>*Denotes required field</em></p>
				</td>
			</tr>
		</table>
		</div>
		<div>		
			<cfform method="post" action="process.cfm?updateacct=1">						
				<fieldset>
				<div class="form-group">
					<label class="control-label" for="ff_standard1">
						<b>First Name*</b>
					</label>  
					<div>
						<cfif isdefined("ff_standard1")>
							<cfinput type="text" class="form-control input-md" name="ff_standard1" value="#ff_standard1#" required="Yes" message="First Name is a required field.">
						<cfelse>
							<cfinput type="text" class="form-control input-md" name="ff_standard1" value="#getuser.firstname#" required="Yes" message="First Name is a required field.">
						</cfif>	
					</div>
				</div>	
				<div class="form-group">
					<label class="control-label" for="ff_standard2">
						<b>Last Name*</b>
					</label>  
					<div>
						<cfif isdefined("ff_standard2")>
							<cfinput type="text" class="form-control input-md" name="ff_standard2" value="#ff_standard2#" required="Yes" message="Last Name is a required field.">
						<cfelse>
							<cfinput type="text" class="form-control input-md" name="ff_standard2" value="#getuser.lastname#" required="Yes" message="Last Name is a required field.">
						</cfif>	
					</div>
				</div>		
				<div class="form-group">
					<label class="control-label" for="ff_standard3">
						<b>E-mail Address*</b>
					</label>  
					<div>
						<cfif isdefined("ff_standard2")>
							<cfinput type="text" class="form-control input-md" name="ff_standard3" value="#ff_standard3#" required="Yes" message="E-mail Address is a required field.">
						<cfelse>
							<cfinput type="text" class="form-control input-md" name="ff_standard3" value="#getuser.emailaddress#" required="Yes" message="E-mail Address is a required field.">
						</cfif>	
					</div>
				</div>	
				<div class="form-group">
					<label class="control-label" for="password">
						Change Password:
					</label>  
					<div>
						<cfif isdefined("password")>
							<cfinput class="form-control input-md" type="password" name="password" value="#password#" id="password">
						<cfelse>
							<cfinput class="form-control input-md" type="password" name="password" value="" id="password">
						</cfif>	
					</div>
				</div>	
				<div class="form-group">
					<label class="control-label" for="passwordconfirm">
						Confirm change:
					</label>  
					<div>
						<cfif isdefined("password_confirm")>
							<cfinput class="form-control input-md" type="password" name="password_confirm" value="#password_confirm#" id="passwordconfirm">
						<cfelse>
							<cfinput class="form-control input-md" type="password" name="password_confirm" value="" id="passwordconfirm">
						</cfif>	
					</div>
				</div>	
				<div class="form-group">
					<label class="control-label" for="ff_standard4">
						<b>Company*</b>
					</label>  
					<div>
						<cfif isdefined("ff_standard4")>
							<cfinput class="form-control input-md" type="text" name="ff_standard4" value="#ff_standard4#" required="Yes" message="Company is a required field.">
						<cfelse>
							<cfinput class="form-control input-md" type="text" name="ff_standard4" value="#getuser.companyname#" required="Yes" message="Company is a required field.">
						</cfif>	
					</div>
				</div>
				<div class="form-group">
					<label for="ffstandard10">Country</label>
					<select class="form-control" name="ff_standard10" id="ffstandard10">
						<cfif isdefined("ff_standard10")>
							<cfloop query="get_countries">
								<option data-code="#countrycode#" value="#countryid#" <cfif ff_standard10 eq countrycode>selected</cfif>>#country#</option>
								<cfif currentrow EQ 2>
								<option disabled="disabled" value="---">---</option>
								</cfif>					
							</cfloop> 
						<cfelseif isdefined("getuser.countryID")>
							<cfloop query="get_countries">
								<option data-code="#countrycode#" value="#countryid#" <cfif getuser.countryID eq countrycode>selected</cfif>>#country#</option>
								<cfif currentrow EQ 2>
								<option disabled="disabled" value="---">---</option>
								</cfif>					
							</cfloop> 								
						<cfelse>
							<cfloop query="get_countries">
								<option data-code="#countrycode#" value="#countryid#">#country#</option>
								<cfif currentrow EQ 2>
								<option disabled="disabled" value="---">---</option>
								</cfif>					
							</cfloop> 								
						</cfif>                                                
					</select> 
				</div>	
				<div class="form-group">
					<label class="control-label" for="phone">
						Phone:
					</label>  
					<div>
						<cfif isdefined("ff_standard11")>
							<cfinput class="form-control input-md" type="text" name="ff_standard11" id="ffstandard11" value="#ff_standard11#">
						<cfelse>
							<cfinput class="form-control input-md" type="text" name="ff_standard11" id="ffstandard11" value="#getuser.phonenumber#">
						</cfif>	
					</div>
				</div>	
				<div class="form-group">
					<label class="control-label" for="ffstandard6">
						Address:
					</label>  
					<div>
						<cfif isdefined("ff_standard6")>
							<cfinput class="form-control input-md" type="text" name="ff_standard6" id="ffstandard6" value="#ff_standard6#">
						<cfelse>
							<cfinput class="form-control input-md" type="text" name="ff_standard6" id="ffstandard6" value="#getuser.billingaddress#">
						</cfif>	
					</div>
				</div>	
				<div class="form-group">
					<label class="control-label" for="ffstandard7">
						City:
					</label>  
					<div>
						<cfif isdefined("ff_standard7")>
							<cfinput class="form-control input-md" type="text" name="ff_standard7" id="ffstandard7" value="#ff_standard7#">
						<cfelse>
							<cfinput class="form-control input-md" type="text" name="ff_standard7" id="ffstandard7" value="#getuser.city#">
						</cfif>	
					</div>
				</div>	
				<div class="form-group">
					<label for="ff_standard8">State/Province</label>
					<cfset last = get_states.countryid[1]>
					<select class="form-control" name="ff_standard8" id="ff_standard8">
						<option value="0" selected>N/A - Not Applicable</option>
						<option disabled="disabled" value="---">---</option>
						<cfif isdefined("ff_standard8")>
							<cfloop query="get_states">                                                        
								<cfif countryid NEQ last>
								<option disabled="disabled" value="---">---</option>
								<cfset last = countryid>
								</cfif>
								<option value="#stateID#" <cfif ff_standard8 eq stateID>selected</cfif>>#fullname#</option>                                                        
							</cfloop>
						<cfelseif isdefined("getuser.stateID")>
							<cfloop query="get_states">                                                        
								<cfif countryid NEQ last>
								<option disabled="disabled" value="---">---</option>
								<cfset last = countryid>
								</cfif>
								<option value="#stateID#" <cfif getuser.stateID eq stateID>selected</cfif>>#fullname#</option>                                                        
							</cfloop>							
						<cfelse>
							<cfloop query="get_states">                                                        
								<cfif countryid NEQ last>
								<option disabled="disabled" value="---">---</option>
								<cfset last = countryid>
								</cfif>
								<option value="#stateID#">#fullname#</option>                                                        
							</cfloop>								
						</cfif>
					</select>
				</div>	
				<div class="form-group">
					<label class="control-label" for="ffstandard9">
						Postal Code:
					</label>  
					<div>
						<cfif isdefined("ff_standard9")>
							<cfinput class="form-control input-md" type="text" name="ff_standard9" id="ffstandard9" value="#ff_standard9#">
						<cfelse>
							<cfinput class="form-control input-md" type="text" name="ff_standard9" id="ffstandard9" value="#getuser.postalcode#">
						</cfif>	
					</div>
				</div>																																																														
				<cfloop query="get_formfields">
					<cfif fieldID is 96 or fieldID is 103><cfset show_required = 1><cfelse><cfset show_required = 0></cfif>
					<cfif fieldID is 32><cfset paren = "Electronic signature"><cfelse><cfset paren = ""></cfif>							
					<div class="form-group">
						<label for="questions">
							<cfif show_required is 1>
								<strong>#display_question#*</strong>
							<cfelse>
								#display_question#
							</cfif>
						</label> 								
						<cfquery name="getval" dbtype="query">
							select distinct custom_field_tagID, custom_field_tag
							from get_all_formfields
							where custom_fieldID = #fieldID#
						</cfquery>
						<cfif isdefined("check_custom_field")>
							<cfquery name="user_custom" dbtype="query">
								select * from check_custom_field
								where custom_fieldID = #fieldID#
							</cfquery>
						</cfif>
						<cfswitch expression="#field_typeID#">
							<cfcase value="1"><!---Text field--->
								<cfif show_required is 1>
									<cfif isdefined("ff_#field_src##fieldID#")>
										<cfinput type="text" class="form-control" name="ff_#field_src##fieldID#" value="#evaluate("ff_#field_src##fieldID#")#" size="28" required message="A value for #field_name# is required.">
									<cfelseif isdefined("user_custom") and user_custom.recordcount gt 0>
										<cfinput type="text" class="form-control" name="ff_#field_src##fieldID#" value="#user_custom.custom_field_value#" size="28" required message="A value for #field_name# is required.">
									<cfelse>
										<cfinput type="text" class="form-control" name="ff_#field_src##fieldID#" size="28" required message="A value for #field_name# is required.">
									</cfif>

								<cfelse>
									<cfif isdefined("ff_#field_src##fieldID#")>
										<cfinput type="text" class="form-control" name="ff_#field_src##fieldID#" value="#evaluate("ff_#field_src##fieldID#")#" size="28">
									<cfelseif isdefined("user_custom") and user_custom.recordcount gt 0>
										<cfinput type="text" class="form-control" name="ff_#field_src##fieldID#" value="#user_custom.custom_field_value#" size="28">
									<cfelse>
										<cfinput type="text" class="form-control" name="ff_#field_src##fieldID#" size="28">
									</cfif>
								</cfif>
								<cfif paren is not ""><br>(#paren#)</cfif>
							</cfcase>
							<cfcase value="2"><!---Checkbox field--->
								<cfloop query="getval">
									<cfif isdefined("ff_#get_formfields.field_src##get_formfields.fieldID#")>
										<p>
											<cfif listfind(#evaluate("ff_#get_formfields.field_src##get_formfields.fieldID#")#,#custom_field_tagID#) neq 0>
												<cfinput type="checkbox" class="form-control" name="ff_#get_formfields.field_src##get_formfields.fieldID#" value="#custom_field_tagID#" checked />
											<cfelse>
												<cfinput type="checkbox" class="form-control" name="ff_#get_formfields.field_src##get_formfields.fieldID#" value="#custom_field_tagID#" />
											</cfif>
											#custom_field_tag#
										</p>
									<cfelseif isdefined("user_custom") and user_custom.recordcount gt 0>
										<p>
											<cfif listfind(#user_custom.custom_field_value#,#custom_field_tagID#) neq 0>
												<cfinput type="checkbox" class="form-control" name="ff_#get_formfields.field_src##get_formfields.fieldID#" value="#custom_field_tagID#" checked />
											<cfelse>
												<cfinput type="checkbox" class="form-control" name="ff_#get_formfields.field_src##get_formfields.fieldID#" value="#custom_field_tagID#" />
											</cfif>
											#custom_field_tag#
										</p>
									<cfelse>	
										<p><cfinput type="checkbox" class="form-control" name="ff_#get_formfields.field_src##get_formfields.fieldID#" value="#custom_field_tagID#" />#custom_field_tag#</p>
									</cfif>
								</cfloop>
							</cfcase>
							<cfcase value="3"><!---Date field--->
								<cfif show_required is 1>
									<cfif isdefined("ff_#field_src##fieldID#")>
										<cfinput type="datefield" class="form-control" name="ff_#field_src##fieldID#" value="#evaluate("ff_#field_src##fieldID#")#" required="yes" message="A value for #field_name# is required." label="date:" mask="m/d/yyyy" />
									<cfelseif isdefined("user_custom") and user_custom.recordcount gt 0>
										<cfinput type="datefield" class="form-control" name="ff_#field_src##fieldID#" value="#user_custom.custom_field_date#" required="yes" message="A value for #field_name# is required." label="date:" mask="m/d/yyyy" />
									<cfelse>
										<cfinput type="datefield" class="form-control" name="ff_#field_src##fieldID#" required="yes" message="A value for #field_name# is required." label="date:" mask="m/d/yyyy" />
									</cfif>
								<cfelse>
									<cfif isdefined("ff_#field_src##fieldID#")>
										<cfinput type="datefield" class="form-control" name="ff_#field_src##fieldID#" value="#evaluate("ff_#field_src##fieldID#")#" label="date:" mask="m/d/yyyy" />
									<cfelseif isdefined("user_custom") and user_custom.recordcount gt 0>
										<cfinput type="datefield" class="form-control" name="ff_#field_src##fieldID#" value="#user_custom.custom_field_date#" label="date:" mask="m/d/yyyy" />
									<cfelse>
										<cfinput type="datefield" class="form-control" name="ff_#field_src##fieldID#" label="date:" mask="m/d/yyyy" />
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="4"><!---Radio button field--->
								<cfif show_required is 1>
									<cfloop query="getval">
										<cfif isdefined("ff_#get_formfields.field_src##get_formfields.fieldID#") and evaluate("ff_#get_formfields.field_src##get_formfields.fieldID#") is #custom_field_tagID#>
											<p><cfinput type="radio" class="form-control" name="ff_#get_formfields.field_src##get_formfields.fieldID#" value="#custom_field_tagID#" checked="checked" required message="A value for #get_formfields.field_name# is required." />#custom_field_tag#</p>
										<cfelseif isdefined("user_custom") and user_custom.recordcount gt 0 and user_custom.custom_field_value is #custom_field_tagID#>
											<p><cfinput type="radio" class="form-control" name="ff_#get_formfields.field_src##get_formfields.fieldID#" value="#custom_field_tagID#" checked="checked" required message="A value for #get_formfields.field_name# is required." />#custom_field_tag#</p>
										<cfelse>
											<p><cfinput type="radio" class="form-control" name="ff_#get_formfields.field_src##get_formfields.fieldID#" value="#custom_field_tagID#" required message="A value for #get_formfields.field_name# is required." />#custom_field_tag#</p>
										</cfif>
									</cfloop>
								<cfelse>
									<cfloop query="getval">
										<cfif isdefined("ff_#get_formfields.field_src##get_formfields.fieldID#") and evaluate("ff_#get_formfields.field_src##get_formfields.fieldID#") is #custom_field_tagID#>
											<p><cfinput type="radio" class="form-control" name="ff_#get_formfields.field_src##get_formfields.fieldID#" value="#custom_field_tagID#" checked="checked">#custom_field_tag#</cfinput></p>
										<cfelseif isdefined("user_custom") and user_custom.recordcount gt 0 and user_custom.custom_field_value is #custom_field_tagID#>
											<p><cfinput type="radio" class="form-control" name="ff_#get_formfields.field_src##get_formfields.fieldID#" value="#custom_field_tagID#" checked="checked" />#custom_field_tag#</p>
										<cfelse>
											<p><cfinput type="radio" class="form-control" name="ff_#get_formfields.field_src##get_formfields.fieldID#" value="#custom_field_tagID#">#custom_field_tag#</cfinput></p>
										</cfif>
									</cfloop>
								</cfif>
							</cfcase>
							<cfcase value="5"><!---Single select field--->
								<cfselect name="ff_#field_src##fieldID#" class="form-control">
									<cfloop query="getval">
										<option value="#custom_field_tagID#"  <cfif isdefined("ff_#get_formfields.field_src##get_formfields.fieldID#") and listfind(#evaluate("ff_#get_formfields.field_src##get_formfields.fieldID#")#,#custom_field_tagID#) neq 0>selected<cfelseif isdefined("user_custom") and user_custom.recordcount gt 0 and listfind(#user_custom.custom_field_value#,#custom_field_tagID#) neq 0>selected</cfif>>#custom_field_tag#</option>
									</cfloop>
								</cfselect>
								<cfif paren is not "">&nbsp;(#paren#)</cfif>
							</cfcase>
							<cfcase value="6"><!---Multiple select field--->
								<cfselect name="ff_#field_src##fieldID#" class="form-control" multiple>
									<cfloop query="getval">
										<option value="#custom_field_tagID#" <cfif isdefined("ff_#get_formfields.field_src##get_formfields.fieldID#") and listfind(#evaluate("ff_#get_formfields.field_src##get_formfields.fieldID#")#,#custom_field_tagID#) neq 0>selected<cfelseif isdefined("user_custom") and user_custom.recordcount gt 0 and listfind(#user_custom.custom_field_value#,#custom_field_tagID#) neq 0>selected</cfif>>#custom_field_tag#</option>
									</cfloop>
								</cfselect>
							</cfcase>
							<cfcase value="7"><!---Textarea field--->
								<cfif show_required is 1>
									<cftextarea class="form-control" name="ff_#field_src##fieldID#" rows="3" cols="22" required message="A value for #field_name# is required."><cfif isdefined("ff_#field_src##fieldID#")>#evaluate("ff_#field_src##fieldID#")#<cfelseif isdefined("user_custom") and user_custom.recordcount gt 0>#user_custom.custom_field_area#</cfif></cftextarea>
								<cfelse>
									<cftextarea class="form-control" name="ff_#field_src##fieldID#" rows="3" cols="22" ><cfif isdefined("ff_#field_src##fieldID#")>#evaluate("ff_#field_src##fieldID#")#</cfif></cftextarea>
								</cfif>
							</cfcase>
						</cfswitch>
					</div>
				</cfloop>										
				<div class="form-group">
					<label class="control-label" for="terms"></label>  
					<div>
						<cfif isdefined("proc_error") and proc_error is 'terms'>
							<p class="error">You must accept the terms and conditions.</p>
						</cfif>
						<cfif isdefined("accept_terms") and accept_terms is "y">
							<cfinput type="checkbox" value="y" name="accept_terms" checked required message="Please check the box to accept the terms and conditions.">
						<cfelseif getuser.accept_terms is "y">
							<cfinput type="checkbox" value="y" name="accept_terms" checked required message="Please check the box to accept the terms and conditions.">
						<cfelse>
							<cfinput type="checkbox" value="y" name="accept_terms" required message="Please check the box to accept the terms and conditions.">
						</cfif>
						<strong>I accept Paint BidTracker's <a href="../dmz/?action=terms" class="bold" target="_blank">Terms and Conditions</font></a> and <a href="../dmz/?action=privacy" class="bold" target="_blank"><font size="2" face="arial">Privacy Policy</font></a>.*</strong>
					</div>
				</div>	
				<div class="form-group">
					<label class="control-label" for="terms"></label>  
					<div>
						<p style="margin-top: 32px;">
							<cfinput type="hidden" name="reg_userID" value="#getuser.reg_userID#">
							<cfinput type="submit" value="Save Changes" name="submit" class="btn btn-primary">
						</p>
					</div>
				</div>																					
				</fieldset>
			</cfform>
		</div>
	</div>	
	<div class="hidden-xs hidden-sm col-md-1 col-lg-1"></div>	
	<div class="col-xs-12 col-sm-12 col-md-5 col-lg-4 pull-left" style="background: linear-gradient(to top,transparent,##f9f8f8);">		
		<div>
			<h2>Subscriptions</h2>
		</div>
			
		<cfloop index="li" list="#site_lists#">
			<cfquery name="user_list" dbtype="query">
				select * from get_list_optins
				where fieldID = <cfqueryparam value="#li#" cfsqltype="cf_sql_integer">
			</cfquery>
			<div style="margin-bottom: 18px;">	
				<p class="bold">
					#user_list.field_name#
				</p>
				<cfquery name="user_status" dbtype="query">
					select * from check_status
					where list_sourceID = <cfqueryparam value="#li#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif user_status.recordcount is 0><cfset start_state="off"><cfelseif user_status.statusID is 1><cfset start_state = "on"><cfelse><cfset start_state="off"></cfif>
				<div id="ajaxswitch#li#"></div>
				<div id="switch#li#"></div>
				<script type="text/javascript">
					$('##ajaxswitch#li#').load('subscribed.cfm?list=#li#&logID=#user_status.logID#&listID=#user_status.listID#');
					$('##switch#li#').iphoneSwitch("#start_state#",
					function() {
						$('##ajaxswitch#li#').load('subscribed.cfm?list=#li#&logID=#user_status.logID#&listID=#user_status.listID#&newstatus=1');
						},
					function() {
						$('##ajaxswitch#li#').load('subscribed.cfm?list=#li#&logID=#user_status.logID#&listID=#user_status.listID#&newstatus=3');
						},
						{
						switch_on_container_path: '../assets/images/container.png'
						});
				</script>
			</div>
		</cfloop>
		
	</div>
</cfoutput>