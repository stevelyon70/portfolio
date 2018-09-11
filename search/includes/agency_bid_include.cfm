<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!---cfset total = "#Evaluate(querynew.recordcount - querynew1.recordcount)#"--->
<!-- Number of rows to display per next/back page --->
<cfset RowsPerPage = 5>
<!-- What row to start at?  Assume first by default -->
<cfparam name="URL.StartRow" Default="1" Type="Numeric">
<!---Allow for Show  All parameter in the URL --->
<cfparam name="URL.ShowAll" Type="boolean" Default="no">
<!-- We know the total number of rows from the query --->
<Cfset TotalRows = total_results.recordcount>
<!---Show all on page if ShowAll is passed in URL--->
<CFIF URL.ShowAll>
	<cfset Rowsperpage = TotalRows>
</cfif>

<!-- Last row is 10 rows past the starting row, or -->
<!-- total number of query rows, whichever is less -->
<cfset EndRow  = Min(URL.StartRow + RowsPerPage - 1, TotalRows)>
<!-- Next button goes to 1 past current end row -->
<cfset StartRowNext = EndRow + 1>
<!-- Back button goes back N rows from start row -->
<cfset StartRowBack = URL.StartRow - RowsPerPage>
<br>

		 <table border="0" width="100%">
		 <tr><td width="100%">
		<span class="tex"><strong>Published by <cfoutput>#getbids.owner#
		<cfif isdefined("bid")>
		from #bidfrom# to #bidto#
		</cfif></strong></span></cfoutput>
		</td></tr>
                  <tr>
                    <td width="100%"> <span class="tex"><br>
					<cfoutput>Showing&nbsp;<b>#URL.StartRow#</b>&nbsp;to  <b>#EndRow#</b>&nbsp;of&nbsp; <b>#totalrows#</b></font></cfoutput><cfif isdefined("showall") and showall is not "yes">&nbsp;|&nbsp;<!---show all link---><cfoutput><a href="?showall=Yes&temphref=#temphref#&userid=#userid#&action=#action#"><span class="tex2"><strong>Show All</strong></span></a></cfoutput></font></cfif>
						
					
					</span><br>
						  
                </tr>
				
				<tr>
                <td width="100%"><!--mstheme--><!--mstheme--></font><p align="right"><cfif not url.showall><!-- Provide next/back links -->
			  <cfinclude template="NextNIncludeBackNext.cfm"> </cfif>
			  </td>
                </tr>
				
              </table>
		 
		 <table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr >
						     <td>
						<!--New code-->
						       <table width="100%" cellpadding="2" cellspacing="0">
						          <tr>
						             <td class="yellowLeft">
						                  <div id="searchText">Search Results</div>
						              </td>                                                                                                 
						              <td class="yellow">
						                 <div id="sortBy" class="sortBy" align="right">
                        					<cfinclude template="sort_inc.cfm">
										</div>
						                </td>                                   
						             </tr>
						       </table>
						    </td>            
						</tr>	 			
			</table>
		<table width="100%" bgcolor="black" bordercolor="black" bordercolorlight="black" border="0" bordercolordark="black"  cellspacing="1" cellpadding="3">


<tr id="ignore" bgcolor="white"   bordercolor="black" bordercolorlight="black"   bordercolordark="black"><cfoutput>
													<td width="6%" style="font-weight:bold;" bgcolor="##fbedbd" align="center">
													BidID
													</td>
         											<td width="18%" style="font-weight:bold;" bgcolor="##fbedbd">
                                               		Project Name
                                                    </td>
													<td width="10%" style="font-weight:bold;" bgcolor="##fbedbd">
                                                    Stage
                                                    </td>
                                                    <td width="13%" style="font-weight:bold;" bgcolor="##fbedbd">
                                                    Architect/Engineer
                                                    </td>
                                                    <td width="9%" style="font-weight:bold;" bgcolor="##fbedbd">
                                                    City
                                                    </td>
                                                    <td width="3%" style="font-weight:bold;" bgcolor="##fbedbd">
                                                    State
                                                    </td>
                                                    <td width="12%" style="font-weight:bold;" bgcolor="##fbedbd">
                                                    Tags
                                                    </td>
													<td width="10%" style="font-weight:bold;" bgcolor="##fbedbd">
                                                    Submittal Date
                                                    </td>
                                                  <td width="14%" style="font-weight:bold;" bgcolor="##fbedbd">
                                                    Est. Value / Project Size
                    							  </td>
</cfoutput>
</tr>

