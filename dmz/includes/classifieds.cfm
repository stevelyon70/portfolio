<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">



<cfoutput>
<cfinclude template="classifieds_header.cfm">
                  
<table border="0" cellpadding="5" cellspacing="0" width="100%">
	<cfif not isdefined("reg_userID") and isdefined("cookie.psquare") and cookie.psquare is not ""><cfset reg_userID = cookie.psquare></cfif>
	<tr>
		<!--left column-->
		<td valign="top" align="left" width="100%" colspan="3">
			<cfif isdefined("reg_userID")>
			<a class="bold" href="#rootpath#classifieds/?reg_userID=#reg_userID#&fuseaction=manage">Manage your classified postings</a>
			<cfelse>
			<a href="#rootpath#register/?fuseaction=login&r_fuseaction=manage&r_directory=classifieds">Sign in to manage your classified postings</a>
			</cfif>
			| <a href="#rootpath#classifieds/?fuseaction=faq">Classifieds info and pricing</a>
			<hr size="1" noshade>          
		</td>
	</tr>
	
	<tr>
		<!--left column-->
		<td valign="top" width="49%">
			
<cfset expiredate = #dateformat(date - 30, "mm/dd/yy")#>
<cfset short_max = 15>
<cfset maxjobs = 50>
<cfquery name="getjobs" datasource="#application.dataSource#">
	select a.jobID, a.supplierID, a.positionID, a.stateID,  a.keyword, a.positiontitle, a.countryID, a.description,
	a.supplierID, a.location, a.dateposted, a.lastupdated, a.confidential, b.companyname,  
	d.position, e.state, f.country, c.companyname as regconame, g.employerid, a.featured_job, a.displaycompany, a.cb_did, a.cb_active
	from job_master a
	left outer join supplier_master b on b.supplierID = a.supplierID
	left outer join reg_users c on c.reg_UserID = a.reg_userID
	left outer join position d on d.positionID = a.positionID
	left outer join state_master e on e.stateID = a.stateID
	left outer join country_master f on f.countryID = a.countryID
	left outer join featured_employers g on g.supplierID = a.supplierID and g.expirationdate >=  '#dateformat(date, "m/d/yyyy")#'
	where (a.expire >  '#dateformat(date, "m/d/yyyy")#')
	and ((a.cb_did is null) or (a.cb_did is not null and a.cb_active = 1))
	and a.jobID in (select contentid from tags_log where content_typeid = 1329 and tagid = <cfqueryparam value="#siteID#" cfsqltype="cf_sql_integer">)
	order by g.employerid desc, a.featured_job desc, a.cb_active asc, a.lastupdated desc, a.dateposted desc, a.positiontitle
</cfquery>

