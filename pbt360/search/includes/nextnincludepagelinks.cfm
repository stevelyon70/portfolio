<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!---
*************
-updated on 5/9/06 by ty: added quicksearch to variables so page does not error when using pagelink buttons.
*************
--->

<!---Simple "Page" counter, starting at first "Page" --->

<cfoutput>


<cfset tempHRef = "">
<cfif isdefined("quicksearch")><cfset tempHRef = tempHRef & "&quicksearch=#quicksearch#"></cfif>
<cfif isdefined("daterange")><cfset tempHRef = tempHRef & "&daterange=#daterange#"></cfif>
<cfif isdefined("addwords")><cfset tempHRef = tempHRef & "&addwords=#addwords#"></cfif>
<cfif isdefined("searchtext")><cfset tempHRef = tempHRef & "&searchtext=#searchtext#"></cfif>
<cfif isdefined("appear") ><cfset tempHRef = tempHRef & "&appear2=#appear2#"></cfif>
<cfif isdefined("appear2") ><cfset tempHRef = tempHRef & "&appear=#appear#"></cfif>
<cfif isdefined("title")><cfset tempHRef = tempHRef & "&title=#title#"></cfif>
<cfif isdefined("header")><cfset tempHRef = tempHRef & "&hdl=#hdl#"></cfif>
<cfif isdefined("timestamp")><cfset tempHRef = tempHRef & "&timestamp=#dateformat(timestamp)#"></cfif>
<cfif isdefined("specdate")><cfset tempHRef = tempHRef & "&specdate=#specdate#"></cfif>
<cfif isdefined("todate")><cfset tempHRef = tempHRef & "&todate=#todate#"></cfif>
<cfif isdefined("fromdate")><cfset tempHRef = tempHRef & "&fromdate=#fromdate#"></cfif>
<cfif isdefined("sort")><cfset tempHRef = tempHRef & "&sort=#sort#"></cfif>
<cfif isdefined("operator")><cfset tempHRef = tempHRef & "&operator=#operator#"></cfif>
<!---Simple "Page" counter, starting at first "Page" --->
<cfset ThisPage= 1>
<cfif TotalRows GT RowsPerPage>
	<font size="1">Page&nbsp;
	<!---Loop thru row numbers, in increments of RowsPerPage--->
	<cfloop from="1" to="#TotalRows#" Step="#RowsPerPage#" index="PageRow">
		<!---Detect whether this "Page" currently being viewed--->
		<cfset IsCurrentPage = (PageRow GTE URL.StartRow) AND (PageRow LTE EndRow)>
		<!---if this "page" is current page, show without link--->
		<cfif IsCurrentPage>
		  <B>#ThisPage#</b>
		  <!---Otherwise, show link so user can go to page--->
		<cfelse>
			<cfset ThisHRef = "#cgi.script_name#?fuseaction=searchresults&StartRow=#PageRow#&rowsperpage=#rowsperpage#" & "#tempHRef#">
			<a href="#ThisHRef#"><font color="blue" size="1"><u>#ThisPage#</u></font></a>
		</cfif>
	
		<!---Increment ThisPage variable--->
		<cfset thispage = thispage + 1>
	</cfloop>

	<!--- Show All Link --->
	<cfset ThisHRef = "#cgi.script_name#?fuseaction=searchresults&ShowAll=Yes" & "#tempHRef#">
	<a href="#ThisHRef#"><font color="blue" size="1"><u>Show All</u></font></a>
</cfif>

</cfoutput>

