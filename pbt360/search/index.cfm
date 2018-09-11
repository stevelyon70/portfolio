

<cfparam default="search" name="url.action" />
<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 
<CFSET BASEDATE = #createodbcdate(now())#> 
<cfparam default="" name="url.tags" />
 <cfquery name="pull_industrial_structures" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 1 and tag_parentID = 1
	 and tag_parentID <> 0
	 order by pbt_tags.tag
 	</cfquery>    
 	<cfquery name="pull_industrial_structures_all" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 1 
	 and tag_parentID <> 0
	 order by pbt_tags.tag
 	</cfquery>
 	<cfquery name="pull_commercial_structures" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 2
	 and tag_parentID <> 0
	 order by pbt_tags.tag
 	</cfquery>    
 	<cfquery name="pull_other_structures" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID not in (1,2) and pbt_tags.tag_typeID = 1
	 and tag_parentID <> 0
	 order by pbt_tags.tag
 	</cfquery>  

 	<cfquery name="pull_gc_scopes" datasource="#application.dataSource#">
 	 select coalesce(t2.tag,pbt_tags.tag) as tag,coalesce(t2.tagID, pbt_tags.tagID) as tagid, pbt_tags.tag, pbt_tags.tagid,t2.tag, t2.tagid, t2.tag_parentID, t2.tag_typeID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 left outer join pbt_tags t2 on t2.tag_parentID = pbt_tags.tagID
	 where pt.packageID = 3 and pbt_tags.tag_typeID = 2
	 and pbt_tags.tag_parentID <> 0	 
	 order by pbt_tags.tag
	 
	 
	 --select pbt_tags.tag,pbt_tags.tagID
	 --from pbt_tags
	 --inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 ---where pt.packageID = 3 and pbt_tags.tag_typeID = 2
	 --and tag_parentID <> 0
	 --order by pbt_tags.tag
 	</cfquery> 
 	
 	<cfquery name="pull_professional_services" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 4 and pbt_tags.tag_typeID = 5
	 and tag_parentID <> 0
	 order by pbt_tags.tag
 	</cfquery> 
 	             
 	<cfquery name="pull_supply_ops" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 5 and pbt_tags.tag_typeID = 2
	 and tag_parentID <> 0
	 order by pbt_tags.tag
 	</cfquery>   
 	<cfquery name="pull_qualifications" datasource="#application.dataSource#">
 	 select pbt_tags.tag,pbt_tags.tagID
	 from pbt_tags
	 inner join pbt_tag_packages pt on pt.tagID = pbt_tags.tagID
	 where pt.packageID = 6 and pbt_tags.tag_typeID = 4
	 and tag_parentID <> 0
	 order by pbt_tags.tag
 	</cfquery> 
 

	
<cfinclude template="../template_inc/design/wrapper_top.cfm">
					<cfif not isdefined("session.packages") or listfind(session.packages, 20)>
						<div class="row">
							<div class="col-sm-3"></div>
							<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/##contact" >sales rep</a> directly.<br /><br />
								<p class="well">You are signed up for a Profiles Only account which limits access to PaintBidTracker 360 Profiles.  <a href="/contractor/?search" class="btn btn-default">Take me there</a></p>
							</div>
							<div class="col-sm-3"></div>
						</div>
					<cfelse>
					<!-- end: PAGE HEADER -->
					<!-- start: PAGE CONTENT -->
					<cftry>
					<cfswitch expression="#url.action#">
						<cfcase value="search">
							<cfinclude template="includes/search.cfm" />
						</cfcase>
						<cfcase value="searches">
							<cfinclude template="includes/searches.cfm" />
						</cfcase>
						<cfcase value="quick">
							<cfinclude template="includes/quicksearch.cfm" />
						</cfcase>
						<cfcase value="qsresults,sresults">
							<cfinclude template="includes/results.cfm" />
						</cfcase>
						<cfcase value="leads">
							<cfinclude template="includes/view_results_inc.cfm" />
						</cfcase>
						<cfcase value="lastvisit">
							<cfinclude template="includes/lastvisit_results_inc.cfm" />
						</cfcase>
						<cfcase value="planning">
							<cfinclude template="includes/projectsearch_agency_inc.cfm">
						</cfcase>
						<cfcase value="planningresults">
							<cfinclude template="includes/search_results_agency_inc.cfm">
						</cfcase>
						<cfcase value="searchresults">
							<cfinclude template="includes/search_results_inc.cfm">
						</cfcase>
						<cfcase value="53">
							<cfinclude template="includes/view_agency.cfm">
						</cfcase>
						<cfcase value="90">
							<cfinclude template="includes/contractor_awards.cfm">
						</cfcase>
						<cfcase value="design">
							<cflocation url="#request.rootpath#search/?search_history=1&action=searchresults&project_stage=3&qt=&bidid=&contractorname=&state=66&amount=1&postfrom=&postto=&subfrom=&subto=&projecttype=3&filter=or&SEARCH=SEARCH" />
							<!---<cfinclude template="includes/projectsearch_design_inc.cfm">--->
						</cfcase>
						<cfcase value="AdvNotices">
							<cflocation url="#request.rootpath#search/?search_history=1&action=searchresults&project_stage=1&qt=&bidid=&contractorname=&state=66&amount=1&postfrom=&postto=&subfrom=&subto=&projecttype=3&filter=or&SEARCH=SEARCH" />
							<!---<cfinclude template="includes/projectsearch_design_inc.cfm">--->
						</cfcase>
						<cfcase value="export">
							<cfinclude template="includes/export.cfm">
						</cfcase>
						<cfcase value="print">
							<cfinclude template="includes/print.cfm">
						</cfcase>						
						<cfcase value="dragtest">
							<cfinclude template="includes/dragtest.cfm">
						</cfcase>
						<cfdefaultcase>
