<!---<cfquery name="getname" datasource="#application.datasource#">
	select name,emailaddress
	from reg_users 
	inner join bid_users on bid_users.reguserID = reg_users.reg_userID
	where bid_users.userID = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>--->

<p>Email this document (PDF) to a colleague along with your comments</p>

<form NAME="emaillead" id="emaillead"  METHOD="post" >
	<cfoutput>

	<table border="0" width="100%">

	<tr>
		<td width="20%">
			Recipient Name:
		</td>
		<td>
			<input size="40" type="text" name="toname" id="toname"/>
		</td>
	</tr>
	<tr>
		<td width="20%">
			Subject:
		</td>
		<td>
			<input size="40" type="text" name="tosubject" id="tosubject" value="" />
		</td>
	</tr>
	<tr>
		<td width="20%">
			Recipient Email*:
		</td>
		<td>
			<input size="40" type="text" name="toemail" id="toemail"/>
		</td>
	</tr>
	<tr>
		<td width="20%">
			Message:
		</td>
		<td>		
			<textarea cols="40" rows="2" name="comments"></textarea>
		</td>
	</tr>
	<tr>
		<td colspan="2">
		<input type="submit" value="Send" style="background-color:##ffc303;"  class="btn btn-default"/>&nbsp;<input type="reset" value="Reset" style="background-color:##ffc303;"  class="btn btn-default">
		</td>
	</tr>
	</table>
	<input type="hidden" name="bidID" value="#bidID#">
	<input type="hidden" name="userID" value="#userID#">		
	</cfoutput>
</form>

<script>
$(function () {	  
	$("#emaillead").submit(function(e){	
		e.preventDefault();	
		if($("#toemail").val() == ""){
			alert("Recipient Email is Required");			
		}
		else{

			$.ajax({
				url: "includes/email_sentto_process_inc.cfm?val=" + Math.random(),
				type: 'POST',
				data: $("#emaillead").serialize(),
				success: function() {
					alert("Email Succesfully Sent.");
					$("#leadsModal").modal('hide');
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