	
                		<tr>
                            <td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: #FFFFFF;">
                             	
                             		<table width="100%" bgcolor="black" bordercolor="black" bordercolorlight="black" border="0" bordercolordark="black"  cellspacing="1" cellpadding="0">
                             					<tr bgcolor="white"   bordercolor="black" bordercolorlight="black"   bordercolordark="black" >
                                                    <td width="18%" style="font-weight:bold;" bgcolor="#fbedbd" align="center" valign="middle">
                                                    Project Name
                                                    </td>
													<td width="10%" style="font-weight:bold;" bgcolor="#fbedbd" align="center" valign="middle">
                                                    Stage
                                                    </td>
                                                    <td width="13%" style="font-weight:bold;" bgcolor="#fbedbd" align="center" valign="middle">
                                                    Agency
                                                    </td>
                                                    <td width="9%" style="font-weight:bold;" bgcolor="#fbedbd" align="center" valign="middle">
                                                    City
                                                    </td>
                                                    <td width="3%" style="font-weight:bold;" bgcolor="#fbedbd" align="center" valign="middle">
                                                    State
                                                    </td>
                                                    <td width="12%" style="font-weight:bold;" bgcolor="#fbedbd" align="center" valign="middle">
                                                    Tags
                                                    </td>
													<td width="10%" style="font-weight:bold;" bgcolor="#fbedbd" align="center" valign="middle">
                                                    Submittal Date
                                                    </td>
                                                    <td width="14%" style="font-weight:bold;" bgcolor="#fbedbd" align="center" valign="middle">
                                                    Est. Value / Project Size
                                                    </td>
                                                </tr>
										
											<cfloop query="search_results" >
												<cfif valuetype is 1>
														<cfset valueT = "Total Contract">
												<cfelseif valuetype is 2>
													<cfset valueT = "Painting Only">
													<cfelse>
												<cfset valueT = "">
												</cfif>	
                                            	<cfoutput> 
												<cfif stageID EQ 5 or stageID EQ 6>
												<cfstoredproc procedure="get_low" datasource="#application.datasource#" >
													<cfprocparam type="in" dbvarname="@bidid" cfsqltype="CF_SQL_INTEGER" value="#bidid#">
													<cfprocresult name="getlow" resultset="1">
													<cfprocresult name="getlow2" resultset="2">
												</cfstoredproc>
												</cfif>
                                                <tr bgcolor="white">
                                                	
                                                    <td width="18%">
                                                    <cfif dateformat(paintpublishdate) gte dateformat(todaydate)>
														<span style="color: red; font-weight:bold" >New Today!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and (updateid is 1 or updateID is 10) >
														<span style="color: red; font-weight:bold" >Updated!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 2 >
														<span style="color: red; font-weight:bold" >Submittal Change!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 3 >
														<span style="color: red; font-weight:bold" >Cancelled!</span><br>
														<!---cfelseif updateid is not "" and viewed is not bidid and updateid is 4 >
														<span style="color: red; font-weight:bold" >Amendment</span><br--->
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 5 >
														<span style="color: red; font-weight:bold" >Award!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 6 >
														<span style="color: red; font-weight:bold" >Postponed!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 7 >
														<span style="color: red; font-weight:bold" >Low Bidders!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 8 >
														<span style="color: red; font-weight:bold" >Rejected!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 9 >
														<span style="color: red; font-weight:bold" >Rebid!</span><br>
														<cfelseif isdefined("planholders") and planholders NEQ "" >
														<span style="color: red; font-weight:bold" >Planholders!</span><br></cfif>
														
														BidID - #bidid#<br>
														<cfif viewed is not "" >
															<a href="../leads/?bidid=#bidid#<cfif isdefined("qt") and qt NEQ "">&keywords=#urlencodedformat(qt)#</cfif>" style="color:purple; text-decoration:none; font-weight:bold;">
														<cfelse>
															<a href="../leads/?bidid=#bidid#<cfif isdefined("qt") and qt NEQ "">&keywords=#urlencodedformat(qt)#</cfif>" style="color:##2d53ac; text-decoration:none; font-weight:bold;">
														</cfif>
														#trim(projectname)#
														</a> 
														</td>
                                                    <td width="10%">
                                                    #stage#
                                                    </td>
                                                    <td width="13%">
                                                    <cfif isdefined("supplierID") and supplierID is not ""><a href="?action=53&userid=#userid#&supplierID=#supplierID#" style="color:##2d53ac; text-decoration:none; font-weight:bold;">#owner#</a><cfelse>#owner#</cfif>
                                                    </td>
                                                    <td width="9%">
                                                    <cfif city NEQ "">
                                                    #trim(city)#
                                                    <cfelseif county NEQ "">
													#trim(county)#
													</cfif>
                                                    </td>
                                                    <td width="3%">
                                                    #state#
                                                    </td>
                                                    <td width="12%">
                                                  	#tags#
                                                    </td>
													 <td width="10%">
                                                    #dateformat(submittaldate, "mm/dd/yyyy")#
                                                    </td>
                                                    <td width="14%">
                                                   	<cfif stageID NEQ 5 and stageID NEQ 6>
														<cfif minimumvalue is not "" and minimumvalue is not "0" and maximumvalue is not "0">
															<cfset bidvalue = "#dollarformat(minimumvalue)# - #dollarformat(maximumvalue)# #valueT#">#bidvalue#
														<cfelseif minimumvalue is not "" and minimumvalue is not "0">
															<cfset bidvalue= "#dollarformat(minimumvalue)# #valueT#">#bidvalue#
														<cfelseif minimumvalue is not "" and minimumvalue is "0" and maximumvalue is not "0">
															<cfset bidvalue= "#dollarformat(maximumvalue)# #valueT#">#bidvalue#
														<cfelse>
															<cfset bidvalue = #projectsize#>#bidvalue#
														</cfif>
													<cfelseif (stageID EQ 5 or stageID EQ 6) and getlow.recordcount EQ 0 and getlow2.recordcount EQ 0>
														<cfif minimumvalue is not "" and minimumvalue is not "0" and maximumvalue is not "0">
															<cfset bidvalue = "#dollarformat(minimumvalue)# - #dollarformat(maximumvalue)# #valueT#">#bidvalue#
														<cfelseif minimumvalue is not "" and minimumvalue is not "0">
															<cfset bidvalue= "#dollarformat(minimumvalue)# #valueT#">#bidvalue#
														<cfelseif minimumvalue is not "" and minimumvalue is "0" and maximumvalue is not "0">
															<cfset bidvalue= "#dollarformat(maximumvalue)# #valueT#">#bidvalue#
														<cfelse>
															<cfset bidvalue = #projectsize#>#bidvalue#
														</cfif>
													<cfelseif (stageID EQ 5 or stageID EQ 6) and getlow.recordcount GT 0>
														<cfloop query="getlow">
														<cfif supplierID NEQ "">
														<a href="?action=90&supplierid=#supplierid#">
															<font face="Arial" size="1" color="blue">#companyname#</font>
														</a>
														<cfelse>
															<font face="Arial" size="1" >#companyname#</font>
														</cfif>
															<br>
															<font size=1>#dollarformat(amount)#</font><br><br>
														</cfloop>
													<cfelseif (stageID EQ 5 or stageID EQ 6) and getlow2.recordcount GT 0>
														<cfloop query="getlow2">
															<font face="Arial" size="1" >#companyname#</font>
															<br>
															<font size=1>#dollarformat(amount)#</font><br><br>
														</cfloop>
													<cfelse>
														<cfif minimumvalue is not "" and minimumvalue is not "0" and maximumvalue is not "0">
															<cfset bidvalue = "#dollarformat(minimumvalue)# - #dollarformat(maximumvalue)# #valueT#">#bidvalue#
														<cfelseif minimumvalue is not "" and minimumvalue is not "0">
															<cfset bidvalue= "#dollarformat(minimumvalue)# #valueT#">#bidvalue#
														<cfelseif minimumvalue is not "" and minimumvalue is "0" and maximumvalue is not "0">
															<cfset bidvalue= "#dollarformat(maximumvalue)# #valueT#">#bidvalue#
														<cfelse>
															<cfset bidvalue = #projectsize#>#bidvalue#
														</cfif>
													</cfif>
                                                    </td>
                                                    
                                                </tr>
                                                
											
											</cfoutput>
											</cfloop> 
										
                                            
                            	</table>
                        	</td>
                    	</tr>