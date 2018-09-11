<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfif not isdefined("reg_userID")>
	<cfif isdefined("cookie.psquare")>
		<cfset reg_userID = cookie.psquare>
	<cfelse>
		<cflocation url="#rootpath#register/?fuseaction=login&jobID=#jobID#&r_directory=classifieds&r_fuseaction=#fuseaction#&r_action=#action#">
	</cfif>
</cfif>

<cfquery name="get_reg_user" datasource="#the_dsn#">
	select * from reg_users
	where reg_userID = <cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="get_resumes" datasource="#the_dsn#">
	select resumeID, resumetitle 
	from resume_master 
	where expiration > '#dateformat(date-1, "m/d/yyyy")#' 
	and active <> 'n' 
	and reg_userID = <cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer"> 
	order by dateposted desc
</cfquery>

<cfif isdefined("process") and process is 1>
	<!---cfif not isdefined("res") or res is "" or res is 0>
		<cflocation url="#rootpath#classifieds/?fuseaction=#fuseaction#&action=#action#&jobID=#jobID#&err=5">
	</cfif--->
	<cftransaction>
		<cfquery name="save_application" datasource="#the_dsn#">
			insert into job_apply_log
			(jobid, reg_userid, dateviewed, cfid, emailaddress, contactname, phonenumber, resumeID, cover_letter, contacttime)
			values
			(<cfif isdefined("jobID") and jobID is not ""><cfqueryparam value="#jobID#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>, 
			<cfif isdefined("reg_userID") and reg_userID is not ""><cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
			<cfqueryparam value="#date#" cfsqltype="cf_sql_timestamp">,
			<cfif isdefined("cfid") and cfid is not ""><cfqueryparam value="#cfid#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif isdefined("emailaddress") and emailaddress is not ""><cfqueryparam value="#emailaddress#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
			<cfif isdefined("contactname") and contactname is not ""><cfqueryparam value="#contactname#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
			<cfif isdefined("phonenumber") and phonenumber is not ""><cfqueryparam value="#phonenumber#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
			<cfif isdefined("res") and res is not ""><cfqueryparam value="#res#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif isdefined("coverletter") and coverletter is not ""><cfqueryparam value="#coverletter#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
			<cfif isdefined("contacttime") and contacttime is not ""><cfqueryparam value="#contacttime#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>)
		</cfquery>
		<cfquery name="insert_reply" datasource="#the_dsn#">
			insert into job_master_contact
			(jobID, reg_userID)
			values
			(<cfqueryparam value="#jobID#" cfsqltype="cf_sql_integer">,
			<cfif isdefined ("reg_userID") and reg_userID is not ""><cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>)
		</cfquery>
	</cftransaction>
	<cfinclude template="jobs_application_email.cfm">
	<cfif jobdetail.resumeemail is not ""><cfset confirm="1"><cfelse><cfset confirm="2"></cfif>
</cfif>

<cfoutput>
<cfinclude template="classifieds_header.cfm">
               
<table border="0" cellpadding="5" cellspacing="0" width="100%">
	<tr>
		<td valign="top" width="100%">
             <table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td width="50%">
									<h1>Send Job Application: #jobdetail.positiontitle#</h1>
								</td>
								<td width="50%" align="right">
									<a href="#rootpath#classifieds/?fuseaction=jobs&action=view&jobID=#jobID#">Job Detail</a> |
									<a href="#rootpath#classifieds/?fuseaction=jobs&action=viewall">View All Jobs</a> |
									<a href="#rootpath#classifieds/?fuseaction=jobs&action=search">Search Jobs</a>
								</td>
							</tr>
						</table>
						<hr class="PBTsmall" noshade>
					</td>
				</tr>
				<cfif isdefined("confirm") and confirm is "1">
				<!---Message to confirm application sent--->
					<tr>
						<td width="100%">
							<div align="left">
								<p>Your application has been successfully sent to the employer's designated e-mail address. Thanks for using the PaintSquare
								Classifieds.</p>
							</div>                              
						</td>
					</tr>
				<cfelseif isdefined("confirm") and confirm is "2">
				<!---Message to confirm application sent--->
					<tr>
						<td width="100%">
							<div align="left">
								<p>Your application has been successfully submitted, but because this employer has not designated an e-mail address to receive
								application, your application has been sent to our administrator. We will see that your application reaches the employer as
								soon as possible. Thanks for using the PaintSquare Classifieds.</p>
							</div>                              
						</td>
					</tr>
				<cfelse>
				<!---Application form--->
					<tr>
						<td width="100%">
							<div align="left">
								<cfform action="#rootpath#classifieds/index.cfm?process=1" method="post" enablecab="yes">
								<table border="0" cellpadding="3" cellspacing="0" width="100%">
									<tr>
										<td width="25%" valign="top" align="right" class="bold">
											Send To:
										</td>
										<td width="75%" valign="top" align="left"> 
											<!---cfif jobdetail.featured_job is "y" and jobdetail.featuredjob_imagelocation is not "" and jobdetail.confidential is not 1>
												<img src="http://www.paintsquare.com/classifieds/#jobdetail.featuredjob_imagelocation#"><br>
											</cfif--->
											<cfif isdefined("feature")>
												<a href="#rootpath#classifieds/?fuseaction=jobs&action=featco&supplierID=#jobdetail.supplierID#">
												<cfif jobdetail.confidential is 1>Confidential
												<cfelse><cfif jobdetail.supplierID is not "">#jobdetail.companyname#<cfelse>#jobdetail.regconame#</cfif>
												</cfif></a>
											<cfelse>
												<cfif jobdetail.confidential is 1>Confidential
												<cfelse><cfif jobdetail.supplierID is not "">#jobdetail.companyname#<cfelse>#jobdetail.regconame#</cfif>
												</cfif>
											</cfif>
										</td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Subject:</td>
										<td valign="top" align="left">Applying for #jobdetail.positiontitle#</td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Date:</td>
										<td valign="top" align="left">#dateformat(date, "m/d/yyyy")#</td>
									</tr>
									<tr>
										<td valign="top" align="left" colspan="2"><hr size="1" noshade></td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Name*:</td>
										<td valign="top" align="left"><cfinput type="text" name="contactname" value="#get_reg_user.firstname# #get_reg_user.lastname#" size="68" required message="Please enter your name."></td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Phone Number*:</td>
										<td valign="top" align="left"><cfinput type="text" name="phonenumber" value="#get_reg_user.phonenumber#" size="68" required message="Please enter your phone number."></td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">E-mail Address*:</td>
										<td valign="top" align="left"><cfinput type="text" name="emailaddress" value="#get_reg_user.emailaddress#" size="68" required message="Please enter your e-mail address."></td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Best Time To Be Contacted:</td>
										<td valign="top" align="left"><cfinput type="text" name="contacttime" size="68"></td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Cover Letter Message:</td>
										<td valign="top" align="left"><textarea id="coverletter" name="coverletter"></textarea>
											<script language="JavaScript">
											generate_wysiwyg('coverletter');
											</script>
										</td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Attach Resum&eacute;*:</td>
										<td valign="top" align="left">
											<cfif isdefined("err") and err is 5><p class="error">Please select an existing resum&eacute;, or add a new resum&eacute;.</p></cfif>
											<cfselect name="res" size="1">
												<option value="">Select a Resum&eacute;</option>
												<cfloop query="get_resumes">
												<option value="#resumeID#" <cfif isdefined("resID") and resID is #resumeID#>selected</cfif>>#resumetitle#</option>
												</cfloop>
											</cfselect>
											&nbsp;&nbsp;<a href="#rootpath#classifieds?fuseaction=resumes&action=post&jobID=#jobID#">Add a Resum&eacute;</a>
										</td>
									</tr>
									<tr>
										<td>&nbsp;
										<cfif isdefined("reg_userID")><cfinput type="hidden" name="reg_userID" value="#reg_userID#"></cfif>
										<cfif isdefined("jobID")><cfinput type="hidden" name="jobID" value="#jobID#"></cfif>
										<cfif isdefined("fuseaction")><cfinput type="hidden" name="fuseaction" value="#fuseaction#"></cfif>
										<cfif isdefined("action")><cfinput type="hidden" name="action" value="#action#"></cfif>
										</td> 
										<td><cfinput name="submit" value="Submit" type="submit"><br><br></td>
									</tr>
								</table>
								</cfform>
							</div>                              
						</td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>
</table>
</cfoutput>