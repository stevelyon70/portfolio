<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<!---Note: search result query in Application file--->
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

<!---Get options for search form--->
<cfquery name="position" datasource="#the_dsn#">
select positionID, position
from position
where positionID <> '13'
order by sort
</cfquery>
<cfquery name="state" datasource="#the_dsn#">
select state_master.stateID, state_master.state, state_master.fullname
from state_master
order by state_master.sort
</cfquery>
<cfquery name="country" datasource="#the_dsn#">
select countryID, country, regionID, sort
from country_master
order by sort
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
									<h1>Search Jobs</h1>
								</td>
								<td width="50%" align="right">
									<a href="#rootpath#classifieds/?fuseaction=jobs&action=viewall">View All Jobs</a> |
									<a href="#rootpath#classifieds/?fuseaction=jobs&action=post">Post a Job</a>
									<cfif isdefined("searchresults")>| <a href="#rootpath#classifieds/?fuseaction=jobs&action=search">New Search</a></cfif>
								</td>
							</tr>
						</table>
						<hr class="PBTsmall" noshade>
					</td>
				</tr>
				<cfif isdefined("searchresults")>
					<cfif alljobs.recordcount gt 0>
					<tr>
						<td width="100%">
							<div align="left">
								<p>Here are your search results.
								</p>
							</div>                              
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
									<cfset last1 = Left(alljobs.positiontitle, 1)>
									<cfset last2 = Right(alljobs.positiontitle, len(alljobs.positiontitle)-1)>
									<cfset newpositiontitle = #ucase(last1)# & #lcase(last2)#>
									<tr>
										<td width="100%">
											<h1 class="headlines" style="margin-bottom: 0">
											<cfif supplierID is not "" and feature.recordcount is not 0>
												<img src="#rootpath#classifieds/images/featemp.GIF">
											<cfelseif featjobs.recordcount is not 0>
												<img src="#rootpath#classifieds/images/featured_job.gif">
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
					<cfelse>
					<tr>
						<td width="100%">
							<div align="left">
								<p>There are no results for the criteria you selected.
								</p>
							</div>                              
						</td>
					</tr>
					</cfif>
				<cfelse>
					<tr>
						<td width="100%">
							<div align="left">
								<p>Search for jobs by selecting as many or as few of the criteria below.</p>
							</div>                              
						</td>
					</tr>
					<tr>
						<td width="100%">
							<div align="left">
							<cfform action="#rootpath#classifieds/index.cfm?searchresults=1" method="post" enablecab="Yes">
							<table border="0" cellpadding="3" cellspacing="0" width="100%">
								<tr>
									<td align="right" valign="top" width="25%">
										<b>Category:</b>
									</td>
									<td valign="top" width="75%">
										<cfselect name="positionID" query="position" value="positionID" display="position" multiple size="5" style="width: 323px" selected="12"></cfselect>
									</td>
								</tr>
								<tr>
									<td align="right" valign="top" width="25%">
										<b>Location:</b>
									</td>
									<td valign="top" width="75%">
										<cfselect name="stateID" query="state" value="stateID" display="fullname" multiple size="5" style="width: 160px" selected="66"></cfselect>
										<cfselect name="countryID" query="country" value="countryID" display="country" multiple size="5" style="width: 160px" selected="218"></cfselect>
									</td>
								</tr>
								<tr>
									<td align="right" valign="top" width="25%">
										<b>Keyword:</b>
									</td>
									<td valign="top" width="75%">
										<cfinput type="text" name="keyword" size="48">
									</td>
								</tr>
								<tr>
									<td align="right" valign="top" width="25%">
										
									</td>
									<td valign="top" width="75%">
										
									</td>
								</tr>
								<tr>
									<td>&nbsp;
									<cfif isdefined("reg_userID")><cfinput type="hidden" name="reg_userID" value="#reg_userID#"></cfif>
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