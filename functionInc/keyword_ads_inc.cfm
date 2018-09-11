<!--- options for algorithm are
CFMX_COMPAT (default), AES, BLOWFISH, DES, and DESEDE --->
<cfset algorithm = "AES">
<!--- encoding options, Base64, hex, or uu --->
<cfset encoding = "hex">
<!---set the encrypt key--->
<cfset application.enc_key = "vXEEoqVBt94kWEI2heBLZQ==">
<!---Initialize ads--->
<cfif not isdefined("nl_versionID")><cfset nl_versionID=0></cfif>

<cfset max_spons_ads = 7>
<cfset max_pbt_ads = 4>
<cfif not isdefined("reg_userID") and isdefined("cookie.psquare")><cfset reg_userID = cookie.psquare></cfif>
<cfif not isdefined("reg_userID") and not isdefined("trackID") and isdefined("cookie.psn_user_ck") and cookie.psn_user_ck is not ""><cfset trackID = cookie.psn_user_ck></cfif>
<cfif isdefined("trackID") and trackID is not "" and (isdefined("nl_versionID") and (nl_versionid is 0 or nl_versionid gt 950))>
	<cfset trackID = URLEncodedFormat(Encrypt(trackID, application.enc_key, algorithm, encoding))>
</cfif>
<!---Create structure to hold ad details--->
<cfset pull_ads = QueryNew("companyname, nl_sponsorID, nl_adID, image_location, adname, adheadline, nl_skedID, rownumber", "varchar, integer, integer, varchar, varchar, varchar, integer, integer")>
<cfset counter=0>

<cfset day_of_week = DayOfWeek(Date)>
<!---set the week day part to identify the week range--->
<cfset weekday = DatePart("d", Date)>
<cfif weekday gte 1 and weekday lte 7>
<cfset weeknumber = 1>
<cfelseif weekday gte 8 and weekday lte 14>
<cfset weeknumber = 2>
<cfelseif weekday gte 15 and weekday lte 23>
<cfset weeknumber = 3>
<cfelseif weekday gte 24 and weekday lte 31>
<cfset weeknumber = 4>
</cfif>

