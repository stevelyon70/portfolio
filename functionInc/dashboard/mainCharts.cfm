 <cfoutput><!-- Bootstrap -->
    <!--link href="#request.rootpath#assets/vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet"-->
    <!-- Font Awesome -->
    <link href="#request.rootpath#assets/vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <!-- NProgress -->
    <link href="#request.rootpath#assets/vendors/nprogress/nprogress.css" rel="stylesheet">
    
    <link href="#request.rootpath#assets/build/css/custom.css" rel="stylesheet">
    
    </cfoutput> 
<cfquery datasource="#application.datasource#" name="IndCount">
	SELECT distinct a.bidID,a.projectname,a.owner,a.ownerID,a.tags,a.submittaldate,a.city, a.state,a.stateID,a.projectsize,a.minimum_value as minimumvalue,a.maximum_value as maximumvalue,a.stage,a.stageID,a.paintpublishdate,a.zipcode,a.valuetypeID as valuetype,a.county,bid_user_viewed_log.bidid as viewed,pbt_project_updates.updateid,a.supplierID
   FROM pbt_project_master_gateway a
   INNER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
   LEFT OUTER JOIN bid_user_viewed_log on a.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid= 13401
   LEFT OUTER JOIN pbt_project_updates on a.bidid = pbt_project_updates.bidid and pbt_project_updates.pupdateid in (select max(pupdateid) from pbt_project_updates where pbt_project_updates.bidid = a.bidid)
   WHERE 1=1  
    and (a.paintpublishdate >= '10/1/2016' and a.paintpublishdate <= '12/31/2016') 
    and (1 <> 1 or (a.stateid in (3,2,5,4,7,8,9,10,67,11,12,13,15,16,17,14,18,19,20,24,23,21,25,26,28,27,29,33,39,35,36,37,40,31,32,41,42,44,45,49,50,51,53,54,55,57,56,58,60,59,61)) ) 
    and ppmc.tagID in (select pbt_tags.tagID from pbt_tags inner join pbt_tag_packages pt on pt.tagid = pbt_tags.tagid where pt.packageID= 1 and tag_parentID <> 0) 
    and a.verifiedpaint = 1
</cfquery>  
<cfquery datasource="#application.datasource#" name="IndCountPriorYr">
	SELECT distinct a.bidID,a.projectname,a.owner,a.ownerID,a.tags,a.submittaldate,a.city, a.state,a.stateID,a.projectsize,a.minimum_value as minimumvalue,a.maximum_value as maximumvalue,a.stage,a.stageID,a.paintpublishdate,a.zipcode,a.valuetypeID as valuetype,a.county,bid_user_viewed_log.bidid as viewed,pbt_project_updates.updateid,a.supplierID
   FROM pbt_project_master_gateway a
   INNER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
   LEFT OUTER JOIN bid_user_viewed_log on a.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid= 13401
   LEFT OUTER JOIN pbt_project_updates on a.bidid = pbt_project_updates.bidid and pbt_project_updates.pupdateid in (select max(pupdateid) from pbt_project_updates where pbt_project_updates.bidid = a.bidid)
   WHERE 1=1  
    and (a.paintpublishdate >= '10/1/2015' and a.paintpublishdate <= '12/31/2015') 
    and (1 <> 1 or (a.stateid in (3,2,5,4,7,8,9,10,67,11,12,13,15,16,17,14,18,19,20,24,23,21,25,26,28,27,29,33,39,35,36,37,40,31,32,41,42,44,45,49,50,51,53,54,55,57,56,58,60,59,61)) ) 
    and ppmc.tagID in (select pbt_tags.tagID from pbt_tags inner join pbt_tag_packages pt on pt.tagid = pbt_tags.tagid where pt.packageID= 1 and tag_parentID <> 0) 
    and a.verifiedpaint = 1
</cfquery>       
<cfquery datasource="#application.datasource#" name="IndCountVal">
	SELECT sum(a.minimum_value) as minimumvalue
   FROM pbt_project_master_gateway a
   INNER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
   LEFT OUTER JOIN bid_user_viewed_log on a.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid= 13401
   LEFT OUTER JOIN pbt_project_updates on a.bidid = pbt_project_updates.bidid and pbt_project_updates.pupdateid in (select max(pupdateid) from pbt_project_updates where pbt_project_updates.bidid = a.bidid)
   WHERE 1=1  
    and (a.paintpublishdate >= '10/1/2016' and a.paintpublishdate <= '12/31/2016') 
    and (1 <> 1 or (a.stateid in (3,2,5,4,7,8,9,10,67,11,12,13,15,16,17,14,18,19,20,24,23,21,25,26,28,27,29,33,39,35,36,37,40,31,32,41,42,44,45,49,50,51,53,54,55,57,56,58,60,59,61)) ) 
    and ppmc.tagID in (select pbt_tags.tagID from pbt_tags inner join pbt_tag_packages pt on pt.tagid = pbt_tags.tagid where pt.packageID= 1 and tag_parentID <> 0) 
    and a.verifiedpaint = 1
