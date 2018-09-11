
<cfif isdefined("res") and res is not "">
<cfquery name="rminfo" datasource="#the_dsn#">
	select confidential
	from resume_master
	where resumeID = <cfqueryparam value="#res#" cfsqltype="cf_sql_integer">
</cfquery>
</cfif>

<cfif jobdetail.resumeemail is not "">
	<cfset mail_subject="Applying for #jobdetail.positiontitle# Position via the Paint BidTracker Classifieds">
	<cfset mail_from="webmaster@paintbidtracker.com">
	<cfset mail_reply="#form.emailaddress#">
	<cfset mail_to="#jobdetail.resumeemail#">
	<cfset mail_bcc="webmaster@paintsquare.com;lmacek@protectivecoatings.com">
<cfelse>
	<cfset mail_subject="Applying for #jobdetail.positiontitle# Position via the Paint BidTracker Classifieds">
	<cfset mail_from="webmaster@paintbidtracker.com">
	<cfset mail_to="webmaster@paintbidtracker.com">
	<cfset mail_reply="webmaster@paintbidtracker.com">
	<cfset mail_bcc="">
</cfif>

<cfoutput>
	<cfmail
		subject="#mail_subject#"
		from="#mail_from#"			
		to="#mail_to#"
		replyto="#mail_reply#"
		bcc="#mail_bcc#"
		
		type="html">
	<body>
	<table width="550" cellspacing="0" cellpadding="0">
		<tr>
			<td width="100%">
				<table width="100%" cellspacing="0" cellpadding="0">
					<tr>
						<td width="50%">
							<a href="http://www.paintbidtracker.com">
							<img src="http://www.paintbidtracker.com/images/PaintBidTracker_PaintcanLogo.png" border="0">
							</a>
						</td>
						<td width="50%" align="right" valign="top">
							<p style="margin-right: 6; margin-top: 12">
							<font face="Arial, Helvetica, sans-serif" size="3" color="333399">
							<b>Job Application Submission</b>
							</font></p>
						</td>
					</tr>
					<tr>
						<td width="100%" colspan="2" background="http://www.paintbidtracker.com/images/Yellow_Block.jpg">
							<img src="http://www.paintbidtracker.com/images/Yellow_Block.jpg" 
							width="12" height="12" border="0">
						</td>
					</tr>
				</table>
			<td>
		</tr>
		<tr>
			<td width="100%">
				<table width="100%" cellspacing="0" cellpadding="6">
					<tr>
						<td width="100%">
							<p><font face="Arial, Helvetica, sans-serif" size="2">
								The following application for the #jobdetail.positiontitle#
								position has been received and forwarded to you from the Paint BidTracker
								Classifieds.
							</font></p>
						</td>
					</tr>
				</table>
			<td>
		</tr>
		<tr>
			<td width="100%">
				<table width="100%" cellspacing="0" cellpadding="0">
					<tr height="6">
						<td width="100%">
							<hr width="100%" size="3" color="355097">
						</td>
					</tr>
					<tr>
						<td width="100%">
							<p style="margin: 6"><font face="Arial, Helvetica, sans-serif" size="2">
								<b>Date:</b> #dateformat(date, "mmmm dd, yyyy")#<br>
						        <b>Applicant:</b> #contactname#<br>
						        <!---cfif res is "" or (isdefined("rminfo") and rminfo.confidential is not 2)--->
									<b>Phone:</b> #phonenumber#<br>
							        <b>E-mail:</b> #emailaddress#<br>
							        <b>Best time(s) to contact:</b> #contacttime#
								<!---/cfif--->
							</font></p>
					        <p style="margin: 6"><font face="Arial, Helvetica, sans-serif" size="2">
								<b>Cover Letter:</b><br>
					        	#coverletter#
							</font></p>
					        <p style="margin: 6"><font face="Arial, Helvetica, sans-serif" size="2">
								<cfif isdefined("res") and res is not "">
								<b>Resum&eacute;:</b><br>
						        <a href="http://www.paintbidtracker.com/classifieds?fuseaction=resumes&action=view&resumeID=#res#"><u>Resum&eacute; of #contactname#</u></a></font></p>
						        </cfif>
								<hr width="100%" size="3" color="355097">
								<ul>
						          <li><a href="http://www.paintbidtracker.com/classifieds?fuseaction=resumes&action=viewall"><font face="Arial" size="2"><u>Search and view resum&eacute;s</u></font></a></li>
						          <li><a href="http://www.paintbidtracker.com/classifieds?fuseaction=jobs&action=edit&jobID=#jobID#"><font face="Arial" size="2"><u>Update this job</u></font></a></li>
						          <li><a href="http://www.paintbidtracker.com/classifieds?fuseaction=jobs&action=post"><font face="Arial" size="2"><u>Post a job</u></font></a></li>
						        </ul>
							</font></p>
					        <p style="margin: 6"><font face="Arial, Helvetica, sans-serif" size="2">
								As the designated contact for this position, Paint BidTracker is happy to provide this information to you, and
						        thanks you for posting this job in the Paint BidTracker Classifieds.
							</font></p>
							<p style="margin: 6"><font face="Arial, Helvetica, sans-serif" size="1">
								This e-mail is sent as a service included in your posting a job in the Paint BidTracker Classifieds. 
								If you believe that you are receiving this e-mail in error, please contact us
						        by e-mail or call 1-800-837-8303 or 1-412-431-8300.
							</font></p>
						</td>
					</tr>
				</table>
			<td>
		</tr>
	</table>
	</body>
	</cfmail>
</cfoutput>
