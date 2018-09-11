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
<cfset variables.lastview = dateadd("d",-1,tdate)>
<cfset variables.lastview = dateformat(variables.lastview,"mm/dd/yyyy")>
	<!-- Styles -->
	<style>
	#chartdiv {
	  width: 100%;
	  height: 350px;
	}
	</style>
<div class="section">
<div class="row">	
  <div class="col col-sm-6 pull-left dashboxTxt" id="box12">
    <div class="dashboxTitle">Quick Search <span class="pull-right">  <i class="clip-cancel-circle"></i> </span></div>
	  <div class="dashboxContent"><cfinclude template="../search/includes/quicksearch.cfm" /></div>
  </div>	
  <div class="col col-sm-6 pull-left dashboxTxt" id="box13">
    <div class="dashboxTitle">Map <span class="pull-right">  <i class="clip-cancel-circle"></i> </span></div>
	  <div class="dashboxContent"><div id="chartdiv"></div> </div>
  </div>
</div>
<div class="row">
</div>
<div class="row">
  <div class="col col-sm-4 pull-left dashboxTxt" id="box1">
    <div class="dashboxTitle">PBT Dashboard Info <span class="pull-right">  <i class="clip-cancel-circle"></i> </span> </div>
    <div class="dashboxContent">Clicking on the <i class="clip-cancel-circle-2"></i> will remove the box from the display.  It can be restored via the settings.</div>
  </div>
  <div class="col col-sm-4 pull-left dashbox" id="box2">
    <div class="dashboxTitle"># of updated jobs <span class="pull-right">  <i class="clip-cancel-circle"></i> </span></div>
	  <div class="dashboxContent"><cfoutput>#updatedJobs.recordcount#</cfoutput></div>
  </div>
  <div class="col col-sm-4 pull-left dashbox" id="box3">
    <div class="dashboxTitle">new jobs in searches <span class="pull-right">  <i class="clip-cancel-circle"></i> </span></div>
    <div class="dashboxContent"><cfoutput>#newJobs.recordcount#</cfoutput></div>
  </div>
  <div class="col col-sm-4 pull-left dashbox" id="box4">
    <div class="dashboxTitle">Industrial Painting Leads and Bid Notices <span class="pull-right">  <i class="clip-cancel-circle"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=1">#pkgArr[1]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 pull-left dashbox" id="box5">
    <div class="dashboxTitle">Industrial Painting Awards and Results <span class="pull-right">  <i class="clip-cancel-circle"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=5">#pkgArr[5]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 pull-left dashbox" id="box6">
    <div class="dashboxTitle">Commercial Painting Leads and Bid Notices <span class="pull-right">  <i class="clip-cancel-circle"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=2">#pkgArr[2]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 pull-left dashbox" id="box7">
    <div class="dashboxTitle">General Construction Leads and Bid Notices <span class="pull-right">  <i class="clip-cancel-circle"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=3">#pkgArr[3]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 pull-left dashbox" id="box8">
    <div class="dashboxTitle">General Construction Awards and Results <span class="pull-right">  <i class="clip-cancel-circle"></i></span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=6">#pkgArr[6]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 pull-left dashbox" id="box9">
    <div class="dashboxTitle">Subcontracting Opportunities <span class="pull-right">  <i class="clip-cancel-circle"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=9">#pkgArr[9]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 pull-left dashbox" id="box10">
    <div class="dashboxTitle">Engineering & Design Leads <span class="pull-right">  <i class="clip-cancel-circle"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=4">#pkgArr[4]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 pull-left dashbox" id="box11">
    <div class="dashboxTitle">Engineering & Design Awards and Results <span class="pull-right">  <i class="clip-cancel-circle"></i> </span></div>
    <div class="dashboxContent"><cfoutput><a href="#request.rootpath#search/?action=lastvisit&lst=#variables.lastview#&packageID=7">#pkgArr[7]#</cfoutput></a></div>
  </div>
  <div class="col col-sm-4 pull-left"></div> 
</div>
<div class="row">
	<div class="col col-sm-12 pull-left dashboxTxt" id="box14">
	<div class="dashboxTitle"> <span class="pull-right">  <i class="clip-cancel-circle"></i> </span></div>
		<cfoutput><iframe frameBorder="0" seamless id="frame1" name="frame1" scroll="no" height=820px width=1500px  src="https://technologypublishing.bime.io/dashboard/main_dashboard_v2?access_token=#session.auth.user_access_token###year=#session.auth.default_year#&quarter=#session.auth.default_qtr#"></iframe></cfoutput>
	</div>
</div> 
<div class="row dashboxTrashbin"></div>
