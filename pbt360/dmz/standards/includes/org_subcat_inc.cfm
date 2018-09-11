<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfquery name = "get_stnd" datasource="#application.dataSource#">
Select standards.standardid, standards.catid, standards.standard_title, standards.link, standards.updatedon,
standardcat.category
from standards
left outer join standardcat on standardcat.catid = standards.catid
where  standards.active = 'y' and standards.catid = #catid#
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
										<h2><a class="bold" href="#rootpath#?action=standards&fuseaction=org&catid=#catID#">#get_stnd.category#</a> (#get_stnd.recordcount#)</h2>
									</td>
									<td valign="bottom" align="right">
										<p>
											<a href="#rootpath#?action=standards&fuseaction=search">Search Standards</a> |
											<a href="#rootpath#?action=standards">Back to all Standards</a>
										</p>                              		   
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
										select subcatid,category
										from standardsubcat
										where catid = <cfqueryPARAM value = "#get_stnd.catid#" CFSQLType = "CF_SQL_INTEGER">  and subcatid = <cfqueryPARAM value = "#subcatid#" CFSQLType = "CF_SQL_INTEGER"> 
										order by category
									</cfquery>

									<cfloop query="pull_subs">
										<cfquery name="count_stnd" datasource="#application.dataSource#">
											Select standards.standardid, standards.catid, standards.standard_title, standards.link, standards.updatedon,
											standardcat.category, standards.sspc_number
											from standards
											left outer join standardcat on standardcat.catid = standards.catid
											where  standards.active = 'y' and subcatid = <cfqueryPARAM value = "#subcatid#" CFSQLType = "CF_SQL_INTEGER">  and standards.catid = <cfqueryPARAM value = "#get_stnd.catid#" CFSQLType = "CF_SQL_INTEGER"> 
											order by standards.sspc_number, standards.updatedon desc
										</cfquery>
										
										<tr>
											<td width="100%">
												<table border="0" cellpadding="0" cellspacing="0" width="100%">
													<tr>
														<td>
															<h4><b>#category#</b> (#count_stnd.recordcount#)</h1>
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<cfloop query="count_stnd">
											<tr>
												<td width="100%" colspan="2">
													<p>
														<a href="#rootpath#?action=standards&fuseaction=view&id=#standardid#">- #standard_title#</a>
													</p>                                    
												</td>
											</tr>
										</cfloop>
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
									<td align="right"><p>(<a href="#rootpath#?action=standards">Back to all Standards</a>)</p></td>
								</tr>
							</table>
						</td>
					</tr>

				</table>                  
			</td> 
		</tr>
	</table>

</cfoutput>