<cfloop query="getbids" ><cfif valuetype EQ "1"><cfset valueT = "Total Contract"><cfelseif valuetype EQ "2"><cfset valueT = "Painting Only"><cfelse><cfset valueT = ""></cfif>
<cfoutput>
<tr bgcolor="white">
<!---run query to get the date and see if the bid is new---><CFSET todayDATE = #CREATEODBCDATE(NOW())#>
<!---cfquery name="getdate" datasource="#the_dsn#">select paintpublishdate from bid_edited_live where bidid = #bidid#</cfquery>
<cfquery name="getstatus" datasource="#the_dsn#" maxrows=1>select updateid from bid_update_log where bidid = #bidid#  order by uid desc</cfquery--->
<!---cfquery name="checkbid" datasource="#the_dsn#" maxrows=1>select bidid,dateviewed from bid_user_viewed_log where bidid = #bidid# and userid=#userid#  order by id desc</cfquery--->
<td align="center" ><span class="tex"><b>#bidid#</b></span></td>
<td> <cfif dateformat(paintpublishdate) gte dateformat(todaydate)>
	<span class="tex6">New Today!</span><br><cfelseif updateid is not "" and viewed is not bidid and (updateid is 1 or updateid is 7 or updateid is 8 or updateid is 9) ><span class="tex6">Updated!</span><br><cfelseif updateid is not "" and viewed is not bidid and updateid is 2 ><span class="tex6">Submittal Change!</span><br><cfelseif updateid is not "" and viewed is not bidid and updateid is 3 ><span class="tex6">Cancelled!</span><br><cfelseif updateid is not "" and viewed is not bidid and updateid is 4 ><span class="tex6">Amendment</span><br><cfelseif updateid is not "" and viewed is not bidid and updateid is 5 ><span class="tex6">Award!</span><br><cfelseif updateid is not "" and viewed is not bidid and updateid is 6 ><span class="tex6">Submittal Extended!</span><br><cfelseif updateid is not "" and viewed is not bidid and updateid is 14 ><span class="tex6">Pre-Bid Mandatory!</span><br><cfelseif updateid is not "" and viewed is not bidid and updateid is 15 ><span class="tex6">No Painting!</span><br></cfif>
	<a href="../leads/?bidid=#bidid#" class="bold">
		<cfif viewed is not "" >
					<span class="tex3">
					<cfelse>
					<span class="tex2">
					</cfif>#trim(projectname)#</span></a></td>
<td>#stage#</td>
<td><cfif architect is not ""><span class="tex">#architect#</span><cfelse><span class="tex">N/A</span></cfif></td>

<td align="center"><span class="tex"><cfif city NEQ "">#city#<cfelseif county NEQ "">#county#</cfif></span></td>

<td align="center" ><span class="tex">#state#</span></td>

<td><span class="tex">#tags#</span></td>


<td><span class="tex">#dateformat(submittaldate, "mm/dd/yyyy")#</span>&nbsp;</td>

<td><!---cfif minimumvalue is not "" and minimumvalue is not "0"---><!---/cfif---><span class="tex"><cfif minimumvalue is not "" and minimumvalue is not "0" and maximumvalue is not "0"><cfset bidvalue = "#dollarformat(minimumvalue)# - #dollarformat(maximumvalue)# #valueT#">#bidvalue#<cfelseif minimumvalue is not "" and minimumvalue is not "0"><cfset bidvalue= "#dollarformat(minimumvalue)# #valueT#">#bidvalue#<cfelseif maximumvalue is not "" and maximumvalue is not "0"><cfset bidvalue= "#dollarformat(maximumvalue)# #valueT#">#bidvalue#<cfelse><cfset bidvalue = #projectsize#>#bidvalue#</cfif></span>&nbsp;</td>

</tr>
</cfoutput>
</cfloop>
</table><!---cfif getbids.recordcount is 0><table><tr><td><b><span class="tex">There are no projects received matching your states selected.</span></b></td></tr></table></cfif--->	  
				   <cfif not URL.ShowAll><!-- Provide next/back links -->
			 <div align="right">  <cfinclude template="NextNIncludeBackNext.cfm"></div>
			  <div align="left"><span class="tex">
<cfinclude template="nextninclude_pagelinks.cfm"></span>		</cfif>		














  <!--- Provide Next/Back links ---><font face="arial, Arial, Helvetica" color="blue"><font face="Arial" size="2"> <cfif not url.showall><cfoutput><a href="#CGI.SCRIPT_NAME#?ShowAll=Yes&userid=#userid#&tempHRef=#tempHRef#"><span class="tex2">Show All</span></a></cfoutput></cfif>
  