  <!----cfscript>
// *** Restrict Access To Page: Grant or deny access to this page
MM_authorizedUsers="";
MM_authFailedURL="../index.cfm";
MM_grantAccess=false;
MM_Session = IIf(IsDefined("Session.MM_Username"),"Session.MM_Username",DE(""));
if (MM_Session IS NOT "") {
  if (true OR (Session.MM_UserAuthorization IS "") OR (Find(Session.MM_UserAuthorization, MM_authorizedUsers) GT 0)) {
    MM_grantAccess = true;
  }
}
if (NOT MM_grantAccess) {
  MM_qsChar = "?";
  if (Find("?",MM_authFailedURL) GT 0) MM_qsChar = "&";
  MM_referrer = CGI.SCRIPT_NAME;
  if (CGI.QUERY_STRING IS NOT "") MM_referrer = MM_referrer & "?" & CGI.QUERY_STRING;
  MM_authFailedURL_Trigger = MM_authFailedURL & MM_qsChar & "accessdenied=" & URLEncodedFormat(MM_referrer);
}
</cfscript>
<cfif IsDefined("MM_authFailedURL_Trigger")>
<cflocation url="#MM_authFailedURL_Trigger#" addtoken="no">
</cfif--->
<CFSET todaydate = #CREATEODBCDATETIME(NOW())#>


	
	<!---TO DO put in a CFC --->
<cfinclude template="user_trash.cfm">

<!---include the returned results--->
<cfinclude template="view_results.cfm">


<!---pull bids that are saved for form--->
<cfquery name="pull_saved_projects" datasource="#the_dsn#">
	select bidID 
	from bid_user_project_bids
	where userID = #userID# and active = 1
</cfquery>


	 <cfswitch expression="#ltype#">
	 	  <cfcase value="1">
		   <cfset viewtype = "Verified Industrial Projects">
		  </cfcase>
		   <cfcase value="2">
		   <cfset viewtype = "Verified Commercial Projects">
		  </cfcase>
		   <cfcase value="3">
		   	 <cfset viewtype = "Verified Industrial & Commercial Bid Results">
		  </cfcase>
		</cfswitch>
	
	


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
<cfif not isdefined("endrow")>
<cfset EndRow  = Min(URL.StartRow + RowsPerPage - 1, TotalRows)>
</cfif>
<cfif totalrows LT 20>
<cfset EndRow = totalrows>
</cfif>
<!-- Next button goes to 1 past current end row -->
<cfset StartRowNext = EndRow + 1>
<!-- Back button goes back N rows from start row -->
<cfset StartRowBack = URL.StartRow - RowsPerPage>	
<cfajaximport tags="cfwindow,cfform">
<script>
	$(function() {
		
		$("#saved-folder").dialog({ 
			autoOpen: false,
			height: 300,
			modal: true,
			close: function() {
			} 
			});
		
		$("#savetofolder").click(function() {
			var values = $('#savefolder').serialize();
		        $("ul#list").html(values);
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
       		ColdFusion.Ajax.submitForm('myform', 'includes/trash_inc.cfm', callback,
            errorHandler);
     	//alert("You clicked: "+button); 
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


<table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                      <td width="100%" align="left" valign="top" colspan="3">
                        <div align="left">
                          <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                              <td align="left" valign="bottom">
                              <h1><span style="font-size:16px">Project Intelligence - <cfoutput>#viewtype#</cfoutput></span></h1>
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
						
                   		<cfoutput>
<tr>
                            
							<td>
                      		
							 <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                              <td align="left" valign="bottom">
                              <strong>#total_results.total_returned# Results Found</strong> under the following criteria:<br>
							 
                       	 	Project Stage: 
							<cfif isdefined("project_stage") and project_stage NEQ "">
								<cfloop query="gettype">
									<cfoutput>#interface_stage# <!---span class="deleteBox">[<span class="xRed">x</span>]</span---><cfif currentrow lt recordcount>,</cfif></cfoutput>
								</cfloop>
							<cfelse>
								All
							</cfif>
							<br />
							Project Types: Verified Painting
                              </td>
                              <td width="200" valign="top" align="right">
								<p align="right">
									<div align="right">
										
									<cfif search_results.recordcount GT 0> 
										<cftooltip 
										    autoDismissDelay="5000" 
										    hideDelay="250" 
										    preventOverlap="true" 
										    showDelay="200" 
										    tooltip="Export to Excel"> 
										 		<a href="../export/?userID=#userid#&ltype=#ltype#" title="Export to Excel" alt="Export to Excel" target="_blank">
													<img src="../images/icons/SaveExcel.png">
												</a>
										</cftooltip>
									</cfif>
										
									<cftooltip 
										    autoDismissDelay="5000" 
										    hideDelay="250" 
										    preventOverlap="true" 
										    showDelay="200" 
										    tooltip="Print List"> 
												<cfoutput>
												<a href="../print/?ltype=#ltype#<cfif url.showall>&showall=yes</cfif>" target="_blank">
												<img src="../images/icons/print.png">
												</a>
												</cfoutput>
									</cftooltip>
									
                   				
									</div> 
                              </p>
							  </td>
                            </tr>
                          </table>
							
							
							
                        	</td>
                     	</tr>
</cfoutput>
						
						
						
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
						                  <div id="searchText">Results</div>
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
<!---Window to launch the Save to Folder option--->
<cfwindow  width="500" height="350" 
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
        source="includes/export_to_excel.cfm?userID=#userid#&search_variables=#search_variables#" />	
 </cfif>