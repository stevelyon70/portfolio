<cfset _urla = cgi.server_name & cgi.script_name & '?'>
<cfset _url = cgi.server_name & cgi.script_name & '?' & cgi.query_string>
<cfoutput>

<cfparam default="false" name="mainDB" />
<div class="navbar-content">
				<!-- start: SIDEBAR -->
				<div class="main-navigation navbar-collapse collapse">
					<!-- start: MAIN MENU TOGGLER BUTTON -->
					<div class="navigation-toggler">
						<i class="clip-chevron-left"></i>
						<i class="clip-chevron-right"></i>
					</div>
					
					<!-- end: MAIN MENU TOGGLER BUTTON -->
					<!-- start: MAIN NAVIGATION MENU -->
					<ul class="main-navigation-menu">
						<!---<cfif _url contains '.paintbidtracker.com#request.rootpath#index.cfm?defaultdashboard' or _url is '#cgi.server_name##cgi.script_name#?'>--->
						<cfif _url contains '?defaultdashboard'>
							<cfset mainDB = true />
							<li class="active open">
						<cfelse>
							<li>
						</cfif>	
							<a href="#request.rootpath#?defaultdashboard" class="restrictLinkNav"><i class="clip-home"></i>
								<span class="title"> Dashboard</span><span class="selected"></span>
							</a>
						</li>					
						<!---cfif _url contains '.paintbidtracker.com/index.cfm?dashboard'>
							<li class="active open">
						<cfelse>
							<li>
						</cfif>	
							<a href="#request.rootpath#?dashboard"><i class="clip-home-2"></i>
								<span class="title"> Dashboard - Contrak </span><span class="selected"></span>
							</a>
						</li--->
						<li class="<cfif _url contains 'myaccount'>active open</cfif>">
							<a href="javascript:void(0)"><i class="clip-settings"></i>
								<span class="title"> My Account </span><i class="icon-arrow"></i>
								<span class="selected"></span>
							</a>
							<ul class="sub-menu">								
								<li class="<cfif _url is 'app.paintbidtracker.com/myaccount/folders/index.cfm?'>active</cfif>"><a href="#request.rootpath#myaccount/folders/" class="restrictLinkNav">
										<span class="title"> Saved Project Folders</span>
									</a></li>
								<li class="<cfif _url contains 'myaccount/folders/index.cfm?action=searches'>active</cfif>"><a href="#request.rootpath#myaccount/folders/?action=searches" class="restrictLinkNav">
										<span class="title"> Saved Searches</span>
									</a></li>
								<li class="<cfif _url contains 'myaccount/email_pref.cfm'>active</cfif>"><a href="#request.rootpath#myaccount/email_pref.cfm" class="restrictLinkNav">
										<span class="title"> Daily Email Settings</span>
									</a></li>
								<li class="<cfif _url contains 'myaccount/index.cfm'>active</cfif>"><a href="#request.rootpath#myaccount/">
										<span class="title"> Account Profile</span>
									</a></li>
							</ul>
						</li>
						<li class="<cfif _url contains 'search/index.cfm?action=search' or _url contains 'search/index.cfm?action=leads'>active open</cfif>">
							<a href="javascript:void(0);"><i class="clip-search"></i>
								<span class="title">Bids and Results </span><i class="icon-arrow"></i>
								<span class="selected"></span>
							</a>
							<ul class="sub-menu">								
								<li class="<cfif _url contains 'search/index.cfm?action=search'>active</cfif>"><a href="#request.rootpath#search/?action=search" class="restrictLinkNav">
										<span class="title"> Search Paint BidTracker</span>
									</a></li>
								<li class="<cfif _url contains 'search/index.cfm?action=leads&ltype=1'>active</cfif>"><a href="#request.rootpath#search/?action=leads&ltype=1" class="restrictLinkNav">
										<span class="title"> Active Verified Painting Industrial</span>
									</a></li>
								<li class="<cfif _url contains 'search/index.cfm?action=leads&ltype=2'>active</cfif>"><a href="#request.rootpath#search/?action=leads&ltype=2" class="restrictLinkNav">
										<span class="title"> Active Verified Painting Commercial</span>
									</a></li>
								<li class="<cfif _url contains 'search/?search_history=1&action=sresults&project_stage=7&project_stage=8&project_stage=9&state=66&amount=1&structures=14%2C8%2C21%2C17%2C20%2C79%2C16%2C11%2C13%2C70%2C19%2C18%2C24%2C10%2C23%2C9%2C12%2C74%2C73&filter=and&qt=&bidid=&contractorname=&postfrom=&postto=&subfrom=&subto=&projecttype=2&SEARCH=Search'>active</cfif>"><a href="#request.rootpath#search/?search_history=1&action=sresults&project_stage=7&project_stage=8&project_stage=9&state=66&amount=1&structures=14%2C8%2C21%2C17%2C20%2C79%2C16%2C11%2C13%2C70%2C19%2C18%2C24%2C10%2C23%2C9%2C12%2C74%2C73&filter=and&qt=&bidid=&contractorname=&postfrom=&postto=&subfrom=&subto=&projecttype=2&SEARCH=Search" class="restrictLinkNav">
										<span class="title"> Prime Painting Industrial Awards & Results</span>
									</a></li>
								<li class="<cfif _url contains 'search/index.cfm?action=sresults&project_stage=2&state=66&amount=1&structures=14%2C8%2C21%2C17%2C20%2C79%2C16%2C11%2C13%2C70%2C19%2C18%2C24%2C10%2C23%2C9%2C12%2C74%2C73&filter=and&qt=&bidid=&contractorname=&postfrom=&postto=&subfrom=&subto=&projecttype=2&SEARCH=Search'>active</cfif>"><a href="#request.rootpath#search/index.cfm?action=sresults&project_stage=2&state=66&amount=1&structures=14%2C8%2C21%2C17%2C20%2C79%2C16%2C11%2C13%2C70%2C19%2C18%2C24%2C10%2C23%2C9%2C12%2C74%2C73&filter=and&qt=&bidid=&contractorname=&postfrom=&postto=&subfrom=&subto=&projecttype=2&SEARCH=Search" class="restrictLinkNav">
										<span class="title"> Active Prime Painting Industrial</span>
									</a></li>
								<li class="<cfif _url contains 'search/index.cfm?search_history=1&action=sresults&project_stage=2&state=66&amount=1&structures=14%2C21%2C22%2C92%2C72%2C70%2C15%2C68%2C25%2C18%2C26%2C31%2C69%2C71&filter=and&qt=&bidid=&contractorname=&postfrom=&postto=&subfrom=&subto=&projecttype=2&SEARCH=Search'>active</cfif>"><a href="#request.rootpath#search/index.cfm?search_history=1&action=sresults&project_stage=2&state=66&amount=1&structures=14%2C21%2C22%2C92%2C72%2C70%2C15%2C68%2C25%2C18%2C26%2C31%2C69%2C71&filter=and&qt=&bidid=&contractorname=&postfrom=&postto=&subfrom=&subto=&projecttype=2&SEARCH=Search" class="restrictLinkNav">
										<span class="title"> Active Prime Painting Commercial</span>
									</a></li>
							
								
								<!---<li class="<cfif _url contains 'search/index.cfmaction=leads&ltype=5'>active</cfif>"><a href="#request.rootpath#search/?search_history=1&action=searchresults&project_stage=13&project_stage=7&project_stage=8&project_stage=9&qt=&bidid=&contractorname=&state=66&amount=1&postfrom=&postto=&subfrom=&subto=&projecttype=3&filter=or&SEARCH=SEARCH">
										<span class="title"> All Recent Contract<br>Awards & Results</span>
									</a></li>
								<li class="<cfif _url contains 'search/index.cfmaction=leads&ltype=4'>active</cfif>"><a href="#request.rootpath#search/?search_history=1&action=searchresults&project_stage=12&project_stage=1&project_stage=2&project_stage=3&project_stage=4&qt=&bidid=&contractorname=&state=66&amount=1&postfrom=&postto=&subfrom=&subto=&projecttype=3&filter=or&SEARCH=SEARCH">
										<span class="title"> All Active Contracts</span>
									</a></li>--->
							</ul>
						</li>
						<li class="<cfif _url contains 'search/index.cfm?action=planning' or _url contains '?action=planning' or _url contains 'search/index.cfm?search_history=1&action=searchresults&project_stage=3&qt=&bidid=&contractorname=&state=66&amount=1&postfrom=&postto=&subfrom=&subto=&projecttype=3'>active open</cfif>">
							<a href="javascript:void(0)"><i class="clip-note"></i>
								<span class="title"> Planning & Design </span><i class="icon-arrow"></i>
								<span class="selected"></span>
							</a>
							<ul class="sub-menu">								
								<li class="<cfif _url contains 'search/index.cfm?action=planning' or _url contains '?action=planning'>active</cfif>"><a href="#request.rootpath#search/?action=planning" class="restrictLinkNav">
										<span class="title"> Capital Spending Reports</span>
									</a></li>
								<li class="<cfif _url contains '.paintbidtracker.com/search/index.cfm?search_history=1&action=searchresults&project_stage=3&qt=&bidid=&contractorname=&state=66&amount=1&postfrom=&postto=&subfrom=&subto=&projecttype=3'>active</cfif>"><a href="#request.rootpath#search/?action=design" class="restrictLinkNav">
										<span class="title"> Engineering & Design Notices</span>
									</a></li>
								<li class="<cfif _url contains '.paintbidtracker.com/search/index.cfm?search_history=1&action=searchresults&project_stage=1&qt=&bidid=&contractorname=&state=66&amount=1&postfrom=&postto=&subfrom=&subto=&projecttype=3&filter=or&SEARCH=SEARCH'>active</cfif>"><a href="#request.rootpath#search/?action=AdvNotices" class="restrictLinkNav">
										<span class="title"> Advanced Notices</span>
									</a></li>
								<li><a href="javascript:void(0)">
										<span class="title"> <i>Term Contracts<br>(Coming Soon..)</i></span>
									</a></li>
							</ul>
						</li>
						<cfif isdefined("performance") or isdefined("market_letting") or isdefined("performance_bridges") or isdefined("performance_tanks") or isdefined("performance_waste")>
							<li class="active open">
						<cfelse>
							<li>
						</cfif>
							<a href="javascript:void(0)"><i class="clip-stats"></i>
								<span class="title"> Market Performance </span><i class="icon-arrow"></i>
								<span class="selected"></span>
							</a>
							<ul class="sub-menu">
								<cfif isdefined("market_letting")>
									<li class="active open">
								<cfelse>
									<li>
								</cfif>
									<a href="#request.rootpath#?market_letting">
										<span class="title">Letting Metrics</span>
									</a>
								</li>
							</ul>
							<ul class="sub-menu">
								<cfif isdefined("performance") or isdefined("performance_bridges") or isdefined("performance_tanks") or isdefined("performance_waste")>
									<li class="active open">
								<cfelse>
									<li>
								</cfif>
									<a href="javascript:;">
										Market Metrics <i class="icon-arrow"></i>
									</a>
									<ul class="sub-menu">
										<cfif isdefined("performance")>
											<li class="active open">
										<cfelse>
											<li>
										</cfif>
											<a href="#request.rootpath#?performance">
										<span class="title">All Industries</span>
									</a>
									</li>
									<cfif isdefined("performance_bridges")>
											<li class="active open">
										<cfelse>
											<li>
										</cfif>
											<a href="#request.rootpath#?performance_bridges">
												<span class="title">Bridges & Tunnels</span>
											</a>
									</li>
									<cfif isdefined("performance_tanks")>
											<li class="active open">
										<cfelse>
											<li>
										</cfif>
										<a href="#request.rootpath#?performance_tanks">
											<span class="title">Tanks</span>
										</a>
									</li>
									<cfif isdefined("performance_waste")>
											<li class="active open">
										<cfelse>
											<li>
										</cfif>
									<a href="#request.rootpath#?performance_waste">
										<span class="title">Water/Waste Treatment</span>
									</a>
								</li>
									</ul>
								</li>
							</ul>
						</li>
						<cfif isdefined("brand_dashboard") or isdefined("brand_share")>
							<li class="active open">
						<cfelse>
							<li>
						</cfif>
							<a href="javascript:void(0)"><i class="clip-bars"></i>
							
								<span class="title"> Market Specification</span><i class="icon-arrow"></i>
								<span class="selected"></span>
							</a>
							<ul class="sub-menu">
								<cfif isdefined("brand_dashboard")>
									<li class="active open">
								<cfelse>
									<li>
								</cfif>
									<a href="#request.rootpath#?brand_dashboard">
										<span class="title"> Brand Dashboard </span>
										
									</a>
								</li>
								<cfif isdefined("brand_share")>
									<li class="active open">
								<cfelse>
									<li>
								</cfif>
									<a href="#request.rootpath#?brand_share">
										<span class="title"> Specification Share Rankings </span>
									</a>
								</li>
							
								
							</ul>
						</li>
						
						<cfif _url contains "?contractor_leaderboard">		
							<li class="active open">
						<cfelse>
							<li>
						</cfif>
							<a href="javascript:void(0)"><i class="clip-airplane"></i>
								<span class="title"> Contractor Benchmarks</span><i class="icon-arrow"></i>
								<span class="selected"></span>
							</a>

							<ul class="sub-menu">
								<cfif _url contains "?contractor_leaderboard">	
									<li class="active open">
								<cfelse>
									<li>
								</cfif>
									<a href="javascript:;">
										Leaderboards <i class="icon-arrow"></i>
									</a>
								
									<ul class="sub-menu">	
									<cftry>
									<cfif session.auth.user_group NEQ 504087>
										<cfif isdefined("type") and type EQ 1>
											<li class="active open">
										<cfelse>
											<li>
										</cfif>
											<a href="#request.rootpath#contractor/?contractor_leaderboard&type=1">
											<span class="title">2017</span>
										</a>
										</li>
										<cfif isdefined("type") and type EQ 2>
											<li class="active open">
										<cfelse>
											<li>
										</cfif>
											<a href="#request.rootpath#contractor/?contractor_leaderboard&type=2">
												<span class="title">2016</span>
											</a>
										</li>
									</cfif>
									<cfcatch></cfcatch></cftry>
									<cfif isdefined("type") and type EQ 3>
											<li class="active open">
										<cfelse>
											<li>
										</cfif>
										<a href="#request.rootpath#contractor/?contractor_leaderboard&type=3">
											<span class="title">2015</span>
										</a>
									</li>
									<cfif isdefined("type") and type EQ 4>
											<li class="active open">
										<cfelse>
											<li>
										</cfif>
									<a href="#request.rootpath#contractor/?contractor_leaderboard&type=4">
										<span class="title">2014</span>
									</a>
								</li>
									</ul>
								</li>
							</ul>
						</li>
						<cfif _url contains "/contractor/" and _url does not contain "?contractor_leaderboard">
							<li class="active open">
						<cfelseif _url contains "/agency/" or _url contains "/engineer/">
							<li class="active open">
						<cfelse>
							<li>
						</cfif>
							<a href="javascript:void(0)"><i class="clip-user-5"></i>
								<span class="title"> Profiles</span><i class="icon-arrow"></i>
								<span class="selected"></span>
							</a>
							<ul class="sub-menu">
								<cfif _url contains "/contractor/" and _url does not contain "?contractor_leaderboard">
									<li class="active">
								<cfelse>
									<li>
								</cfif>
									<a href="#request.rootpath#contractor/?search">
										<span class="title"> Contractor Profiles </span>
									</a>
								</li>
							
								<cfif _url contains "/agency/">
									<li class="active">
								<cfelse>
									<li>
								</cfif>
									<!---a href="#request.rootpath#agency/?search"--->
									<a href="#request.rootpath#agency/">
										<span class="title">Agency Profiles</span>
									</a>
								</li>
								
								<cfif _url contains "/engineer/">
									<li class="active">
								<cfelse>
									<li>
								</cfif>
									<a href="#request.rootpath#engineer/">
										<span class="title">Engineer Profiles</span>
									</a>
								</li>
							</ul>
						</li>


						<!---li class="<cfif _url contains 'action=quick'>active</cfif>">
							<a href="/search/?action=quick"><i class="clip-search-2"></i>
								<span class="title"> Quick Search</span>
							</a>
						</li--->
						<li class="<cfif _url contains 'action=faq'>active</cfif>"><a href="#request.rootpath#dmz/?action=faq"><i class="clip-question"></i>
								<span class="title"> FAQs</span>
							</a></li>
						<li class="resources <cfif _url contains 'action=news' or _url contains 'action=webinars' or _url contains 'action=standards' or _url contains 'action=classifieds' or _url contains 'action=resources'>active open</cfif>"><a href="javascript:void(0)"><i class="clip-list-4"></i>
								<span class="title"> Resources</span><i class="icon-arrow"></i>
								<span class="selected"></span>
							</a>
							<ul class="sub-menu">
								<li class="<cfif _url contains 'action=news'>active</cfif>"><a href="#request.rootpath#dmz/?action=news">
										<span class="title">News</span>
									</a></li>
								<li class="<cfif _url contains 'action=webinars'>active</cfif>"><a href="#request.rootpath#dmz/?action=webinars">
										<span class="title">Webinars/Tutorials</span>
									</a></li>
								<li class="<cfif _url contains 'action=standards'>active</cfif>"><a href="#request.rootpath#dmz/?action=standards">
										<span class="title">Standards</span>
									</a></li>
								<li class="<cfif _url contains 'action=classifieds'>active</cfif>"><a href="#request.rootpath#dmz/?action=classifieds">
										<span class="title">Classifieds</span>
									</a></li>
								<li class="<cfif _url contains 'action=resources'>active</cfif>"><a href="#request.rootpath#dmz/?action=resources">
										<span class="title">Other Resources</span>
									</a></li>
								<!---<li>
									<a href="javascript:void(0)">
									<span class="title">Other Resources</span><i class="icon-arrow"></i>
									<span class="selected"></span>
									</a>									
									<ul class="sub-menu">
										<li>
											<a href="http://www.concrete.org/" target="_blank"><span class="title">American Concrete Institute</span> <i class="clip-new-tab"></i></a>
										</li>
										<li>		
											<a href="http://www.aisc.org/" target="_blank"><span class="title">American Institute of Steel Construction</span> <i class="clip-new-tab"></i></a>
										</li>
										<li>		
											<a href="http://www.awwa.org/" target="_blank"><span class="title">American Water Works Association</span> <i class="clip-new-tab"></i></a>
										</li>
										<li>
											<a href="http://www.astm.org/" target="_blank"><span class="title">ATSM International</span><i class="clip-new-tab"></i> <i class="clip-new-tab"></i></a>
										</li>
										<li>
											<a href="http://www.ecfr.gov/cgi-bin/ECFR?page=browse" target="_blank"><span class="title">Code of Federal Regulations (OSHA, EPA, DOT, Etc.)</span> <i class="clip-new-tab"></i></a>
										</li>
										<li>
											<a href="http://www.icri.org/" target="_blank"><span class="title">International Concrete Repair Institute</span> <i class="clip-new-tab"></i></a>
										</li>
										<li>
											<a href="http://www.fhwa.dot.gov/webstate.cfm" target="_blank"><span class="title">Links to State DOT Sites</span> <i class="clip-new-tab"></i></a>
										</li>
										<li>
											<a href="http://www.nace.org/" target="_blank"><span class="title">NACE International</span> <i class="clip-new-tab"></i></a>
										</li>
										<li>
											<a href="http://www.nepcoat.org/" target="_blank"><span class="title">NEPCOAT</span> <i class="clip-new-tab"></i></a>
										</li>
										<li>
											<a href="http://www.sspc.org/" target="_blank"><span class="title">The Society for Protective Coatings</span> <i class="clip-new-tab"></i></a>
										</li>	
										<li>
											<a href="http://www.trb.org/" target="_blank"><span class="title">Transportation Research Board</span> <i class="clip-new-tab"></i></a>
										</li>
										<li>
											<a href="http://www.usace.army.mil/Pages/default.aspx" target="_blank"><span class="title">US Army Corps of Engineers</span> <i class="clip-new-tab"></i></a>
										</li>
										<li>
											<a href="http://www.dol.gov/compliance/index.htm" target="_blank"><span class="title">US Department of Labor, Compliance Assistance</span> <i class="clip-new-tab"></i></a>
										</li>
										<li>
											<a href="http://www.fhwa.dot.gov/" target="_blank"><span class="title">US DOT, Federal Highway Administration</span> <i class="clip-new-tab"></i></a>
										</li>
										<li>
											<a href="http://www.sba.gov/" target="_blank"><span class="title">US Small Business Administration</span> <i class="clip-new-tab"></i></a>
										</li>									
									</ul></li>--->
								
							</ul>
						</li>
						<li class="socialLinks">
							<a href="javascript:void(0)"><i class="clip-globe"></i>
								<span class="title"> Social Media</span><i class="icon-arrow"></i>
								<span class="selected"></span>
							</a>
							<ul class="sub-menu">
								<li>							
									<a href="https://twitter.com/PaintBidTracker" target="_blank">
										<i class="fa fa-twitter"></i> <span class="title"> Twitter</span>
									</a>
								</li>
								<li>
									<a href="https://www.facebook.com/PaintBidTracker/" target="_blank">
										<i class="fa fa-facebook"></i> <span class="title"> Facebook</span>
									</a>
								</li>	
								<li>								
									<a href="https://www.linkedin.com/company/paint-bidtracker" target="_blank">
										<i class="fa fa-linkedin-square"></i> <span class="title"> LinkedIn</span>
									</a>
								</li>
								<li>								
									<a href="https://www.instagram.com/paintbidtracker360/" target="_blank">
										<i class="fa fa-instagram"></i> <span class="title"> Instagram</span>
									</a>
								</li>
								<!---<li><a href="" data-toggle="modal" data-target="##restrictModal"></a></li>--->
							</ul>
						</li>
					</ul>
					<!-- end: MAIN NAVIGATION MENU -->
				</div>
				<!-- end: SIDEBAR -->
			</div>
</cfoutput>
										
<!-- modal for restricting access -->
<cfinclude template="restrict_modal.cfm">
<cftry>
<cfif listfind(session.packages, 20)> 
	 <!---class="restrictLink"--->
<script>
$(function() {
	$(".restrictLinkNav").attr("href", "#");
    $('.restrictLinkNav').on('click', function(e){
		 e.preventDefault();		
		$("#restrictModal").modal({show: true});
	})
});												
</script>												
</cfif>
	<cfcatch></cfcatch></cftry>
<!---
<cfif #session.auth.userID# eq 14601 or #session.auth.userID# eq 15210 or #session.auth.userID# eq 2331>


<script type="text/javascript">
	/*$(document).ready(function(){
		$("#restrictModal").modal({show: true});	
	});*/
</script>
</cfif>--->