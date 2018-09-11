<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<div class="row">
	
<!-- start: LOGIN BOX -->
<div class="box-loginx col-sm-6">
	<h3>Forgot Password</h3>

	<div class="getpass">
		<form action="" method="POST" id="fgtpass">
			<table border="0" cellpadding="0" cellspacing="0" width="90%">					
				<tr>
					<td width="100%"><font face="Arial" size="2"><b>Password Reminder</b></font>
						<p><font face="Arial" size="2">Please enter your e-mail address, and the password for that account will be sent immediately.
						<br><br>
						<input type="Text" name="emailaddress" id="emailaddress" size="40"></font>
					</td>		
				</tr>
				<tr>
					<td>
						<input type="submit" name="submit" value="Get Password" id="submitfrm" class="btn btn-blue">
						<span class="hidden">PROCESSING... <img src="../assets/images/spinner.svg" id="spin"> </span>

					</td>
				</tr>			
			</table>
		</form>
	</div>
	<div class="passedpass hidden">
		<table border="0" cellpadding="0" cellspacing="0" width="90%">
			<tr>
				<td width="100%">
					<font face="Arial" size="2"><b>Password Has Been Sent</b></font>
					<p>
						<font face="Arial" size="2">
							The password you selected has been sent
							to the e-mail address for your account.&nbsp; Please check your messages
							to retrieve your password.&nbsp; if you have difficulty receiving the
							e-mail, please call 1-800-837-8303 or 1-412-431-8300.<br><br>				
							<a href="../?defaultdashboard">Return to login</a>
						</font>
					</p>
				</td>
			</tr>
		</table>	
	</div>	
	<div class="failedpass hidden">
		<table border="0" cellpadding="0" cellspacing="0" width="90%">
			<tr>
				<td><br>
					<p style="color: red;">You have requested the password for an e-mail address that is not in our system.<br>
						Please verify you have entered a valid e-mail address format.<br>
						Please enter a registered e-mail address or <a href="http://www.paintbidtracker.com/free-trial/">sign up</a>
						for your free account.
					</p>
				</td>
			</tr>
		</table>	
	</div>
</div>
<script>
	$(function () {
		$("#fgtpass").submit(function(e){
			e.preventDefault();
			if(!$("#emailaddress").val()){
				alert('Please enter a valid email address');
			}
			else{
				$('.failedpass').addClass('hidden');
				$('.passedpass').addClass('hidden');	
				$('#submitfrm').removeClass('btn-blue').toggleClass('btn-warning').prop('disabled', true).text('Processing');
				$.ajax({
					url: "includes/forgot_password_confirm_inc.cfm?val=" + Math.random(),
					type: 'POST',
					dataType: "json",
					data: $("#fgtpass").serialize(),
					success: function(result) {
						// ... Process the result ...
						if (result.valid)
						{	
							$('.getpass').addClass('hidden');
							$('.passedpass').removeClass('hidden');												
						}
						else
						{		
							$('#submitfrm').addClass('btn-blue').toggleClass('btn-warning').prop('disabled', false).text('Submit');
							$('.failedpass').removeClass('hidden');	
							$('#spin').addClass('hidden');
						}
					},

					error: function() {
						$('#spin').addClass('hidden');
						$('#submitfrm').addClass('btn-blue').toggleClass('btn-warning').prop('disabled', false).text('Submit');						
						alert('There has been an error, please alert us immediately.\nPlease provide details of what you were working on when you\nreceived this error.');

					}					
					/*error: function (request, status, error) {
						alert(request.responseText);
					}*/

				});	
			}
		});
	});			 
</script>