<cfoutput>
<script src="#request.rootpath#ammap/ammap.js"></script>
<script src="#request.rootpath#ammap/maps/js/usaLow.js"></script>
<script src="#request.rootpath#ammap/plugins/export/export.min.js"></script>
<link rel="stylesheet" href="#request.rootpath#ammap/plugins/export/export.css" type="text/css" media="all" />
<script src="#request.rootpath#ammap/themes/light.js"></script>
<!-- Chart code -->
<script src="#request.rootpath#template_inc/AmCharts.cfm"></script>
</cfoutput>
<cfinclude template="../functionInc/dashboard/dashboard.cfm" />
<cfinclude template="../functionInc/dashboard/updatedCount.cfm" />
<cfset variables.lastview = dateadd("d",-1,tdate)>
<cfset variables.lastview = dateformat(variables.lastview,"mm/dd/yyyy")>
	<!-- Styles -->
	<style>
	#chartdiv {
	  width: 100%;
	  height: 350px;
	}
	.adBanner{
		margin-bottom: 10px;
	}
		
	@media (min-width: 767px) {
		.squareAd{max-height: 225px;}
	}
	</style>
<div class="section">

	<div class="col col-sm-8 col-xs-12 pull-left">
		<div class="">
			<a href="https://store.technologypub.com/products/threemapseries2018/" target="_blank"><img src="../assets/images/17-09-leaderboard_1456x180_PBTtriplemap.jpg" class="img-responsive" /></a>
		</div>
	</div>
	<div class="col col-sm-4 hidden-xs pull-left">
		<div class="well ">
			<h4>Notifications:</h4>
			<p><i class="fa fa-info-circle wellcss pull-left text-info" aria-hidden="true"></i> Mar 2, 2018 - Users experiencing scrolling issues in Internet Explorer: please download <a href="https://www.google.com/chrome/" target="_blank">Chrome</a> or <a href="https://www.mozilla.org/en-US/firefox/new/" target="_blank">Firefox</a> for optimal performance, or contact <a href="mailto:jlockley@paintbidtracker.com">Josiah Lockley</a> for assistance. </p>
			<!---<p><i class="fa fa-info-circle wellcss pull-left text-info" aria-hidden="true"></i> Feb 23, 2018 - REMINDER: We will be officially switching to the new 360 platform on Saturday, February 24 and at that time you will no longer have access to the legacy site. Contact Josiah Lockley with questions or for training at jlockley@paintbidtracker.com, or visit our webinars and tutorials page <a href="http://beta360.paintbidtracker.com/dmz/?action=webinars">here</a>.</p>--->
			<!---<p><i class="fa fa-info-circle wellcss pull-left text-info" aria-hidden="true"></i> Feb 14, 2018 - Our offices will be closed on Monday, February 19, 2018 in observance of the Presidents' Day holiday.</p>--->
			<!---<p><i class="fa fa-info-circle wellcss pull-left text-info" aria-hidden="true"></i> Feb 9, 2018 - Join our Paint BidTracker 360 Webinar to learn about the new features, Friday, February 9th at 11 am EST. Click <a href="https://register.gotowebinar.com/register/946905299862089729" target="_blank">here</a> to register.--->
			<!---<p><i class="fa fa-info-circle wellcss pull-left text-info" aria-hidden="true"></i> Feb 8, 2018  - Multiple lead printing is now available within the 'Multi Bid Action' drop down at the top of search results. Select up to 10 leads, choose 'Print Leads' from the drop down, then 'Create' the printable PDF. Once processed, click the 'PDF READY' button to view the PDF.</p>--->
			<!---<p><i class="fa fa-info-circle wellcss pull-left text-info" aria-hidden="true"></i> Dec 22, 2017 - Searching by Coatings Type and Manufacturer have been added to the bid search form.</p>--->
			
