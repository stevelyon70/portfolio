<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">


<cfoutput>
               
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td width="50%">
							<h1 class="big">#jobdetail.positiontitle#</h1>
						</td>
						<td width="50%" align="right">
							<a href="#rootpath#dmz/?action=classifieds">View All Jobs</a> <!---|
							<a href="#rootpath#classifieds/?fuseaction=jobs&action=search">Search Jobs</a> |
							<a href="#rootpath#classifieds/?fuseaction=jobs&action=post">Post a Job</a>--->
						</td>
					</tr>
				</table>
				<hr>
			</td>
		</tr>
		<tr>
			<td>
				<table border="0" cellpadding="3" cellspacing="0" width="50%">
					<tr>
						<td valign="top" width="20%"><b>Company:</b></td>
						<td valign="top" align="left"> 
							<cfif isdefined("feature")>
								<a href="#rootpath#classifieds/?fuseaction=jobs&action=featco&supplierID=#jobdetail.supplierID#">
								<cfif jobdetail.confidential is 1>Confidential
								<cfelse><cfif jobdetail.displaycompany is not "">#jobdetail.displaycompany#<cfelseif jobdetail.supplierID is not "">#jobdetail.companyname#<cfelse>#jobdetail.regconame#</cfif>
								</cfif></a>
							<cfelse>
								<cfif jobdetail.confidential is 1>Confidential
								<cfelse><cfif jobdetail.displaycompany is not "">#jobdetail.displaycompany#<cfelseif jobdetail.supplierID is not "">#jobdetail.companyname#<cfelse>#jobdetail.regconame#</cfif>
								</cfif>
							</cfif>
						</td>
					</tr>
					<tr>
						<td valign="top"><b>Location:</b></td>
						<td valign="top" align="left">#jobdetail.location# #jobdetail.state# #jobdetail.country#</td>
					</tr>
					<cfif jobdetail.lastupdated gt jobdetail.dateposted>
					<tr>
						<td valign="top"><b>Last Updated:</b></td>
						<td valign="top" align="left">#dateformat(jobdetail.lastupdated, "m/d/yyyy")#</td>
					</tr>
					</cfif>
					<tr>
						<td valign="top"><b>Posted:</b></td>
						<td valign="top" align="left">#dateformat(jobdetail.dateposted, "m/d/yyyy")#</td>
					</tr>
					<tr>
						<td valign="top"><b>Salary:</b></td>
						<td valign="top" align="left">#jobdetail.payrate#</td>
					</tr>
				</table>
			</td>
			<cfif jobdetail.featured_job is "y" and jobdetail.featuredjob_imagelocation is not "" and jobdetail.confidential is not 1>
			<td width="120px" valign="top" align="right">
				<cfset max_width=115><cfset max_height=60>
				<cfobject type="JAVA" action="Create" name="tk" 
					class="java.awt.Toolkit">
				</cfobject>
				<cfobject type="JAVA" action="Create" name="img" 
					class="java.awt.Image">
				</cfobject>
				<cfscript>
					img = tk.getDefaultToolkit().getImage("d:\wwwroot\paintsquare.com\classifieds\#jobdetail.featuredjob_imagelocation#");
					width = img.getWidth();
					height = img.getHeight();
					img.flush();
				</cfscript>
				<cfset disp_width=#width#>
				<cfset disp_height=#height#>
				<cfif disp_width gt max_width><cfset disp_width="#max_width#"></cfif>
				<cfif disp_height gt max_height><cfset disp_height="#max_height#"></cfif>
				<img src="http://www.paintsquare.com/classifieds/#jobdetail.featuredjob_imagelocation#" width="#disp_width#" height="#disp_height#" alt="#jobdetail.positiontitle#"><br>
			</td>
			</cfif>
		</tr>
		<tr>
			<cfif jobdetail.featured_job is "y" and jobdetail.featuredjob_imagelocation is not "" and jobdetail.confidential is not 1>
			<td colspan="2">
			<cfelse>
			<td>
			</cfif>
				<table border="0" cellpadding="3" cellspacing="0" width="100%">
					<tr>
						<td colspan="2" valign="top" align="left">
							<hr size="1" noshade>
							#jobdetail.description#
							<hr size="1" noshade>
						</td>
					</tr>
					<tr>
						<td valign="top" colspan="2">
							<cfif jobdetail.cb_DID is not ""><!---If a Career Builder job--->
								<p><em><strong>This job was originally posted on CareerBuilder.com.</strong></em> <a href="#jobdetail.cb_detail_link#" target="_blank">Original job posting</a></p>
								<a href="#jobdetail.cb_apply_link#" target="_blank">Apply for this job</a> (via CareerBuilder.com) 
							<!---<cfelse>
							<a href="#rootpath#classifieds/?fuseaction=jobs&action=apply&jobID=#jobdetail.jobID#">Apply for this job</a>--->
							</cfif>
						</td>
					</tr>
					<tr>
						<!---<td valign="top" align="left" colspan="2">
							<a href="#rootpath#classifieds/?fuseaction=jobs&action=forward&jobID=#jobdetail.jobID#">E-mail this job listing to a friend</a>
						</td>--->
					</tr>
				</table>
			</td>
		</tr>
	</table>

</cfoutput>

<!---Save to job view log--->
<cfquery name="insert_job_view" datasource="#application.dataSource#">
	insert into job_view_log
	(jobID, dateviewed, cfid, remoteIP, userID)
	values
	(<cfqueryparam value="#jobID#" cfsqltype="cf_sql_integer">,
	<cfqueryparam value="#date#" cfsqltype="cf_sql_timestamp">, 
	<cfqueryparam value="#cfid#" cfsqltype="cf_sql_integer">, 
	<cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">, 
	<cfif isdefined ("reg_userID") and reg_userID is not ""><cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>)
</cfquery>
<!---Record page view after content loads--->
<cfset view_date = createodbcdatetime(now())>
<cfquery name="insert_page_view" datasource="#application.dataSource#">
	insert into gateway_page_view_log
	(gateway_id, pageID, contentID, datestamp, reg_userID, cfid)
	values
	(2, 
	167, 
	#jobID#,
	#view_date#, 
	<cfif isdefined("reg_userID") and reg_userID is not "">#reg_userID#<cfelse>NULL</cfif>,
	<cfif isdefined("cfid") and cfid is not "">#cfid#<cfelse>NULL</cfif>)
</cfquery>