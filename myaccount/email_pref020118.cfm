<!---
******************************
created : slyon 4/1/2017

******************************
--->
<cfparam default="folders" name="url.action" />
<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<CFSET BASEDATE = #createodbcdate(now())#>

<!DOCTYPE html>
<!-- Template Name: Responsive Admin Template build with Twitter Bootstrap 3.x Version: 1.3 Author: DS -->
<!--[if IE 8]><html class="ie8 no-js" lang="en"><![endif]-->
<!--[if IE 9]><html class="ie9 no-js" lang="en"><![endif]-->
<!--[if !IE]><!-->
<html lang="en" class="no-js">
<!--<![endif]-->
<!-- start: HEAD -->
<head>
<title>PBT360: Market Analytics and Business Intelligence for the Coatings Industry</title>
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
  <link rel="stylesheet" href="#request.rootpath#assets/plugins/bootstrap/css/bootstrap.min.css">
  <link rel="stylesheet" href="#request.rootpath#assets/plugins/font-awesome/css/font-awesome.min.css">
  <link rel="stylesheet" href="#request.rootpath#assets/fonts/style.css">
  <link rel="stylesheet" href="#request.rootpath#assets/css/main.css">
  <link rel="stylesheet" href="#request.rootpath#assets/css/main-responsive.css">
  <link rel="stylesheet" href="#request.rootpath#assets/plugins/iCheck/skins/all.css">
  <link rel="stylesheet" href="#request.rootpath#assets/plugins/bootstrap-colorpalette/css/bootstrap-colorpalette.css">
  <link rel="stylesheet" href="#request.rootpath#assets/plugins/perfect-scrollbar/src/perfect-scrollbar.css">
  <!---link rel="stylesheet" href="#request.rootpath#assets/css/theme_black_and_white.css" type="text/css" id="skin_color"--->
  <link rel="stylesheet" href="#request.rootpath#assets/less/styles_blue.less" id="skin_color">
  <link rel="stylesheet" href="#request.rootpath#assets/css/print.css" type="text/css" media="print"/>
  <!--[if IE 7]>
		<link rel="stylesheet" href="assets/plugins/font-awesome/css/font-awesome-ie7.min.css">
		<![endif]-->
  <!-- end: MAIN CSS -->
  <!-- start: CSS REQUIRED FOR THIS PAGE ONLY -->
	<link rel="stylesheet" href="#request.rootpath#assets/plugins/select2/select2.css">
	<link rel="stylesheet" href="#request.rootpath#assets/plugins/datepicker/css/datepicker.css">
	<link rel="stylesheet" href="#request.rootpath#assets/plugins/bootstrap-timepicker/css/bootstrap-timepicker.min.css">
	<link rel="stylesheet" href="#request.rootpath#assets/plugins/bootstrap-daterangepicker/daterangepicker-bs3.css">
	<link rel="stylesheet" href="#request.rootpath#assets/plugins/bootstrap-colorpicker/css/bootstrap-colorpicker.css">
	<link rel="stylesheet" href="#request.rootpath#assets/plugins/jQuery-Tags-Input/jquery.tagsinput.css">
	<link rel="stylesheet" href="#request.rootpath#assets/plugins/bootstrap-fileupload/bootstrap-fileupload.min.css">
	<link rel="stylesheet" href="#request.rootpath#assets/plugins/summernote/build/summernote.css">
	<link rel="stylesheet" href="#request.rootpath#assets/plugins/DataTables/media/css/DT_bootstrap.css" />
	<link href="#request.rootpath#assets/plugins/bootstrap-modal/css/bootstrap-modal-bs3patch.css" rel="stylesheet" type="text/css"/>
	<link href="#request.rootpath#assets/plugins/bootstrap-modal/css/bootstrap-modal.css" rel="stylesheet" type="text/css"/>

  <!-- end: CSS REQUIRED FOR THIS PAGE ONLY -->
  <link rel="shortcut icon" href="favicon.ico" />
