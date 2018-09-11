<!---Module - Webinars and Education main page
--->

<!---Initialize master tag query--->
<cfset all_rel_tags = QueryNew("tagid, total, featured, tag, rownumber", "integer, integer, integer, varchar, integer")>
<cfset counter=0>

<!---Queries for webinars--->
	<cfif not isdefined("fuseaction") or fuseaction is "webinar" or fuseaction is "archive">
	<cfset content_type_tagID = 42><!---For Webinar--->
	<!---All recorded webinars--->
	<cfquery name="get_archive" datasource="#application.dataSource#">
		select webinarID, title, live_date, start_time, end_time, cost, branding_image, registration_url, recording_url, meta_keywords
		from webinars
		where recording_url is not null and active = 1
		and live_date < <cfqueryparam value="#date+1#" cfsqltype="cf_sql_timestamp">
		and display_end_date > <cfqueryparam value="#date-1#" cfsqltype="cf_sql_timestamp">
		and display_start_date < <cfqueryparam value="#date+1#" cfsqltype="cf_sql_timestamp">
		and webinarID in (select contentID from tags_log where tagID = <cfqueryparam value="#site_tagID#" cfsqltype="cf_sql_integer">
		and content_typeID = <cfqueryparam value="#content_type_tagID#" cfsqltype="cf_sql_integer">)
		order by live_date desc, start_time, title
	</cfquery>
	<cfif isdefined("fuseaction") and fuseaction is "archive" and get_archive.recordcount gt 0>
		<cfset page_title = "Upcoming Paint and Coatings Webinars : Paint BidTracker">
		<cfset meta_tags = "#valuelist(get_archive.meta_keywords, ', ')#, painting webinars, painting training, paint education">						
	</cfif>
	<!---All upcoming webinars--->
	<cfquery name="get_webinars" datasource="#application.dataSource#">
		select webinarID, title, live_date, start_time, end_time, cost, branding_image, registration_url, meta_keywords
		from webinars
		where active=1
		and live_date > <cfqueryparam value="#date-1#" cfsqltype="cf_sql_timestamp">
		and display_start_date < <cfqueryparam value="#date+1#" cfsqltype="cf_sql_timestamp">
		and display_end_date > <cfqueryparam value="#date-1#" cfsqltype="cf_sql_timestamp">
		and webinarID in (select contentID from tags_log where tagID = <cfqueryparam value="#site_tagID#" cfsqltype="cf_sql_integer">
		and content_typeID = <cfqueryparam value="#content_type_tagID#" cfsqltype="cf_sql_integer">)
		<cfif get_archive.recordcount gt 0>and webinarID not in (#valuelist(get_archive.webinarID, ", ")#)</cfif>
		order by live_date, start_time, title
	</cfquery>
	<cfif isdefined("fuseaction") and fuseaction is "webinar" and get_webinars.recordcount gt 0>
		<cfset page_title = "Upcoming Paint and Coatings Webinars : Paint BidTracker">
		<cfset meta_tags = "#valuelist(get_webinars.meta_keywords, ', ')#, painting webinars, painting training, paint education">						
	</cfif>
	<!---Selected webinar detail--->
		<cfif isdefined("webinarID")>
			<cfquery name="get_webinar_detail" datasource="#application.dataSource#">
				select *
				from webinars
				where webinarID = <cfqueryparam value="#webinarID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfquery name="pull_tags_main_topic" datasource="#application.dataSource#">
				select distinct tags_log.tagid,tag,tag_typeid
				from tags_log
				inner join tags on tags.tagid = tags_log.tagid and content_typeid =42
				where contentid = <cfqueryPARAM value = "#webinarID#" CFSQLType = "CF_SQL_INTEGER">  and tag_typeid in (14)
				and active = 1
				order by tag
			</cfquery>
			<cfquery name="pull_tags_link_list" datasource="#application.dataSource#">
				select distinct tags_log.tagid,tag,tag_typeid
				from tags_log
				inner join tags on tags.tagid = tags_log.tagid and content_typeid =42
				where contentid = <cfqueryPARAM value = "#webinarID#" CFSQLType = "CF_SQL_INTEGER">  and tag_typeid in (1,4,10)
				and active = 1
				order by tag
			</cfquery>
			<cfif isdefined("fuseaction") and fuseaction is "webinar">
				<cfset page_title = "#get_webinar_detail.title# : Paint BidTracker Upcoming Webinars">
			</cfif>
			<cfif isdefined("fuseaction") and fuseaction is "archive">
				<cfset page_title = "#get_webinar_detail.title# : Paint BidTracker Archived Webinars">
			</cfif>
			<cfset meta_tags = "#get_webinar_detail.meta_keywords#, painting webinars, painting training, paint education">
			<cfset meta_description = "#get_webinar_detail.meta_description#">					
			<cfquery name="get_presenters" datasource="#application.dataSource#">
				select *
				from webinar_presenter
				where active = 1 and webinarID = <cfqueryparam value="#webinarID#" cfsqltype="cf_sql_integer">
				order by sort
			</cfquery>
			<cfquery name="get_sponsors" datasource="#application.dataSource#">
				select *
				from webinar_sponsor a
				inner join webinar_sponsor_type_definer b on b.sponsor_typeID = a.sponsor_typeID
				where a.active = 1 and a.webinarID = <cfqueryparam value="#webinarID#" cfsqltype="cf_sql_integer">
				order by b.sort, a.sort
			</cfquery>
		</cfif>
	<!---Get the related tags for webinars--->
	<cfset pull_tag_types = "1, 4, 10, 14"><!---For category, structure, company--->
	<cfquery name="pull_related_tags_webinar" datasource="#application.dataSource#">
		select distinct tags_log.tagid, count(tags_log.tagid) as total, tags.tag, tags_log.featured
		from tags_log
		inner join tags on tags.tagid = tags_log.tagid
		where content_typeid = <cfqueryparam value="#content_type_tagID#" cfsqltype="cf_sql_integer">
		and contentID in (select webinarID from webinars where active =1)
		and tag_typeid in (<cfqueryparam value="#pull_tag_types#" cfsqltype="cf_sql_integer" list="true">)
		<cfif isdefined("fuseaction") and (fuseaction is "webinar" or fuseaction is "archive")>
			<cfif isdefined("webinarID")>
				and contentid = <cfqueryparam value="#webinarID#" cfsqltype="cf_sql_integer">
			<cfelseif fuseaction is "webinar">
				<cfif get_webinars.recordcount gt 0>
					and contentid in (<cfqueryparam value="#valuelist(get_webinars.webinarid)#" cfsqltype="cf_sql_integer" list="true">)
				<cfelse>
					and 1=0
				</cfif>
			<cfelseif fuseaction is "archive">
				<cfif get_archive.recordcount gt 0>
					and contentid in (<cfqueryparam value="#valuelist(get_archive.webinarid)#" cfsqltype="cf_sql_integer" list="true">)
				<cfelse>
					and 1=0
				</cfif>
			</cfif>
		</cfif>
		group by tags_log.tagid, tags.tag, tags_log.featured
		order by total desc, tags.tag
	</cfquery>
	<!---Add the article tags to the master--->
	<cfloop query="pull_related_tags_webinar">
		<cfif listfind(#valuelist(all_rel_tags.tagid)#, #tagid#) eq 0>
			<cfset newRow = QueryAddRow(all_rel_tags, 1)>
			<cfset counter=counter+1>
			<cfset temp = QuerySetCell(all_rel_tags, "tagid", #tagid#, #counter#)>
			<cfset temp = QuerySetCell(all_rel_tags, "total", #total#, #counter#)>
			<cfset temp = QuerySetCell(all_rel_tags, "tag", "#tag#", #counter#)>
			<cfset temp = QuerySetCell(all_rel_tags, "rownumber", "#counter#", #counter#)>
			<cfif featured is 1><cfset temp = QuerySetCell(all_rel_tags, "featured", 1, #counter#)></cfif>
		<cfelse>
			<!---Add to the count of the existing row--->
			<cfquery name="find_row" dbtype="query">
				select rownumber from all_rel_tags where tagid = <cfqueryparam value="#tagid#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset temp = QuerySetCell(all_rel_tags, "total", #all_rel_tags.total#+#total#, #find_row.rownumber#)>
		</cfif>
	</cfloop>
	</cfif>

<cfoutput>
<!---Heading--->
<table border="0" cellpadding="5" cellspacing="0" width="100%">
	<tr>
		<td width="100%" align="left" valign="top" colspan="3">
			<!---Title--->
			<div align="left">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td align="left" valign="bottom">
							<h3>Paint BidTracker Webinars/Tutorials</h3><hr>
						</td>

					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>

<cfif isUserLoggedIn()>
<div class="container">

	<div class="h2">Tutorials<hr></div>
<div><spam class="h2"><i>My Account</i></span><br>
		<div class="h3">How to Update Email Preferences</div>
		<div id="vid_cont14">Loading the video player ...</div>

		
		<hr>	
	</div>
	<div><br></div>
<div><spam class="h2"><i>Dashboard</i></span><br>
		<div class="h3">How to customize your dashboard</div>
		<div id="vid_cont8">Loading the video player ...</div>

		<div class="h3">How to use the map feature on the dashboard</div>
		<div id="vid_cont10">Loading the video player ...</div>	
		<hr>	
	</div>
	

	<div><br></div>
	
	<div><spam class="h2"><i>Search Results</i></span><br>
		<div class="h3">How to narrow search results</div>
		<div id="vid_cont1">Loading the video player ...</div>	

		<div class="h3">How to reorder columns</div>
		<div id="vid_cont2">Loading the video player ...</div>

		<div class="h3">How to sort search results</div>
		<div id="vid_cont3">Loading the video player ...</div>

		<div class="h3">How to preview a project lead with the Quickview tool</div>
		<div id="vid_cont4">Loading the video player ...</div>

		<div class="h3">How to print multiple leads on a single PDF</div>
		<div id="vid_cont11">Loading the video player ...</div>	

		<div class="h3">How to save your search parameters for future use</div>
		<div id="vid_cont12">Loading the video player ...</div>

		<div class="h3">How to track project leads by saving them to a folder</div>
		<div id="vid_cont9">Loading the video player ...</div>

		<div class="h3">How to use the clipboard tool</div>
		<div id="vid_cont6">Loading the video player ...</div>	
		<hr>	
	</div>

	<div><br></div>

	<div><spam class="h2"><i>Other Functionality</i></span><br>
		<div class="h3">How to view a contractor's bidding history</div>
		<div id="vid_cont7">Loading the video player ...</div>	

		<div class="h3">How to know when project leads that you are tracking have been updated</div>
		<div id="vid_cont13">Loading the video player ...</div>	
	</div>
	<div class="h2">Webinars</div>
	<div class="h3">Paint BidTracker 360 Tutorial: An Overview of the New Layout and Features</div>
	<div id="vid_cont5">Loading the video player ...</div>
	<div><br><br></div>
	
</div>


<script type="text/javascript" src="../jwplayer/jwplayer.js"></script>

<script type="text/javascript">
	jwplayer("vid_cont1").setup({
	autostart: false,
	flashplayer: "../jwplayer/player.swf",
	file: "../dmz/files/how_to_narrow_search_results.mp4",
	height: 405,
	width: 750,
	volume: 50,
	wmode: "opaque",
	players: [
		{ type: "html5" },
		{ type: "flash", src: "../jwplayer/player.swf" }
	]
	});
	
	jwplayer("vid_cont2").setup({
	autostart: false,
	flashplayer: "../jwplayer/player.swf",
	file: "../dmz/files/how_to_reorder_columns.mp4",
	height: 405,
	width: 750,
	volume: 50,
	wmode: "opaque",
	players: [
		{ type: "html5" },
		{ type: "flash", src: "../jwplayer/player.swf" }		
	]
	});
	
	jwplayer("vid_cont3").setup({
	autostart: false,
	flashplayer: "../jwplayer/player.swf",
	file: "../dmz/files/how_to_sort_search_results.mp4",
	height: 405,
	width: 750,
	volume: 50,
	wmode: "opaque",
	players: [
		{ type: "html5" },
		{ type: "flash", src: "../jwplayer/player.swf" }
	]
	});
	
	jwplayer("vid_cont4").setup({
	autostart: false,
	flashplayer: "../jwplayer/player.swf",
	file: "../dmz/files/how_to_view_project_previews.mp4",
	height: 405,
	width: 750,
	volume: 50,
	wmode: "opaque",
	players: [
		{ type: "html5" },
		{ type: "flash", src: "../jwplayer/player.swf" }
	]
	});
	
	jwplayer("vid_cont5").setup({
	autostart: false,
	flashplayer: "../jwplayer/player.swf",
	file: "../dmz/files/360Tutorial_AnOverview.mp4",
	height: 405,
	width: 750,
	volume: 50,
	wmode: "opaque",
	players: [
		{ type: "html5" },
		{ type: "flash", src: "../jwplayer/player.swf" }
	]
	});

	jwplayer("vid_cont6").setup({
	autostart: false,
	flashplayer: "../jwplayer/player.swf",
	file: "../dmz/files/clipboard.mp4",
	height: 405,
	width: 750,
	volume: 50,
	wmode: "opaque",
	players: [
		{ type: "html5" },
		{ type: "flash", src: "../jwplayer/player.swf" }
	]
	});

	jwplayer("vid_cont7").setup({
	autostart: false,
	flashplayer: "../jwplayer/player.swf",
	file: "../dmz/files/contractor_history.mp4",
	height: 405,
	width: 750,
	volume: 50,
	wmode: "opaque",
	players: [
		{ type: "html5" },
		{ type: "flash", src: "../jwplayer/player.swf" }
	]
	});

	jwplayer("vid_cont8").setup({
	autostart: false,
	flashplayer: "../jwplayer/player.swf",
	file: "../dmz/files/dashboard.mp4",
	height: 405,
	width: 750,
	volume: 50,
	wmode: "opaque",
	players: [
		{ type: "html5" },
		{ type: "flash", src: "../jwplayer/player.swf" }
	]
	});

	jwplayer("vid_cont9").setup({
	autostart: false,
	flashplayer: "../jwplayer/player.swf",
	file: "../dmz/files/folders.mp4",
	height: 405,
	width: 750,
	volume: 50,
	wmode: "opaque",
	players: [
		{ type: "html5" },
		{ type: "flash", src: "../jwplayer/player.swf" }
	]
	});

	jwplayer("vid_cont10").setup({
	autostart: false,
	flashplayer: "../jwplayer/player.swf",
	file: "../dmz/files/map.mp4",
	height: 405,
	width: 750,
	volume: 50,
	wmode: "opaque",
	players: [	
		{ type: "html5" },	
		{ type: "flash", src: "../jwplayer/player.swf" }
	]
	});

	jwplayer("vid_cont11").setup({
	autostart: false,
	flashplayer: "../jwplayer/player.swf",
	file: "../dmz/files/printing_pdf.mp4",
	height: 405,
	width: 750,
	volume: 50,
	wmode: "opaque",
	players: [
		{ type: "html5" },
		{ type: "flash", src: "../jwplayer/player.swf" }
	]
	});

	jwplayer("vid_cont12").setup({
	autostart: false,
	flashplayer: "../jwplayer/player.swf",
	file: "../dmz/files/saved_searches.mp4",
	height: 405,
	width: 750,
	volume: 50,
	wmode: "opaque",
	players: [
		{ type: "html5" },
		{ type: "flash", src: "../jwplayer/player.swf" }
	]
	});

	jwplayer("vid_cont13").setup({
	autostart: false,
	flashplayer: "../jwplayer/player.swf",
	file: "../dmz/files/updates_revised.mp4",
	height: 405,
	width: 750,
	volume: 50,
	wmode: "opaque",
	players: [
		{ type: "html5" },
		{ type: "flash", src: "../jwplayer/player.swf" }
	]
	})
	
	jwplayer("vid_cont14").setup({
	autostart: false,
	flashplayer: "../jwplayer/player.swf",
	file: "../dmz/files/email_settings.mp4",
	height: 405,
	width: 750,
	volume: 50,
	wmode: "opaque",
	players: [
		{ type: "html5" },
		{ type: "flash", src: "../jwplayer/player.swf" }
	]
	});
</script>
<cfelse>
<div class="h4 text-alert well">Tutorials are only available to subscribers.  Please login to your account.</div>
</cfif>
<!---Body--->
<!---table border="0" cellpadding="5" cellspacing="0" width="100%">
	<tr>
		<td>
			<p style="margin-bottom: 18px;">Paint BidTracker periodically hosts webinars on training, new site features, general Q&A, and other topics that help you get the most out of the valuable information provided through a Paint BidTracker subscription.</p>
		</td>
	</tr>
</table--->     
<table border="0" cellpadding="5" cellspacing="0" width="100%">
	<tr>
		<!--Left column-->
		<cfif get_webinars.recordcount gt 0>
		<td valign="top" width="49%">
			<cfoutput>
<table width="100%"  border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="50%" valign="bottom">
						<h1><a class="bold" href="#rootpath#webinars/?fuseaction=webinar">Upcoming Webinars</a></h1>
						<hr class="PBTsmall" noshade>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%">
			<div align="center">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<!---Set max rows for short, default list--->
				<cfset short_max = 5>
				<cfif short_max gt get_webinars.recordcount><cfset short_max = get_webinars.recordcount></cfif>
				<cfset full_start = short_max + 1>
				<cfif get_webinars.recordcount gt 0>
				<cfloop query="get_webinars" startrow="1" endrow="#short_max#">
					<!---Pull presenter(s) and sponsor(s)--->
					<cfquery name="get_presenters" datasource="#application.dataSource#">
						select presenter, title, company
						from webinar_presenter
						where active = 1 and webinarID = <cfqueryparam value="#webinarID#" cfsqltype="cf_sql_integer">
						order by sort
					</cfquery>
					<cfquery name="get_sponsors" datasource="#application.dataSource#">
						select a.sponsor
						from webinar_sponsor a
						inner join webinar_sponsor_type_definer b on b.sponsor_typeID = a.sponsor_typeID
						where a.active = 1 and a.webinarID = <cfqueryparam value="#webinarID#" cfsqltype="cf_sql_integer">
						order by b.sort, a.sort
					</cfquery>
					<tr>
						<td width="100%">
						<cfif branding_image is not "">
						<a href="#rootpath#webinars/?fuseaction=webinar&action=view&webinarID=#webinarID#">
						<img src="http://www.paintsquare.com/education/branding_images/#branding_image#" border="0" alt="#title#; Sponsored by #valuelist(get_sponsors.sponsor, " and ")#" height="100px" width="100px" align="left">
						</a>
						</cfif>
						<h1 class="headlines" style="margin-bottom: 0">
						<a href="#rootpath#webinars/?fuseaction=webinar&action=view&webinarID=#webinarID#" class="bold">#title#</a></h1>
						<p style="margin-top: 0; margin-bottom: 6">
						#dateformat(live_date,"dddd, mmmm d, yyyy")#;
						#timeformat(start_time, "h:mm tt")#-#timeformat(end_time, "h:mm tt")# Eastern;
						Cost: <cfif cost is "">FREE<cfelse>$#cost#</cfif><br><a href="#registration_url#" target="_blank">Register now</a>
						<!---br><br><cfif get_presenters.recordcount gt 0>Presented by
						<cfloop query="get_presenters"><cfif currentrow is #get_presenters.recordcount# and get_presenters.recordcount gt 2>; and
						<cfelseif currentrow is #get_presenters.recordcount# and get_presenters.recordcount gt 1> and
						<cfelseif get_presenters.recordcount gt 2 and currentrow gt 1>; </cfif>#presenter#<cfif title is not "">, #title#</cfif><cfif company is not "">, #company#</cfif></cfloop></cfif--->
						<br><br>
						<cfif get_webinars.recordcount gt 1><hr></cfif>
						</p>                                  
						</td>
					</tr>
				</cfloop>
				<cfelse>
					<tr>
						<td width="100%">
						<p style="margin-top: 0; margin-bottom: 6">
						There are no upcoming webinars to display, but please check back later.
						</p>                                 
						</td>
					</tr>
				</cfif>
			</table>
			</div>                              
		</td>
	</tr>
	<tr>
		<td width="100%">
			<cfif get_webinars.recordcount gt #short_max#>
				<!---Call to script--->
				<script language="javascript">toggle(getObject('get_webinarsadd'), 'get_webinars_link');</script>		
				<!---Add rest of list to short list, initially hidden--->
				<div id="get_webinarsadd" style="display:none">
				<cfloop query="get_webinars" startrow="#full_start#" endrow="#get_webinars.recordcount#">   
					<!---Pull presenter(s) and sponsor(s)--->
					<cfquery name="get_presenters" datasource="#application.dataSource#">
						select presenter, title, company
						from webinar_presenter
						where active = 1 and webinarID = <cfqueryparam value="#webinarID#" cfsqltype="cf_sql_integer">
						order by sort
					</cfquery>
					<cfquery name="get_sponsors" datasource="#application.dataSource#">
						select a.sponsor
						from webinar_sponsor a
						inner join webinar_sponsor_type_definer b on b.sponsor_typeID = a.sponsor_typeID
						where a.active = 1 and a.webinarID = <cfqueryparam value="#webinarID#" cfsqltype="cf_sql_integer">
						order by b.sort, a.sort
					</cfquery>
					<cfquery name="get_sponsor_image" datasource="#application.dataSource#" maxrows="1">
						select a.sponsor_logo
						from webinar_sponsor a
						inner join webinar_sponsor_type_definer b on b.sponsor_typeID = a.sponsor_typeID
						where a.active = 1 and a.webinarID = <cfqueryparam value="#webinarID#" cfsqltype="cf_sql_integer">
						order by b.sort, a.sort
					</cfquery>
					<cfif branding_image is not "">
						<a href="#rootpath#webinars/?fuseaction=webinar&action=view&webinarID=#webinarID#">
						<img src="http://www.paintsquare.com/education/branding_images/#branding_image#" border="0" alt="#title#; Sponsored by #valuelist(get_sponsors.sponsor, " and ")#" height="100px" width="100px" align="left">
						</a>
						</cfif>
						<h1 class="headlines" style="margin-bottom: 0">
						<a href="#rootpath#webinars/?fuseaction=webinar&action=view&webinarID=#webinarID#" class="bold">#title#</a></h1>
						<p style="margin-top: 0; margin-bottom: 6">
						#dateformat(live_date,"dddd, mmmm d, yyyy")#;
						#timeformat(start_time, "h:mm tt")#-#timeformat(end_time, "h:mm tt")# Eastern;
						Cost: <cfif cost is "">FREE<cfelse>$#cost#</cfif><br><a href="#registration_url#" target="_blank">Register now</a>
						<!---br><br><cfif get_presenters.recordcount gt 0>Presented by
						<cfloop query="get_presenters"><cfif currentrow is #get_presenters.recordcount# and get_presenters.recordcount gt 2>; and
						<cfelseif currentrow is #get_presenters.recordcount# and get_presenters.recordcount gt 1> and
						<cfelseif get_presenters.recordcount gt 2 and currentrow gt 1>; </cfif>#presenter#<cfif title is not "">, #title#</cfif><cfif company is not "">, #company#</cfif></cfloop></cfif--->
						<br><br>
						<hr> 
				</cfloop>
				</div>
				<!---Toggle link if short list maxes out and more results to display--->
				<p align="right"><a title="expand/collapse" id="get_webinars_link" href="javascript: void(0);" 
				onclick="toggle(this, 'get_webinarsadd');"  style="text-decoration: none; color: ##000000; ">See more</a>
				&nbsp;<img src="#rootpath#images/yellowtriangle.jpg" border="0"></p>
			</cfif>                            
		</td>
	</tr>
	<tr>
		<td>
			&nbsp;<br>
			&nbsp;                            
		</td>
	</tr>
</table>
</cfoutput>

		</td>
		</cfif>
		<cfif get_webinars.recordcount gt 0 and get_archive.recordcount gt 0>
		<!---Spacer column--->
		<td width="2%">
		</td>
		</cfif>
		<cfif get_archive.recordcount gt 0>
		<!---Right column--->
		<td valign="top" width="49%">
			<cfoutput>
<table width="100%"  border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="50%" valign="bottom">
						<h1><a class="bold" href="#rootpath#webinars/?fuseaction=archive">Webinar Recordings / Archives</a></h1>
						<hr class="PBTsmall" noshade>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%">
			<div align="center">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<!---Set max rows for short, default list--->
				<cfset short_max = 5>
				<cfif short_max gt get_archive.recordcount><cfset short_max = get_archive.recordcount></cfif>
				<cfset full_start = short_max + 1>
				<cfif get_archive.recordcount gt 0>
				<cfloop query="get_archive" startrow="1" endrow="#short_max#">
					<!---Pull presenter(s) and sponsor(s)--->
					<cfquery name="get_presenters" datasource="#application.dataSource#">
						select presenter, title, company
						from webinar_presenter
						where active = 1 and webinarID = <cfqueryparam value="#webinarID#" cfsqltype="cf_sql_integer">
						order by sort
					</cfquery>
					<cfquery name="get_sponsors" datasource="#application.dataSource#">
						select a.sponsor
						from webinar_sponsor a
						inner join webinar_sponsor_type_definer b on b.sponsor_typeID = a.sponsor_typeID
						where a.active = 1 and a.webinarID = <cfqueryparam value="#webinarID#" cfsqltype="cf_sql_integer">
						order by b.sort, a.sort
					</cfquery>
					<tr>
						<td width="100%">
						<cfif branding_image is not "">
						<a href="#rootpath#webinars/?fuseaction=archive&action=view&webinarID=#webinarID#">
						<img src="http://www.paintsquare.com/education/branding_images/#branding_image#" border="0" alt="#title#; Sponsored by #valuelist(get_sponsors.sponsor, " and ")#" height="100px" width="100px" align="left">
						</a>
						</cfif>
						<h1 class="headlines" style="margin-bottom: 0">
						<a href="#rootpath#webinars/?fuseaction=archive&action=view&webinarID=#webinarID#" class="bold">#title#</a></h1>
						<p style="margin-top: 0; margin-bottom: 6">
						Originally presented on #dateformat(live_date,"dddd, mmmm d, yyyy")#. <!---cfif get_presenters.recordcount gt 0>by
						<cfloop query="get_presenters"><cfif currentrow is #get_presenters.recordcount# and get_presenters.recordcount gt 2>; and
						<cfelseif currentrow is #get_presenters.recordcount# and get_presenters.recordcount gt 1> and
						<cfelseif get_presenters.recordcount gt 2 and currentrow gt 1>; </cfif>#presenter#<cfif title is not "">, #title#</cfif><cfif company is not "">, #company#</cfif></cfloop></cfif>
						| ---><br><a href="#rootpath#webinars/?fuseaction=archive&action=view&webinarID=#webinarID#">Watch recording</a>
						<br><br>
						<cfif get_archive.recordcount gt 1><hr></cfif>
						</p>                                  
						</td>
					</tr>
				</cfloop>
				<cfelse>
					<tr>
						<td width="100%">
						<p style="margin-top: 0; margin-bottom: 6">
						No archived/recorded webinars to display.
						</p>                                 
						</td>
					</tr>
				</cfif>
			</table>
			</div>                              
		</td>
	</tr>
	<tr>
		<td width="100%">
			<cfif get_archive.recordcount gt #short_max#>
				<!---Call to script--->
				<script language="javascript">toggle(getObject('get_archiveadd'), 'get_archive_link');</script>		
				<!---Add rest of list to short list, initially hidden--->
				<div id="get_archiveadd" style="display:none">
				<cfloop query="get_archive" startrow="#full_start#" endrow="#get_archive.recordcount#">   
					<!---Pull presenter(s) and sponsor(s)--->
					<cfquery name="get_presenters" datasource="#application.dataSource#">
						select presenter, title, company
						from webinar_presenter
						where active = 1 and webinarID = <cfqueryparam value="#webinarID#" cfsqltype="cf_sql_integer">
						order by sort
					</cfquery>
					<cfquery name="get_sponsors" datasource="#application.dataSource#">
						select a.sponsor
						from webinar_sponsor a
						inner join webinar_sponsor_type_definer b on b.sponsor_typeID = a.sponsor_typeID
						where a.active = 1 and a.webinarID = <cfqueryparam value="#webinarID#" cfsqltype="cf_sql_integer">
						order by b.sort, a.sort
					</cfquery>
					<cfquery name="get_sponsor_image" datasource="#application.dataSource#" maxrows="1">
						select a.sponsor_logo
						from webinar_sponsor a
						inner join webinar_sponsor_type_definer b on b.sponsor_typeID = a.sponsor_typeID
						where a.active = 1 and a.webinarID = <cfqueryparam value="#webinarID#" cfsqltype="cf_sql_integer">
						order by b.sort, a.sort
					</cfquery>
					<cfif branding_image is not "">
						<a href="#rootpath#webinars/?fuseaction=webinar&action=view&webinarID=#webinarID#">
						<img src="http://www.paintsquare.com/education/branding_images/#branding_image#" border="0" alt="#title#; Sponsored by #valuelist(get_sponsors.sponsor, " and ")#" height="100px" width="100px" align="left">
						</a>
						</cfif>
						<h1 class="headlines" style="margin-bottom: 0">
						<a href="#rootpath#webinars/?fuseaction=archive&action=view&webinarID=#webinarID#" class="bold">#title#</a></h1>
						<p style="margin-top: 0; margin-bottom: 6">
						Originally presented on #dateformat(live_date,"dddd, mmmm d, yyyy")#. <!---cfif get_presenters.recordcount gt 0>by
						<cfloop query="get_presenters"><cfif currentrow is #get_presenters.recordcount# and get_presenters.recordcount gt 2>; and
						<cfelseif currentrow is #get_presenters.recordcount# and get_presenters.recordcount gt 1> and
						<cfelseif get_presenters.recordcount gt 2 and currentrow gt 1>; </cfif>#presenter#<cfif title is not "">, #title#</cfif><cfif company is not "">, #company#</cfif></cfloop></cfif>
						| ---><br><a href="#rootpath#webinars/?fuseaction=archive&action=view&webinarID=#webinarID#">Watch recording</a>
						<br><br>
						<cfif get_archive.recordcount gt 1><hr></cfif>
						</p>   
				</cfloop>
				</div>
				<!---Toggle link if short list maxes out and more results to display--->
				<p align="right"><a title="expand/collapse" id="get_archive_link" href="javascript: void(0);" 
				onclick="toggle(this, 'get_archiveadd');"  style="text-decoration: none; color: ##000000; ">See more</a>
				&nbsp;<img src="#rootpath#images/yellowtriangle.jpg" border="0"></p>
			</cfif>                            
		</td>
	</tr>
	<tr>
		<td>
			&nbsp;<br>
			&nbsp;                            
		</td>
	</tr>
</table>
</cfoutput>

		</td>
		</cfif>
		<cfif get_webinars.recordcount is 0 and get_archive.recordcount is 0>
		<!---Message if empty
		<td>
			There no webinars currently scheduled nor archived, but please check back soon.
		</td>--->
		</cfif>
		
	</tr>
</table>
</cfoutput>
	