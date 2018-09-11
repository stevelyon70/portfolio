<div class="navbar navbar-inverse navbar-fixed-top">
	<div class="">
		<div class="col-sm-8 banner-logo-home">
			<button data-target=".navbar-collapse" data-toggle="collapse" class="navbar-toggle" type="button">
				<span class="clip-list-2"></span>
			</button>
			<a class="" href="<cfoutput>#request.rootpath#</cfoutput>?defaultdashboard">
			<img src="//www.paintbidtracker.com/images/PBT_Logo_WebHeader_Home_DoubleSize.png" alt="Paint BidTracker" border="0" class="img-responsive"> </a>
		</div>

		<div class="navbar-tools col-sm-4">
			<!--- TOP NAV INCLUDE --->
			<ul class="nav navbar-right" style="padding-top: 8px;">	
			
				<!-- start: TO-DO DROPDOWN -->
				<li class="dropdown clipboard">
					<a data-toggle="dropdown" data-hover="dropdown" class="dropdown-toggle" data-close-others="true" href="#">
						<!---<i class="clip-list-5"></i>--->
						<i class="fa fa-clipboard headcss" aria-hidden="true"></i>
						<cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn() >
							<span class="badge"> <span class="clipCount">0</span></span>
						</cfif>
					</a>
						<cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn() >
							<ul class="dropdown-menu todo">								
								<li>
									<span class="dropdown-menu-title"> You have <span class="clipCount">0</span> Clipboard items</span>
								</li>
								<li>
									<div class="drop-down-wrapper ps-container clipArea">
										<ul>
											<li>												
													<span class="desc" style="opacity: 1; text-decoration: none;">Name</span>
													<span class="label label-danger" style="opacity: 1;"> Project ID</span>
												
											</li>
											<li>												
													<span class="desc"> Hire developers</span>
													<span class="label label-warning"> tommorow</span>
											</li>
										</ul>									
									</div>
								</li>
								<li class="view-all">
									<a href="/myaccount/folders/?action=clip&id_mag=1">
										See Full Clipboard <i class="fa fa-arrow-circle-o-right"></i>
									</a>
								</li>
							</ul>
						</cfif>

				</li>
	<!---  TO DO ----
											add onload of the clipbord.
											add load of clip board on drop
					--->						
																																	
												<!---table id="clipboardcontent">
													<thead>
														<tr>
															<th field="name" width=140>Name</th>
															<th field="bid" width=60 align="right">Project ID</th>
														</tr>
													</thead>
												</table---><!---
				<li class="dropdown">
					<a data-toggle="dropdown" data-hover="dropdown" class="dropdown-toggle" data-close-others="true" href="#">
					<!---<i class="clip-list-5"></i>--->
					<i class="fa fa-list headcss" aria-hidden="true"></i>
					<cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn()><span class="badge"> 4</span></cfif>
					</a>
					<cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn()>
						<ul class="dropdown-menu todo">
							<li>
								<span class="dropdown-menu-title"> You have 4 pending tasks</span>
							</li>
							<li>
								<div class="drop-down-wrapper ps-container">
									<ul>
										<li>
											<a class="todo-actions" href="javascript:void(0)">
												<i class="fa fa-square-o"></i>
												<span class="desc" style="opacity: 1; text-decoration: none;">Staff Meeting</span>
												<span class="label label-danger" style="opacity: 1;"> today</span>
											</a>
										</li>
										<li>
											<a class="todo-actions" href="javascript:void(0)">
												<i class="fa fa-square-o"></i>
												<span class="desc"> Hire developers</span>
												<span class="label label-warning"> tommorow</span>
											</a>
										</li>
										<li>
											<a class="todo-actions" href="javascript:void(0)">
												<i class="fa fa-square-o"></i>
												<span class="desc">Staff Meeting</span>
												<span class="label label-warning"> tommorow</span>
											</a>
										</li>
										<li>
											<a class="todo-actions" href="javascript:void(0)">
												<i class="fa fa-square-o"></i>
												<span class="desc"> New frontend layout</span>
												<span class="label label-success"> this week</span>
											</a>
										</li>
									</ul>
								<div class="ps-scrollbar-x-rail" style="width: 270px; display: none; left: 0px; bottom: 3px;"><div class="ps-scrollbar-x" style="left: 0px; width: 0px;"></div></div><div class="ps-scrollbar-y-rail" style="top: 0px; height: 250px; display: none; right: 3px;"><div class="ps-scrollbar-y" style="top: 0px; height: 0px;"></div></div><div class="ps-scrollbar-x-rail" style="width: 270px; display: none; left: 0px; bottom: 3px;"><div class="ps-scrollbar-x" style="left: 0px; width: 0px;"></div></div><div class="ps-scrollbar-y-rail" style="top: 0px; height: 250px; display: none; right: 3px;"><div class="ps-scrollbar-y" style="top: 0px; height: 0px;"></div></div></div>
							</li>
						</ul>
					</cfif>							
				</li>
				<!-- end: TO-DO DROPDOWN -->

				<!-- start: NOTIFICATION DROPDOWN -->
				<li class="dropdown">
					<a data-toggle="dropdown" data-hover="dropdown" class="dropdown-toggle" data-close-others="true" href="#">
						<!---<i class="clip-notification-2"></i>--->
						<i class="fa fa-exclamation-triangle headcss" aria-hidden="true"></i>
						<cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn() ><span class="badge"> 5</span></cfif>
					</a>
					<cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn() >
						<ul class="dropdown-menu notifications">
							<li>
								<span class="dropdown-menu-title"> You have 5 notifications</span>
							</li>
							<li>
								<div class="drop-down-wrapper ps-container">
									<ul>
										<li>
											<a href="javascript:void(0)">
												<span class="label label-primary"><i class="fa fa-user"></i></span>
												<span class="message"> New user registration</span>
												<span class="time"> 1 min</span>
											</a>
										</li>
										<li>
											<a href="javascript:void(0)">
												<span class="label label-success"><i class="fa fa-comment"></i></span>
												<span class="message"> New comment</span>
												<span class="time"> 7 min</span>
											</a>
										</li>
										<li>
											<a href="javascript:void(0)">
												<span class="label label-success"><i class="fa fa-comment"></i></span>
												<span class="message"> New comment</span>
												<span class="time"> 8 min</span>
											</a>
										</li>
										<li>
											<a href="javascript:void(0)">
												<span class="label label-success"><i class="fa fa-comment"></i></span>
												<span class="message"> New comment</span>
												<span class="time"> 16 min</span>
											</a>
										</li>
										<li>
											<a href="javascript:void(0)">
												<span class="label label-primary"><i class="fa fa-user"></i></span>
												<span class="message"> New user registration</span>
												<span class="time"> 36 min</span>
											</a>
										</li>

								<div class="ps-scrollbar-x-rail" style="width: 270px; display: none; left: 0px; bottom: 3px;"><div class="ps-scrollbar-x" style="left: 0px; width: 0px;"></div></div><div class="ps-scrollbar-y-rail" style="top: 0px; height: 250px; display: none; right: 3px;"><div class="ps-scrollbar-y" style="top: 0px; height: 0px;"></div></div></ul><div class="ps-scrollbar-x-rail" style="width: 270px; display: none; left: 0px; bottom: 3px;"><div class="ps-scrollbar-x" style="left: 0px; width: 0px;"></div></div><div class="ps-scrollbar-y-rail" style="top: 0px; height: 250px; display: none; right: 3px;"><div class="ps-scrollbar-y" style="top: 0px; height: 0px;"></div></div></div>
							</li>
							<li class="view-all">
								<a href="javascript:void(0)">
									See all notifications <i class="fa fa-arrow-circle-o-right"></i>
								</a>
							</li>
						</ul>	
					</cfif>	
				</li>
				<!-- end: NOTIFICATION DROPDOWN -->
				
				<!-- start: EMAIL ALERT DROPDOWN -->
				<li class="dropdown">
					<a data-toggle="dropdown" data-hover="dropdown" class="dropdown-toggle" data-close-others="true" href="#">
						<i class="fa fa-envelope"></i>
						<cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn() ><span class="badge"> 5</span></cfif>
					</a>
					<cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn() >
						<ul class="dropdown-menu notifications">
							<li>
								<span class="dropdown-menu-title"> You have 5 notifications</span>
							</li>
							<li>
								<div class="drop-down-wrapper ps-container">
									<ul>
										<li>
											<a href="javascript:void(0)">
												<span class="label label-primary"><i class="fa fa-user"></i></span>
												<span class="message"> New user registration</span>
												<span class="time"> 1 min</span>
											</a>
										</li>
										<li>
											<a href="javascript:void(0)">
												<span class="label label-success"><i class="fa fa-comment"></i></span>
												<span class="message"> New comment</span>
												<span class="time"> 7 min</span>
											</a>
										</li>
										<li>
											<a href="javascript:void(0)">
												<span class="label label-success"><i class="fa fa-comment"></i></span>
												<span class="message"> New comment</span>
												<span class="time"> 8 min</span>
											</a>
										</li>
										<li>
											<a href="javascript:void(0)">
												<span class="label label-success"><i class="fa fa-comment"></i></span>
												<span class="message"> New comment</span>
												<span class="time"> 16 min</span>
											</a>
										</li>
										<li>
											<a href="javascript:void(0)">
												<span class="label label-primary"><i class="fa fa-user"></i></span>
												<span class="message"> New user registration</span>
												<span class="time"> 36 min</span>
											</a>
										</li>

								<div class="ps-scrollbar-x-rail" style="width: 270px; display: none; left: 0px; bottom: 3px;"><div class="ps-scrollbar-x" style="left: 0px; width: 0px;"></div></div><div class="ps-scrollbar-y-rail" style="top: 0px; height: 250px; display: none; right: 3px;"><div class="ps-scrollbar-y" style="top: 0px; height: 0px;"></div></div></ul><div class="ps-scrollbar-x-rail" style="width: 270px; display: none; left: 0px; bottom: 3px;"><div class="ps-scrollbar-x" style="left: 0px; width: 0px;"></div></div><div class="ps-scrollbar-y-rail" style="top: 0px; height: 250px; display: none; right: 3px;"><div class="ps-scrollbar-y" style="top: 0px; height: 0px;"></div></div></div>
							</li>
							<li class="view-all">
								<a href="javascript:void(0)">
									See all notifications <i class="fa fa-arrow-circle-o-right"></i>
								</a>
							</li>
						</ul>	
					</cfif>	
				</li>
				<!-- end: EMAIL ALERT DROPDOWN -->
				--->
				<!-- start: USER DROPDOWN -->				
				<li class="dropdown current-user">
					<a data-toggle="dropdown" data-hover="dropdown" class="dropdown-toggle" data-close-others="true" href="#">
						<span class="username">
							<cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn()>
								<cfoutput>#listfirst(session.auth.userName,'@')#</cfoutput><i class="clip-chevron-down"></i>
							<cfelse>
								Guest
							</cfif>
						</span>
					</a>
					<cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn()>
						<ul class="dropdown-menu">
							<!--<li>
								<a href="">
									<i class="clip-user-2"></i>
									&nbsp;My Profile
								</a>
							</li>-->
							<li>
								<a href="?logout=1">
									<i class="clip-exit"></i>
									&nbsp;Log Out
								</a>
							</li>
						</ul>
					</cfif>
				</li>
				<!-- end: USER DROPDOWN -->	


				<!--- END TOP NAV INCLUDE ---> 
			</ul>
			<!---
			-- start: SOCIAL MEDIA--
			<ul class="nav navbar-right" style="padding-top: 8px;">					
				<li>
					<a href="https://twitter.com/PaintBidTracker" target="_blank">
					<img src="http://app.paintbidtracker.com/images/TwitterLogo.jpg" align="texttop" border="0" class="socialNavIcons">
					</a>
				</li>
				<li>
				<a href="https://www.facebook.com/PaintBidTracker/" target="_blank">
					<img src="http://app.paintbidtracker.com/images/FBLogo.jpg" align="texttop" border="0" class="socialNavIcons">
				</a>
				</li>
				<li>
				<a href="https://www.linkedin.com/company/paint-bidtracker" target="_blank">
					<img src="/assets/images/social/In-Black-101px-R.png" align="texttop" border="0" class="socialNavIcons">
				</a>
				</li>
			</ul>				
			-- end: SOCIAL MEDIA --			
			--->

		</div>
	</div>
