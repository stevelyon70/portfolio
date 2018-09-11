

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

	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td valign="top">
							<h2><cfif detail.catid IS 1>#detail.standard_title#<cfelse>#detail.sspc_number# #detail.standard_title#</cfif></h2>
						</td>
						<td valign="top" align="right" width="25%">
							<p>
								<a href="#rootpath#?action=standards">All Standards</a> |
								<a href="#rootpath#?action=standards&fuseaction=org&catid=#cat.catid#">#cat.category# Standards</a><br>
								<a href="#rootpath#?action=standards&fuseaction=search">Search Standards</a>
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
						<!---<tr>
						<td class="tinytext">
						!---A href="sspc_link.cfm?standardid=#detail.standardid#"---<input type="button" value="Purchase &amp; Download" name="purchase_download" onClick="window.open('http://www.paintsquare.com/astd/sspc_link.cfm?standardid=#detail.standardid#');">!---/a--- Click to Purchase and Download this Standard or Test Method
						</td>
						</tr>
						<tr>
						<td><hr>
						</td>
						</tr>---> 
							<tr>
								<td>
									Revision Date: #dateformat(detail.revision_date, "mmmm dd, yyyy")#  
								</td>
							</tr>
							<tr>
								<td>
									Updated On: #dateformat(detail.updatedon, "mmmm dd, yyyy")#  
								</td>
							</tr>
							<tr>
								<td>
									Editorial Change: #DateFormat(detail.editorial_change, "mmmm d, yyyy")#  
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>
									#detail.description1#<cfif detail.description2 is not ""><br><br>#detail.description2#</cfif><cfif detail.description3 is not ""><br><br>
									#detail.description3#</cfif><cfif detail.description4 is not ""><br><br>#detail.description4#</cfif><cfif detail.description5 is not ""><br><br>#detail.description5#</cfif><cfif detail.description6 is not ""><br><br>#detail.description6#</cfif><br>
								</td>
							</tr>
							<tr>
								<td><hr></td>
							</tr>
							<tr>
								<td align="right"><p>(<a href="#rootpath#?action=standards">Back to all Standards</a>)</p></td>
							</tr>
					</table>
				</div>
			</td>
		</tr>
	</table>                  

</cfoutput>