<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="50%" valign="bottom"><p class="header1"> 
						<cfset total = getjobs.recordcount>
						<a class="bold" href="#rootpath#classifieds/?fuseaction=jobs&action=viewall">Jobs</a></p>
					</td>
					<td width="50%" valign="bottom" align="right">
						<a href="#rootpath#classifieds/index.cfm?fuseaction=jobs&action=post">Post a Job</a>
					</td>
				</tr>
			</table>
			<hr size="5" class="PBTsmall" noshade>                            
		</td>
	</tr>
	<tr>
		<td width="100%">
		<div align="left">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<cfif getjobs.recordcount is not 0>
					<cfif short_max gt getjobs.recordcount><cfset short_max = getjobs.recordcount></cfif>
					<cfset full_start = #short_max#+1>
					<cfloop query="getjobs" startrow="1" endrow="#short_max#">
						<cfif supplierID is not "">
							<cfquery name="feature" datasource="#application.dataSource#">
								Select * from Featured_Employers where expirationdate > '#dateformat(date, "mm/dd/yy")#' and supplierID = #getjobs.supplierID#
							</cfquery>
						</cfif>
						<cfquery name="featjobs" datasource="#application.dataSource#">
							select *
							from job_master
							where JobID = #jobID# and featured_job = 'y' and
							featuredjob_inception <= '#dateformat(date, "mm/dd/yy")#' and featuredjob_expiration > '#dateformat(date, "mm/dd/yy")#'
						</cfquery>
						<cfset last1 = Left(getjobs.positiontitle, 1)>
						<cfset last2 = Right(getjobs.positiontitle, len(getjobs.positiontitle)-1)>
						<cfset newpositiontitle = #ucase(last1)# & #lcase(last2)#>
						<tr>
							<td width="100%" colspan="2">
								<h1 class="headlines" style="margin-bottom: 0">
								<cfif featjobs.recordcount is 1>
									<img src="#rootpath#classifieds/images/featured_job.gif">
									<a class="bold" href="#rootpath#classifieds/?fuseaction=jobs&action=view&jobID=#jobID#&featjob=1">#newpositiontitle#</a>
								<cfelseif supplierID is not "" and feature.recordcount gt 0>
									<img src="#rootpath#classifieds/images/featemp.GIF">
									<a class="bold" href="#rootpath#classifieds/?fuseaction=jobs&action=view&jobID=#jobID#&feature=1">#newpositiontitle#</a>
								<cfelse>
									<a href="#rootpath#classifieds/?fuseaction=jobs&action=view&jobID=#jobID#">#newpositiontitle#</a>
								</cfif></h1>
								<p class="smaller">Last updated: #dateformat(lastupdated, "m/d/yyyy")#</p>
								<p class="smaller"><cfif confidential is not 1><cfif getjobs.displaycompany is not "">#displaycompany#<cfelseif getjobs.supplierID is not "">#companyname#<cfelse>#regconame#</cfif><cfelse>Confidential</cfif> - #location#, #state#, #country#</p>                                    
								<p></p>
							</td>
						</tr>
					</cfloop>
				<cfelse>
					<tr>
						<td width="100%" colspan="2">
							There are no jobs posted at this time. Please check back reguarly, as new jobs may be posted at a later date.
						</td>
					</tr>
				</cfif>
			</table>
		</div>                              
		</td>
	</tr>
	<tr>
		<td width="100%" align="left">
			<cfif getjobs.recordcount gt #short_max#>
				<cfif getjobs.recordcount lt #maxjobs#><cfset maxjobs = #getjobs.recordcount#></cfif>
				<!---Call to script--->
				<script language="javascript">toggle(getObject('getjobsadd'), 'getjobs_link');</script>
				<!---Add rest of list to short list, initially hidden--->
				<div id="getjobsadd" style="display:none">
				<cfloop startrow="#full_start#" endrow="#maxjobs#" query="getjobs">
					<cfif supplierID is not "">
						<cfquery name="feature" datasource="#application.dataSource#">
							Select * from Featured_Employers where expirationdate > '#dateformat(date, "mm/dd/yy")#' and supplierID = #getjobs.supplierID#
						</cfquery>
					</cfif>
					<cfquery name="featjobs" datasource="#application.dataSource#">
						select *
						from job_master
						where JobID = #jobID# and featured_job = 'y' and
						featuredjob_inception <= '#dateformat(date, "mm/dd/yy")#' and featuredjob_expiration > '#dateformat(date, "mm/dd/yy")#'
					</cfquery>
					<cfset last1 = Left(getjobs.positiontitle, 1)>
						<cfset last2 = Right(getjobs.positiontitle, len(getjobs.positiontitle)-1)>
						<cfset newpositiontitle = #ucase(last1)# & #lcase(last2)#>
					<h1 class="headlines" style="margin-bottom: 0">
					<cfif featjobs.recordcount is 1>
						<img src="#rootpath#classifieds/images/featured_job.gif">
						<a class="bold" href="#rootpath#classifieds/?fuseaction=jobs&action=view&jobID=#jobID#&featjob=1">#newpositiontitle#</a>
					<cfelseif supplierID is not "" and feature.recordcount gt 0>
						<img src="#rootpath#classifieds/images/featemp.GIF">
						<a class="bold" href="#rootpath#classifieds/?fuseaction=jobs&action=view&jobID=#jobID#&feature=1">#newpositiontitle#</a>
					<cfelse>
						<a href="#rootpath#classifieds/?fuseaction=jobs&action=view&jobID=#jobID#">#newpositiontitle#</a>
					</cfif></h1>
					<p class="smaller">Last updated: #dateformat(lastupdated, "m/d/yyyy")#</p>
					<p class="smaller"><cfif confidential is not 1><cfif getjobs.displaycompany is not "">#displaycompany#<cfelseif getjobs.supplierID is not "">#companyname#<cfelse>#regconame#</cfif><cfelse>Confidential</cfif> - #location#, #state#, #country#</p>  
					<p></p>
				</cfloop>
				<cfif getjobs.recordcount gt #maxjobs#><h1 class="headlines" style="margin-bottom: 0"><a href="#rootpath#classifieds/?fuseaction=jobs&action=viewall">--See all #total# jobs--</a></h1></cfif>
				
				</div>
				<!---Toggle link if short list maxes out and more results to display--->
				<p align="right"><a title="expand/collapse" id="getjobs_link" href="javascript: void(0);" 
				onclick="toggle(this, 'getjobsadd');"  style="text-decoration: none; color: ##000000; ">See more</a>
				&nbsp;<img src="#rootpath#images/yellowtriangle.jpg" border="0"></p>
			</cfif>
		</td>
	</tr>
	<tr>
		<td>
			&nbsp;<br>
			&nbsp;
		</td>
	</tr>
