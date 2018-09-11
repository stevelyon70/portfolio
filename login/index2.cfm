<!DOCTYPE html>

<cfoutput>
<html lang="en" class="no-js">
    	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    	<title>ConTrak by Paint BidTracker: Market Analytics and Business Intelligence for the Painting Industry</title>
    		<!-- start: MAIN CSS -->
		<link rel="stylesheet" href="#application.rootpath#assets/plugins/bootstrap/css/bootstrap.min.css">
		<link rel="stylesheet" href="#application.rootpath#assets/plugins/font-awesome/css/font-awesome.min.css">
		<link rel="stylesheet" href="#application.rootpath#assets/fonts/style.css">
		<link rel="stylesheet" href="#application.rootpath#assets/css/main.css">
		<link rel="stylesheet" href="#application.rootpath#assets/css/main-responsive.css">
		<link rel="stylesheet" href="#application.rootpath#assets/plugins/iCheck/skins/all.css">
		<link rel="stylesheet" href="#application.rootpath#assets/plugins/bootstrap-colorpalette/css/bootstrap-colorpalette.css">
		<link rel="stylesheet" href="#application.rootpath#assets/plugins/perfect-scrollbar/src/perfect-scrollbar.css">
		<link rel="stylesheet" href="#application.rootpath#assets/css/theme_light.css" type="text/css" id="skin_color">
		<link rel="stylesheet" href="#application.rootpath#assets/css/print.css" type="text/css" media="print"/>
		<!--[if IE 7]>
		<link rel="stylesheet" href="assets/plugins/font-awesome/css/font-awesome-ie7.min.css">
		<![endif]-->
		<!-- end: MAIN CSS -->
		<!-- start: CSS REQUIRED FOR THIS PAGE ONLY -->
		<!-- end: CSS REQUIRED FOR THIS PAGE ONLY -->
</head>
</cfoutput>
<!-- start: BODY -->
	<body class="login example2">
		<div class="main-login col-sm-4 col-sm-offset-4">
			<div class="logo">ConTrak
			</div>
			<!-- start: LOGIN BOX -->
			<div class="box-login">
				<h3>Sign in to your account</h3>
				<p>
					Please enter your name and password to log in.
				</p>
				<form class="form-login" action="">
				
					<div class="errorHandler alert alert-danger no-display">
						<i class="fa fa-remove-sign"></i> You have some form errors. Please check below.
					</div>
					
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
								<!---a class="forgot" href="#">
									I forgot my password
								</a---> </span>
						</div>
						<div class="form-actions">
							<!---label for="remember" class="checkbox-inline">
								<input type="checkbox" class="grey remember" id="remember" name="remember">
								Keep me signed in
							</label--->
							<button type="submit" class="btn btn-bricky pull-right">
								Login <i class="fa fa-arrow-circle-right"></i>
							</button>
						</div>
						<!---div class="new-account">
							Don't have an account yet?
							<a href="#" class="register">
								Create an account
							</a>
						</div--->
					</fieldset>
				</form>
			</div>
			<!-- end: LOGIN BOX -->
			<!--- start: FORGOT BOX -->
			<div class="box-forgot">
				<h3>Forget Password?</h3>
				<p>
					Enter your e-mail address below to reset your password.
				</p>
				<form class="form-forgot">
					<div class="errorHandler alert alert-danger no-display">
						<i class="fa fa-remove-sign"></i> You have some form errors. Please check below.
					</div>
					<fieldset>
						<div class="form-group">
							<span class="input-icon">
								<input type="email" class="form-control" name="email" placeholder="Email">
								<i class="fa fa-envelope"></i> </span>
						</div>
						<div class="form-actions">
							<a class="btn btn-light-grey go-back">
								<i class="fa fa-circle-arrow-left"></i> Back
							</a>
							<button type="submit" class="btn btn-bricky pull-right">
								Submit <i class="fa fa-arrow-circle-right"></i>
							</button>
						</div>
					</fieldset>
				</form>
			</div>
			<!-- end: FORGOT BOX --->
			
			<!-- start: COPYRIGHT -->
			<div class="copyright">
				2014 &copy; ConTrak by Paint BidTracker
			</div>
			<!-- end: COPYRIGHT -->
		</div>
		<!-- start: MAIN JAVASCRIPTS -->
		<!--[if lt IE 9]>
		<script src="assets/plugins/respond.min.js"></script>
		<script src="assets/plugins/excanvas.min.js"></script>
		<script type="text/javascript" src="assets/plugins/jQuery-lib/1.10.2/jquery.min.js"></script>
		<![endif]-->
		<!--[if gte IE 9]><!-->
		<script src="#Application.rootpath#assets/plugins/jQuery-lib/2.0.3/jquery.min.js"></script>
		<!--<![endif]-->
		<script src="#Application.rootpath#assets/plugins/jquery-ui/jquery-ui-1.10.2.custom.min.js"></script>
		<script src="#Application.rootpath#assets/plugins/bootstrap/js/bootstrap.min.js"></script>
		<script src="#Application.rootpath#assets/plugins/bootstrap-hover-dropdown/bootstrap-hover-dropdown.min.js"></script>
		<script src="#Application.rootpath#assets/plugins/blockUI/jquery.blockUI.js"></script>
		<script src="#Application.rootpath#assets/plugins/iCheck/jquery.icheck.min.js"></script>
		<script src="#Application.rootpath#assets/plugins/perfect-scrollbar/src/jquery.mousewheel.js"></script>
		<script src="#Application.rootpath#assets/plugins/perfect-scrollbar/src/perfect-scrollbar.js"></script>
		<script src="#Application.rootpath#assets/plugins/less/less-1.5.0.min.js"></script>
		<script src="#Application.rootpath#assets/plugins/jquery-cookie/jquery.cookie.js"></script>
		<script src="#Application.rootpath#assets/plugins/bootstrap-colorpalette/js/bootstrap-colorpalette.js"></script>
		<script src="#Application.rootpath#assets/js/main.js"></script>
		<!-- end: MAIN JAVASCRIPTS -->
		<!-- start: JAVASCRIPTS REQUIRED FOR THIS PAGE ONLY -->
		<script src="#Application.rootpath#assets/plugins/jquery-validation/dist/jquery.validate.min.js"></script>
		<script src="#Application.rootpath#assets/js/login.js"></script>
		<!-- end: JAVASCRIPTS REQUIRED FOR THIS PAGE ONLY -->
		<script>
			jQuery(document).ready(function() {
				Main.init();
				Login.init();
			});
		</script>
	</body>
	<!-- end: BODY -->

</html>
