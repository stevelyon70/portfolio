<!DOCTYPE html>
<!-- Template Name: Responsive Admin Template build with Twitter Bootstrap 3.x Version: 1.3 Author: DS -->
<!--[if IE 8]><html class="ie8 no-js" lang="en"><![endif]-->
<!--[if IE 9]><html class="ie9 no-js" lang="en"><![endif]-->
<!--[if !IE]><!-->
<html lang="en" class="no-js">
	<!--<![endif]-->
	<!-- start: HEAD -->
	<head>
		<title>ConTrak by Paint BidTracker: Market Analytics and Business Intelligence for the Painting Industry</title>
		<!-- start: META -->
		<meta charset="utf-8" />
		<!--[if IE]><meta http-equiv='X-UA-Compatible' content="IE=edge,IE=9,IE=8,chrome=1" /><![endif]-->
		<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		<meta content="" name="description" />
		<meta content="" name="author" />
		<!-- end: META -->
		<!-- start: MAIN CSS -->
		<cfoutput>
		
		<link rel="stylesheet" href="#Application.rootpath#assets/plugins/bootstrap/css/bootstrap.min.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/plugins/font-awesome/css/font-awesome.min.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/fonts/style.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/css/main.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/css/main-responsive.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/plugins/iCheck/skins/all.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/plugins/bootstrap-colorpalette/css/bootstrap-colorpalette.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/plugins/perfect-scrollbar/src/perfect-scrollbar.css">
		<!---link rel="stylesheet" href="#Application.rootpath#assets/css/theme_light.css" id="skin_color">
		<link rel="stylesheet" href="#Application.rootpath#assets/css/theme_black_and_white.css" type="text/css" id="skin_color"--->
		<link rel="stylesheet" href="#Application.rootpath#assets/less/styles_blue.less" id="skin_color">
		<link rel="stylesheet" href="#Application.rootpath#assets/css/print.css" type="text/css" media="print"/>
		<!-- start: CSS REQUIRED FOR THIS PAGE ONLY -->
		<link rel="stylesheet" href="#Application.rootpath#assets/plugins/select2/select2.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/plugins/datepicker/css/datepicker.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/plugins/bootstrap-timepicker/css/bootstrap-timepicker.min.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/plugins/bootstrap-daterangepicker/daterangepicker-bs3.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/plugins/bootstrap-colorpicker/css/bootstrap-colorpicker.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/plugins/jQuery-Tags-Input/jquery.tagsinput.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/plugins/bootstrap-fileupload/bootstrap-fileupload.min.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/plugins/summernote/build/summernote.css">
		<link rel="stylesheet" href="#Application.rootpath#assets/plugins/DataTables/media/css/DT_bootstrap.css" />
		<link href="#Application.rootpath#assets/plugins/bootstrap-modal/css/bootstrap-modal-bs3patch.css" rel="stylesheet" type="text/css"/>
		<link href="#Application.rootpath#assets/plugins/bootstrap-modal/css/bootstrap-modal.css" rel="stylesheet" type="text/css"/>
		<!-- end: CSS REQUIRED FOR THIS PAGE ONLY -->
		<!--[if IE 7]>
		<link rel="stylesheet" href="assets/plugins/font-awesome/css/font-awesome-ie7.min.css">
		<![endif]-->
		<!-- end: MAIN CSS -->
		<!-- start: CSS REQUIRED FOR THIS PAGE ONLY -->
		<!-- end: CSS REQUIRED FOR THIS PAGE ONLY -->
		<link rel="shortcut icon" href="favicon.ico" />
		</cfoutput>
	</head>
	<!-- end: HEAD -->
	<!-- start: BODY -->
	<!---removed fixed header--->
	<body class="header-default">
		<!-- start: HEADER -->
		<cfinclude template="#Application.rootpath#template_inc/header_inc.cfm">
		<!-- end: HEADER -->
		<!-- start: MAIN CONTAINER -->
		<div class="main-container">
			<!-- start: SIDEBAR -->
			<cfinclude template="#Application.rootpath#template_inc/side_nav_inc.cfm">
			
			<!-- start: PAGE -->
			<div class="main-content">
				<div class="container">
					<!-- start: PAGE HEADER -->
					<div class="row">
						<div class="col-sm-12">
								<!-- start: PAGE TITLE & BREADCRUMB -->
							<ol class="breadcrumb">
								<li class="active">
									<i class="clip-airplane"></i>
										Help & Support
								</li>
							</ol>
							<!---div class="page-header">
								<h1>Contractor Profile</h1>
							</div--->
							<!-- end: PAGE TITLE & BREADCRUMB -->
						</div>
					</div>
					<!-- end: PAGE HEADER -->
					<!-- start: PAGE CONTENT -->
					<cfif isdefined("feedback")><br />
						<cfinclude template="includes/feedback_inc.cfm">
					<cfelseif isdefined("search")><br />
						<cfinclude template="includes/agency_search_inc.cfm">
					<cfelseif isdefined("search_results")><br />
						<cfinclude template="includes/search_results_inc.cfm">
					<cfelse>
						<cfinclude template="includes/faq_inc.cfm">
					</cfif>					
					
					
					<!-- end: PAGE CONTENT-->
				</div>
			</div>
			<!-- end: PAGE -->
		</div>
		<!-- end: MAIN CONTAINER -->
		<!--- start: FOOTER --->
			<cfinclude template="#Application.rootpath#template_inc/footer_inc.cfm">
		<!--- end: FOOTER --->
		<!-- start: MAIN JAVASCRIPTS -->
		<!--[if lt IE 9]>
		<script src="assets/plugins/respond.min.js"></script>
		<script src="assets/plugins/excanvas.min.js"></script>
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
		<![endif]-->
		<!--[if gte IE 9]><!-->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
		<!--<![endif]-->
		<cfoutput>
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
		<!-- start: JAVASCRIPTS REQUIRED FOR THIS PAGE ONLY -->
		<script src="#Application.rootpath#assets/plugins/jquery-inputlimiter/jquery.inputlimiter.1.3.1.min.js"></script>
		<script src="#Application.rootpath#assets/plugins/autosize/jquery.autosize.min.js"></script>
		<script src="#Application.rootpath#assets/plugins/select2/select2.min.js"></script>
		<script src="#Application.rootpath#assets/plugins/jquery.maskedinput/src/jquery.maskedinput.js"></script>
		<script src="#Application.rootpath#assets/plugins/jquery-maskmoney/jquery.maskMoney.js"></script>
		<script src="#Application.rootpath#assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
		<script src="#Application.rootpath#assets/plugins/bootstrap-timepicker/js/bootstrap-timepicker.min.js"></script>
		<script src="#Application.rootpath#assets/plugins/bootstrap-daterangepicker/moment.min.js"></script>
		<script src="#Application.rootpath#assets/plugins/bootstrap-daterangepicker/daterangepicker.js"></script>
		<script src="#Application.rootpath#assets/plugins/bootstrap-colorpicker/js/bootstrap-colorpicker.js"></script>
		<script src="#Application.rootpath#assets/plugins/bootstrap-colorpicker/js/commits.js"></script>
		<script src="#Application.rootpath#assets/plugins/jQuery-Tags-Input/jquery.tagsinput.js"></script>
		<script src="#Application.rootpath#assets/plugins/bootstrap-fileupload/bootstrap-fileupload.min.js"></script>
		<script src="#Application.rootpath#assets/plugins/summernote/build/summernote.min.js"></script>
		<script src="#Application.rootpath#assets/plugins/ckeditor/ckeditor.js"></script>
		<script src="#Application.rootpath#assets/plugins/ckeditor/adapters/jquery.js"></script>
		<!---script src="#Application.rootpath#assets/plugins/bootstrap/js/bootstrap-button.js"></script--->
		<script src="#Application.rootpath#assets/plugins/bootstrap-modal/js/bootstrap-modal.js"></script>
		<script src="#Application.rootpath#assets/plugins/bootstrap-modal/js/bootstrap-modalmanager.js"></script>
		<script src="#Application.rootpath#assets/js/ui-modals.js"></script>
		<script type="text/javascript" src="#Application.rootpath#assets/plugins/DataTables/media/js/jquery.dataTables.min.js"></script>
		<script type="text/javascript" src="#Application.rootpath#assets/plugins/DataTables/media/js/DT_bootstrap.js"></script>
		<script src="#Application.rootpath#assets/js/form-elements.js"></script>
		<script src="#Application.rootpath#assets/js/table-data-agency.js"></script>
		<script src="#Application.rootpath#assets/plugins/datatables/fnFilterOnReturn.js"></script>
		<script src="#Application.rootpath#assets/plugins/datatables/jquery.dataTables.columnFilter.js"></script>
		
		<!-- end: JAVASCRIPTS REQUIRED FOR THIS PAGE ONLY -->
		</cfoutput>
		<!-- end: MAIN JAVASCRIPTS -->
		<!-- start: JAVASCRIPTS REQUIRED FOR THIS PAGE ONLY -->
		<!-- end: JAVASCRIPTS REQUIRED FOR THIS PAGE ONLY -->
		<script>
			jQuery(document).ready(function() {
				Main.init();
				FormElements.init();
				TableData.init();
				UIModals.init();
				
			});
		</script>

	</body>
	<!-- end: BODY -->
</html>