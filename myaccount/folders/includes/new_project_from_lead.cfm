<CFSET DATE = #CREATEODBCDATETIME(NOW())#>

<script>
	$(function () {	
		<cfif isDefined("url.clip")>
			if ($("#holdhididClip").length ) {
				 $("#bidid").val($("#holdhididClip").val());
			}				
		<cfelse>
			if ($("#holdhidid").length ) {
				 $("#bidid").val($("#holdhidid").val());
			}	
		</cfif>
		$("#newProjectFolder").submit(function(e){	

			e.preventDefault();	
			if($("#foldername").val() == ""){
				alert("Folder Name is Required");			
			}
			else{		
				$.ajax({
					url: "../../myaccount/folders/includes/new_project_process.cfm?val=" + Math.random(),
					type: 'POST',
					data: $("#newProjectFolder").serialize(),
					success: function() {
						$(".modal-body").html("Folder Created - Bids Saved.<br>Reloading Page....");
						setTimeout(function(){ location.reload(true);  }, 1500); /*$('#leadsModal').modal('hide');*/
					},
					error: function() {
						alert('There has been an error, please alert us immediately');
					}		
					/*error: function (request, status, error) {
						alert(request.responseText);
					}*/

				});	
			}

		});	  
	}); 
</script>

<cfquery name="getusers" datasource="#application.datasource#">
	select distinct reg_users.name,bid_users.userid
	from reg_users 
	inner join bid_users on bid_users.reguserid = reg_users.reg_userid
	left outer join bid_subscription_log on bid_subscription_log.userid = bid_users.userid 
	where bid_users.sid in (select sid from bid_users where userid = #userid# and bt_status = 1) and bid_subscription_log.effective_date <= #date# and bid_subscription_log.expiration_date > #date# and bid_subscription_log.active = 1
	and bid_users.bt_status = 1
	order by reg_users.name
</cfquery>
<cfform name="newProjectFolder" id="newProjectFolder">
	<cfoutput>
	<cfif isdefined("awd")><input type="hidden" name="awardid" value="1"></cfif>
	<cfif isdefined("bidid")><input type="hidden" name="bidid" id="bidid" value="#bidid#"></cfif>
	<cfif isdefined("ref") and ref is 2><input type="hidden" name="ref" value="2"></cfif>
	<input type="hidden" name="userid" value="#userid#">
	<input type="hidden" name="process" value="21">
	<input type="hidden" name="siteid" value="#session.auth.siteID#">
	</cfoutput>
	<table width="100%" border=0>
		<tr>
			<td><strong>Create a New Folder</strong><br><br></td>
		</tr>
		<tr>
			<td><strong>Folder Name:</strong></td>
		</tr>
		<tr>
			<td><input type="Text" name="foldername" id="foldername" size="30"></td>
		</tr>
		<tr>
			<td><strong>Folder Description:</strong></td>
		</tr>
		<tr>
			<td><textarea cols="30" rows="5" name="description"></textarea></td>
		</tr>
		<tr>
			<td><br><strong>Security Settings:</strong></td></tr>
		<tr>
			<td>Select the security settings for this folder:</td>
		</tr>
		<tr>
			<td><cfinput type="radio" name="share" value="2" checked="Yes"> I would like this folder to be private.</td>
		</tr>
		<tr>
			<td><cfinput type="radio" name="share" value="1" > I would like all users on our account to have access to this folder.</td>
		</tr>
		<tr>
			<td><cfinput type="radio" name="share" value="3" > I would like the following users on our account to have access to this folder.</td>
		</tr>
		<tr> 
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfselect name="specific_users" query="getusers" value="userid" display="name" multiple size="5"></cfselect></td>
		</tr>
		<tr>
			<td><br><input type="submit" name="submit" value="Save" class="btn btn-primary"></td><!---style="background-color:#ffc303;"--->
		</tr>
	</table>
</cfform>
