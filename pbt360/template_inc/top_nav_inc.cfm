		<ul class="nav navbar-right" style="padding-top: 8px;">	
					<li class="dropdown">
						<a data-toggle="dropdown" data-hover="dropdown" class="dropdown-toggle" data-close-others="true" href="#">
							<i class="clip-list-5"></i>
							<cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn() >
								<span class="badge"> 3</span>
							</cfif>
						</a>
							<cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn() >
								<ul class="dropdown-menu todo">								
									<li>
										<span class="dropdown-menu-title"> You have 3 items on the Clipboard</span>
									</li>
								</ul>
							</cfif>
							
					</li>
						<li class="dropdown">
							<a data-toggle="dropdown" data-hover="dropdown" class="dropdown-toggle" data-close-others="true" href="#">
								<i class="clip-list-5"></i>
								<cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn() ><span class="badge"> 4</span></cfif>
							</a>
							<cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn() >
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
									<div class="ps-scrollbar-x-rail" style="width: 270px; display: none; left: 0px; bottom: 3px;"><div class="ps-scrollbar-x" style="left: 0px; width: 0px;"></div></div><div class="ps-scrollbar-y-rail" style="top: 0px; height: 250px; display: none; right: 3px;"><div class="ps-scrollbar-y" style="top: 0px; height: 0px;"></div></div></div>
								</li>
							</ul>
							</cfif>
						</li>
	<li class="dropdown">
		<a data-toggle="dropdown" data-hover="dropdown" class="dropdown-toggle" data-close-others="true" href="#">
			<i class="clip-notification-2"></i>
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

				<div class="ps-scrollbar-x-rail" style="width: 270px; display: none; left: 0px; bottom: 3px;"><div class="ps-scrollbar-x" style="left: 0px; width: 0px;"></div></div><div class="ps-scrollbar-y-rail" style="top: 0px; height: 250px; display: none; right: 3px;"><div class="ps-scrollbar-y" style="top: 0px; height: 0px;"></div></div></div>
			</li>
			<li class="view-all">
				<a href="javascript:void(0)">
					See all notifications <i class="fa fa-arrow-circle-o-right"></i>
				</a>
			</li>
		</ul>
		</cfif>
	</li>
		
		

		<!---</ul>
		<ul class="nav navbar-right" style="padding-top: 8px;">	--->				
						<li class="dropdown current-user">
							<a data-toggle="dropdown" data-hover="dropdown" class="dropdown-toggle" data-close-others="true" href="#">
								<!---img src="assets/images/avatar-1-small.jpg" class="circle-img" alt=""--->
								<span class="username"><cfoutput>  <cfif isdefined("session.auth.username") and session.auth.username NEQ "" and isUserLoggedIn() >
	#session.auth.userName#<cfelse>Guest</cfif></cfoutput></span>
								<i class="clip-chevron-down"></i>
							</a>
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
						</li>
						<!-- end: USER DROPDOWN -->
					</ul>