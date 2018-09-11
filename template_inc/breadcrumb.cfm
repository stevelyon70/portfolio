<cfset _urla = cgi.server_name & cgi.script_name & '?'>
<cfset _url = cgi.server_name & cgi.script_name & '?' & cgi.query_string>
<cfoutput>
<script>
	console.log('#_url#');
	console.log('#_urla#');
</script>
</cfoutput>
<cfparam name="dash1" default="" />
<cfparam name="dash2" default="" />
<cfif _url contains 'defaultdashboard'>
	<cfset dash1 = '<i class="fa fa-home" aria-hidden="true"></i> Dashboard'/>
	<cfset dash2 = ''/>
<cfelseif _url contains '/dmz/'>
	<cfset dash1 = '<i class="fa fa-globe" aria-hidden="true"></i> Resources'/>
	<cfset dash2 = ' #ucase(url.action)#'/>

<cfelseif _url contains '/contractor/'>
	<cfset dash1 = '<i class="fa fa-user-circle" aria-hidden="true"></i> Contractor'/>
	<cfif _url contains 'results'>
		<cfset dash2 = '<i class="fa fa-globe" aria-hidden="true"></i> Results'/>
	</cfif>
	<cfif _url contains 'supplierID'>
		<cfset dash2 = '<i class="fa fa-info" aria-hidden="true"></i> Details'/>
	</cfif>
	
<cfelseif _url contains '/agency/'>
	<cfset dash1 = '<i class="fa fa-user-circle" aria-hidden="true"></i> Agency'/>
	<cfif _url contains 'results'>
		<cfset dash2 = '<i class="fa fa-globe" aria-hidden="true"></i> Results'/>
	</cfif>
	<cfif _url contains 'supplierID'>
		<cfset dash2 = '<i class="fa fa-info" aria-hidden="true"></i> Details'/>
	</cfif>
<cfelseif _url contains '/engineer/'>
	<cfset dash1 = '<i class="fa fa-user-circle" aria-hidden="true"></i> Engineer'/>
	<cfif _url contains 'results'>
		<cfset dash2 = '<i class="fa fa-globe" aria-hidden="true"></i> Results'/>
	</cfif>
	<cfif _url contains 'engineerID'>
		<cfset dash2 = '<i class="fa fa-info" aria-hidden="true"></i> Details'/>
	</cfif>

<cfelseif _url contains '/leads/'>
	<cfset dash1 = '<i class="fa fa-search" aria-hidden="true"></i> Bids and Results' />
	<cfif _url contains 'action' and action EQ 'planning'>
		<cfset dash2 = '<i class="fa fa-globe" aria-hidden="true"></i> Capital Spending Lead Detail'/>
	<cfelse>
		<cfset dash2 = '<i class="fa fa-globe" aria-hidden="true"></i> Lead Detail'/>	
	</cfif>
<cfelseif _url contains '/myaccount/'>
	<cfset dash1 = '<i class="clip-settings" aria-hidden="true"></i> My Account' />
	
	<cfif _url contains '/email_pref'>
		<cfset dash2 = '<i class="fa fa-sticky-note-o" aria-hidden="true"></i> Email Preferences' />
	<cfelseif _url contains '/folders/index.cfm?action=searches'>	
		<cfset dash2 = '<i class="fa fa-sticky-note-o" aria-hidden="true"></i> Saved Searches' />
	<cfelseif _url contains '/folders/'>
		<cfset dash2 = '<i class="fa fa-sticky-note-o" aria-hidden="true"></i> Folders' />
	<cfelse>
		<cfset dash2 = '<i class="fa fa-sticky-note-o" aria-hidden="true"></i> Account Profile' />
	</cfif>
	

<cfelseif _url contains 'action'>
	<cfswitch expression="#url.action#">
		<cfcase value="planning">
			<cfset dash1 = '<i class="fa fa-sticky-note-o" aria-hidden="true"></i> Planning &amp; Design' />
			<cfset dash2 = ''/>
		</cfcase>
		<cfcase value="planningresults">
			<cfset dash1 = '<i class="fa fa-sticky-note-o" aria-hidden="true"></i> Planning &amp; Design' />
			<cfset dash2 = '<i class="fa fa-list-alt" aria-hidden="true"></i> Results'/>
		</cfcase>
		<cfcase value="search">
			<cfset dash1 = '<i class="fa fa-search" aria-hidden="true"></i> Bids and Results' />
			<cfset dash2 = ''/>
		</cfcase>
		<cfcase value="searchresults,sresults,qsresults,leads,lastvisit">
			<cfset dash1 = '<i class="fa fa-search" aria-hidden="true"></i> Bids and Results' />
			<cfset dash2 = '<i class="fa fa-list-alt" aria-hidden="true"></i> Results'/>
		</cfcase>
		<cfcase value="forgotpassword">
			<cfset dash1 = '<i class="fa fa-home" aria-hidden="true"></i> Forgot Password' />
			<cfset dash2 = ''/>
		</cfcase>
		<cfdefaultcase>
			<cfset dash1 = '<i class="fa fa-home" aria-hidden="true"></i> Dashboard'/>
			<cfset dash2 = ''/>
		</cfdefaultcase>
	</cfswitch>
	
<cfelseif _url contains 'brand_dashboard'>
	<cfset dash1 = '<i class="fa fa-sticky-note-o" aria-hidden="true"></i> Brand Dashboard' />
	<cfset dash2 = ''/>
<cfelseif _url contains 'brand_share'>
	<cfset dash1 = '<i class="fa fa-sticky-note-o" aria-hidden="true"></i> Specification Share Rankings' />
	<cfset dash2 = ''/>
<cfelseif _url contains 'market_letting'>
	<cfset dash1 = '<i class="fa fa-sticky-note-o" aria-hidden="true"></i> Letting Metrics' />
	<cfset dash2 = ''/>
<cfelseif _url contains 'performance'>
	<cfset dash1 = '<i class="fa fa-sticky-note-o" aria-hidden="true"></i> Market Metrics - All Industries' />
	<cfset dash2 = ''/>
<cfelseif _url contains 'performance_bridges'>
	<cfset dash1 = '<i class="fa fa-sticky-note-o" aria-hidden="true"></i> Market Metrics - Bridges &amp; Tunnels' />
	<cfset dash2 = ''/>
<cfelseif _url contains 'performance_tanks'>
	<cfset dash1 = '<i class="fa fa-sticky-note-o" aria-hidden="true"></i> Market Metrics - Tanks' />
	<cfset dash2 = ''/>
<cfelseif _url contains 'performance_waste'>
	<cfset dash1 = '<i class="fa fa-sticky-note-o" aria-hidden="true"></i> Market Metrics - Water/Waste Treatment' />
	<cfset dash2 = ''/>
</cfif>


<div class="row">
	<div class="col-sm-12">
		<nav aria-label="breadcrumb" role="navigation">
		  <ol class="breadcrumb">
			<li class="breadcrumb-item">
				<cfoutput>#dash1#</cfoutput>
			</li>
			<li class="breadcrumb-item">
				<cfoutput>#dash2#</cfoutput>
				<!--a href="/search/?action=search">Search</a-->
				</li>
		  </ol>
		</nav>

	</div>
</div>