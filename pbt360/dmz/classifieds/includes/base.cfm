<cfset expiredate = #dateformat(date - 30, "mm/dd/yy")#>
<cfset short_max = 15>
<cfset maxjobs = 50>
<cfquery name="getjobs" datasource="#application.dataSource#" cachedwithin="#createtimespan(1,0,0,0)#">
	select a.jobID, a.supplierID, a.positionID, a.stateID,  a.keyword, a.positiontitle, a.countryID, a.description,
	a.supplierID, a.location, a.dateposted, a.lastupdated, a.confidential, b.companyname,  
	d.position, e.state, f.country, c.companyname as regconame, g.employerid, a.featured_job, a.displaycompany, a.cb_did, a.cb_active
	from job_master a
	left outer join supplier_master b on b.supplierID = a.supplierID
	left outer join reg_users c on c.reg_UserID = a.reg_userID
	left outer join position d on d.positionID = a.positionID
	left outer join state_master e on e.stateID = a.stateID
	left outer join country_master f on f.countryID = a.countryID
	left outer join featured_employers g on g.supplierID = a.supplierID and g.expirationdate >=  '#dateformat(date, "m/d/yyyy")#'
	where (a.expire >  '#dateformat(date, "m/d/yyyy")#')
	and ((a.cb_did is null) or (a.cb_did is not null and a.cb_active = 1))
	and a.jobID in (select contentid from tags_log where content_typeid = 1329 and tagid = <cfqueryparam value="#siteID#" cfsqltype="cf_sql_integer">)
	order by g.employerid desc, a.featured_job desc, a.cb_active asc, a.lastupdated desc, a.dateposted desc, a.positiontitle
</cfquery>
<cfset total = getjobs.recordcount>


<cfset short_max = 15>
<cfset maxres = 50>
<cfquery name="getres" datasource="#application.dataSource#">
	select a.resumeID, a.desiredposition, a.positionID, a.updatedon, a.confidential,
	b.firstname, b.lastname, b.name, b.reg_userID, b.stateID, b.countryID, e.position, c.state, d.country
	from resume_master a
	left outer join reg_users b on b.reg_userID = a.reg_userID
	left outer join state_master c on c.stateID = b.stateID
	left outer join country_master d on d.countryID = b.countryID
	left outer join position e on e.positionID = a.positionID
	where (a.expiration > '#dateformat(date, "m/d/yyyy")#')
	order by a.updatedon desc
</cfquery>

<div class="col-sm-12">
 <div class="page-header">
  <h3>Paint and Coatings Classifieds</h3>
 </div>
</div>

<div class="row">
	<div class="col-sm-12">
		<cfif isdefined("reg_userID")>
			<a class="bold" href="http://app.paintbidtracker.com/classifieds/?reg_userID=<cfoutput>#reg_userID#</cfoutput>&fuseaction=manage">Manage your classified postings</a>
		<cfelse>
			<a href="http://app.paintbidtracker.com/classifieds/?fuseaction=resumes" target="_blank">Sign in to manage your classified postings</a>
		</cfif>
			| <a href="http://app.paintbidtracker.com/classifieds/?fuseaction=faq" target="_blank">Classifieds info and pricing</a>
			<hr size="1" noshade>          
	</div>	
</div>

<CFOUTPUT>				
<div class="row"><!-- resumes-->
	