</cfoutput>
</head>
<!-- end: HEAD -->
<!-- start: BODY -->
<!---removed fixed header header-default footer-fixed--->
<body class="header-default">
<!-- start: HEADER -->
<cftry>
  <cfinclude template="../template_inc/header_inc.cfm">
  <cfcatch>
    <cfdump var="#cfcatch#" />
  </cfcatch>
</cftry>
<!-- end: HEADER --> 
<!-- start: MAIN CONTAINER -->
<div class="main-container"> 
  <!-- start: SIDEBAR -->
  <cftry>
    <cfinclude template="../template_inc/side_nav_inc.cfm">
    <cfcatch>
      <cfdump var="#cfcatch#" />
    </cfcatch>
  </cftry>
  <!-- start: PAGE -->
  <div class="main-content">
    <div class="container"> 
      <!-- start: PAGE HEADER -->
      <div class="row">
        <div class="col-sm-12"> 
          <!-- start: STYLE SELECTOR BOX --> 
          <!---cfinclude template="template_inc/style_selector_inc.cfm"---> 
          <!-- end: STYLE SELECTOR BOX --> 
          <!-- start: PAGE TITLE & BREADCRUMB -->
          <ol class="breadcrumb">
            <li><i class="clip-settings"></i> My Account
              <cfif isdefined("performance") or isdefined("performance_bridges") or isdefined("performance_tanks") or isdefined("performance_waste")>
                <i class="clip-stats"></i> Market Performance
                <cfelseif isdefined("brand_dashboard")>
                <i class="clip-bars"></i> Market Specification
                <cfelseif isdefined("brand_share")>
                <i class="clip-bars"></i> Market Specification
                <cfelseif isdefined("market_letting")>
                <i class="clip-stats"></i> Market Performance
                <cfelseif isdefined("dashboard")>
                <i class="clip-home-3"></i> Dashboard
              </cfif>
            </li>
            <li class="active">
              <cfif isdefined("performance")>
                Total Market Metrics
                <cfelseif isdefined("performance_bridges")>
                Bridge & Tunnels
                <cfelseif isdefined("performance_tanks")>
                Water Tanks
                <cfelseif isdefined("performance_waste")>
                Water / Waste
                <cfelseif isdefined("brand_dashboard")>
                Brand Dashboard
                <cfelseif isdefined("brand_share")>
                Specification Share Rankings
                <cfelseif isdefined("market_letting")>
                Letting Metrics
              </cfif>
            </li>
            <!---include the search form box--->
            <cfinclude template="../template_inc/main_search_inc.cfm">
          </ol>
          <!---div class="page-header">
								<!---h1>Blank Page <small>blank page</small></h1--->
							</div---> 
          <!-- end: PAGE TITLE & BREADCRUMB --> 
        </div>
      </div>
      <!-- end: PAGE HEADER --> 
      <!-- start: PAGE CONTENT -->
      <cftry>
        <cfinclude template="includes/email_pref_inc.cfm" />
        <cfcatch>
          <cfdump var="#cfcatch#" />
        </cfcatch>
      </cftry>
      <!---https://technologypublishing.bime.io/dashboard/main_dashboard##year=#application.default_year#&quarter=#application.default_qtr#---> 
      <!-- end: PAGE CONTENT--> 
    </div>
  </div>
  <!-- end: PAGE --> 
</div>
<!-- end: MAIN CONTAINER --> 
<!--- start: FOOTER --->
<cfinclude template="../template_inc/footer_inc.cfm">
<!--- end: FOOTER ---> 
<!-- start: MAIN JAVASCRIPTS --> 
<!--[if lt IE 9]>
		<script src="assets/plugins/respond.min.js"></script>
		<script src="assets/plugins/excanvas.min.js"></script>
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
		<![endif]--> 
 <cfoutput>                       
