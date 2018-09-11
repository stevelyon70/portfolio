
<cfif mail_to is not "">
<cfset mail_subject="Forwarded Job Listing From the Paint BidTracker Classifieds">
<cfset mail_from="webmaster@paintbidtracker.com">
<cfset mail_reply="#form.emailaddress#">
<cfset mail_bcc="webmaster@paintsquare.com;lmacek@protectivecoatings.com">
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
							<b>Forwarded Job</b>
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
								#contactname# forwarded this job listing from the Paint BidTracker Classifieds to you.
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
								<b>Message:</b><br>
					        	#message#
							</font></p>
					        <p style="margin: 6"><font face="Arial, Helvetica, sans-serif" size="2">
								<b>Job Link:</b> <cfif jobdetail.featured_job is "y" and jobdetail.featuredjob_expiration gte #date#><a href="http://www.paintbidtracker.com/classifieds/?fuseaction=jobs&action=view&jobID=#jobID#&featjob=1"><u>#jobdetail.positiontitle#</u></a><cfelse><a href="http://www.paintbidtracker.com/classifieds/?fuseaction=jobs&action=view&jobID=#jobID#"><u>#jobdetail.positiontitle#</u></a></cfif>
							</font></p>
					        <p style="margin: 6"><font face="Arial, Helvetica, sans-serif" size="2">
								<cfif isdefined("res") and res is not "">
								<b>Resum&eacute;:</b><br>
						        <a href="http://www.paintbidtracker.com/classifieds?fuseaction=resumes&action=view&resumeID=#res#"><u>Resum&eacute; of #contactname#</u></a></font></p>
						        </cfif>
								<hr width="100%" size="3" color="355097">
								<ul>
						          <li><a href="http://www.paintbidtracker.com/classifieds?fuseaction=jobs&action=viewall"><font face="Arial" size="2"><u>Search and view all jobs</u></font></a></li>
						          <li><a href="http://www.paintbidtracker.com/classifieds?fuseaction=resumes&action=post"><font face="Arial" size="2"><u>Post a resume</u></font></a></li>
						        </ul>
							</font></p>
					        <p style="margin: 6"><font face="Arial, Helvetica, sans-serif" size="1">
								You have been sent forwarded this information at the request of #contactname#.
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
</cfif>
