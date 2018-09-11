<cfinclude template="../template_inc/design/wrapper_top.cfm">
				<!---<cfif cgi.query_string NEQ ''>
				<div class="row">
					<div class="col-sm-3"></div>
					<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/#contact" >sales rep</a> directly.
					</div>
					<div class="col-sm-3"></div>
				</div>
				</cfif>--->
				<div class="row">
					<div class="col-sm-3"></div>
				<!-- start: LOGIN BOX -->
				<div class="box-login2 col-sm-6">
					<h3>Sign in to your account</h3>
					<p>
						Please enter your username and password to log in.
					</p>
					<cfoutput>
					<form class="form-login" method="post" action="" enctype="multipart/form-data">
						<div class="errorHandler alert alert-danger no-display">
							<i class="fa fa-remove-sign"></i> You have some form errors. Please check below.
						</div>
						<cfif isdefined("error")>
							<div class="alert alert-danger" id="allErrors" >The user name and password entered do not match any existing user.</div>
						</cfif>
						<fieldset>
							<div class="form-group">
								<span class="input-icon">
									<input type="text" class="form-control" name="loginUsername" placeholder="Username">
									<i class="fa fa-user"></i> </span>
							</div>
							<div class="form-group form-actions">
								<span class="input-icon">
									<input type="password" class="form-control password" name="loginPassword" placeholder="Password">
									<i class="fa fa-lock"></i>
									<a class="forgot" href="http://app.paintbidtracker.com/register/?fuseaction=forgotpassword">
										I forgot my password
									</a> 
									 </span>
							</div>
							<div class="form-actions">
								<button type="submit" class="btn btn-blue">
									Login <i class="fa fa-arrow-circle-right"></i>
								</button>
								<p>
									<br>By proceeding, I agree to the Paint BidTracker <a href="/dmz/?action=terms">Terms of Usage</a> and <a href="/dmz/?action=privacy">Privacy Policy</a>. 
								</p>
							</div>
							<div class="new-account">
								Don't have an account yet?
								<a href="http://www.paintbidtracker.com" class="register">
									Learn more</a> or try Paint BidTracker for <a href="http://www.paintbidtracker.com/free-trial/">free</a>.
								
							</div>
						</fieldset>
					</form></cfoutput>
				</div>
				<div class="col-sm-3"></div>
				</div>
			</div>
		</div>
		</div>
		</div>
		<cfinclude template="../template_inc/footer_inc.cfm">
		<cfinclude template="../template_inc/feedback.cfm">		
		<cfinclude template="../template_inc/script_inc.cfm">
		<script>
			jQuery(document).ready(function() {
				try{Main.init();}catch(r){console.log(r);}
				try{Login.init();}catch(r){console.log(r);}
			});
			function runPage(){	
			}
		</script>
<cfinclude template="../template_inc/design/wrapper_bot.cfm">