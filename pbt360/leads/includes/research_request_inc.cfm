	<cfquery name="getname" datasource="#application.datasource#">
		select name,emailaddress,companyname,phonenumber
		from reg_users 
		inner join bid_users on bid_users.reguserID = reg_users.reg_userID
		where bid_users.userID = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">
	</cfquery>

	<script>

	$("#requestInfo").submit(function(e){	
		e.preventDefault();	
		if($("#phone").val() == ""){
			alert("Phone Number is Required");			
		}
		else{

			$.ajax({
				url: "includes/research_process_inc.cfm?val=" + Math.random(),
				type: 'POST',
				data: $("#requestInfo").serialize(),
				success: function() {
					alert("Request Email Succesfully Sent.");
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

	</script>



	<p>
	Submit this form and a member of the Paint BidTracker team will call you within 1 business day.
	</p>

	<form name="requestInfo" id="requestInfo">
		<cfoutput>

		<table border="0" width="100%">
			<tr>
				<td width="20%">
					Your Name*:
				</td>
				<td>
					<input type="text" name="emailname" value="#getname.name#" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td  width="20%">  
					Email Address*:
				</td>
				<td>
					<input type="text" name="email" id="email" size="40" value="#getname.emailaddress#" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<hr>
				</td>
			</tr>
			<tr>
				<td width="20%">
					Company*:
				</td>
				<td>
					<input type="text" name="company" id="company"  value="#getname.companyname#" readonly="readonly" />
				</td>
			</tr>
			<tr>
				<td width="20%">
					Phone*:
				</td>
				<td>
					<input type="text" name="phone" id="phone" value="#getname.phonenumber#" />
				</td>
			</tr>
			<tr>
				<td width="20%">
					Message:
				</td>
				<td>
					<textarea cols="40" rows="3" name="comments"></textarea>
				</td>
			</tr>		
			<tr>
				<td>
					<br><input type="submit" value="Submit" style="background-color:##ffc303;" class="btn btn-default" />
				</td>
			</tr>
		</table>
		<input type="hidden" name="bidID" value="#bidID#">
		<input type="hidden" name="userID" value="#userID#">		
		
		</cfoutput>
	</form>
