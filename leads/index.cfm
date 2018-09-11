


<cfparam default="detail" name="url.action" />
<cfset site_tagID = 50>
<cfset rootpath = '' />
<CFSET DATE = #CREATEODBCDATETIME(NOW())#> 
<CFSET BASEDATE = #createodbcdate(now())#> 
<cfinclude template="../template_inc/design/wrapper_top.cfm">
			<div class="row">
				<div class="col-md-8 col-lg-9">
				<cfif not isdefined("session.packages") or listfind(session.packages, 20)>
					<div class="row">
						<div class="col-sm-3"></div>
						<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/##contact" >sales rep</a> directly.<br /><br />
								<p class="well">You are signed up for a Profiles Only account which limits access to PaintBidTracker 360 Profiles.  <a href="/contractor/?search" class="btn btn-default">Take me there</a></p>
						</div>
						<div class="col-sm-3"></div>
					</div>					
				<cfelse>
					<!-- start: PAGE CONTENT -->
					<cftry>
					<cfswitch expression="#url.action#">
						<cfcase value="detail2">
							<cfinclude template="includes/detail2.cfm" />
						</cfcase>
						<cfcase value="detail">
							<cfinclude template="includes/detail.cfm" />
						</cfcase>
						<cfcase value="folder">
							<cfinclude template="../includes/folder.cfm" />
						</cfcase>
						<cfcase value="searches">
							<cfinclude template="../includes/searches.cfm" />
						</cfcase>
						<cfcase value="print">
							<cfinclude template="includes/print.cfm" />
						</cfcase>
						<cfcase value="planning">
							<cfinclude template="includes/spending.cfm" />
						</cfcase>
						<cfdefaultcase>
							lead detail
						</cfdefaultcase>
					</cfswitch>
					<cfcatch><cfdump var="#cfcatch#"/></cfcatch></cftry>
				</cfif>
					<!---https://technologypublishing.bime.io/dashboard/main_dashboard##year=#application.default_year#&quarter=#application.default_qtr#--->
					<!-- end: PAGE CONTENT-->
				</div>
			
				<div class="col-md-4 col-lg-3">
					<cftry>
						<cfinclude template="../functionInc/keyword_ads_inc.cfm">
					<cfcatch><cfdump var="#cfcatch#"/></cfcatch></cftry>
				</div>
			</div>	
			<!-- end: PAGE -->
		</div>
		<!-- end: MAIN CONTAINER -->

		<!--- start: FOOTER --->
		<cfinclude template="../template_inc/footer_inc.cfm">
		<cfinclude template="../template_inc/feedback.cfm">	
		<cfinclude template="../template_inc/script_inc.cfm">	
		<script>
			jQuery(document).ready(function() {
				Main.init();
			});
		</script>

<cfinclude template="../template_inc/design/wrapper_bot.cfm">