</div>				
	
			
												
								
<div class="panel-group" id="accordion">
  <div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="##accordion" href="##collapse1" class="accordion-toggle" >
        Jobs</a>
      </h4>
    </div>
    <div id="collapse1" class="panel-collapse collapse">
      <div class="panel-body">
		<cfif getjobs.recordcount NEQ 0>
		<cfif short_max gt getjobs.recordcount><cfset short_max = getjobs.recordcount></cfif>
			<cfset full_start = #short_max#+1>
			<cfloop query="getjobs" startrow="1" endrow="#short_max#">
				<cfif supplierID is not "">
					<cfquery name="feature" datasource="#application.dataSource#" cachedwithin="#createtimespan(1,0,0,0)#">
						Select * 
						from Featured_Employers 
						where expirationdate > '#dateformat(date, "mm/dd/yy")#' 
							and supplierID = #getjobs.supplierID#
					</cfquery>
				</cfif>
				<cfquery name="featjobs" datasource="#application.dataSource#" cachedwithin="#createtimespan(1,0,0,0)#">
					select *
					from job_master
					where JobID = #getjobs.jobID# 
						and featured_job = 'y' 
						and	featuredjob_inception <= '#dateformat(date, "mm/dd/yy")#' 
						and featuredjob_expiration > '#dateformat(date, "mm/dd/yy")#'
				</cfquery>
				<cfset last1 = Left(getjobs.positiontitle, 1)>
				<cfset last2 = Right(getjobs.positiontitle, len(getjobs.positiontitle)-1)>
				<cfset newpositiontitle = #ucase(last1)# & #lcase(last2)#>						
						<cfif featjobs.recordcount is 1>
							<img src="//app.paintbidtracker.com/classifieds/images/featured_job.gif">
							<i class="clip-note"></i>						
							<a href="../../../classifieds/?fuseaction=jobs&claction=view&jobID=#getjobs.jobID#&featjob=1">#newpositiontitle#</a>
						<cfelseif getjobs.supplierID is not "" and feature.recordcount gt 0>
							<img src="//app.paintbidtracker.com/classifieds/images/featemp.GIF">
							<i class="clip-note"></i>
							<a  href="../../../classifieds/?fuseaction=jobs&claction=view&jobID=#getjobs.jobID#&feature=1">#newpositiontitle#</a>
						<cfelse>
							<i class="clip-note"></i>
							<a href="../../dmz/?action=classifieds&fuseaction=jobs&claction=view&jobID=#getjobs.jobID#">#newpositiontitle#</a>

						</cfif>
						<p>Last updated: #dateformat(lastupdated, "m/d/yyyy")#</p>
						<p><cfif confidential is not 1><cfif getjobs.displaycompany is not "">#displaycompany#<cfelseif getjobs.supplierID is not "">#companyname#<cfelse>#regconame#</cfif><cfelse>Confidential</cfif> - #location#, #state#, #country#</p>                                    

			</cfloop>
		<cfelse>					
			There are no jobs posted at this time. Please check back reguarly, as new jobs may be posted at a later date.
		</cfif>		
   
   
   	  </div>
    </div>
  </div>
  <!---<div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="##accordion" href="##collapse2" class="accordion-toggle" >
        Products and Services</a>
      </h4>
    </div>
    <div id="collapse2" class="panel-collapse collapse">
      <div class="panel-body">Lorem ipsum dolor sit amet, consectetur adipisicing elit,
      sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
      minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
      commodo consequat.</div>
    </div>
  </div>--->
  <div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="##accordion" href="##collapse3"  class="accordion-toggle" >
        Resumes</a>
      </h4>
    </div>
    <div id="collapse3" class="panel-collapse collapse">
      <div class="panel-body">
    	<cfif getres.recordcount eq 0>
		There are no resum&eacute;s posted at this time. Please check back reguarly, as new resum&eacute;s may be posted at a later date.
	<cfelse>
		<h1 class="headlines">Please <a href="#Application.rootpath#register/?fuseaction=login&r_directory=classifieds&r_fuseaction=resumes&r_action=viewall">sign-in</a> to view resum&eacute;s</h1>
		<p>(There <cfif getres.recordcount eq 1>is<cfelse>are</cfif> #getres.recordcount# resum&eacute;<cfif getres.recordcount eq 1><cfelse>s</cfif> currently available for viewing.)</p> 
	</cfif>
      </div>
    </div>
  </div>
</div>										

</CFOUTPUT>	
<style>
.panel-heading .accordion-toggle:after {
    /* symbol for "opening" panels */
    font-family: 'Glyphicons Halflings';  /* essential for enabling glyphicon */
    content: "\e114";    /* adjust as needed, taken from bootstrap.css */
    float: right;        /* adjust as needed */
    color: grey;         /* adjust as needed */
}
.panel-heading .accordion-toggle.collapsed:after {
    /* symbol for "collapsed" panels */
    content: "\e080";    /* adjust as needed, taken from bootstrap.css */
}
</style>
<script>
function runPage(){
	$('.chevyClick').click(function(_t){		 
		//$('.chevys').toggleClass('clip-chevron-right', 'clip-chevron-down');
	});
	$('.panel-heading .accordion-toggle').toggleClass('collapsed');
	//$('a.accordion-toggle').toggleClass('collapsed');
}	
   

</script>													