</div>


<script>
		var data = {"total":0,"rows":[]};
		var totalCost = 0;
		
		$(function(){

			// Quick View hover
			$(".qv").hover(function() {
				$(this).css('cursor','pointer').attr('title', 'Click for project preview');
			});

			// Quick View handler
			$(".qv").click(function(){
			  var bidID = $(this).attr('data-bidid');
			  var full = "<a href='../leads/?bidid=" + bidID + "'>View full details</a>"
			  $(".modal-body").html("Content loading please wait...  <img src='../assets/images/spinner.svg'>");
			  $(".modal-title").html("QUICK VIEW - BidID: " + bidID);

			  $(".modal-footer").html(full);		
			  $("#quickview").modal("show");
			  $(".modal-body").load('../leads/includes/quickview.cfm?bidid=' + bidID);
			});	

			$('#clipboardcontent').datagrid({
				singleSelect:true
			});
			$('.projectBid').draggable({
				revert:true,
				proxy:'clone',
				handle:'#bidHandle',
				onStartDrag:function(){
					$(this).draggable('options').cursor = 'not-allowed';
					$(this).draggable('proxy').css('z-index',10);
					$(this).draggable('proxy').css('background-color','#dce6f4');
					$('.clipboard').toggleClass('activeClip');
				},
				onStopDrag:function(){
					$(this).draggable('options').cursor='move';
					$('.clipboard').toggleClass('activeClip');
				}
			});
			$('.clipboard').droppable({
				onDragEnter:function(e,source){
					$(source).draggable('options').cursor='auto';
				},
				onDragLeave:function(e,source){
					$(source).draggable('options').cursor='not-allowed';
				},
				onDrop:function(e,source){	
					//console.log($(source));
					var bid = $(source).find('span:eq(0)').html();
					var name = $(source).find('span:eq(1)').html();
					//console.log(bid);
					//send this bid to the page to process and ad to clipboard
		//			then refresh the page and send back and load to DOMParser
					addProject(bid,name);
				}
			});
			
			clipLoad();
			
			
		});
		
		function addProject(_bid,_name){
			function add(){
				$.get( "/template_inc/getUserClipBoard.cfm?action=insert", { name: _name, bid: _bid } );
	
			}
			
			function reload(){
				clipLoad();
			}
			add();
			
			c = setTimeout(reload, 500);
		}
		function delAll(){
			//loop thru checkboxes
			//check if selected
			//run delProject
			 $( ".cliptrashBox" ).each(function() {
				 if(this.checked){
				 console.log($(this).val());
				 delProject($(this).val(), false)	 
				 }
			 });
			
			setTimeout(clipLoad, 500);
		}
		function delProject(_bid, _r){
			$.get( "/template_inc/getUserClipBoard.cfm?action=remove", { bid: _bid } );
			if (_r){
				setTimeout(clipLoad, 500);
			}
		}
	
		function clipLoad(){
			$(".clipArea").load("/template_inc/getUserClipBoard.cfm?action=get&in=<cfoutput>#now#</cfoutput>");
			clipCountLoad();
		}
	
		function clipCountLoad(){
			$(".clipCount").load("/template_inc/getUserClipBoard.cfm?action=getCount");
			
			
		}
		
	function sendProject(_bid){			
	  $(".modal-body").html("Content loading please wait...  <img src='../../assets/images/spinner.svg'>");
  	  $(".modal-title").html("Send Lead - BidID: " + _bid);	
	  $(".modal-body").load('/leads/includes/email_cf_inc.cfm?bidID=' + _bid);
	  $(".modal-footer").html();	
	  $("#clipModalPopup").modal("show");
	}
	function folderProject(_bid){
		$(".modal-body").html("Content loading please wait...  <img src='../../assets/images/spinner.svg'>");
  	  $(".modal-title").html("Save Lead - BidID: " + _bid);	
	  $(".modal-body").load('/search/includes/savetofolder_inc.cfm?projects=' + _bid);	
	  $(".modal-footer").html();	
	  $("#clipModalPopup").modal("show");	
	}
	</script>
<style>
	.banner-logo-home img {
	padding-top: 5px;
	padding-bottom: 0%;
	max-width: 350px;
	left: 15px;
	position: fixed;}	
	.iconTopPad {padding-top: 17px;}
	.socialIconTopNav{margin-left:10px;margin-right: 10px;}

	.main-container {
		top: 55px;
		position: relative;}
	.header-default .navbar {
		position: fixed!important;}
	.main-navigation{position: fixed!important;}

	.activeClip{border:2px dashed #C39F30;}
	.ui-draggable-dragging { background: red; }
</style>