<!--
			<p><i class="fa fa-info-circle wellcss pull-left text-info" aria-hidden="true"></i> Nov 28, 2017 - Looking at the map below, you can click on a state to run a search for that specific state.</p>
			<p><i class="fa fa-info-circle wellcss pull-left text-info" aria-hidden="true"></i> Nov 28, 2017 -  The Drag-n-Drop functionality has been added to search results, allowing a record in the result set to be dropped in the upper-right portion of the screen and saved in the clipboard. Use the <i class="fa fa-clipboard"></i> in the results to drag.</p>
			<p><i class="fa fa-info-circle wellcss pull-left text-info" aria-hidden="true"></i> Nov 28, 2017 -  Looking at the map, you can see which states you are subscribed to by the color.  If the state is <span style="color:#244999">blue</span>, it is added to your account.</p>
-->
		</div>
	</div>

<!---div class="row">
	<div class="col col-sm-12 pull-left dashNotificationBox" id="box15">
		<div class="well ">
			<h4>Notifications:</h4>
			<p><i class="fa fa-info-circle wellcss pull-left text-info" aria-hidden="true"></i> Dec 22, 2017 - Searching by Coatings Type and Manufacturer have been added to the bid search form.</p>
			<p><i class="fa fa-info-circle wellcss pull-left text-info" aria-hidden="true"></i> Nov 28, 2017 - Looking at the map below, you can click on a state to run a search for that specific state.</p>
			<p><i class="fa fa-info-circle wellcss pull-left text-info" aria-hidden="true"></i> Nov 28, 2017 -  The Drag-n-Drop functionality has been added to search results, allowing a record in the result set to be dropped in the upper-right portion of the screen and saved in the clipboard. Use the <i class="fa fa-clipboard"></i> in the results to drag.</p>
			<p><i class="fa fa-info-circle wellcss pull-left text-info" aria-hidden="true"></i> Nov 28, 2017 -  Looking at the map, you can see which states you are subscribed to by the color.  If the state is <span style="color:#244999">blue</span>, it is added to your account.</p>
		</div>
	</div>	
