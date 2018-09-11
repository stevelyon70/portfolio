<cfparam default="faq" name="url.action" />
<cfset gatewayID = 2>
<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 
<CFSET BASEDATE = #createodbcdate(now())#> 
<cfinclude template="../template_inc/design/wrapper_top.cfm">
					<div class="row">
						<div class="col-sm-12">
							<!-- start: STYLE SELECTOR BOX -->
							<!---cfinclude template="template_inc/style_selector_inc.cfm"--->
							<!-- end: STYLE SELECTOR BOX -->
							<!-- start: PAGE TITLE & BREADCRUMB -->
							<!---ol class="breadcrumb">
								<li>
									<cfif isDefined("url.action")>
										<cfif url.action eq 'faq'><i class="clip-question"></i> FAQs</cfif>
										<cfif url.action eq 'news'><i class="clip-list-3"></i> News</cfif>
										<cfif url.action eq 'webinars'><i class="clip-list-3"></i> Webinars</cfif>
										<cfif url.action eq 'standards'><i class="clip-list-3"></i> Standards</cfif>
										<cfif url.action eq 'classifieds'><i class="clip-list-3"></i> Classifieds</cfif>
										<cfif url.action eq 'terms'><i class="clip-list-3"></i> Terms of Use</cfif>
										<cfif url.action eq 'privacy'><i class="clip-list-3"></i> Privacy Policy</cfif>
								    	</cfif>
									<cfif isdefined("performance") or isdefined("performance_bridges") or isdefined("performance_tanks") or isdefined("performance_waste")>
										<i class="clip-stats"></i>
										Market Performance
									<cfelseif isdefined("brand_dashboard")>
										<i class="clip-bars"></i>
										Market Specification
									<cfelseif isdefined("brand_share")>
										<i class="clip-bars"></i>
										Market Specification
									<cfelseif isdefined("market_letting")>
										<i class="clip-stats"></i>
										Market Performance
									<cfelseif isdefined("dashboard")>
										<i class="clip-home-3"></i>
										Dashboard 
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
							</ol--->
							</div--->
						</div>
					</div>
					<!-- end: PAGE HEADER -->
					<!-- start: PAGE CONTENT -->
					<cfswitch  expression="#url.action#">
						<cfcase value="faq">
							<cfinclude template="includes/faq.cfm" />
						</cfcase>
						<cfcase value="news">
							<cfinclude template="includes/news.cfm" />
						</cfcase>
						<cfcase value="newsview">
							<cfinclude template="includes/view_inc.cfm" />
						</cfcase>
						<cfcase value="webinars">
							<cfinclude template="includes/webinars.cfm" />
						</cfcase>
						<cfcase value="standards">
							<cfinclude template="standards/index.cfm" />
						</cfcase>
						<cfcase value="classifieds">
							<cfinclude template="classifieds/index.cfm" />
						</cfcase>
						<cfcase value="terms">
							<cfinclude template="includes/terms_inc.cfm" />
						</cfcase>
						<cfcase value="privacy">
							<cfinclude template="includes/privacy_inc.cfm" />
						</cfcase>
						<cfcase value="resources">
							<cfinclude template="includes/resources.cfm" />
						</cfcase>
						<cfdefaultcase>
							nothing to see here!
						</cfdefaultcase>						
					</cfswitch>
				</div>
			</div>
		</div>
		<cfinclude template="../template_inc/footer_inc.cfm">
		<cfinclude template="../template_inc/feedback.cfm">	
		<cfinclude template="../template_inc/script_inc.cfm">
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
<cfinclude template="../template_inc/design/wrapper_bot.cfm">