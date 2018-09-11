
<tr>
	<td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: #FFFFFF;">
		
		<cfform name="myform" > 
			<cfinput type="hidden" name="userID" value="#userID#">
			
			<table class="grid table table-striped hidden" id="results_table">					
				<thead class="thead-default">
					<tr class="grid grid_head">
					  <th class="grid grid_head searchGridHead col-xs-1 text-center">
					  	<cfif search_results.recordcount GT 0>
					  		<!--input type="checkbox" class="selAllTrash" /> Select All-->
					  		<select class="actionSelect">
					  			<option selected>Multi Bid Action</option>
					  			<option value="_1">Select All</option>
					  			<option value="_2">Select None</option>
					  			<option value="_3">Track Leads</option>
					  			<option value="_4">Remove Leads</option>
					  			<option value="_5">Print Leads</option>
					  		</select>
					  	</cfif>
					  </th>
					  <th class="grid grid_head searchGridHead col-xs-3">Project Name </th>
					  <th class="grid grid_head searchGridHead col-xs-2">Agency </th>
					  <th class="grid grid_head searchGridHead col-xs-1">City </th>
					  <th class="grid grid_head searchGridHead col-xs-1">State </th>
					  <th class="grid grid_head searchGridHead col-xs-1">Project Year(s)</th>
					  <th class="grid grid_head searchGridHead col-xs-1">Total Budget</th>
					</tr>
				</thead>					
				<tfoot class="thead-default">
					<tr class="grid grid_head">
					  <th class="grid grid_head searchGridHeadB col-xs-1 text-center">
					  	&nbsp;
					  	<!---<cfif search_results.recordcount GT 0>
					  		<input type="checkbox" class="selAllTrash" /> Select All
					  	</cfif>--->
					  </th>
					  <th class="grid grid_head searchGridHeadB col-xs-3">Project Name </th>
					  <th class="grid grid_head searchGridHeadB col-xs-2">Agency </th>
					  <th class="grid grid_head searchGridHeadB col-xs-1">City </th>
					  <th class="grid grid_head searchGridHeadB col-xs-1">State </th>
					  <th class="grid grid_head searchGridHeadB col-xs-1">Project Year(s)</th>
					  <th class="grid grid_head searchGridHeadB col-xs-1">Total Budget</th>
					</tr>
				</tfoot>					
				<cfloop query="search_results" >
					<cfoutput> 
						<tr class="grid projectBid main-row">
							<td class="grid col-xs-1 text-center"> 
								<div>           
									<!---<cfif not listcontains(valuelist(pull_saved_projects.bidID),bidID)>       
										<cfinput name="trash" type="checkbox" value="#bidID#" class="actionbox">
									<cfelse>
										<cfinput name="trash" type="checkbox" value="#bidID#" disabled>
									</cfif>--->
									<cfinput name="trash" type="checkbox" value="#bidID#" class="actionbox">&nbsp; &nbsp;									

									<i class="fa fa-search qv topStack" data-bidid="#bidid#" aria-hidden="true"></i>&nbsp; &nbsp;

									<i class="fa fa-clipboard bidHandle" aria-hidden="true" id="bidHandle"></i>
									
								</div>					
							</td>
							<td class="grid col-xs-3">
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
									<span style="color: red; font-weight:bold" >Rebid!</span><br>
								</cfif>
								BidID - <span id="bid">#bidid#</span><br>
								<cfif isdefined("qt") and qt NEQ "">
									<cfset qt= #replace(qt, '\', '', "all")#><cfset qt= #replace(qt, '"', '', "all")#>
								</cfif>								
								<cfif viewed is not "" >
									<a href="../leads/?action=planning&bidid=#bidid#<cfif isdefined("qt") and qt NEQ "">&keywords=#urlencodedformat(qt)#</cfif>" style="color:purple; text-decoration:none; font-weight:bold;">
								<cfelse>
									<a href="../leads/?action=planning&bidid=#bidid#<cfif isdefined("qt") and qt NEQ "">&keywords=#urlencodedformat(qt)#</cfif>" style="color:##2d53ac; text-decoration:none; font-weight:bold;">
								</cfif>
								<span class="topStack">#trim(projectname)#</span></a> 
								<br><br>
								(Publication Date: #dateformat(paintpublishdate,"mm/dd/yyyy")#)<br>
							</td>
							<!---td width="10%">
							#stage#
							</td--->
							<td class="grid col-xs-2">
								<cfif isdefined("supplierID") and supplierID is not "">
									<a href="../../contrak/agency/?agency&supplierID=#search_results.supplierID#&userid=#userid#" style="color:##2d53ac; text-decoration:none; font-weight:bold;">#owner#</a>
								<cfelse>
									#owner#
								</cfif>
							</td>
							<td class="grid col-xs-1">
								<cfif city NEQ "">
									#trim(city)#
								<cfelseif county NEQ "">
									#trim(county)#
								</cfif>
							</td>
							<td width="3%">
								#state#
							</td>
							<!---<td width="12%">
							#tags#
							</td>--->
							<td class="grid col-xs-1">
								#project_startdate#-#project_enddate#
							</td>
							<td class="grid col-xs-1">
								#dollarformat(total_budget)#
							</td>
						</tr>
						<tr class="grid projectBid tags-row">
							<td class="grid col-xs-1"> </td>
							<td colspan="11" class="grid">
							<cfquery name="get_tags" datasource="#application.datasource#">
								select distinct pbt_project_master_cats.tagID,pbt_tags.tag
								from pbt_project_master_cats
									left outer join pbt_tags on pbt_tags.tagID = pbt_project_master_cats.tagID
								where pbt_tags.active = 1 
									and pbt_project_master_cats.bidID = <cfqueryPARAM value = "#bidID#" CFSQLType = "CF_SQL_INTEGER">
								--and pbt_tags.tag_typeID <> 9
								order by tag 
							 </cfquery>
								<cfloop query="get_tags">							
								<cfif not listfind(url.tags,get_tags.tagID)>
									<a href="?search_history=1&action=sresults&state=66&project_stage=1&project_stage=2&project_stage=3&project_stage=4&projecttype=1&tags=#get_tags.tagID#"><span class="tags pull-left">#get_tags.tag#</span></a>
								<cfelse>
									<span class="tags pull-left">#get_tags.tag#</span>
								</cfif>
								</cfloop>
							</td>
						</tr>					
					</cfoutput>
				</cfloop> 
			</table>
		</cfform>
	</td>
</tr>


<!--- Quick View Modal --->
<div class="modal fade" tabindex="-1" role="dialog" id="quickview">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h5 class="modal-title qv-title" id="detailLabel"></h5>
			</div>							  
			<div class="modal-body qv-body"></div>
			<div class="modal-footer qv-footer"></div>
		</div>
	</div>
</div>	

<!--- Save Search Modal --->
<div class="modal fade" tabindex="-1" role="dialog" id="savesearch">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h5 class="modal-title" id="detailLabel"> Save this Search</h5>
			</div>							  
			<div class="modal-body">
				<cfinclude template="saved_search_form2.cfm">				
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>	

<!--- Track Lead Modal --->
<cfquery name="getsid" datasource="#application.datasource#">select sid from bid_users where userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"></cfquery>
<CFQUERY NAME="Getfolders" datasource="#application.datasource#">
SELECT distinct  bid_user_project_folders.folderID, bid_user_project_folders.foldername,bid_user_project_folders.privacy_setting
FROM bid_user_project_folders
left outer join bid_user_privacy_log on bid_user_privacy_log.folderid = bid_user_project_folders.folderid
where bid_user_project_folders.active = 1 
and (1 <> 1 
or (bid_user_project_folders.privacy_setting = 1 and bid_user_project_folders.userid in (select userid from bid_users where sid = #getsid.sid#)) 
or (bid_user_project_folders.privacy_setting = 3 and ((bid_user_privacy_log.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#"> and bid_user_privacy_log.userid in (select userid from bid_users where sid in (select sid from bid_users where userid = bid_user_project_folders.userid))) or bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">))
or (bid_user_project_folders.privacy_setting is null and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">)
or (bid_user_project_folders.privacy_setting = 2 and bid_user_project_folders.userid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">))
and bid_user_project_folders.folderID not in (select folderID from pbt_user_folders_deletions where userID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.userid#">)
ORDER BY bid_user_project_folders.foldername
</CFQUERY>  

<div class="modal fade" role="dialog" id="leadsModal">
	<div class="modal-dialog">    
	  <!-- Modal content-->
	  <div class="modal-content">
		<div class="modal-header">
		  <button type="button" class="close" data-dismiss="modal">&times;</button>
		  <h4 class="modal-title">Track this Lead</h4>
		</div>
		<div class="modal-body">
			<form NAME="tracklead" id="tracklead">
				<input type="hidden" value="<cfoutput>#session.auth.userid#</cfoutput>" name="userid" id="userid">
				<input type="hidden" name="bidid" id="bidid" value="">
				<cfif isdefined("type")><input type="hidden" name="type" value="<cfoutput>#type#</cfoutput>"></cfif>
				<table width="100%">
					<tr>
						<td align="center">
							Select a folder in which to save the following projects:<br>		
							<strong>
								BidID: "<span class="js-bidList"></span>"
							</strong>
						</td>
					</tr>
					<tr>
						<td align="center"><br>
							<select name="project_folder">
								<Option value="0" selected>- &nbsp;&nbsp;Select a Folder&nbsp;&nbsp; -</OPTION>
								<cfoutput query="getfolders">
									<option value="#folderid#">#foldername#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="center">
							<input name="savelead" id="savelead" type="button" value="Save" class="btn btn-primary">
							&nbsp;
							<input name="newfolder" id="newfolder" type="button" value="Create New Folder"  style="background-color:#ffc303;" class="btn btn-default">
							<!---&nbsp;<input type="reset" value="Reset" style="background-color:#ffc303;" class="btn btn-default">--->
							<div class="js-message" style="color: red;"></div>
						</td>
					</tr>
				</table>			
			</form>        	        	
		</div>
		<div class="modal-footer">
		  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button><input type="hidden" name="holdhidid" id="holdhidid" value="">
		</div>
	  </div>      
	</div>
</div>

<!--- Print Lead Modal --->
<div class="modal fade" role="dialog" id="printModal">
	<div class="modal-dialog">    
	  <!-- Modal content-->
	  <div class="modal-content">
		<div class="modal-header">
		  <button type="button" class="close" data-dismiss="modal">&times;</button>
		  <h4 class="modal-title">Print Leads</h4>
		</div>
		<div class="modal-body">
			<form NAME="printlead" id="printlead">
				<input type="hidden" value="<cfoutput>#session.auth.userid#</cfoutput>" name="userid" id="useridp">
				<input type="hidden" name="bidids" id="bididp" value="">
				<table width="100%">
					<tr>
						<td align="center">
							Generate a consolidated PDF of the following projects:<br><br>		
							<strong>
								BidID: "<span class="js-bidListp"></span>"
							</strong>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="center">
							<input name="printbtn" id="printbtn" type="button" value="Create" class="btn btn-primary">
							<div class="js-messagep"></div>
						</td>
					</tr>
				</table>			
			</form>        	        	
		</div>
		<div class="modal-footer">
		  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button><input type="hidden" name="holdhidid" id="holdhidid" value="">
		</div>
	  </div>      
	</div>
</div>

<style>
	.topStack{z-index: 1000!important;}
	.tags{    
		border: 1px dotted #949494;
    	border-radius: 10px;
    	padding: 3px;
    	margin: 3px;
	}
	.tags:hover{border: 1px solid #FF0000;}	
</style>

<script>
	
$(function () {
	
	// CACHE THEN DELETE ALL DRILL DOWN ROWS !!
    	$('.main-row').each(function(){
        	var $row = $(this);
        	var $rowmore = $row.next('.tags-row');

        	if($rowmore.length>0){
            	$row.data('cached-row', $rowmore);
        	}
    	});

    	$('.tags-row').remove();

	$('#results_table').dataTable( {
		"columnDefs": [
			{ "orderable": false, "targets": 0 }
		  ],	
		"paging": true,
		"order": [[ 1, 'asc' ]],
		"lengthMenu": [[10, 50, 100, -1], [10, 50, 100, "All"]],
  		"language": {
    			"lengthMenu": "Show _MENU_ records",
			"info": "Showing _START_ to _END_ of _TOTAL_ records"  		
		},
		"colReorder": true,
		"stateSave": true,
		"colReorder": {
				fixedColumnsLeft: 1
		}	
		,
		"initComplete": function( settings, json ) {
			$('.main-row').each(function(){
       				var $line = $(this);
        			if($line.data('cached-row')){
            			$line.data('cached-row').toggle().insertAfter($line);
        			}
			});
			$( ".loadBanner" ).addClass( "hide" );
			$( "#results_table" ).removeClass( "hidden" );
  		}
	} );
	
	$('#results_table').on( 'draw.dt', function () {
    		console.log( 'Redraw occurred at: '+new Date().getTime() );
		$('.main-row').each(function(){
       			var $line = $(this);
        		if($line.data('cached-row')){
            		$line.data('cached-row').toggle().insertAfter($line);
        		}
		});
	});

	$(".bidHandle").hover(function() {
		$(this).css('cursor','pointer').attr('title', 'Drag to add this project to your clipboard');
	});

	$(".selAllTrash").on('click',function(){
		if(this.checked){
			$('.actionbox').each(function(){
				this.checked = true;
			})
		}else{
			$('.actionbox').each(function(){
				this.checked = false;
			})
		}
	});	
	
	// Save Search
	$(".fa-floppy-o").hover(function() {
		$(this).css('cursor','pointer');
	});	
	$(".saveSearch").click(function(){
		$("#savesearch").modal("show");				
	});	
	
	$(".actionSelect").on('change',function(){
		doActionSelect($(this).val());
	})
	
	// ALL TRACK LEAD FUNCTION JS

	$("#newfolder").click(function(e){	
		var userid = $("#userid").val();
		$("#holdhidid").val($("#bidid").val());
		$("#leadsModal").find('.modal-body').load('../../myaccount/folders/includes/new_project_from_lead.cfm?userid=' + userid + '&bidID=');
	});	
		
	$("#savelead").click(function(e){	
		e.preventDefault();	
		$.ajax({
			url: "../search/includes/submitSaveFolder.cfm?val=" + Math.random(),
			type: 'POST',
			data: $("#tracklead").serialize(),
			success: function() {
				$(".js-message").html("<br>Leads Saved to Folder.");
				/*$('input[type=checkbox]:checked').each(function(){
					$(this).attr('checked', false);	
					$(this).attr('disabled', 'disabled');			  		
				});*/					
				setTimeout(function(){ $('#leadsModal').modal('hide');  }, 1500);
			
			},
			error: function() {
				alert('There has been an error, please alert us immediately');
			}		
			/*error: function (request, status, error) {
				alert(request.responseText);
			}*/
		});	

	});	
	
	// Print Leads
	$("#printbtn").click(function(e){	
		e.preventDefault();	
		$("#printbtn").attr('disabled', 'disabled');
		$("#printbtn").val("Processing");	
		$.ajax({
			url: "../leads/includes/print_lead_multiple_spending.cfm?val=" + Math.random(),
			type: 'POST',
			dataType: "json",
			data: $("#printlead").serialize(),
			success: function(result) {
				if (result.valid)
				{
					$("#printbtn").addClass( "hidden" );
					$(".js-messagep").html('<a href="../leads/pdf_files/leads_<cfoutput>#session.auth.userid#</cfoutput>.pdf" class="btn btn-success" type="button" target="_blank">PDF READY TO VIEW/PRINT</a>');
				}
				else
				{		
					alert('There has been an error, please alert us immediately.\nPlease provide details of what you were working on when you\nreceived this error.');
				}
				$("#printbtn").removeAttr("disabled"); 
				$("#printbtn").val("Create");					
			},
			/*error: function (request, status, error) {
			alert(request.responseText);
			}*/
			error: function() {
				$("#printbtn").removeAttr("disabled"); 
				$("#printbtn").val("Create");						
				alert('There has been an error, please alert us immediately.\nPlease provide details of what you were working on when you\nreceived this error.');
			}
		});	

	});		
	
});		
	
	
var doActionSelect = function(_x){
	switch(_x){
		case '_1': $('.actionbox').each(function(){this.checked = true;	});				
			break;
		case '_2': $('.actionbox').each(function(){this.checked = false;	});
			break;
		case '_3':	var bids = "";				
					$('input[type=checkbox]:checked').each(function(){
				  		bids = bids + $(this).val() + ", ";				  		
					});
					if(bids.length > 0){
						bids = bids.slice(0, -2);
						$("#bidid").val(bids);
						$(".js-bidList").html(bids);
						$(".js-message").html("");
						$("#leadsModal").modal("show");
					}
					else{
						alert("Select one or more leads to track");
					}
			break;
		case '_4':;	var bids = "";				
					$('input[type=checkbox]:checked').each(function(index){
				  		bids = bids + $(this).val() + ", ";				  		
					});
					if(bids.length > 0){
						bids = bids.slice(0, -2);
						if(confirm("Are you sure you want to remove the selected leads?" )){
							$.ajax({
								url: "../search/includes/trash_inc.cfm?val=" + Math.random(),
								type: 'POST',
								data: {"trash": bids},
								success: function() {
									alert("Leads Removed\nReloading Results");
									location.reload(true); 
								},
								error: function() {
									alert('There has been an error, please alert us immediately');
								}		
								/*error: function (request, status, error) {
									alert(request.responseText);
								}*/
							});							
						}						
					}
					else{
						alert("Select one or more leads to remove");
					}
			
			break;
		case '_5':	var bids = "";
					var count = 0;
					$('input[type=checkbox]:checked').each(function(){
				  		bids = bids + $(this).val() + ", ";	
						count++;
					});
					if(count > 0){
						if(count <= 10){
							bids = bids.slice(0, -2);
							$("#bididp").val(bids);
							$(".js-bidListp").html(bids);
							$(".js-messagep").html("");
							$("#printbtn").removeClass( "hidden" );
							$("#printModal").modal("show");
						}
						else{
							alert("Select up to 10 leads maximum to print");
						}
					}
					else{
						alert("Select one or more leads to print");
					}
			break;			
			
	}
	$(".actionSelect")[0].selectedIndex = 0;
}	
</script>
<style>
	.actionSelect{font-size: .75em;}
</style>	
