
<cfif isdefined("form.NEW")>
<cflocation url="../../myaccount/folders/?action=60&userid=#session.auth.userid#&bidid=#form.bidid#" addtoken="No">
<!---<cflocation url="../projectsearch/includes/new_folder_create.cfm?bidid=#form.bidid#" addtoken="No">--->
</cfif>

<cfif projects EQ "">
	<!---TO DO Add prompt to error if no project selected--->
	<cfabort>
</cfif>
<cfset bidID = projects>
<cfquery  name="getsid" datasource="#application.datasource#">select sid from bid_users where userid = <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"></cfquery>
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

	
<!---TODO FIGURE OUT THE CFPARAM GLITCH FOR VALUELIST--->
<CFQUERY NAME="Getbids" datasource="#application.datasource#">
select projectname,bidID from pbt_project_master where bidid in (#bidid#) 
</CFQUERY>

<html>
<head>
	<title>Track Project</title>
</head>

<body>
<cfif isdefined("ref") and ref is 2>
	<cfset rootref = "../../search/">
<cfelse>
	<cfset rootref = "">
</cfif>
<cfset _n = "newfolder#timeformat(now(),'mmss')#" />
<cfset _s = "savelead#timeformat(now(),'mmss')#" />
<script>
	  
	$("#<cfoutput>#_n#</cfoutput>").click(function(e){
		$(".modal-body").load('../../myaccount/folders/includes/new_project_from_lead.cfm?userid=' + <cfoutput>#session.auth.userid#</cfoutput> + '&bidID=' + <cfoutput>#bidID#</cfoutput>);
	});	
	
	$("#<cfoutput>#_s#</cfoutput>").click(function(e){	
		e.preventDefault();	
					
		$.ajax({
			url: "<cfoutput>#rootref#</cfoutput>includes/submitSaveFolder.cfm?val=" + Math.random(),
			type: 'POST',
			data: $("#RFPManagement").serialize(),
			success: function() {
				alert("Saved to Folder.\nReloading Page.");
				//$("#leadsModal").modal('hide');
				location.reload(true);
			},
			error: function() {
				alert('There has been an error, please alert us immediately');
			}		
			/*error: function (request, status, error) {
				alert(request.responseText);
			}*/

		});	
		
	});	  
	 
</script>


<FORM NAME="RFPManagement" id="RFPManagement">
		
	<input type="hidden" value="<cfoutput>#session.auth.userid#</cfoutput>" name="userid">
	<cfif isdefined("bidID")><input type="hidden" name="bidid" value="<cfoutput>#bidid#</cfoutput>"></cfif>
	<cfif isdefined("type")><input type="hidden" name="type" value="<cfoutput>#type#</cfoutput>"></cfif>
	<table width="100%">
		<tr>
			<td align="center">
				Select a folder in which to save the following projects:<br>		
				<strong>
				BidID: 
				<cfloop query="Getbids">
					<cfoutput>"#getbids.bidID#"<cfif currentrow lt recordcount>,</cfif></cfoutput>
				</cfloop>
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
				<input name="savelead" id="<cfoutput>#_s#</cfoutput>" type="button" value="Save" style="background-color:#ffc303;" class="btn btn-default">
				&nbsp;
				<input name="newfolder" id="<cfoutput>#_n#</cfoutput>" type="button" value="Create New Folder"  style="background-color:#ffc303;" class="btn btn-default">
				<!---&nbsp;<input type="reset" value="Reset" style="background-color:#ffc303;" class="btn btn-default">--->
			</td>
		</tr>
	</table>			
	
</form>
	

		
</body>
</html>