<!--[if gte IE 9]><!--> 
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script> 
<!--<![endif]--> 
<script src="#request.rootpath#assets/plugins/jquery-ui/jquery-ui-1.10.2.custom.min.js"></script> 
<script src="#request.rootpath#assets/plugins/bootstrap/js/bootstrap.min.js"></script> 
<script src="#request.rootpath#assets/plugins/bootstrap-hover-dropdown/bootstrap-hover-dropdown.min.js"></script> 
<script src="#request.rootpath#assets/plugins/blockUI/jquery.blockUI.js"></script> 
<script src="#request.rootpath#assets/plugins/iCheck/jquery.icheck.min.js"></script> 
<script src="#request.rootpath#assets/plugins/perfect-scrollbar/src/jquery.mousewheel.js"></script> 
<script src="#request.rootpath#assets/plugins/perfect-scrollbar/src/perfect-scrollbar.js"></script> 
<script src="#request.rootpath#assets/plugins/less/less-1.5.0.min.js"></script> 
<script src="#request.rootpath#assets/plugins/jquery-cookie/jquery.cookie.js"></script> 
<script src="#request.rootpath#assets/plugins/bootstrap-colorpalette/js/bootstrap-colorpalette.js"></script> 
<script src="#request.rootpath#assets/js/main.js"></script> 
<!-- end: MAIN JAVASCRIPTS --> 
<!-- start: JAVASCRIPTS REQUIRED FOR THIS PAGE ONLY --> 
 		<script src="#request.rootpath#assets/plugins/jquery-inputlimiter/jquery.inputlimiter.1.3.1.min.js"></script>
		<script src="#request.rootpath#assets/plugins/autosize/jquery.autosize.min.js"></script> 
		<script src="#request.rootpath#assets/plugins/select2/select2.min.js"></script>   
		<script src="#request.rootpath#assets/plugins/jQuery-Tags-Input/jquery.tagsinput.js"></script>
		<script src="#request.rootpath#assets/plugins/bootstrap-fileupload/bootstrap-fileupload.min.js"></script>
		<script src="#request.rootpath#assets/plugins/summernote/build/summernote.min.js"></script>
		<script src="#request.rootpath#assets/plugins/ckeditor/ckeditor.js"></script>
		<script src="#request.rootpath#assets/plugins/ckeditor/adapters/jquery.js"></script>
		<!---script src="#request.rootpath#assets/plugins/bootstrap/js/bootstrap-button.js"></script--->
		<script src="#request.rootpath#assets/plugins/bootstrap-modal/js/bootstrap-modal.js"></script>
		<script src="#request.rootpath#assets/plugins/bootstrap-modal/js/bootstrap-modalmanager.js"></script>
		<script src="#request.rootpath#assets/js/ui-modals.js"></script>
		<script type="text/javascript" src="https://cdn.datatables.net/1.10.7/js/jquery.dataTables.js"></script>
		<script type="text/javascript" src="#request.rootpath#assets/plugins/DataTables/media/js/DT_bootstrap.js"></script>
		<!---script type="text/javascript" src="#request.rootpath#assets/plugins/DataTables/media/js/jquery.dataTables.min.js"></script>
		<script type="text/javascript" src="#request.rootpath#assets/plugins/DataTables/media/js/DT_bootstrap.js"></script--->
		<script src="#request.rootpath#assets/js/form-elements.js"></script>
		<script src="#request.rootpath#assets/js/table-data-agency.js"></script>
		<script src="#request.rootpath#assets/plugins/datatables/fnFilterOnReturn.js"></script>
		<script src="#request.rootpath#assets/plugins/datatables/jquery.dataTables.columnFilter.js"></script>
		<script src="#request.rootpath#assets/js/form-actions.js"></script>  </cfoutput>        