</cfquery> 
<cfquery datasource="#application.datasource#" name="commCount">
	SELECT distinct a.bidID,a.projectname,a.owner,a.ownerID,a.tags,a.submittaldate,a.city, a.state,a.stateID,a.projectsize,a.minimum_value as minimumvalue,a.maximum_value as maximumvalue,a.stage,a.stageID,a.paintpublishdate,a.zipcode,a.valuetypeID as valuetype,a.county,bid_user_viewed_log.bidid as viewed,pbt_project_updates.updateid,a.supplierID
   FROM pbt_project_master_gateway a
   INNER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
   LEFT OUTER JOIN bid_user_viewed_log on a.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid= 13401
   LEFT OUTER JOIN pbt_project_updates on a.bidid = pbt_project_updates.bidid and pbt_project_updates.pupdateid in (select max(pupdateid) from pbt_project_updates where pbt_project_updates.bidid = a.bidid)
   WHERE 1=1  
    and (a.paintpublishdate >= '10/1/2016' and a.paintpublishdate <= '12/31/2016') 
    and (1 <> 1 or (a.stateid in (3,2,5,4,7,8,9,10,67,11,12,13,15,16,17,14,18,19,20,24,23,21,25,26,28,27,29,33,39,35,36,37,40,31,32,41,42,44,45,49,50,51,53,54,55,57,56,58,60,59,61)) ) 
    and ppmc.tagID in (select pbt_tags.tagID from pbt_tags inner join pbt_tag_packages pt on pt.tagid = pbt_tags.tagid where pt.packageID= 2 and tag_parentID <> 0) 
    and a.verifiedpaint = 1
</cfquery>     
<cfquery datasource="#application.datasource#" name="commCountPriorYr">
	SELECT distinct a.bidID,a.projectname,a.owner,a.ownerID,a.tags,a.submittaldate,a.city, a.state,a.stateID,a.projectsize,a.minimum_value as minimumvalue,a.maximum_value as maximumvalue,a.stage,a.stageID,a.paintpublishdate,a.zipcode,a.valuetypeID as valuetype,a.county,bid_user_viewed_log.bidid as viewed,pbt_project_updates.updateid,a.supplierID
   FROM pbt_project_master_gateway a
   INNER JOIN pbt_project_master_cats ppmc on ppmc.bidID = a.bidID
   LEFT OUTER JOIN bid_user_viewed_log on a.bidid = bid_user_viewed_log.bidid and bid_user_viewed_log.userid= 13401
   LEFT OUTER JOIN pbt_project_updates on a.bidid = pbt_project_updates.bidid and pbt_project_updates.pupdateid in (select max(pupdateid) from pbt_project_updates where pbt_project_updates.bidid = a.bidid)
   WHERE 1=1  
    and (a.paintpublishdate >= '10/1/2015' and a.paintpublishdate <= '12/31/2015') 
    and (1 <> 1 or (a.stateid in (3,2,5,4,7,8,9,10,67,11,12,13,15,16,17,14,18,19,20,24,23,21,25,26,28,27,29,33,39,35,36,37,40,31,32,41,42,44,45,49,50,51,53,54,55,57,56,58,60,59,61)) ) 
    and ppmc.tagID in (select pbt_tags.tagID from pbt_tags inner join pbt_tag_packages pt on pt.tagid = pbt_tags.tagid where pt.packageID= 2 and tag_parentID <> 0) 
    and a.verifiedpaint = 1
</cfquery>

            
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="x_panel">
  <div class="x_title">
	<h2>Bar graph <small>Sessions</small></h2>
	<ul class="nav navbar-right panel_toolbox">
	  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
	  </li>	  
	  <li><a class="close-link"><i class="fa fa-close"></i></a>
	  </li>
	</ul>
	<div class="clearfix"></div>
  </div>
  <div class="x_content">
	<canvas id="mybarChart2"></canvas>
  </div>
</div>
</div>
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="x_panel">
  <div class="x_title">
	<h2>Bar graph <small>Sessions</small></h2>
	<ul class="nav navbar-right panel_toolbox">
	  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
	  </li>	  
	  <li><a class="close-link"><i class="fa fa-close"></i></a>
	  </li>
	</ul>
	<div class="clearfix"></div>
  </div>
  <div class="x_content">
	<canvas id="mybarChart3"></canvas>
  </div>
