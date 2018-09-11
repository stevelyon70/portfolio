
<CFSET todaydate = #CREATEODBCDATETIME(NOW())#>

	
	<!---TO DO put in a CFC --->
<cfinclude template="user_trash.cfm">

<!---include the returned results--->
<cfinclude template="lastvisit_results.cfm">


<!---pull bids that are saved for form--->
<cfquery name="pull_saved_projects" datasource="#application.datasource#">
	select bidID 
	from bid_user_project_bids
	where userID = #userID# and active = 1
</cfquery>


<CFPARAM NAME="mystartrow" DEFAULT="1">
<CFPARAM NAME="realstartrow" DEFAULT="1">
<!-- Number of rows to display per next/back page --->
<cfset RowsPerPage = 20>
<!--- What row to start at?  Assume first by default --->
<cfparam name="URL.StartRow" Default="1" Type="Numeric">
<!---Allow for Show  All parameter in the URL --->
<cfparam name="URL.ShowAll" Type="boolean" Default="no">
<!--- We know the total number of rows from the query --->
<cfset totalrows = total_results.total_returned>
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
<!---cfajaximport tags="cfwindow,cfform">
<script>
	$(function() {
		
		$("#saved-folder").dialog({ 
			autoOpen: false,
			height: 300,
			modal: true,
			/*buttons: {
				"Save": function() {
						$( this ).dialog( "close" );
					
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			},*/
			close: function() {
				
			} 
			});
		/*
	 var answer =  $("#savefolder").find("input:checked").val();
			  var ar= answer;
		        var items="";
		        for(var i=0;i<ar.length;i++){
		                items +="<li>" + ar[i] + "</li>";
		        }
	*/
		
		$("#savetofolder").click(function() {
			var values = $('#savefolder').serialize();
		//window.open('includes/test_popup.cfm','','width=400,height=400');
			
		        $("ul#list").html(values);
			//$("#saved-folder").dialog('open');
			// prevent the default action, e.g., following a link
			return false;
		});
		
		
	}
	);
	</script>
 
<script  type="text/javascript"> 
    //Function to to show result of a message box. 
    var yesTrash = function(button){ 
		if (button == 'yes')
		{
			//ColdFusion.Window.show('trashProject')
			
           
       		 ColdFusion.Ajax.submitForm('myform', 'includes/trash_inc.cfm', callback,
            errorHandler);
    		
     //alert("You clicked button: "+button); 
    	}
    
		}; 
		
      var removeSuccess = function(button){ 
		if (button == 'ok')
		{
			
			ColdFusion.Window.hide('trashProject')
			window.location.reload()
    	}
    
		}; 
	  
    function callback(text)
    {
        //alert("Callback: " + text);
		
			ColdFusion.Window.hide('folderSave')
			window.location.reload()
		
    }
    
    function errorHandler(code, msg)
    {
        alert("Error!!! " + code + ": " + msg);
    }
    
</script>
--->   

<table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                      <td width="100%" align="left" valign="top" colspan="3">
                        <div align="left">
                          <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                              <td align="left" valign="bottom">
                              <h1><span style="font-size:16px">Paint BidTracker</span></h1>
                              </td>
                              <td width="200" valign="top" align="right">
								<p align="right">
									  <!-- AddThis Button BEGIN -->
								<div class="addthis_toolbox addthis_default_style"><a class="addthis_button_email"></a>  <a class="addthis_button_print"></a> <a class="addthis_button_twitter"></a> <a class="addthis_button_facebook"></a> <a class="addthis_button_linkedin"></a> <!---a class="addthis_button_stumbleupon"></a> <a class="addthis_button_digg"></a---> <span class="addthis_separator">|</span> <a class="addthis_button_expanded">More</a></div>
								<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js?pub=xa-4a843f5743c4576f"></script>
								<!-- AddThis Button END -->
                              </p>
							  </td>
                            </tr>
                          </table>
                        </div>
                        <div align="left">
  						<table border="0" cellpadding="0" cellspacing="0" width="100%">
    						<tr>
      							<td width="100%"><hr class="PBT" noshade></td>
    						</tr>
  						</table>
						</div>
                   	</td>
                </tr>
           </table>
			<!--end heading-->
 
