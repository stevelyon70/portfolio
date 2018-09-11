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
						<!---<div class="row">--->
						<cftry><cfinclude template="top_nav_inc.cfm"><cfcatch><cfdump var="#cfcatch#" /></cfcatch></cftry>				
							<div class="col-sm-6 navbar-right iconTopPad">
								<div class="socialIconTopNav pull-left">
									<a href="https://twitter.com/PaintBidTracker" target="_blank" >
									<img src="http://app.paintbidtracker.com/images/TwitterLogo.jpg" align="texttop" border="0" class="socialNavIcons">
									</a>
								</div>
								<div class="socialIconTopNav pull-left">
								<a href="https://www.facebook.com/PaintBidTracker/" target="_blank" >
									<img src="http://app.paintbidtracker.com/images/FBLogo.jpg"  align="texttop" border="0" class="socialNavIcons">
								</a>
								</div>
								<div class="socialIconTopNav pull-left">
								<a href="https://www.linkedin.com/company/paint-bidtracker" target="_blank" >
									<img src="<cfoutput>#request.rootpath#</cfoutput>assets/images/social/In-Black-101px-R.png"  align="texttop" border="0" class="socialNavIcons">
								</a>
								</div>
							</div>
						<!---</div>--->					
					</div>				
				</div>
		</div>
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
				top: 50px;
				position: relative;}
			.header-default .navbar {
			    position: fixed!important;}
			.main-navigation{position: fixed!important;}
		</style>