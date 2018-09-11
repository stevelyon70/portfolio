<CFSET todaydate = #CREATEODBCDATETIME(NOW())#>
<cfset user_trash.recordcount = 0>
<cfparam default="1" name="session.history" />
<!---include the returned results--->
<cfinclude template="search_results2.cfm">
<!---pull bids that are saved for form--->
<cfquery name="pull_saved_projects" datasource="#application.datasource#">
	select bidID 
	from bid_user_project_bids
	where userID = #session.auth.userID# and active = 1
</cfquery>
<CFPARAM NAME="mystartrow" DEFAULT="1">
<CFPARAM NAME="realstartrow" DEFAULT="1">
<cfset RowsPerPage = 20>
<cfparam name="URL.StartRow" Default="1" Type="Numeric">
<cfparam name="URL.ShowAll" Type="boolean" Default="no">
<cfset totalrows = total_results.total_returned>
<CFIF URL.ShowAll>
	<cfset Rowsperpage = TotalRows>
</cfif>
<cfif not isdefined("endrow")>
<cfset EndRow  = Min(URL.StartRow + RowsPerPage - 1, TotalRows)>
</cfif>
<cfif totalrows LT 20>
<cfset EndRow = totalrows>
</cfif>
<cfset StartRowNext = EndRow + 1>
<cfset StartRowBack = URL.StartRow - RowsPerPage>	

<!--- **************     ***********--->

<div class="page-header">
	<h3>Search Paint BidTracker <small> results</small></h3>
</div>		
<div class="row">
	<cfinclude template="search_results_criteria_inc.cfm">
</div> 
<div class="row">
	<div class="text-right col-sm-12">
		
	</div>	
</div> 
<div class="row">
	<div class="col-sm-12">
		<div id="searchText">Search Results [<strong>Showing Records<cfoutput> #startrow# of #endrow#</cfoutput>:</strong>
						<cfif not url.showall><cfinclude template="nextninclude_pagelinks.cfm"> </cfif><cfif search_results.recordcount is not 0><cfif not url.showall><cfoutput> | <a href="?ShowAll=Yes&userid=#userid#&tempHRef=#tempHRef#">Show All</a></cfoutput></cfif></cfif>]</div>
		<!---div id="sortBy" class="sortBy" align="right">
			<cfinclude template="sort_inc.cfm">
		</div--->
	</div>
</div>
<div class="row">
	<cfinclude template="search_results_grid_inc_drag.cfm">
</div>
<!--- **************     ***********--->
 

<cfif search_results.recordcount GT 0>
<cfinclude template="search_params.cfm">
 </cfif>
 


<script>
		var data = {"total":0,"rows":[]};
		var totalCost = 0;
		
		$(function(){
			$('#clipboardcontent').datagrid({
				singleSelect:true
			});
			$('.projectBid').draggable({
				revert:true,
				proxy:'clone',
				onStartDrag:function(){
					$(this).draggable('options').cursor = 'not-allowed';
					$(this).draggable('proxy').css('z-index',10);
					$('.clipboard').toggleClass('activeClip');
				},
				onStopDrag:function(){
					$(this).draggable('options').cursor='move';
					$('.clipboard').toggleClass('activeClip');
				}
			});
			$('.clipboard').droppable({
				onDragEnter:function(e,source){
					$(source).draggable('options').cursor='auto';
				},
				onDragLeave:function(e,source){
					$(source).draggable('options').cursor='not-allowed';
				},
				onDrop:function(e,source){					
					var bid = $(source).find('div:eq(0)').html();
					var name = $(source).find('div:eq(1)').html();
					//send this bid to the page to process and ad to clipboard
		//			then refresh the page and send back and load to DOMParser
					addProject(bid,name);
				}
			});
		});
		
		function addProject(_bid,_name){
			
			function add(){
				
				data.total += 1;
				data.rows.push({
					name:_name,
					bid:_bid
				});
				
			}
			add();
			//totalCost += price;
			$('#clipboardcontent').datagrid('loadData', data);
			//$('div.clipboard .total').html('Total: $'+totalCost);
		}
	</script>