</div>
</div>              
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="x_panel">
  <div class="x_title">
	<h2>Industrial <small>Bids</small></h2>
	<ul class="nav navbar-right panel_toolbox">
	  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
	  </li>	  
	  <li><a class="close-link"><i class="fa fa-close"></i></a>
	  </li>
	</ul>
	<div class="clearfix"></div>
  </div>
  <cfset perPrior = (IndCount.recordcount-IndCountPriorYr.recordcount)/IndCountPriorYr.recordcount*100>
  <div class="x_content">
	<cfoutput>#IndCount.recordcount#<hr/>#round(perPrior)#% <i class="clip-arrow-<cfif perPrior gt 0>up<cfelse>down</cfif>-3"></i></cfoutput>
  </div>
</div>
</div>
</div>               
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="x_panel">
  <div class="x_title">
	<h2>Commercial <small>Bids</small></h2>
	<ul class="nav navbar-right panel_toolbox">
	  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
	  </li>
	  <li><a class="close-link"><i class="fa fa-close"></i></a>
	  </li>
	</ul>
	<div class="clearfix"></div>
  </div>
<cfset perPrior = (CommCount.recordcount-CommCountPriorYr.recordcount)/CommCountPriorYr.recordcount*100>  
  <div class="x_content">
	<cfoutput>#CommCount.recordcount#<hr />#round(perPrior)#% <i class="clip-arrow-<cfif perPrior gt 0>up<cfelse>down</cfif>-3"></i></cfoutput>
  </div>
</div>
</div>              
<div class="col-md-4 col-sm-4 col-xs-12">
<div class="x_panel">
  <div class="x_title">
	<h2>Total <small>dollars</small></h2>
	<ul class="nav navbar-right panel_toolbox">
	  <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
	  </li>
	  <li><a class="close-link"><i class="fa fa-close"></i></a>
	  </li>
	</ul>
	<div class="clearfix"></div>
  </div>  
  <div class="x_content">
	<cfoutput>#dollarformat(IndCountVal.minimumvalue)#</cfoutput>
  </div>
</div>
</div>                       
              
            <div class="clearfix"></div>
            
<cfoutput>
    <!-- jQuery -->
    <script src="#request.rootpath#assets/vendors/jquery/dist/jquery.min.js"></script>
    <!-- Bootstrap -->
    <script src="#request.rootpath#assets/vendors/bootstrap/dist/js/bootstrap.min.js"></script>
    <!-- FastClick -->
    <script src="#request.rootpath#assets/vendors/fastclick/lib/fastclick.js"></script>
    <!-- NProgress -->
    <script src="#request.rootpath#assets/vendors/nprogress/nprogress.js"></script>
    <!-- Chart.js -->
    <script src="#request.rootpath#assets/vendors/Chart.js/dist/Chart.js"></script>
      
    <script src="#request.rootpath#assets/build/js/custom.js"></script>
    </cfoutput>   
      
     <script>
 // Bar chart
			  
			if ($('#mybarChart2').length ){ 
			  
			  var ctx = document.getElementById("mybarChart2");
			  var mybarChart2 = new Chart(ctx, {
				type: 'bar',
				data: {
				  labels: ["Jan", "Feb", "Mar", "Apr", "May", "June", "July"],
				  datasets: [{
					label: '# of Votes',
					backgroundColor: "#26B99A",
					data: [56, 56, 22, 65, 33, 65, 112]
				  }, {
					label: '# of Votes',
					backgroundColor: "#03586A",
					data: [41, 56, 25, 48, 72, 34, 12]
				  }]
				},

				options: {
				  scales: {
					yAxes: [{
					  ticks: {
						beginAtZero: true
					  }
					}]
				  }
				}
			  });
			  
			} 
if ($('#mybarChart3').length ){ 
			  
			  var ctx = document.getElementById("mybarChart3");
			  var mybarChart3 = new Chart(ctx, {
				type: 'bar',
				data: {
				  labels: ["Mon", "Tue", "Wed", "Ths", "Fri", "Sat", "Sun"],
				  datasets: [{
					label: '# of Votes',
					backgroundColor: "#26B99A",
					data: [565, 56, 22, 65, 33, 65, 112]
				  }, {
					label: '# of Votes',
					backgroundColor: "#03586A",
					data: [41, 56, 25, 48, 72, 34, 12]
				  }]
				},

				options: {
				  scales: {
					yAxes: [{
					  ticks: {
						beginAtZero: true
					  }
					}]
				  }
				}
			  });
			  
			} 			  
</script>