</table>
</cfoutput>
			               
		</td>
		<!---spacer--->
		<td width="2%">
		</td>
		<!---right column--->
		<td valign="top" width="49%">
			
<cfset short_max = 15>
<cfset maxres = 50>
<cfquery name="getres" datasource="#application.dataSource#">
	select a.resumeID, a.desiredposition, a.positionID, a.updatedon, a.confidential,
	b.firstname, b.lastname, b.name, b.reg_userID, b.stateID, b.countryID, e.position, c.state, d.country
	from resume_master a
	left outer join reg_users b on b.reg_userID = a.reg_userID
	left outer join state_master c on c.stateID = b.stateID
	left outer join country_master d on d.countryID = b.countryID
	left outer join position e on e.positionID = a.positionID
	where (a.expiration > '#dateformat(date, "m/d/yyyy")#')
	order by a.updatedon desc
</cfquery>	

<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" width="100%">    
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="50%" valign="bottom"><p class="header1"> 
						<a class="bold" href="#rootpath#classifieds/?fuseaction=resumes">Resum&eacute;s</a></p>
					</td>
					<td width="50%" valign="bottom" align="right">
						<a href="#rootpath#classifieds/index.cfm?fuseaction=resumes&action=post">Post a Resum&eacute;</a>
					</td>
				</tr>
			</table>
			<hr size="5" class="PBTsmall" noshade>                            
		</td>
	</tr>
	<tr>
		<td width="100%">
		<div align="center">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<cfif not isdefined("cookie.psquare")>
				<tr>
					<td width="100%">
						<cfif getres.recordcount eq 0>
							There are no resum&eacute;s posted at this time. Please check back reguarly, as new resum&eacute;s may be posted at a later date.
						<cfelse>
							<h1 class="headlines">Please <a href="#rootpath#register/?fuseaction=login&r_directory=classifieds&r_fuseaction=resumes&r_action=viewall">sign-in</a> to view resum&eacute;s</h1>
							<p>(There <cfif getres.recordcount eq 1>is<cfelse>are</cfif> #getres.recordcount# resum&eacute;<cfif getres.recordcount eq 1><cfelse>s</cfif> currently available for viewing.)</p> 
						</cfif>                                  
					</td>
				</tr>
			<cfelse>
				<cfquery name="checkaccess" datasource="#application.dataSource#">
					select * from resume_access where reg_userID = #reg_userID# and expirationdate > '#dateformat(date, "m/d/yyyy")#' and viewresume = 1
				</cfquery>
				<cfif checkaccess.recordcount is 0>
					<cfquery name="checkaccess2" datasource="#application.dataSource#">
						select * from resume_user_access where reg_userID = #reg_userID# and expirationdate > '#dateformat(date, "m/d/yyyy")#' and viewresume = 1
					</cfquery>
				</cfif>
					<cfif checkaccess.recordcount is not 0 or checkaccess2.recordcount is not 0>	
					<!---Set max rows for short, default list--->
					<cfif short_max gt getres.recordcount><cfset short_max = getres.recordcount></cfif>
						<cfset full_start = short_max + 1>
						<cfloop query="getres" startrow="1" endrow="#short_max#">
						<tr>
							<td width="100%">
								<h1 class="headlines" style="margin-bottom: 0"><a href="#rootpath#classifieds/?fuseaction=resumes&action=view&resumeID=#resumeID#">#desiredposition#</a></h1>
								<p class="smaller">Last updated: #dateformat(updatedon, "m/d/yyyy")#</p>
								<p class="smaller"><cfif getres.confidential is 2>Confidential<cfelse>#firstname# #lastname#</cfif></p>
								<p></p>
							</td>
						</tr>
						</cfloop>
						<cfif getres.recordcount eq 0>
						<tr>
							<td width="100%" colspan="2">
								There are no resum&eacute;s posted at this time. Please check back reguarly, as new resum&eacute;s may be posted at a later date.
							</td>
						</tr>
					</cfif>
					<tr>
						<td width="100%" align="left">
							<cfif getres.recordcount gt #short_max#>
								<cfif getres.recordcount lt #maxres#><cfset maxres = #getres.recordcount#></cfif>
								<!---Call to script--->
								<script language="javascript">toggle(getObject('getresadd'), 'getres_link');</script>
								
								<!---Add rest of list to short list, initially hidden--->
								<div id="getresadd" style="display:none">
								<cfloop startrow="#full_start#" endrow="50" query="getres"><h1 class="headlines">
									<h1 class="headlines" style="margin-bottom: 0"><a href="#rootpath#classifieds/?fuseaction=resumes&action=view&resumeID=#resumeID#">#desiredposition#</a></h1>
									<p class="smaller">Last updated: #dateformat(updatedon, "m/d/yyyy")#</p>
									<p class="smaller"><cfif getres.confidential is 2>Confidential<cfelse>#firstname# #lastname#</cfif></p>
									<p></p>
								</cfloop>
								<cfif getres.recordcount gt #maxres#><h1 class="headlines" style="margin-bottom: 0"><a href="#rootpath#classifieds/?fuseaction=resumes">--See all #total# resum&eacute;s--</a></h1></cfif>
								</div>
								<!---Toggle link if short list maxes out and more results to display--->
								<p align="right"><a title="expand/collapse" id="getres_link" href="javascript: void(0);" 
								onclick="toggle(this, 'getresadd');"  style="text-decoration: none; color: ##000000; ">See more</a>
								&nbsp;<img src="#rootpath#images/yellowtriangle.jpg" border="0"></p>
							</cfif>
						</td>
					</tr> 
				<cfelseif checkaccess.recordcount is 0 or checkaccess2.recordcount is 0 or isdefined("renew")>
					<cfif getres.recordcount eq 0>
						There are no resum&eacute;s posted at this time. Please check back reguarly, as new resum&eacute;s may be posted at a later date.
					<cfelse>
						<p><a href="#rootpath#classifieds/?fuseaction=resumes&action=purchase">Purchase resum&eacute; access</a>.</p>
						<p>(There <cfif getres.recordcount eq 1>is<cfelse>are</cfif> #getres.recordcount# resum&eacute;<cfif getres.recordcount eq 1><cfelse>s</cfif> currently available for viewing.)</p> 
					</cfif>
				</cfif>
			</cfif>
			</table>
		</div>                              
		</td>
	</tr>
	<tr>
		<td>
			&nbsp;<br>
			&nbsp;
		</td>
	</tr>
</table> 
</cfoutput>

		</td>
	</tr>
</table>
</cfoutput>