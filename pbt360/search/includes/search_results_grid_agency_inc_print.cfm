	
                		<tr>
                            <td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: #FFFFFF;">
                             	
                             		<table width="100%" bgcolor="black" bordercolor="black" bordercolorlight="black" border="0" bordercolordark="black"  cellspacing="1" cellpadding="0" class="grid">
                             					<tr bgcolor="white"   bordercolor="black" bordercolorlight="black"   bordercolordark="black"  class="grid grid_head">
                                                    <td width="18%" style="font-weight:bold;" background-color:#fbedbd; align="center" valign="middle" class="grid grid_head">
                                                    Project Name
                                                    </td>
													<!---td width="10%" style="font-weight:bold;" bgcolor="#fbedbd" align="center" valign="middle">
                                                    Stage
                                                    </td--->
                                                    <td width="13%" style="font-weight:bold;" background-color:#fbedbd; align="center" valign="middle" class="grid grid_head">
                                                    Agency
                                                    </td>
                                                    <td width="9%" style="font-weight:bold;" background-color:#fbedbd; align="center" valign="middle" class="grid grid_head">
                                                    City
                                                    </td>
                                                    <td width="3%" style="font-weight:bold;" background-color:#fbedbd; align="center" valign="middle" class="grid grid_head">
                                                    State
                                                    </td>
                                                    <td width="12%" style="font-weight:bold;" background-color:#fbedbd; align="center" valign="middle" class="grid grid_head">
                                                    Tags
                                                    </td>
													<td width="10%" style="font-weight:bold;" background-color:#fbedbd; align="center" valign="middle" class="grid grid_head">
                                                    Project Year(s)
                                                    </td>
                                                    <td width="14%" style="font-weight:bold;" background-color:#fbedbd; align="center" valign="middle" class="grid grid_head">
                                                    Total Budget
                                                    </td>
                                                </tr>
										
											<cfloop query="search_results" >
                                            	<cfoutput> 
                                                <tr bgcolor="white" class="grid">
                                                    <td width="18%" class="grid">
                                                    <cfif dateformat(paintpublishdate) gte dateformat(todaydate)>
														<span style="color: red; font-weight:bold" >New Today!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and (updateid is 1 or updateid is 7 or updateid is 8 or updateid is 9 or updateid is 10) >
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
														<span style="color: red; font-weight:bold" >Low Bidders!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 14 >
														<span style="color: red; font-weight:bold" >Pre-Bid Mandatory!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 15 >
														<span style="color: red; font-weight:bold" >No Painting!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 19 >
														<span style="color: red; font-weight:bold" >Rejected!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 20 >
														<span style="color: red; font-weight:bold" >Rebid!</span><br></cfif>
														
														ID - #bidid#<br>
														<cfif viewed is not "" >
															<a href="../leads/?action=planning&bidid=#bidid#<cfif isdefined("qt") and qt NEQ "">&keywords=#urlencodedformat(qt)#</cfif>" style="color:purple; text-decoration:none; font-weight:bold;">
														<cfelse>
															<a href="../leads/?action=planning&bidid=#bidid#<cfif isdefined("qt") and qt NEQ "">&keywords=#urlencodedformat(qt)#</cfif>" style="color:##2d53ac; text-decoration:none; font-weight:bold;">
														</cfif>
														#trim(projectname)#
														</a> 
														</td>
                                                    <!---td width="10%">
                                                    #stage#
                                                    </td--->
                                                    <td width="13%" class="grid">
                                                    <cfif isdefined("supplierID") and supplierID is not ""><a href="#application.contrakpath#/agency/?agency&supplierID=#search_results.supplierID#&userid=#userid#" style="color:##2d53ac; text-decoration:none; font-weight:bold;">#owner#</a><cfelse>#owner#</cfif>
                                                    </td>
                                                    <td width="9%" class="grid">
                                                    <cfif city NEQ "">
                                                    #trim(city)#
                                                    <cfelseif county NEQ "">
													#trim(county)#
													</cfif>
                                                    </td>
                                                    <td width="3%" class="grid">
                                                    #state#
                                                    </td>
                                                    <td width="12%" class="grid">
                                                  	#tags#
                                                    </td>
													 <td width="10%" class="grid">
                                                    #project_startdate#-#project_enddate#
                                                    </td>
                                                    <td width="14%" class="grid">
                                                   #dollarformat(total_budget)#
                                                    </td>
                                                    
                                                </tr>
                                                
											
											</cfoutput>
											</cfloop> 
                            	</table>
                        	</td>
                    	</tr>