<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfif not isdefined("reg_userID") and isdefined("cookie.psquare") and cookie.psquare is not ""><cfset reg_userID = cookie.psquare></cfif>
<cfif not isdefined("reg_userID")><cfset reg_userID = #get_item.reg_userID#></cfif>

<cfif not isdefined("jobID") or jobID is "" or jobID is 0><cflocation url="#rootpath#classifieds/?fuseaction=manage"></cfif>

<cfquery name="get_details" datasource="#the_dsn#">
	select distinct a.jobID, a.contactname as name, a.displaycompany as companyname, a.positiontitle as title, a.dateposted as effective_date, a.expire as expiration_date, a.lastupdated, count(b.viewID) as views
	from job_master a
	left outer join job_view_log b on b.jobID = a.jobID
	left outer join supplier_master d on d.supplierID = a.supplierID
	where a.jobID = <cfqueryparam value="#jobID#" cfsqltype="cf_sql_integer">
	group by a.jobID, a.contactname, a.displaycompany, a.positiontitle, a.dateposted, a.expire, a.lastupdated
</cfquery>
<cfquery name="get_applications" datasource="#the_dsn#">
	select ID, dateviewed, reg_userID, contactname, phonenumber, emailaddress, contacttime, cover_letter, resumeID
	from job_apply_log
	where jobID = <cfqueryparam value="#jobID#" cfsqltype="cf_sql_integer">
</cfquery>

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
									<h1>Stats / Replies for a Job</h1>
								</td>
								<td width="50%" align="right">
									<a href="#rootpath#classifieds/?fuseaction=manage">Back to manage page</a>
								</td>
							</tr>
						</table>
						<hr class="PBTsmall" noshade>
					</td>
				</tr>
				
				<cfif not isdefined("cookie.psquare") and not isdefined("reg_userID")>
				<!---Require login--->
					<tr>
						<td width="100%">
							<div align="left">
								<p>To view the stats of your job, <a href="#rootpath#register/?fuseaction=login&jobID=#jobID#&r_directory=classifieds&r_fuseaction=#fuseaction#&r_action=#action#">please sign in</a> to your free PaintSquare account.</p>
							</div>                              
						</td>
					</tr>
				<cfelse>
				<!---Form to display preview and continue to payment/confirmation or go back to edit--->
					<tr>
						<td width="100%">
							<p>Here are the stats for your job listing, "#get_details.title#," posted from #dateformat(get_details.effective_date, 'm/d/yyyy')# to #dateformat(get_details.expiration_date, 'm/d/yyyy')# <cfif get_details.lastupdated is not "">and last updated on #dateformat(get_details.lastupdated, 'm/d/yyyy')#</cfif>.
							</p>
							<!---hr size="1" noshade--->                            
						</td>
					</tr>
					<tr>
						<td width="100%">
							<p class="bold">Total Page Views of this Job:  #get_details.views#</p>
							<p></p>
						</td>
					</tr>
					<tr>
						<td valign="top">
							<p class="bold">Total Job Application Submissions:  #get_applications.recordcount#</p>
							<p></p>
						</td>
					</tr>
					<cfif get_applications.recordcount gt 0>
					<tr>
						<td valign="top" class="bold">
							<hr size="1" noshade>
							<p class="bold">Details of Job Application Submissions</p>
						</td>
					</tr>
					<tr>
						<td valign="top">
							<table width="80%">
								<cfloop query="get_applications">
								<tr>
									<td width="10%"></td>
									<td>
										<hr size="1" noshade>
										<p class="bold">Applicant: #contactname# <cfif resumeID is not "">(<a href="#rootpath#classifieds/?fuseaction=resumes&job=view&resumeID=#resumeID#">View resum&eacute;</a>)</cfif></p>
										<p>Date of application: #dateformat(dateviewed, 'm/d/yyyy')#, #timeformat(dateviewed, 'h:mm tt')#</p>
										<p>Phone number: #phonenumber#</p>
										<p>E-mail address: <a href="mailto:#emailaddress#">#emailaddress#</a></p>
										<p>Best time to contact: #contacttime#</p>
										<p>Cover letter: #cover_letter#</p>
									</td>
								</tr>
								</cfloop>
							</table>
						</td>
					</tr>
					</cfif>
				</cfif>
			</table>
		</td>
	</tr>
</table>
</cfoutput>