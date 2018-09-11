<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">


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
									<h1>Featured Employer: #featcodetail.companyname#</h1>
								</td>
								<td width="50%" align="right">
									<a href="#rootpath#classifieds/?fuseaction=jobs&action=search&searchresults=1&supplierID=#supplierID#">View All Jobs from this Employer</a>
								</td>
							</tr>
						</table>
						<hr class="PBTsmall" noshade>
					</td>
				</tr>
				<tr>
					<td width="100%">
						<div align="left">
							<table border="0" cellpadding="3" cellspacing="0" width="100%">
								<cfif featcodetail.image_location is not "">
								<tr>
									<td width="75%" valign="top" align="left" colspan="2"> 
										<cfset max_width=115><cfset max_height=60>
										<cfobject type="JAVA" action="Create" name="tk" 
											class="java.awt.Toolkit">
										</cfobject>
										<cfobject type="JAVA" action="Create" name="img" 
											class="java.awt.Image">
										</cfobject>
										<cfscript>
											img = tk.getDefaultToolkit().getImage("d:\wwwroot\paintsquare.com\classifieds\#featcodetail.image_location#");
											width = img.getWidth();
											height = img.getHeight();
											img.flush();
										</cfscript>
										<cfset disp_width=#width#>
										<cfset disp_height=#height#>
										<cfif disp_width gt max_width><cfset disp_width="#max_width#"></cfif>
										<cfif disp_height gt max_height><cfset disp_height="#max_height#"></cfif>
										<img src="http://www.paintsquare.com/classifieds/#featcodetail.image_location#" width="#disp_width#" height="#disp_height#" alt="#featcodetail.companyname#"><br>
									</td>
								</tr>
								</cfif>
								<tr>
									<td width="25%" valign="top" align="right" class="bold">
										Contact Information:
									</td>
									<td width="75%" valign="top" align="left">
										<cfif featcodetail.companyname is not "">#featcodetail.companyname#<br></cfif>
										<cfif featcodetail.billingaddress is not "">#featcodetail.billingaddress#<br></cfif>
										<cfif featcodetail.city is not "" or featcodetail.state is not "" or featcodetail.postalcode is not "" or featcodetail.country is not "">
											<cfif featcodetail.city is not "">#featcodetail.city# </cfif>
											<cfif featcodetail.state is not "">#featcodetail.state# </cfif>
											<cfif featcodetail.postalcode is not "">#featcodetail.postalcode# </cfif>
											<cfif featcodetail.country is not "">#featcodetail.country# </cfif><br>
										</cfif>
										<cfif featcodetail.phonenumber is not "">Phone: #featcodetail.phonenumber#<br></cfif>
										<cfif featcodetail.emailaddress is not "">E-mail: <a href="#rootpath#classifieds/?fuseaction=jobs&action=featcontact&supplierID=#supplierID#">#featcodetail.emailaddress#</a><br></cfif>
										<cfif featcodetail.url is not "">Web site: <a href="#featcodetail.url#" target="_blank">#featcodetail.url#</a><br></cfif>
										
										<br><br>
									</td>
								</tr>
								
								<cfif featcodetail.para1 is not "">
								<tr>
									<td width="25%" valign="top" align="right" class="bold">
										About Us:
									</td>
									<td valign="top" align="left">
										#featcodetail.para1#
									</td>
								</tr>
								</cfif>
								<cfif featcodetail.para2 is not "">
								<tr>
									<td valign="top" align="right" class="bold">
									</td>
									<td valign="top" align="left">
										#featcodetail.para2#
									</td>
								</tr>
								</cfif>
								<cfif featcodetail.para3 is not "">
								<tr>
									<td valign="top" align="right" class="bold">
									</td>
									<td valign="top" align="left">
										#featcodetail.para3#
									</td>
								</tr>
								</cfif>
								<cfif featcodetail.para4 is not "">
								<tr>
									<td valign="top" align="right" class="bold">
									</td>
									<td valign="top" align="left">
										#featcodetail.para4#
									</td>
								</tr>
								</cfif>
								<cfif featcodetail.para5 is not "">
								<tr>
									<td valign="top" align="right" class="bold">
									</td>
									<td valign="top" align="left">
										#featcodetail.para5#
									</td>
								</tr>
								</cfif>
								<cfif featcodetail.para6 is not "">
								<tr>
									<td valign="top" align="right" class="bold">
									</td>
									<td valign="top" align="left">
										#featcodetail.para5#
									</td>
								</tr>
								</cfif>
								<cfquery name="getfeatured_jobs" datasource="#the_dsn#">   
									select a.jobID, a.supplierID, a.positionID, a.stateID,  a.keyword, a.positiontitle, a.countryID, a.description,
									a.supplierID, a.location, a.dateposted, a.lastupdated, a.confidential, b.companyname,  
									d.position, e.state, f.country, c.companyname as regconame, g.employerid, a.featured_job, a.displaycompany
									from job_master a
									left outer join supplier_master b on b.supplierID = a.supplierID
									left outer join reg_users c on c.reg_UserID = a.reg_userID
									left outer join position d on d.positionID = a.positionID
									left outer join state_master e on e.stateID = a.stateID
									left outer join country_master f on f.countryID = a.countryID
									left outer join featured_employers g on g.supplierID = a.supplierID and g.expirationdate >=  '#dateformat(date, "m/d/yyyy")#'
									where (a.expire >  '#dateformat(date, "m/d/yyyy")#')
									and a.supplierID in (#supplierID#)
									order by g.employerid desc, featured_job desc, a.lastupdated desc, a.dateposted desc, a.positiontitle
								</cfquery>
								<cfif getfeatured_jobs.recordcount is not 0>
									<tr>
										<td valign="top" align="left" colspan="2" class="bold">
											<br><br>Our Current Job Openings
											<hr size="1" noshade>
										</td>
									</tr>
									<cfloop query="getfeatured_jobs">
										<cfif len(positiontitle) gt 1>
											<cfset last1 = Left(positiontitle, 1)>
											<cfset last2 = Right(positiontitle, len(positiontitle)-1)>
											<cfset newpositiontitle = #ucase(last1)# & #lcase(last2)#>
										<cfelse>
											<cfset newpositiontitle = "#positiontitle#">
										</cfif>
										<tr>
											<td width="100%" colspan="2">
												<h1 class="headlines" style="margin-bottom: 0">
												<a href="#rootpath#classifieds/?fuseaction=jobs&action=view&jobID=#jobID#&feature=1">#newpositiontitle#</a>
												</h1>
												<p class="smaller">Last updated: #dateformat(lastupdated, "m/d/yyyy")#</p>#location#, #state#, #country#</p>                                    
												<hr size="1" noshade>                                 
											</td>
										</tr>
									</cfloop>
								<cfelse>
									<tr>
										<td valign="top" align="left" colspan="2">
											<br><br><hr size="1" noshade>
											We do not currently have any active job postings, but you are welcome to 
											<a href="#rootpath#classifieds/?fuseaction=jobs&action=featcontact&supplierID=#supplierID#">send us your resum&eacute;</a>
											so that we may consider you for future openings.
										</td>
									</tr>
								</cfif>
							</table>
						</div>                              
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</cfoutput>

<!---Save to featured company view log--->
<cfquery name="insert_featco_view" datasource="#the_dsn#">
	insert into featured_visits
	(reg_userID, supplierID, datevisited, remoteIP)
	values
	(<cfif isdefined ("reg_userID") and reg_userID is not ""><cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
	<cfif isdefined ("supplierID") and supplierID is not ""><cfqueryparam value="#supplierID#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
	<cfqueryparam value="#date#" cfsqltype="cf_sql_timestamp">, 
	<cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
	)
</cfquery>