<table border="0" cellpadding="5" cellspacing="0" width="100%">
<tr>
	<td>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
               	<td width="100%">
                  	<div align="center">
                	<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
                        	<td height="10"></td>
                  		</tr>
						 <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                              <td align="left" valign="bottom">
                   		 <strong>
                   		 <cfoutput>
                   		#total_results.total_returned# 
						  </cfoutput> Results Found</strong> under the following criteria:<br>
							  </td>
							 </tr>
						
                      	<tr>
                        <td align="right">
                        <strong>Showing Records<cfoutput> #startrow# to #endrow#</cfoutput>:</strong>
						<cfif not url.showall><cfinclude template="NextNIncludeBackNext.cfm"> </cfif><cfif search_results.recordcount is not 0><cfif not url.showall><cfoutput> | <a href="?ShowAll=Yes&userid=#userid#&tempHRef=#tempHRef#">Show All</a></cfoutput></cfif></cfif>
						
						 
						</td>
						</tr>
                        	
						
						<tr>
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

	<!---include grid results--->
                    <cfinclude template="search_results_grid_inc.cfm">
                    
						
						<!---new search format--->
							<!---tr>
                            <td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: #FFFFFF;">
                             	<table width="100%"  cellspacing="1" cellpadding="3">
                             					<tr>
                                                	<td width="6%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    Trash
                                                    </td> 
                                                    <td width="18%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    Project Name
                                                    </td>
													<td width="10%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    Type
                                                    </td>
                                                    <td width="13%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    Agency
                                                    </td>
                                                    <td width="9%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    City
                                                    </td>
                                                    <td width="3%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    State
                                                    </td>
                                                    <td width="12%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    Tags
                                                    </td>
													<td width="10%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    Submittal Date
                                                    </td>
                                                    <td width="14%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    Est. Value / Project Size
                                                    </td>
                                                    <td align="center" width="3%" style="font-weight:bold;" bgcolor="#fbedbd">
                                                    <a href="">Save to Folder</a>
                                                    </td>
                                                </tr>
											<cfloop query="search_results" >	
                                            	<cfoutput> 
										
                                                <tr >
                                                	<td>
                                                    <!---span class="redNotices">Updated</span---><br />
                                                   <input name="trash" type="checkbox" value="#bidID#">
                                                    </td>
                                                    <td>
                                                    <!---cfif dateformat(paintpublishdate) gte dateformat(todaydate)>
														<span class="tex6">New Today!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and (updateid is 1 or updateid is 7 or updateid is 8 or updateid is 9) >
														<span class="tex6">Updated!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 2 >
														<span class="tex6">Submittal Change!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 3 >
														<span class="tex6">Cancelled!</span><br><cfelseif updateid is not "" and viewed is not bidid and updateid is 4 >
														<span class="tex6">Amendment</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 5 >
														<span class="tex6">Award!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 6 >
														<span class="tex6">Submittal Extended!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 14 >
														<span class="tex6">Pre-Bid Mandatory!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 15 >
														<span class="tex6">No Painting!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 19 >
														<span class="tex6">Rejected!</span><br>
														<cfelseif updateid is not "" and viewed is not bidid and updateid is 20 >
														<span class="tex6">Rebid!</span><br></cfif>
														<cfif isdefined("planholders") and planholders is not ""><span class="tex6">Planholders</span><br></cfif--->
														BidID - #bidid#<br>
														<a href="?action=36&bidid=#bidid#&userid=#userid#&keywords=" style="color:##2d53ac; text-decoration:none; font-weight:bold;">
															<!---cfif viewed is not "" ><span class="tex3"><cfelse></cfif--->
														#trim(projectname)#</a> 
																
														</td>
                                                    <td>
                                                    #stage#
                                                    </td>
                                                    <td>
                                                    <cfif isdefined("ownerid") and ownerid is not ""><a href="?action=53&userid=#userid#&ownerid=#ownerid#" style="color:##2d53ac; text-decoration:none; font-weight:bold;">#owner#</a><cfelse><span class="tex">#owner#</span></cfif>
                                                    </td>
                                                    <td>
                                                    #city#
                                                    </td>
                                                    <td>
                                                    #state#
                                                    </td>
                                                    <td>
                                                  	#tags#
                                                    </td>
													 <td>
                                                    #dateformat(submittaldate, "mm/dd/yyyy")#
                                                    </td>
                                                    <td>
                                                    <cfif minimumvalue is not "" and minimumvalue is not "0" and maximumvalue is not "0"><cfset bidvalue = "#dollarformat(minimumvalue)# - #dollarformat(maximumvalue)# #valueT#">#bidvalue#<cfelseif minimumvalue is not "" and minimumvalue is not "0"><cfset bidvalue= "#dollarformat(minimumvalue)# #valueT#">#bidvalue#<cfelse><cfset bidvalue = #projectsize#>#bidvalue#</cfif></span>&nbsp;
                                                    </td>
                                                    <td align="center">
                                                    <input name="save" type="checkbox" value="">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="10">
                                                    <hr class="Gray">
                                                    </td>
                                                </tr>
											
											</cfoutput>
											</cfloop> 
										
                                            
                            	</table>
                        	</td>
                    	</tr--->
                        <tr>
                        	<td align="right"><strong>Showing Records <cfoutput>#startrow# to #endrow#</cfoutput>:</strong>
							<cfif search_results.recordcount is not 0>
								<p class="tinytext">
									<cfif not url.showall><cfinclude template="nextninclude_pagelinks.cfm"></cfif><cfif not url.showall><cfoutput> | <a href="?ShowAll=Yes&userid=#userid#&tempHRef=#tempHRef#">Show All</a></cfoutput></cfif>
								</p>
						    </cfif>   </td>
                  		</tr>
                	</table>
            	</div>
           		</td>
            </tr>
            <tr>
                <td width="100%" align="right">
                </td>
            </tr>
            <tr>
                <td>
                &nbsp;<br>
                &nbsp;
            	</td>
          	</tr>
   	      </table>
		</td>
	</tr>
