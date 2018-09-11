<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfquery name = "get_stnd" datasource="#application.dataSource#">
Select standards.standardid, standards.catid, standards.standard_title, standards.link, standards.updatedon,
standardcat.category
from standards
left outer join standardcat on standardcat.catid = standards.catid
where  standards.active = 'y' and standards.catid = <cfqueryPARAM value = "#catID#" CFSQLType = "CF_SQL_INTEGER"> 
order by standards.updatedon desc
</cfquery>

<cfoutput>
	<table border="0" cellpadding="5" cellspacing="0" width="100%">
		<tr>
			<td width="100%" align="left" valign="top" colspan="3">
				<div align="left">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td align="left" valign="top">
								<h3>Paint and Coatings Industry Standards</h3>
								<hr>
							</td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
	</table>
<!--end heading-->

	<table border="0" cellpadding="5" cellspacing="0" width="100%">
		<tr>

			<td valign="top" width="49%">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td valign="bottom">
										<h2>#get_stnd.category# (#get_stnd.recordcount#)</h2>
									</td>
									<td valign="bottom" align="right">
										<p><a href="#rootpath#?action=standards&fuseaction=search">Search Standards</a> |
										<a href="#rootpath#?action=standards">Back to all Standards</a></p>                              		   
									</td>
								</tr>
							</table>
							<hr class="PBTsmall" noshade>                            
						</td>
					</tr>
			
					<tr>
						<td width="100%">
							<div align="center">
								<table border="0" cellpadding="0" cellspacing="0" width="100%">

									<cfquery name="pull_subs" datasource="#application.dataSource#">
										select distinct a.subcatid,a.category,a.catid
										from standardsubcat a
										where a.catid = <cfqueryPARAM value = "#catid#" CFSQLType = "CF_SQL_INTEGER"> 
										and a.subcatid in (select subcatid from standards where catid = <cfqueryPARAM value = "#catid#" CFSQLType = "CF_SQL_INTEGER">  and active = 'y')
										order by a.category
									</cfquery>

									<cfloop query="pull_subs">
										<cfquery name="count_stnd" datasource="#application.dataSource#">
											Select standards.standardid, standards.catid, standards.standard_title, standards.link, standards.updatedon,
											standardcat.category
											from standards
											left outer join standardcat on standardcat.catid = standards.catid
											where  standards.active = 'y' and subcatid = <cfqueryPARAM value = "#subcatID#" CFSQLType = "CF_SQL_INTEGER">  and standards.catid = <cfqueryPARAM value = "#get_stnd.catid#" CFSQLType = "CF_SQL_INTEGER"> 
											order by standards.updatedon desc
										</cfquery>
										
										<!---Set max rows for short, default list
										<cfset short_max = 3>
										<cfif short_max gt count_stnd.recordcount>
										<cfset short_max = count_stnd.recordcount>
										</cfif>
										<cfset full_start = short_max + 1>--->
										<tr>
											<td width="100%">
												<table border="0" cellpadding="0" cellspacing="0" width="100%">
													<tr>
														<td>
															<h4>
																<a href="#rootpath#?action=standards&fuseaction=subcat&catid=#pull_subs.catid#&subcatid=#subcatid#"><b>#category#</b></a> (#count_stnd.recordcount#)
															</h4>
														</td>
													</tr>
												</table>
											</td>
										</tr> 
										<cfloop query="count_stnd"> <!--- startrow="1" endrow="#short_max#"--->
											<tr>
												<td width="100%" colspan="2">
													<p>
														<a href="#rootpath#?action=standards&fuseaction=view&id=#standardid#">- #standard_title#</a>
													</p>
												</td>
											</tr>
										</cfloop>
										<!---<tr>
										<td width="100%" colspan="2">
										<cfif count_stnd.recordcount gt 3>
										!---Call to script---
										<script language="javascript">toggle(getObject('count_stndadd#currentrow#'), 'count_stnd_link#currentrow#');</script>		
										!---Add rest of list to short list, initially hidden---
										<div id="count_stndadd#currentrow#" style="display:none">
										<cfloop startrow="#full_start#" endrow="#count_stnd.recordcount#" query="count_stnd">   
										<h1 class="headlines" style="margin-bottom: 0">
										<a href="#rootpath#?action=standards&fuseaction=view&id=#standardid#">- #standard_title#</a>
										</h1>
										</cfloop>
										</div>
										!---Toggle link if short list maxes out and more results to display---
										<p align="right"><a title="expand/collapse" id="count_stnd_link#currentrow#" href="javascript: void(0);" 
										onclick="toggle(this, 'count_stndadd#currentrow#');"  style="text-decoration: none; color: ##000000; ">See more</a>
										&nbsp;<img src="#rootpath#images/yellowtriangle.jpg" border="0"></p>
										</cfif>
										</td>
										</tr>--->

										<tr>
											<td><hr></td>
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
									<td align="right">
										<p>(<a href="#rootpath#?action=standards">Back to all Standards</a>)</p>
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