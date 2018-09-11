

<cfparam default="search" name="url.action" />
<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 
<CFSET BASEDATE = #createodbcdate(now())#> 
<cfparam default="" name="url.tags" />
	

	
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
						<cfcase value="exportAgency">
							<cfinclude template="includes/export_to_excel_agency.cfm">
						</cfcase>
						<cfcase value="print">
							<cfinclude template="includes/print.cfm">
						</cfcase>						
						<cfcase value="dragtest">
							<cfinclude template="includes/dragtest.cfm">
						</cfcase>
						<cfdefaultcase>
you are a bad search, Andy.
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