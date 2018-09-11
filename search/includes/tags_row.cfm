	<cfoutput>
	<tr class="grid projectBid tags-row">
		<td class="grid col-xs-1"> </td>
		<td colspan="11" class="grid">
			<cfquery name="get_tags" datasource="#application.datasource#">
				select distinct pbt_project_master_cats.tagID,pbt_tags.tag
				from pbt_project_master_cats
					left outer join pbt_tags on pbt_tags.tagID = pbt_project_master_cats.tagID
					inner join site_tag_xref x on pbt_tags.tagID = x.tagID 
				where pbt_tags.active = 1 
					and pbt_project_master_cats.bidID = <cfqueryPARAM value = "#bidID#" CFSQLType = "CF_SQL_INTEGER">
					and siteID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.auth.siteID#" />
				--and pbt_tags.tag_typeID <> 9
				order by tag 
			</cfquery>
			<cfset firstset = 5>
			<cfset fshidden = 0>
			<cfset sshidden = 0>
			<cfif get_tags.recordcount LTE firstset><cfset firstset = #get_tags.recordcount#></cfif>

			<cfloop from="1" to="#firstset#" index="f">
				<cfset tagDisplay = application.tagsObj.tagDisplay(get_tags.tagID[f]) />
				<cfif tagDisplay EQ "hidden"><cfset fshidden = fshidden+1></cfif>
				<cfif not listfind(url.tags,get_tags.tagID[f])>
					<a href="?search_history=1&action=sresults&state=66&project_stage=1&project_stage=2&project_stage=3&project_stage=4&projecttype=1&tags=#get_tags.tagID[f]#">
						<span class="tags pull-left #tagDisplay#">#get_tags.tag[f]#</span>
					</a>
				<cfelse>
					<span class="tags pull-left #tagDisplay#">#get_tags.tag[f]#</span>
				</cfif>
			</cfloop>

			<cfif get_tags.recordcount GT 5>
				<span class="hidden js-#bidid#"><!---hidden --->
				<cfloop from="#firstset+1#" to="#get_tags.recordcount#" index="s">
					<cfset tagDisplay = application.tagsObj.tagDisplay(get_tags.tagID[s]) />
					<cfif tagDisplay EQ "hidden"><cfset sshidden = sshidden+1></cfif>
					<cfif not listfind(url.tags,get_tags.tagID[s])>
						<a href="?search_history=1&action=sresults&state=66&project_stage=1&project_stage=2&project_stage=3&project_stage=4&projecttype=1&tags=#get_tags.tagID[s]#">
							<span class="tags pull-left #tagDisplay#">#get_tags.tag[s]#</span>
						</a>
					<cfelse>
						<span class="tags pull-left #tagDisplay#">#get_tags.tag[s]#</span>
					</cfif>
				</cfloop>
				</span>
				<cfset leftover = get_tags.recordcount-5-fshidden-sshidden>
				<cfif leftover GT 0>
					<span class="tagstwo pull-left js-more js-more-#bidid#" data-bidid="#bidid#">show #leftover# more</span>
				</cfif>
			</cfif>
		</td>
	</tr>
	</cfoutput>