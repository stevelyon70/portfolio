<div class="row">
	<div class="col-sm-12">
		<div id="searchText">SEARCH RESULTS [<strong>Showing Records<cfoutput> #startrow# of #endrow#</cfoutput>:</strong>
						<cfif not url.showall><cfinclude template="nextninclude_pagelinks.cfm"> </cfif><cfif search_results.recordcount is not 0><cfif not url.showall><cfoutput> | <a href="?ShowAll=Yes&userid=#userid#&tempHRef=#tempHRef#">Show All</a></cfoutput></cfif></cfif>]</div>
		<!---div id="sortBy" class="sortBy" align="right">
			<cfinclude template="sort_inc.cfm">
		</div--->
	</div>
</div>