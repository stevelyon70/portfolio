<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<!---Page numbering script--->
<!-- Number of rows to display per next/back page --->
<cfset rowsperpage = 25>
<!-- What row to start at?  Assume first by default -->
<cfparam name="URL.startrow" Default="1" Type="Numeric">
<!---Allow for Show  All parameter in the URL --->
<cfparam name="URL.showall" Type="boolean" Default="no">
<!-- We know the total number of rows from the query --->
<cfset totalrows = alljobs.recordcount>
<!---Show all on page if ShowAll is passed in URL--->
<cfif URL.showall>
	<cfset rowsperpage = totalrows>
</cfif>

<!-- Last row is 10 rows past the starting row, or -->
<!-- total number of query rows, whichever is less -->
<cfset endRow  = min(URL.startrow + rowsperpage - 1, totalrows)>
<!-- Next button goes to 1 past current end row -->
<cfset startrownext = endrow + 1>
<!-- Back button goes back N rows from start row -->
<cfset startrowback = URL.startrow - rowsperpage>	

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
									<h1>View All Jobs</h1>
								</td>
								<td width="50%" align="right">
									<a href="#rootpath#classifieds/?fuseaction=jobs&action=search">Search Jobs</a> |
									<a href="#rootpath#classifieds/?fuseaction=jobs&action=post">Post a Job</a>
								</td>
							</tr>
						</table>
						<hr class="PBTsmall" noshade>
					</td>
				</tr>
				<tr>
					<td width="100%">
						<div align="left">
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<cfloop query="alljobs" startrow="#URL.startrow#" endrow="#endrow#">
								<cfif supplierID is not "">
									<cfquery name="feature" datasource="#the_dsn#">
										select * from featured_employers 
										where expirationdate > '#dateformat(date, "mm/dd/yy")#'
										and supplierID = #alljobs.supplierID#
									</cfquery>
								</cfif>
								<cfquery name="featjobs" datasource="#the_dsn#">
									select *
									from job_master
									where jobID = #jobID# and featured_job = 'y' 
									and featuredjob_inception <= '#dateformat(date, "mm/dd/yy")#' 
									and featuredjob_expiration > '#dateformat(date, "mm/dd/yy")#'
								</cfquery>
								<cfif len(alljobs.positiontitle) gt 1>
									<cfset last1 = Left(alljobs.positiontitle, 1)>
									<cfset last2 = Right(alljobs.positiontitle, len(alljobs.positiontitle)-1)>
									<cfset newpositiontitle = #ucase(last1)# & #lcase(last2)#>
								<cfelse>
									<cfset newpositiontitle = "#alljobs.positiontitle#">
								</cfif>
								<tr>
									<td width="100%">
										<h1 class="headlines" style="margin-bottom: 0">
										<cfif featjobs.recordcount is not 0>
											<img src="#rootpath#classifieds/images/featured_job.gif">
										<cfelseif supplierID is not "" and feature.recordcount is not 0>
											<img src="#rootpath#classifieds/images/featemp.GIF">
										</cfif>
										<cfif supplierID is not "" and feature.recordcount is not 0>
											<a class="bold" href="#rootpath#classifieds/?fuseaction=jobs&action=view&jobID=#jobID#&feature=1">#newpositiontitle#</a>
										<cfelseif featjobs.recordcount is not 0>
											<a class="bold" href="#rootpath#classifieds/?fuseaction=jobs&action=view&jobID=#jobID#&featjob=1">#newpositiontitle#</a>
										<cfelse>
											<a href="#rootpath#classifieds/?fuseaction=jobs&action=view&jobID=#jobID#">#newpositiontitle#</a>
										</cfif>
										</h1>
										<p class="smaller">Last Updated: #dateformat(lastupdated, "m/d/yyyy")#<cfif dateposted lt lastupdated>; Originally Posted: #dateformat(dateposted, "m/d/yyyy")#</cfif></p>
										<p class="smaller"><cfif position is not "">Category: #position#</cfif></p>
										<p class="smaller"><cfif confidential is not 1><cfif alljobs.displaycompany is not "">#displaycompany#<cfelseif alljobs.supplierID is not "">#companyname#<cfelse>#regconame#</cfif><cfelse>Confidential</cfif> - #location#, #state#, #country#</p>                                    
									</td>
								</tr>
								<tr>
									<td>
										<hr size="1" noshade>
									</td>
								</tr>
							</cfloop>
						</table>
						</div>                              
					</td>
				</tr>
				<tr>
					<td>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td align="right"><p> 
									<cfinclude template="#rootpath#pagecount_showall.cfm"></p>
								</td>
								<td align="right" width="20%">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</cfoutput>

<!---Record page view after content loads--->
<cfset view_date = createodbcdatetime(now())>
<cfquery name="insert_page_view" datasource="#the_dsn#">
	insert into gateway_page_view_log
	(gateway_id, pageID, datestamp, reg_userID, cfid)
	values
	(2, 
	168,
	#view_date#, 
	<cfif isdefined("reg_userID") and reg_userID is not "">#reg_userID#<cfelse>NULL</cfif>,
	<cfif isdefined("cfid") and cfid is not "">#cfid#<cfelse>NULL</cfif>)
</cfquery>