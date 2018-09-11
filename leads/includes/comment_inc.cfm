
<script>

$("#RFPManagement").submit(function(e){	
	e.preventDefault();	

	$.ajax({
		url: "includes/comment_save_inc.cfm?val=" + Math.random(),
		type: 'POST',
		data: $("#RFPManagement").serialize(),
		success: function() {
			alert("Comment Saved.\nReloading Page.");
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
            
<table width="100%">
	<tr>
		<td align="center">
			<form name="RFPManagement" id="RFPManagement">
			<cfoutput>
			<input type="hidden" value="#userid#" name="userid">
			<input type="hidden" value="#bidid#" name="bidid">
			<input type="hidden" name="projectid" value="#projectid#">
			<input type="hidden" name="process" value="3">
			</cfoutput>
			<textarea cols="40" rows="5" name="comments"></textarea><br>&nbsp;
			<input type="submit" value="Submit" style="background-color:#ffc303;" class="btn btn-default"/>
			</form>
		</td>
	</tr>
</table>