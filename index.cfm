<cfinclude template="template_inc/design/wrapper_top.cfm">
					
					
					<cftry>
					<cfoutput>
					<div class="BIframe" id="BIframeID">
					<cfif not isdefined("session.packages") or listfind(session.packages, 20)>
						<div class="row">
							<div class="col-sm-3"></div>
							<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/##contact" >sales rep</a> directly.<br /><br />
								<p class="well">You are signed up for a Profiles Only account which limits access to PaintBidTracker 360 Profiles.  <a href="/contractor/?search" class="btn btn-default">Take me there</a></p>
							</div>
							<div class="col-sm-3"></div>
						</div>
						<cflocation url="/contractor/?search" />
					<cfelse>
					<cfif isdefined("performance")><br />
					<cfif not listfind(session.packages, 19)>
						<div class="row">
							<div class="col-sm-3"></div>
							<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/##contact" >sales rep</a> directly.
							</div>
							<div class="col-sm-3"></div>
						</div>
					<cfelse>
							<cfinclude template="bime/marketPerformanceAwards.cfm" />
						<cfif session.auth.userid eq 14601 or session.auth.userid eq 15210>
							<!--img src="/bime/placeholders/market metrics - all 1.png" /-->
						</cfif>
						
					</cfif>
						<cfelseif isdefined("performance_bridges")><br />
					<cfif not listfind(session.packages, 19)>
						<div class="row">
							<div class="col-sm-3"></div>
							<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/##contact" >sales rep</a> directly.
							</div>
							<div class="col-sm-3"></div>
						</div>
					<cfelse>
							<cfinclude template="bime/marketPerformanceAwardsBridges.cfm" />
						<cfif session.auth.userid eq 14601 or session.auth.userid eq 15210>
							<!--img src="/bime/placeholders/market metrics - bridges .png" /-->
						</cfif>
							
					</cfif>
						<cfelseif isdefined("performance_tanks")><br />
					<cfif not listfind(session.packages, 19)>
						<div class="row">
							<div class="col-sm-3"></div>
							<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/##contact" >sales rep</a> directly.
							</div>
							<div class="col-sm-3"></div>
						</div>
					<cfelse>
							<cfinclude template="bime/marketPerformanceAwardsTanks.cfm" />
						<cfif session.auth.userid eq 14601 or session.auth.userid eq 15210>
							<!--img src="/bime/placeholders/market metrics - tanks.png" /-->
						</cfif>
					</cfif>
						<cfelseif isdefined("performance_waste")><br />
					<cfif not listfind(session.packages, 19)>
						<div class="row">
							<div class="col-sm-3"></div>
							<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/##contact" >sales rep</a> directly.
							</div>
							<div class="col-sm-3"></div>
						</div>
					<cfelse>
							<cfinclude template="bime/marketPerformanceAwardsWater.cfm" />
						<cfif session.auth.userid eq 14601 or session.auth.userid eq 15210>
						<!--img src="/bime/placeholders/market metrics - water.png" /-->	
						</cfif>					
					</cfif>
					<cfelseif isdefined("brand_dashboard")><br />
					<cfif not listfind(session.packages, 19)>
						<div class="row">
							<div class="col-sm-3"></div>
							<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/##contact" >sales rep</a> directly.
							</div>
							<div class="col-sm-3"></div>
						</div>
					<cfelse>
						<cfif session.auth.userid eq 14601 or session.auth.userid eq 15210>
						<cfinclude template="bime/brand.cfm" />
						</cfif>	
						<img src="/bime/placeholders/brand dash.png" />
					</cfif>
						<cfelseif isdefined("brand_share")><br />
					<cfif not listfind(session.packages, 19)>
						<div class="row">
							<div class="col-sm-3"></div>
							<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/##contact" >sales rep</a> directly.
							</div>
							<div class="col-sm-3"></div>
						</div>
					<cfelse>
							<cfinclude template="bime/specShare.cfm" />
						<cfif session.auth.userid eq 14601 or session.auth.userid eq 15210>
						<!--img src="/bime/placeholders/spec share ranks.png" /-->	
						</cfif>					
					</cfif>
					<cfelseif isdefined("value")><br />
					<cfif not listfind(session.packages, 19)>
						<div class="row">
							<div class="col-sm-3"></div>
							<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/##contact" >sales rep</a> directly.
							</div>
							<div class="col-sm-3"></div>
						</div>
					<cfelse>
						<iframe  frameBorder="0" seamless id="frame1" name="frame1" scroll="no" onload="document.getElementById('loadImg').style.display='none';"
					        src="https://html5.bimeapp.com/technologypublishing/9C5309C56E66CE5C239805BCDB549061?access_token=#session.auth.user_access_token#"></iframe>
					</cfif>
					<cfelseif isdefined("market_letting")><br />
					<cfif not listfind(session.packages, 19)>
						<div class="row">
							<div class="col-sm-3"></div>
							<div class="h4 col-sm-6 lead">We're sorry, this content is not available with your current subscription.To gain access, please email us at <a href="mailto:sales@paintbidtracker.com">sales@paintbidtracker.com</a> or contact your Paint BidTracker <a href="http://www.paintbidtracker.com/info/##contact" >sales rep</a> directly.
							</div>
							<div class="col-sm-3"></div>
						</div>
					<cfelse>
						<img src="/bime/placeholders/letting metrics.png" />
					</cfif>
					<cfelseif mainDB><br /><!-- pbt dash -->
						<cfinclude template="template_inc/pbtdash.cfm" />
					<cfelse><br />
					<!-- contrak -->
						<cfinclude template="template_inc/pbtdash.cfm" />
						<!---<
						<cfinclude template="/functionInc/dashboard/mainCharts.cfm" />--->
					</cfif>	
					</cfif>
					</div>				
					</cfoutput>
					<cfcatch>" />
						<CFMAIL SUBJECT="issue alert" FROM="PaintBidtracker@paintsquare.com" to="slyon@technologypub.com" type="html">
							<cfdump var="#cfcatch#" />
						</cfmail>
						</cfcatch></cftry>
				</div>
			</div>
		</div>
		<cfinclude template="template_inc/footer_inc.cfm">
		<cfinclude template="template_inc/feedback.cfm">		
		<cfinclude template="template_inc/script_inc.cfm">
		
		<script>
			jQuery(document).ready(function() {								
				try{					
					
					$('.dashClose').on('click', function(x){												
						addToTrash($(this).parent().parent().parent().attr('id'));
						hideDashBox($(this).parent().parent().parent());						
						loadTrash();
					});	
					
					
					loadTrash();
					FormElements.init();
				}catch(e){
					console.log(e);
				}
				//alert(localStorage.navState);
				try{Main.init();}catch(r){console.log(r);}
				
				
			});
			var hideDashBox = function(_this){
				_this.hide();
			}
			var addToTrash = function(_this){
				localStorage.setItem(_this, 1);
			}
			var delFromTrash = function(_this){
				localStorage.setItem(_this, 0);
				loadTrash();
			}
			var loadTrash = function(){
				var clearBut = '<a href="javascript:void(0);" onclick="clearAll();" class="btn btn-danger">Restore All</a>';
				$('.dashboxTrashbin').html('');
				$('.dashboxTrashbin').append(clearBut);
				$('.dashbox').each(function(i,obj){
					//alert(localStorage.getItem($(this).attr('id')));
					if(localStorage.getItem($(this).attr('id')) == 1){	
						_title = $(this).find('.dashboxTitle').html();
						_span = _title.indexOf('<span');
						_textTitle = _title.substring(0,_span);
						_textTitleLinkBox = '<span class="trashBinBox btn" onclick="boxRestore('+$(this).attr('id')+')" dataID="'+$(this).attr('id')+'">' + _textTitle + '<i class="clip-arrow-up"></i></span>';
						$('.dashboxTrashbin').append(_textTitleLinkBox);						
						hideDashBox($(this));
					}								
				});
			}
			var clearAll = function(){
				localStorage.clear();
				$('.dashbox').each(function(i,obj){
					$(this).show();
				});
				loadTrash();
			}
			var boxRestore = function(_this){				
				$(_this).show();
				delFromTrash($(_this).attr('id'));
			}
		</script>
<cfinclude template="template_inc/design/wrapper_bot.cfm">		