<!-- end: JAVASCRIPTS REQUIRED FOR THIS PAGE ONLY --> 
<script>
			jQuery(document).ready(function() {
				Main.init();
		
		
		//hide default element
		//$( "#project_stage" ).hide();
		$( "#structures" ).hide();
		$( "#scopes" ).hide();
		$( "#supply" ).hide();
		$( "#qualifications" ).hide();
		$( "#filter" ).hide();
		
		// set project stage toggle
		$( "#button" ).click(function() {
			$( "#project_stage" ).toggle();
			$('.minus, .add').toggle();
			return false;
		});
		
		// set structure toggle
		$( "#structure_button" ).click(function() {
			$( "#structures" ).toggle();
			$('.struct_minus, .struct_add').toggle();
			return false;
		});
		
		// set scopes toggle
		$( "#scopes_button" ).click(function() {
			$( "#scopes" ).toggle();
			$('.scopes_minus, .scopes_add').toggle();
			return false;
		});
		
		// set supply toggle
		$( "#supply_button" ).click(function() {
			$( "#supply" ).toggle();
			$('.supply_minus, .supply_add').toggle();
			return false;
		});
		
		// set qualifications toggle
		$( "#qual_button" ).click(function() {
			$( "#qualifications" ).toggle();
			$('.qual_minus, .qual_add').toggle();
			return false;
		});
		
		// set filter toggle
		$( "#filter_button" ).click(function() {
			$( "#filter" ).toggle();
			$('.filter_minus, .filter_add').toggle();
			return false;
		});


        $( '#selectall' ).on( 'change', function() {
            $( '.currentprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
       
        });
        $( '.currentprojects' ).on( 'change', function() {
            $( '.currentprojects' ).length == $( '.currentprojects:checked' ).length ? $( '#selectall' ).prop( 'checked', 'checked' ).next() : $( '#selectall' ).prop( 'checked', '' ).next();

        });

        $( '#selectall_results' ).on( 'change', function() {
            $( '.resultsprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.resultsprojects' ).on( 'change', function() {
            $( '.resultsprojects' ).length == $( '.resultsprojects:checked' ).length ? $( '#selectall_results' ).prop( 'checked', 'checked' ).next() : $( '#selectall_results' ).prop( 'checked', '' ).next();

        });

        $( '#selectall_expired' ).on( 'change', function() {
            $( '.expiredprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.expiredprojects' ).on( 'change', function() {
            $( '.expiredprojects' ).length == $( '.expiredprojects:checked' ).length ? $( '#selectall_expired' ).prop( 'checked', 'checked' ).next() : $( '#selectall_expired' ).prop( 'checked', '' ).next();

        });

        $( '#selectall_industrial' ).on( 'change', function() {
            $( '.industrialprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.industrialprojects' ).on( 'change', function() {
            $( '.industrialprojects' ).length == $( '.industrialprojects:checked' ).length ? $( '#selectall_industrial' ).prop( 'checked', 'checked' ).next() : $( '#selectall_industrial' ).prop( 'checked', '' ).next();

        });

        $( '#selectall_commercial' ).on( 'change', function() {
            $( '.commercialprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.commercialprojects' ).on( 'change', function() {
            $( '.commercialprojects' ).length == $( '.commercialprojects:checked' ).length ? $( '#selectall_commercial' ).prop( 'checked', 'checked' ).next() : $( '#selectall_commercial' ).prop( 'checked', '' ).next();

        });

        $( '#selectall_construction' ).on( 'change', function() {
            $( '.constructionprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.constructionprojects' ).on( 'change', function() {
            $( '.constructionprojects' ).length == $( '.constructionprojects:checked' ).length ? $( '#selectall_construction' ).prop( 'checked', 'checked' ).next() : $( '#selectall_construction' ).prop( 'checked', '' ).next();

        });


        $( '#selectall_services' ).on( 'change', function() {
            $( '.professionalprojects' ).prop( 'checked', $( this ).is( ':checked' ) ? 'checked' : '' );
            
        });
        $( '.professionalprojects' ).on( 'change', function() {
            $( '.professionalprojects' ).length == $( '.professionalprojects:checked' ).length ? $( '#selectall_services' ).prop( 'checked', 'checked' ).next() : $( '#selectall_services' ).prop( 'checked', '' ).next();

        });
});

	</script>
</body>
<!-- end: BODY -->
</html>