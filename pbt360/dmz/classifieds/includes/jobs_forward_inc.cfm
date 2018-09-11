<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfif not isdefined("reg_userID")>
	<cfif isdefined("cookie.psquare")>
		<cfset reg_userID = cookie.psquare>
	<cfelse>
		<cflocation url="#rootpath#register/?fuseaction=login&jobID=#jobID#&r_directory=classifieds&r_fuseaction=#fuseaction#&r_action=#action#">
	</cfif>
</cfif>

<cfif isdefined("reg_userID") and reg_userID is not "">
	<cfquery name="get_reg_user" datasource="#the_dsn#">
		select * from reg_users
		where reg_userID = <cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>

<cfif isdefined("process") and process is 1>
	<cftransaction>
		<!---Build the mailing list after verifying valid e-mails and recording--->
		<cfset mail_to = "">
		<cfset bad_email = "">
		<cfif isdefined("email")>
			<cfloop index="maillist" list="#email#" delimiters=", ">
				<CF_EmailVerify Email="#maillist#"> 
				<cfif emailerror is 1>
					<cfset bad_email=listappend(bad_email, "#maillist#", "; ")>
				<cfelse>
					<cfset mail_to=listappend(mail_to, "#maillist#", "; ")>
					<cfquery name="checkreg" datasource="#the_dsn#" maxrows="1">
						select reg_userID, emailaddress 
						from reg_users
						where emailaddress = '#maillist#'
					</cfquery>
					<cfquery name="record_send" datasource="#the_dsn#">
						insert into email_friend_careercenter
						(jobid, reg_userid, date_sent,recipient_email, recipient_Reg_UserID)
						values
						(<cfqueryparam value="#jobid#" cfsqltype="cf_sql_integer">, 
						<cfif isdefined("reg_userID") and reg_userID is not ""><cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,  
						<cfqueryparam value="#date#" cfsqltype="cf_sql_timestamp">, 
						<cfqueryparam value="#maillist#" cfsqltype="cf_sql_varchar">, 
						<cfif checkreg.reg_userID is not ""><cfqueryparam value="#checkreg.reg_userID#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
	<cfinclude template="jobs_forward_email.cfm">
	<cfset confirm="1">
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
									<h1>Forward Job: #jobdetail.positiontitle#</h1>
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
								<p>
								<cfif mail_to is not "">The job has successfully been forwarded to: #mail_to#.<br><br></cfif>
								<cfif bad_email is not "">We were not able to send the e-mail to the following invalid e-mail addresses: #bad_email#<br><br></cfif>
								Thanks for using the Paint BidTracker Classifieds.</p>
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
										<td valign="top" align="right" class="bold">Subject:</td>
										<td valign="top" align="left">Forwarded Job Listing from the PaintSquare Classifieds</td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Date:</td>
										<td valign="top" align="left">#dateformat(date, "m/d/yyyy")#</td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Position:</td>
										<td valign="top" align="left">#jobdetail.positiontitle#</td>
									</tr>
									<tr>
										<td valign="top" align="left" colspan="2"><hr size="1" noshade></td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Your Name*:</td>
										<td valign="top" align="left">
											<cfif isdefined ("get_reg_user")>
												<cfinput type="text" name="contactname" value="#get_reg_user.firstname# #get_reg_user.lastname#" size="68" required message="Please enter your name.">
											<cfelse>
												<cfinput type="text" name="contactname" size="68" required message="Please enter your name.">
											</cfif>
										</td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Your E-mail Address*:</td>
										<td valign="top" align="left">
											<cfif isdefined ("get_reg_user")>
												<cfinput type="text" name="emailaddress" value="#get_reg_user.emailaddress#" size="68" required message="Please enter your e-mail address.">
											<cfelse>
												<cfinput type="text" name="emailaddress" size="68" required message="Please enter your e-mail address.">
											</cfif>
										</td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Send To*:</td>
										<td valign="top" align="left">
											<cfinput type="text" name="email" size="68" required message="Please enter at least one valid e-mail address to send to.">
											<br><p class="smaller">To send to more than one address, separate the addresses with a comma (,)</p>
										</td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Custom Message:</td>
										<td valign="top" align="left"><textarea id="message" name="message">Here's a job opening that I thought might interest you.</textarea>
											<script language="JavaScript">
											generate_wysiwyg('message');
											</script>
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