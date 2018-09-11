<cfswitch expression="#url.action#">
	<cfcase value="insert">
		<cfquery datasource="#application.dataSource#" name="q12">
		SELECT *
		FROM pbt_project_clipboard
		where bidID = #url.bid# 
			and userID = #session.auth.userid#
		</cfquery>
		<cfif q12.recordcount eq 0>	
			<cfquery datasource="#application.dataSource#" name="q12">
			insert into pbt_project_clipboard
			(bidID, userID, projectName)
			values
			(#url.bid#, #session.auth.userid#, '#url.name#')
			</cfquery>
		</cfif>
		
	</cfcase>
	<cfcase value="getCount">
		<cfquery datasource="#application.dataSource#" name="q12">
		SELECT *
		FROM pbt_project_clipboard
		where userID = #session.auth.userid#
		</cfquery>
			<cfoutput>#q12.recordcount#</cfoutput>
	</cfcase>
	<cfcase value="remove">
		<cfquery datasource="#application.dataSource#" name="q12">
		delete
		FROM pbt_project_clipboard
		where bidID = #url.bid# 
			and userID = #session.auth.userid#
		</cfquery>
		
	</cfcase>
	<cfcase value="get">
		<cfquery datasource="#application.dataSource#" name="clipboard">
		SELECT *
		FROM pbt_project_clipboard
		where userID = #session.auth.userid#
		</cfquery>
		<ul>
			<li class="row">							
													
				<span class="desc col-sm-2" style="opacity: 1;"> ID</span>
				<span class="desc col-sm-6" style="opacity: 1; text-decoration: none;"> Name</span>
				<span class="col-sm-1" style="opacity: 1;"></span>
				<span class="col-sm-1" style="opacity: 1;"></span>
				<span class="col-sm-1" style="opacity: 1;"></span>
				<!--span class="col-sm-2" style="opacity: 1;">
					<a href="javascript:void(0);" onClick="delAll();"><i class="fa fa-trash-o fa-lg" aria-hidden="true"></i></a>
					<input type="checkbox" class="selAllTrash" />
				</span-->
			</li>
		  <cfoutput query="clipboard">
			<li class="row">												
				<span class="desc col-sm-2" style="opacity: 1; text-decoration: underline; cursor: pointer;" onClick="location='/leads/?bidid=#bidID#'"> #bidID#</span>
				<span class="desc col-sm-6" style="opacity: 1; text-decoration: none;font-size: 12px; font-size-adjust: auto;">#left(projectName, 40)#<cfif len(projectName) gt 40>...</cfif></span>
				<span class="label label-danger col-sm-1" style="opacity: 1; cursor: pointer;" onClick="sendProject(#bidID#)"> <i class="fa fa-envelope" aria-hidden="true"></i></span>
				<span class="label label-danger col-sm-1" style="opacity: 1; cursor: pointer;" onClick="folderProject(#bidID#)"> <i class="fa fa-folder-open" aria-hidden="true"></i></span>
				<span class="label label-danger col-sm-1" style="opacity: 1; cursor: pointer;" onClick="delProject(#bidID#, true)"> <i class="fa fa-trash" aria-hidden="true"></i></span>
				<!--span class="desc col-sm-2" style="opacity: 1; text-decoration: underline; cursor: pointer; pull-right;" > <input type="checkbox" class="cliptrashBox" name="folderDel" value="#bidID#" /></span-->
			</li> 
			</cfoutput>
		</ul>	
	</cfcase>
</cfswitch>
	<!--- messgae box Modal --->
<div class="modal fade" tabindex="-1" role="dialog" id="clipModalPopup">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h5 class="modal-title detailLabel"></h5>
			</div>							  
			<div class="modal-body"></div>
			<div class="modal-footer"></div>
		</div>
	</div>
</div>	
	
		<style>
		.navbar-tools .dropdown-menu {
			max-width: 600px!important;
			}
			.navbar-tools .drop-down-wrapper {
				width: 600px!important;
				overflow-y:auto!important;
			}
			.todo li .label {
				position: inherit!important;	
			}
			.navbar-tools .drop-down-wrapper li a {
			    padding: 0px!important;
    			display: initial!important;
			}
			span 
			.label {margin-left:1px!important;}
		</style>
		<script>					
			$(".selAllTrash").on('click',function(){
				if(this.checked){
					$('.cliptrashBox').each(function(){
						this.checked = true;
					})
				}else{
					$('.cliptrashBox').each(function(){
						this.checked = false;
					})
				}
			});
		</script>