</table>
<cfif search_results.recordcount GT 0>
<cfinclude template="search_params.cfm">
<!---Window to launch the Save to Folder option
<cfwindow  width="500" height="450" 
        name="folderSave" title="Save to Folder" 
        initshow="false"  draggable="false" center="true"  resizable="false" modal="true" bodystyle="background:##FFFFFF"
        source="includes/savetofolder_inc.cfm?userID=#userid#&projects={myform:check1.value@click}" />

<!--- Code to define the message boxes. --->                     
<cfmessagebox name="trash_confirm" type="confirm"  
        message="Are you sure you want to remove these projects?"  
        labelOK="Yes" labelCANCEL="Cancel" modal="yes" callbackhandler="yesTrash"
            multiline="false"/> 
<!--- Code to define the message boxes. --->                     
<cfmessagebox name="trash_success" type="confirm"  
        message="Projects Removed Successfully"  
        labelOK="Ok"  modal="yes" callbackhandler="removeSuccess"
            multiline="false"/> 
<!---Window to launch the Trash option--->
<cfwindow  width="500" height="350" 
        name="trashProject" title="Send to Trash" 
        initshow="false"  draggable="false" center="true"  resizable="false" modal="true" bodystyle="background:##FFFFFF"
        source="includes/trash_inc.cfm?userID=#userid#&projects={myform:trash.value@click}" />		
		
<!---Window to launch the Export option--->
<cfwindow  width="500" height="350" 
        name="ExportExcel" title="Export To Excel" 
        initshow="false"  draggable="false" center="true"  resizable="false"  bodystyle="background:##FFFFFF"
        source="includes/export_to_excel.cfm?userID=#userid#&search_variables=#search_variables#" />--->	
 </cfif>