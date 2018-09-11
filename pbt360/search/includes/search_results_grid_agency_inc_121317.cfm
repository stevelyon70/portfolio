	
                		<tr>
                            <td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: #FFFFFF;">
                             	<cfform name="myform" > <cfinput type="hidden" name="userID" value="#userID#">
                             		<table width="100%" bgcolor="black" bordercolor="black" bordercolorlight="black" border="0" bordercolordark="black"  cellspacing="1" cellpadding="0">
                             					<tr bgcolor="white"   bordercolor="black" bordercolorlight="black"   bordercolordark="black" >
                                                	<td width="6%" style="font-weight:bold;" background-color:#fbedbd; align="center" valign="middle">
                                                    <cfif search_results.recordcount GT 0>
                                                    <input type="checkbox" class="selAllTrash" />
                                                    <script>					
															$(".selAllTrash").on('click',function(){
																	if(this.checked){
																		$('.trashbox').each(function(){
																			this.checked = true;
																		})
																	}else{
																		$('.trashbox').each(function(){
																			this.checked = false;
																		})
																	}
																});
													</script>
                                                    <a href="javaScript:ColdFusion.MessageBox.show('trash_confirm')"  ><img src="//app.paintbidtracker.com/images/icons/Trash.png" ></a><cfelse><img src="//app.paintbidtracker.com/images/icons/Trash.png" >                 
                                                   </cfif>
                                                    </td> 
                                                    <td width="30%" style="font-weight:bold;" background-color:#fbedbd; align="center" valign="middle">
                                                    Project Name
                                                    </td>
													<!---td width="10%" style="font-weight:bold;" bgcolor="#fbedbd" align="center" valign="middle">
                                                    Stage
                                                    </td--->
                                                    <td width="13%" style="font-weight:bold;" background-color:#fbedbd; align="center" valign="middle">
                                                    Agency
                                                    </td>
                                                    <td width="9%" style="font-weight:bold;" background-color:#fbedbd; align="center" valign="middle">
                                                    City
                                                    </td>
                                                    <td width="3%" style="font-weight:bold;" background-color:#fbedbd; align="center" valign="middle">
                                                    State
                                                    </td>
                                                    <td width="12%" style="font-weight:bold;" background-color:#fbedbd; align="center" valign="middle">
                                                    Tags
                                                    </td>
													<td width="10%" style="font-weight:bold;" background-color:#fbedbd; align="center" valign="middle">
                                                   Project Year(s)
                                                    </td>
                                                    <td width="14%" style="font-weight:bold;" bbackground-color:#fbedbd; align="center" valign="middle">
                                                    Total Budget
                                                    </td>
                                                    <td align="center" width="5%" style="font-weight:bold;" background-color:#fbedbd;>
                                                     <cfif search_results.recordcount GT 0>
                                                     <input type="checkbox" class="selAllSave" />
                                                     <script>					
															$(".selAllSave").on('click',function(){
																	if(this.checked){
																		$('.savebox').each(function(){
																			this.checked = true;
																		})
																	}else{
																		$('.savebox').each(function(){
																			this.checked = false;
																		})
																	}
																});
													</script>
                                                     <a href="javaScript:ColdFusion.Window.show('folderSave')"  ><img src="//app.paintbidtracker.com/images/icons/SaveFolder.png"></a><cfelse><img src="//app.paintbidtracker.com/images/icons/SaveFolder.png">
                                                   </cfif>
                                                    </td>
                                                </tr>
										
											<cfloop query="search_results" >
                                            	<cfoutput> 
                                                <tr bgcolor="white">
                                                	<td width="6%" align="center" valign="center">
                                                    <!---span class="redNotices">Updated</span--->
                                                   		<cfinput name="trash" type="checkbox" value="#bidID#" class="trashbox">
                                                    </td>
                                                    <td width="30%">
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
														#trim(projectname)#</a> 
														<br><br>
														(Publication Date: #dateformat(paintpublishdate,"mm/dd/yyyy")#)<br>
														
														</td>
                                                    <!---td width="10%">
                                                    #stage#
                                                    </td--->
                                                    <td width="13%">
                                                    <cfif isdefined("supplierID") and supplierID is not ""><a href="../../contrak/agency/?agency&supplierID=#search_results.supplierID#&userid=#userid#" style="color:##2d53ac; text-decoration:none; font-weight:bold;">#owner#</a><cfelse>#owner#</cfif>
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
                                                    #project_startdate#-#project_enddate#
                                                    </td>
                                                    <td width="14%">
                                                   #dollarformat(total_budget)#
                                                    </td>
                                                    <td  width="5%" align="center">
                                                    <cfif not listcontains(valuelist(pull_saved_projects.bidID),bidID)>
                                                    	<cfinput name="check1"  type="checkbox" value="#bidID#" class="savebox" >
													<cfelse>
														<cfinput name="check1"  type="checkbox" value="#bidID#" class="savebox" disabled>
                                                    </cfif>
                                                    </td>
                                                </tr>
                                                
											
											</cfoutput>
											</cfloop> 
										
                                            
                            	</table></cfform>
                        	</td>
                    	</tr>