<!---Pull ads matching Paint BidTracker tags - up to max_pbt_ads defined above--->
<cfif isdefined("bidID") and (isdefined("get_tags") and get_tags.recordcount gt 0)>
	<cfquery name="get_pbt_ads" datasource="#application.datasource#">
		select distinct supplier_master.companyname,nl_sponsors.nl_sponsorid,nl_sponsor_ads.nl_adid,nl_sponsor_ads.image_location,nl_sponsor_ads.adname,nl_sponsor_ads.adheadline,nl_sponsors_schedule.nl_skedID
		from nl_sponsors
		inner join nl_sponsor_ads on nl_sponsor_ads.nl_sponsorid = nl_sponsors.nl_sponsorid
		inner join nl_sponsors_schedule on nl_sponsors_schedule.nl_adid = nl_sponsor_ads.nl_adid
		inner join supplier_master on supplier_master.supplierid = nl_sponsors.supplierid
		where nl_sponsors_schedule.start_date <= #date# 
		and nl_sponsors_schedule.end_date >= #date#
		and nl_sponsors_schedule.nl_positionID = 2
		and nl_sponsors_schedule.newsletterID in (17)
		and nl_sponsor_ads.active = 'y'
		<cfif day_of_week is not 1 and day_of_week is not 7>and (nl_sponsors_schedule.dayofweek = #day_of_week# or nl_sponsors_schedule.dayofweek is null)</cfif>
		and (nl_sponsors_schedule.week_number = #weeknumber# or nl_sponsors_schedule.week_number is null)
		and nl_sponsors_schedule.nl_skedID in (select nl_skedID from nl_sponsor_schedule_tags_pbt where gatewayID = 2 and tagID in (<cfqueryparam value="#valuelist(get_tags.tagID)#" cfsqltype="cf_sql_integer" list="yes">))
		<cfif isdefined("cookie.pbt_cp")>
			and nl_sponsors.supplierid <> 9000
		</cfif>
	</cfquery>
	<!---Random sort results and add to structure--->
	<cfif get_pbt_ads.recordcount gte #max_pbt_ads#>
		<cfset tot_items = #max_pbt_ads#>
	<cfelse>
		<cfset tot_items = #get_pbt_ads.recordcount#>
	</cfif>
	<!---Make a list--->
	<cfset itemlistads = "">
	<cfloop from="1" to="#get_pbt_ads.recordCount#" index="i">
		<cfset itemlistads = ListAppend(itemlistads, i)>
	</cfloop>
	<!---Randomize the list--->
	<cfset randomItemsads = "">
	<cfset itemCount = ListLen(itemlistads)>
	<cfloop from="1" to="#itemCount#" index="i">
		<cfset random = ListGetAt(itemlistads, RandRange(1, itemCount))>
		<cfset randomItemsads = ListAppend(randomItemsads, random)>
		<cfset itemlistads = ListDeleteAt(itemlistads, ListFind(itemlistads, random))>
		<cfset itemCount = ListLen(itemlistads)>
	</cfloop>
	<!---Add to structure--->
	<cfloop from="1" to="#tot_items#" index="i">
		<cfif listfind(#valuelist(pull_ads.nl_sponsorID)#, #get_pbt_ads.nl_sponsorID[ListGetAt(randomItemsads, i)]#) eq 0>
			<cfset newRow = QueryAddRow(pull_ads, 1)>
			<cfset counter=counter+1>
			<cfset temp = QuerySetCell(pull_ads, "companyname", "#get_pbt_ads.companyname[ListGetAt(randomItemsads, i)]#", #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "nl_sponsorID", #get_pbt_ads.nl_sponsorID[ListGetAt(randomItemsads, i)]#, #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "nl_adID", #get_pbt_ads.nl_adID[ListGetAt(randomItemsads, i)]#, #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "image_location", "#get_pbt_ads.image_location[ListGetAt(randomItemsads, i)]#", #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "adname", "#get_pbt_ads.adname[ListGetAt(randomItemsads, i)]#", #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "adheadline", "#get_pbt_ads.adheadline[ListGetAt(randomItemsads, i)]#", #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "nl_skedID", #get_pbt_ads.nl_skedID[ListGetAt(randomItemsads, i)]#, #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "rownumber", "#counter#", #counter#)>
		</cfif>
	</cfloop>
</cfif>

<!---Pull ads matching a general keyword tag not already from a sponsor with an ad displaying--->
<cfif isdefined("all_rel_tags") and all_rel_tags.recordcount gt 0>
	<cfquery name="get_tag_ads" datasource="#application.datasource#">
		select distinct supplier_master.companyname,nl_sponsors.nl_sponsorid,nl_sponsor_ads.nl_adid,nl_sponsor_ads.image_location,nl_sponsor_ads.adname,nl_sponsor_ads.adheadline,nl_sponsors_schedule.nl_skedID
		from nl_sponsors
		inner join nl_sponsor_ads on nl_sponsor_ads.nl_sponsorid = nl_sponsors.nl_sponsorid
		inner join nl_sponsors_schedule on nl_sponsors_schedule.nl_adid = nl_sponsor_ads.nl_adid
		inner join supplier_master on supplier_master.supplierid = nl_sponsors.supplierid
		where nl_sponsors_schedule.start_date <= #date# 
		and nl_sponsors_schedule.end_date >= #date# 
		and nl_sponsors_schedule.nl_positionID = 2
		and nl_sponsors_schedule.newsletterID in (17)
		and nl_sponsor_ads.active = 'y'
		<cfif day_of_week is not 1 and day_of_week is not 7>and (nl_sponsors_schedule.dayofweek = #day_of_week# or nl_sponsors_schedule.dayofweek is null)</cfif>
		<cfif pull_ads.recordcount gt 0>and not nl_sponsors.nl_sponsorid in (<cfqueryparam value="#valuelist(pull_ads.nl_sponsorID)#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
		and (nl_sponsors_schedule.week_number = #weeknumber# or nl_sponsors_schedule.week_number is null)
		and nl_sponsors_schedule.nl_skedID in (select nl_skedID from nl_sponsor_schedule_tags where gatewayID = 2 and tagID in (<cfqueryparam value="#valuelist(all_rel_tags.tagID)#" cfsqltype="cf_sql_integer" list="yes">))
		<cfif isdefined("cookie.pbt_cp")>
			and nl_sponsors.supplierid <> 9000
		</cfif>
	</cfquery>
	<!---Random sort results and add to structure--->
	<cfset tot_rem = max_spons_ads - counter>
	<cfif get_tag_ads.recordcount gte #tot_rem#>
		<cfset tot_items2 = #tot_rem#>
	<cfelse>
		<cfset tot_items2 = #get_tag_ads.recordcount#>
	</cfif>
	<!---Make a list--->
	<cfset itemlistads = "">
	<cfloop from="1" to="#get_tag_ads.recordCount#" index="i">
		<cfset itemlistads = ListAppend(itemlistads, i)>
	</cfloop>
	<!---Randomize the list--->
	<cfset randomItemsads = "">
	<cfset itemCount = ListLen(itemlistads)>
	<cfloop from="1" to="#itemCount#" index="i">
		<cfset random = ListGetAt(itemlistads, RandRange(1, itemCount))>
		<cfset randomItemsads = ListAppend(randomItemsads, random)>
		<cfset itemlistads = ListDeleteAt(itemlistads, ListFind(itemlistads, random))>
		<cfset itemCount = ListLen(itemlistads)>
	</cfloop>
	<!---Add to structure--->
	<cfloop from="1" to="#tot_items2#" index="i">
		<cfif listfind(#valuelist(pull_ads.nl_sponsorID)#, #get_tag_ads.nl_sponsorID[ListGetAt(randomItemsads, i)]#) eq 0>
			<cfset newRow = QueryAddRow(pull_ads, 1)>
			<cfset counter=counter+1>
			<cfset temp = QuerySetCell(pull_ads, "companyname", "#get_tag_ads.companyname[ListGetAt(randomItemsads, i)]#", #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "nl_sponsorID", #get_tag_ads.nl_sponsorID[ListGetAt(randomItemsads, i)]#, #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "nl_adID", #get_tag_ads.nl_adID[ListGetAt(randomItemsads, i)]#, #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "image_location", "#get_tag_ads.image_location[ListGetAt(randomItemsads, i)]#", #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "adname", "#get_tag_ads.adname[ListGetAt(randomItemsads, i)]#", #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "adheadline", "#get_tag_ads.adheadline[ListGetAt(randomItemsads, i)]#", #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "nl_skedID", #get_tag_ads.nl_skedID[ListGetAt(randomItemsads, i)]#, #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "rownumber", "#counter#", #counter#)>
		</cfif>
	</cfloop>
</cfif>

<cfif counter lt max_spons_ads>
	<!---Pull ads to fill remaining spots with randomized ads from entire active pool not already from a sponsor with an ad displaying--->
	<cfquery name="get_rem_ads" datasource="#application.datasource#">
		select distinct supplier_master.companyname,nl_sponsors.nl_sponsorid,nl_sponsor_ads.nl_adid,nl_sponsor_ads.image_location,nl_sponsor_ads.adname,nl_sponsor_ads.adheadline,nl_sponsors_schedule.nl_skedID
		from nl_sponsors
		inner join nl_sponsor_ads on nl_sponsor_ads.nl_sponsorid = nl_sponsors.nl_sponsorid
		inner join nl_sponsors_schedule on nl_sponsors_schedule.nl_adid = nl_sponsor_ads.nl_adid
		inner join supplier_master on supplier_master.supplierid = nl_sponsors.supplierid
		where nl_sponsors_schedule.start_date <= #date# 
		and nl_sponsors_schedule.end_date >= #date# 
		and nl_sponsors_schedule.nl_positionID = 2
		and nl_sponsors_schedule.newsletterID in (17)
		and nl_sponsor_ads.active = 'y'
		<cfif day_of_week is not 1 and day_of_week is not 7>and (nl_sponsors_schedule.dayofweek = #day_of_week# or nl_sponsors_schedule.dayofweek is null)</cfif>
		and (nl_sponsors_schedule.week_number = #weeknumber# or nl_sponsors_schedule.week_number is null)
		<cfif pull_ads.recordcount gt 0>and not nl_sponsors.nl_sponsorid in (<cfqueryparam value="#valuelist(pull_ads.nl_sponsorID)#" cfsqltype="cf_sql_integer" list="yes">)</cfif>
		<cfif isdefined("cookie.pbt_cp")>
			and nl_sponsors.supplierid <> 9000
		</cfif>
	</cfquery>
	<!---Random sort results and add to structure--->
	<cfset tot_rem = max_spons_ads - counter>
	<cfif get_rem_ads.recordcount gte #tot_rem#>
		<cfset tot_items3 = #tot_rem#>
	<cfelse>
		<cfset tot_items3 = #get_rem_ads.recordcount#>
	</cfif>
	<!---Make a list--->
	<cfset itemlistads = "">
	<cfloop from="1" to="#get_rem_ads.recordCount#" index="i">
		<cfset itemlistads = ListAppend(itemlistads, i)>
	</cfloop>
	<!---Randomize the list--->
	<cfset randomItemsads2 = "">
	<cfset itemCount = ListLen(itemlistads)>
	<cfloop from="1" to="#itemCount#" index="i">
		<cfset random = ListGetAt(itemlistads, RandRange(1, itemCount))>
		<cfset randomItemsads2 = ListAppend(randomItemsads2, random)>
		<cfset itemlistads = ListDeleteAt(itemlistads, ListFind(itemlistads, random))>
		<cfset itemCount = ListLen(itemlistads)>
	</cfloop>
	<!---Add to structure--->
	<cfloop from="1" to="#get_rem_ads.recordCount#" index="i">
		<cfif listfind(#valuelist(pull_ads.nl_sponsorID)#, #get_rem_ads.nl_sponsorID[ListGetAt(randomItemsads2, i)]#) eq 0>
			<cfset newRow = QueryAddRow(pull_ads, 1)>
			<cfset counter=counter+1>
			<cfset temp = QuerySetCell(pull_ads, "companyname", "#get_rem_ads.companyname[ListGetAt(randomItemsads2, i)]#", #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "nl_sponsorID", #get_rem_ads.nl_sponsorID[ListGetAt(randomItemsads2, i)]#, #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "nl_adID", #get_rem_ads.nl_adID[ListGetAt(randomItemsads2, i)]#, #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "image_location", "#get_rem_ads.image_location[ListGetAt(randomItemsads2, i)]#", #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "adname", "#get_rem_ads.adname[ListGetAt(randomItemsads2, i)]#", #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "adheadline", "#get_rem_ads.adheadline[ListGetAt(randomItemsads2, i)]#", #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "nl_skedID", #get_rem_ads.nl_skedID[ListGetAt(randomItemsads2, i)]#, #counter#)>
			<cfset temp = QuerySetCell(pull_ads, "rownumber", "#counter#", #counter#)>
		</cfif>
	</cfloop>
</cfif>


<cfif pull_ads.recordCount gt 0>
	<cfif pull_ads.recordcount gte #max_spons_ads#>
		<cfset loopmaxrow = #max_spons_ads#>
	<cfelse>
		<cfset loopmaxrow = #pull_ads.recordcount#>
	</cfif>
	<!---<table width="200" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: #ffffff; BORDER-BOTTOM: #000000 1px solid; BORDER-LEFT: #000000 1px solid; PADDING-BOTTOM: 18px; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; MARGIN-BOTTOM: 18px; BORDER-TOP:  #000000 1px solid; BORDER-RIGHT: #000000 1px solid; PADDING-TOP: 0px">
				---p style="margin-top:7px; margin-bottom:7px;">
					<span style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:11px;">
						<strong><em>Category/Keyword Ads Under Development</em></strong>
					</span>
				</p>---	
			--->
				<cfloop query="pull_ads" startrow="1" endrow="#loopmaxrow#">
				<div class="col-xs-12 col-sm-4 col-md-12 col-lg-12">
					<cfoutput>
						<!---cfif currentrow is 5><cfinclude template="#rootpath#modules/comments_side_inc.cfm"></cfif--->
						<cfquery name="get_detail" datasource="#application.datasource#">
							select nl_sponsor_ads.adcontent
							from  nl_sponsor_ads 
							where nl_sponsor_ads.nl_adid = #nl_adid#
						</cfquery>
						<p style="margin-top:7px; margin-bottom:7px;">
							<span style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:11px;">
								<cfif isdefined("trackID") and trackID is not "">
								 <a href="http://www.paintsquare.com/newsletter/tracking/bid/?trackID=#trackID#&nl_moduleid=15&nl_versionid=#nl_versionid#&nl_skedid=#nl_skedID#&nl_adid=#nl_adid#&redirectid=11" target="_blank">
								<cfelseif isdefined("reg_userID") and reg_userID is not "">
								<a href="http://www.paintsquare.com/newsletter/tracking/bid/?reg_userID=#reg_userID#&nl_moduleid=15&nl_versionid=#nl_versionid#&nl_skedid=#nl_skedID#&nl_adid=#nl_adid#&redirectid=11" target="_blank">
								<cfelse>
								<a href="http://www.paintsquare.com/newsletter/tracking/bid/?nl_moduleid=15&nl_versionid=#nl_versionid#&nl_skedid=#nl_skedID#&nl_adid=#nl_adid#&redirectid=11" target="_blank">
								</cfif>
								<cfif image_location is not ""><img border="0" src="http://www.paintsquare.com/newsletter/#image_location#" alt="#companyname#"><br></cfif>
								<b>#adheadline#</b></a><br>
								<cfloop query="get_detail">#adcontent#</cfloop>
							</span>
						</p>
						<!---Record ad impression--->
						<cfquery name="impression" datasource="#application.datasource#">
							insert into nl_sponsor_site_display_log
							(nl_skedID, nl_adID, gatewayID, visitdate, remoteIP, remotehost, reg_userID, cfID, cftoken)
							values (<cfqueryparam value="#nl_skedid#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#nl_adid#" cfsqltype="cf_sql_integer">,
							2,
							<cfqueryparam value="#date#" cfsqltype="cf_sql_timestamp">,
							<cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#cgi.remote_host#" cfsqltype="cf_sql_varchar">,
							<cfif isdefined("reg_userID") and reg_userID is not ""><cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
							<cfqueryparam value="#cfid#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#cftoken#" cfsqltype="cf_sql_varchar">)
						</cfquery>
						<cfif currentrow is not #loopmaxrow#><hr size="1" color="C0C0C0" class="hidden-md"></cfif>
					</cfoutput>
				</div>
				</cfloop>
				
			<!---</td>
		</tr>
	</table>--->
</cfif>