</div--->

  <div class="col col-sm-6 col-xs-12 pull-left dashbox" id="box13">
    <div class="dashboxTitle">Map <span class="pull-right">  <i class="fa fa-times-circle-o fa-lg dashClose" aria-hidden="true"></i> </span></div>
	  <div class="dashboxContent"><div id="chartdiv"></div> <!---Hover over map for state project information.---></div>
  </div>	
  <div class="col col-sm-6 col-xs-12 pull-left dashbox" id="box12">
    <div class="dashboxTitle">Quick Search, Filter Verified Painting Leads By <span class="pull-right">  <i class="fa fa-times-circle-o fa-lg dashClose" aria-hidden="true"></i> </span></div>
	  <div class="dashboxContent dashText1"><cfinclude template="../search/includes/quicksearch.cfm" /></div>
  </div>
  <div class="col col-sm-4 col-xs-12 pull-left dashbox text-center" id="box16">
	  <div class="dashboxContent dashText1"><a href="https://store.technologypub.com/products/jpcl-monopoly/" target="_blank"><img src="../assets/images/Monopoly_ad.png" class="img-responsive squareAd" style="display:inherit!important;" /></a></div>
  </div>	



  <div class="col col-sm-4 col-xs-12 pull-left dashbox" id="box1">
    <div class="dashboxTitle">Dashboard User Guidelines <span class="pull-right">  <i class="fa fa-times-circle-o fa-lg dashClose" aria-hidden="true"></i> </span> </div>
    <div class="dashboxContent dashText1">Clicking on the <i class="fa fa-times-circle-o fa-lg" aria-hidden="true"></i> will remove the box from the display. <br/> To restore a box you have closed, go to the bottom of the page and click the one you want restored, or click restore all to reset.</div>
  </div>
  
  <div class="col col-sm-4 col-xs-12 pull-left dashbox" id="box2">
    <div class="dashboxTitle">No. of Updated Jobs <span class="pull-right">  <i class="fa fa-times-circle-o fa-lg dashClose" aria-hidden="true"></i> </span></div>
	  <div class="dashboxContent"><cfoutput><a href="#request.rootpath#myaccount/folders/">#updateCnt#</a></cfoutput></div>
  </div><!--
  <div class="col col-sm-4 pull-left dashbox" id="box3">
    <div class="dashboxTitle">New Jobs in Searches <span class="pull-right">  <i class="fa fa-times-circle-o fa-lg dashClose" aria-hidden="true"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#myaccount/folders/?action=searches" >#newJobs.recordcount#</a></cfoutput></div>
  </div>
   -->
  <div class="col col-sm-4 col-xs-12 pull-left dashbox" id="box4">
    <div class="dashboxTitle">Industrial Painting Leads and Bid Notices <span class="pull-right">  <i class="fa fa-times-circle-o fa-lg dashClose" aria-hidden="true"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=1">#pkgArr[1]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 col-xs-12 pull-left dashbox" id="box5">
    <div class="dashboxTitle">Industrial Painting Awards and Results <span class="pull-right">  <i class="fa fa-times-circle-o fa-lg dashClose" aria-hidden="true"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=5">#pkgArr[5]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 col-xs-12 pull-left dashbox" id="box6">
    <div class="dashboxTitle">Commercial Painting Leads and Bid Notices <span class="pull-right">  <i class="fa fa-times-circle-o fa-lg dashClose" aria-hidden="true"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=2">#pkgArr[2]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 col-xs-12 pull-left dashbox" id="box7">
    <div class="dashboxTitle">General Construction Leads and Bid Notices <span class="pull-right">  <i class="fa fa-times-circle-o fa-lg dashClose" aria-hidden="true"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=3">#pkgArr[3]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 col-xs-12 pull-left dashbox" id="box8">
    <div class="dashboxTitle">General Construction Awards and Results <span class="pull-right">  <i class="fa fa-times-circle-o fa-lg dashClose" aria-hidden="true"></i></span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=6">#pkgArr[6]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 col-xs-12 pull-left dashbox" id="box9">
    <div class="dashboxTitle">Subcontracting Opportunities <span class="pull-right">  <i class="fa fa-times-circle-o fa-lg dashClose" aria-hidden="true"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=9">#pkgArr[9]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 col-xs-12 pull-left dashbox" id="box10">
    <div class="dashboxTitle">Engineering & Design Leads <span class="pull-right">  <i class="fa fa-times-circle-o fa-lg dashClose" aria-hidden="true"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=4">#pkgArr[4]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 col-xs-12 pull-left dashbox" id="box11">
    <div class="dashboxTitle">Engineering & Design Awards and Results <span class="pull-right">  <i class="fa fa-times-circle-o fa-lg dashClose" aria-hidden="true"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=7">#pkgArr[7]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 col-xs-12 pull-left"></div> 


	<div class="col col-sm-12 hidden-xs pull-left dashbox" id="box14">
	<div class="dashboxTitle"> <span class="pull-right">  <i class="fa fa-times-circle-o fa-lg dashClose" aria-hidden="true"></i> </span></div>
	<cfif not listfind(session.packages, 19)>
	<div class="row">
		<div class="col-sm-3"></div>
		<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/#contact" >sales rep</a> directly.
		</div>
		<div class="col-sm-3"></div>
	</div>
	<cfelse>
		<cfoutput><iframe frameBorder="0" seamless id="frame1" name="frame1" scroll="no" height=820px width=1500px  src="https://technologypublishing.bime.io/dashboard/main_dashboard_v2?access_token=#session.auth.user_access_token###year=#session.auth.default_year#&quarter=#session.auth.default_qtr#"></iframe></cfoutput>
	</cfif>
	</div>

<div class="col-xs-12 dashboxTrashbin"></div>
</div>

<!--- messgae box Modal --->
<div class="modal fade" tabindex="-1" role="dialog" id="siteMessageBox">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h5 class="modal-title" id="detailLabel"></h5>
			</div>							  
			<div class="modal-body"></div>
			<div class="modal-footer"></div>
		</div>
	</div>