you are a bad search.
						</cfdefaultcase>
					</cfswitch>
					<cfcatch><cfdump var="#cfcatch#" /></cfcatch></cftry>
							
					</cfif>
				</div>
			</div>
		</div>
		<cfinclude template="../template_inc/footer_inc.cfm">
		<cfinclude template="../template_inc/feedback.cfm">	
		<cfinclude template="../template_inc/script_inc.cfm">	
		
		
<!---		
		
		<script src="../assets/plugins/jquery-ui/jquery-ui-1.10.2.custom.min.js"></script>
		<script src="../assets/plugins/bootstrap/js/bootstrap.min.js"></script>
		<script src="../assets/plugins/bootstrap-hover-dropdown/bootstrap-hover-dropdown.min.js"></script>
		<script src="../assets/plugins/blockUI/jquery.blockUI.js"></script>
		<script src="../assets/plugins/iCheck/jquery.icheck.min.js"></script>
		<script src="../assets/plugins/perfect-scrollbar/src/jquery.mousewheel.js"></script>
		<script src="../assets/plugins/perfect-scrollbar/src/perfect-scrollbar.js"></script>
		<script src="../assets/plugins/less/less-1.5.0.min.js"></script>
		<script src="../assets/plugins/jquery-cookie/jquery.cookie.js"></script>
		<script src="../assets/plugins/bootstrap-colorpalette/js/bootstrap-colorpalette.js"></script>
		<script src="../assets/js/main.js"></script>
 <cfoutput>                       
 		<script src="#request.rootpath#assets/plugins/jquery-inputlimiter/jquery.inputlimiter.1.3.1.min.js"></script>
		<script src="#request.rootpath#assets/plugins/autosize/jquery.autosize.min.js"></script> 
		<script src="#request.rootpath#assets/plugins/select2/select2.min.js"></script>   
		<script src="#request.rootpath#assets/plugins/jQuery-Tags-Input/jquery.tagsinput.js"></script>
		<script src="#request.rootpath#assets/plugins/bootstrap-fileupload/bootstrap-fileupload.min.js"></script>
		<script src="#request.rootpath#assets/plugins/summernote/build/summernote.min.js"></script>
		<script src="#request.rootpath#assets/plugins/ckeditor/ckeditor.js"></script>
		<script src="#request.rootpath#assets/plugins/perfect-scrollbar/src/jquery.mousewheel.js"></script>
		<script src="#request.rootpath#assets/plugins/perfect-scrollbar/src/perfect-scrollbar.js"></script>
		<script src="#request.rootpath#assets/plugins/ckeditor/adapters/jquery.js"></script>
		<script src="#request.rootpath#assets/plugins/bootstrap-modal/js/bootstrap-modal.js"></script>
		<script src="#request.rootpath#assets/plugins/bootstrap-modal/js/bootstrap-modalmanager.js"></script>
		<script src="#request.rootpath#assets/plugins/jquery.maskedinput/src/jquery.maskedinput.js"></script>	
		<script src="#request.rootpath#assets/plugins/jquery-maskmoney/jquery.maskMoney.js"></script>
		<script src="#request.rootpath#assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
		<script src="#request.rootpath#assets/plugins/bootstrap-timepicker/js/bootstrap-timepicker.js"></script>
		<script src="#request.rootpath#assets/plugins/bootstrap-daterangepicker/daterangepicker.js"></script>
		<script src="#request.rootpath#assets/plugins/bootstrap-colorpicker/js/bootstrap-colorpicker.js"></script>
		<script src="#request.rootpath#assets/plugins/bootstrap-colorpalette/js/bootstrap-colorpalette.js"></script>
		<script src="#request.rootpath#assets/plugins/jQuery-Tags-Input/jquery.tagsinput.js"></script>
		<script src="#request.rootpath#assets/plugins/moment/moment.js"></script>
		<script src="#request.rootpath#assets/js/ui-modals.js"></script>
		<script type="text/javascript" src="https://cdn.datatables.net/1.10.7/js/jquery.dataTables.js"></script>
		<script type="text/javascript" src="#request.rootpath#assets/plugins/DataTables/media/js/DT_bootstrap.js"></script>
		<script src="#request.rootpath#assets/js/form-elements.js"></script>
		<script src="#request.rootpath#assets/js/table-data-agency.js"></script>
		<script src="#request.rootpath#assets/plugins/datatables/fnFilterOnReturn.js"></script>
		<script src="#request.rootpath#assets/plugins/datatables/jquery.dataTables.columnFilter.js"></script>
		<script src="#request.rootpath#assets/js/form-actions.js"></script>  
		<script src="#request.rootpath#assets/js/main.js"></script>
</cfoutput>        

--->
<!-- end: JAVASCRIPTS REQUIRED FOR THIS PAGE ONLY --> 
		<script>
			jQuery(document).ready(function() {
				try{
				Main.init();}catch(e){}
				try{
				FormElements.init();}catch(e){}
				try{
				TableData.init();}catch(e){}
				try{
				UIModals.init();}catch(e){}
		
		//hide default element
		//$( "#project_stage" ).hide();
		//$( "#structures" ).hide();
		//$( "#scopes" ).hide();
		//$( "#supply" ).hide();
		//$( "#qualifications" ).hide();
		//$( "#filter" ).hide();
		
		// set project stage toggle
		$( "#button" ).click(function() {
			$( "#project_stage" ).toggle();
			$('.minus, .add').toggle();
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
<cfinclude template="../template_inc/design/wrapper_bot.cfm">