</div>	
	<script>
		$_init = true;
		$( document.body ).click(function() {
			if ($_init){
			 $( "path" ).each(function() {
				 if (typeof $( this ).attr('aria-label') != 'undefined'){
					 $(this).on('click', function(){
						 $state = $( this ).attr('aria-label').replace(" 0 ", "");						 
						 $stateID=getStateID($state);						 
						 location = '/search/?search_history=1&action=sresults&project_stage=2&qt=&bidid=&contractorname=&state='+$stateID+'&amount=1&postfrom=&postto=&subfrom=&subto=&projecttype=1&filterOP=or&SEARCH=SEARCH';
					 })					 
				 }
		     });
				$_init = false;
			}
		});
		
		
	// site message box handler
/*$(function() {
    //var bidID = $(this).attr('data-bidid');
	  var full = "<a href='../functioninc/dashboard/sitemessage.cfm'>View full details</a>";
	  $(".modal-body").html("Content loading please wait...  <img src='../assets/images/spinner.svg'>");
  	  $(".modal-title").html("SITE ALERT");
	
	  $(".modal-footer").html();		
	  $("#siteMessageBox").modal("show");
	  $(".modal-body").load('../functioninc/dashboard/sitemessage.cfm');
});*/


		
		function getStateID(s){
			switch (s) {
				case 'Alabama':
					return 3;
					break;
				case 'Alaska':
					return 2;
					break;
				case 'Arizona':
					return 5;
					break;
				case 'Arkansas':
					return 4;
					break;
				case 'California':
					return 7;
					break;
				case 'Colorado':
					return 8;
					break;
				case 'Connecticut':
					return 9;
					break;
				case 'Delaware':
					return 10;
					break;
				case 'District of Columbia':
					return 67;
					break;
				case 'Florida':
					return 11;
					break;
				case 'Georgia':
					return 12;
					break;
				case 'Hawaii':
					return 13;
					break;
				case 'Idaho':
					return 15;
					break;
				case 'Illinois':
					return 16;
					break;
				case 'Indiana':
					return 17;
					break;
				case 'Iowa':
					return 14;
					break;
				case 'Kansas':
					return 18;
					break;
				case 'Kentucky':
					return 19;
					break;
				case 'Louisiana':
					return 20;
					break;
				case 'Maine':
					return 24;
					break;
				case 'Maryland':
					return 23;
					break;
				case 'Massachusetts':
					return 21;
					break;
				case 'Michigan':
					return 25;
					break;
				case 'Minnesota':
					return 26;
					break;
				case 'Mississippi':
					return 28;
					break;
				case 'Missouri':
					return 27;
					break;
				case 'Montana':
					return 29;
					break;
				case 'Nebraska':
					return 33;
					break;
				case 'Nevada':
					return 39;
					break;
				case 'New Hampshire':
					return 35;
					break;
				case 'New Jersey':
					return 36;
					break;
				case 'New Mexico':
					return 37;
					break;
				case 'New York':
					return 40;
					break;
				case 'North Carolina':
					return 31;
					break;
				case 'North Dakota':
					return 32;
					break;
				case 'Ohio':
					return 41;
					break;
				case 'Oklahoma':
					return 42;
					break;
				case 'Oregon':
					return 44;
					break;
				case 'Pennsylvania':
					return 45;
					break;
				case 'Rhode Island':
					return 49;
					break;
				case 'South Carolina':
					return 50;
					break;
				case 'South Dakota':
					return 51;
					break;
				case 'Tennessee':
					return 53;
					break;
				case 'Texas':
					return 54;
					break;
				case 'Utah':
					return 55;
					break;
				case 'Vermont':
					return 57;
					break;
				case 'Virginia':
					return 56;
					break;
				case 'Washington':
					return 58;
					break;
				case 'West Virginia':
					return 60;
					break;
				case 'Wisconsin':
					return 59;
					break;
				case 'Wyoming':
					return 61;
					break;
		}
		}
	</script>