<cfoutput>

<!--- This is a common include file for all Buying Guide search results page. It places links for Back and/or Next pages.
Hence it checks for the existence of any variable that can be passed by any of those pages --->
<cfset tempHRef = "">
<cfif isdefined("daterange")><cfset tempHRef = tempHRef & "&daterange=#daterange#"></cfif>
<cfif isdefined("addwords")><cfset tempHRef = tempHRef & "&addwords=#addwords#"></cfif>
<cfif isdefined("searchtext")><cfset tempHRef = tempHRef & "&searchtext=#searchtext#"></cfif>
<cfif isdefined("appear2") ><cfset tempHRef = tempHRef & "&appear2=#appear2#"></cfif>
<cfif isdefined("appear") ><cfset tempHRef = tempHRef & "&appear=#appear#"></cfif>
<cfif isdefined("title")><cfset tempHRef = tempHRef & "&title=#title#"></cfif>
<cfif isdefined("header")><cfset tempHRef = tempHRef & "&hdl=#hdl#"></cfif>
<cfif isdefined("timestamp")><cfset tempHRef = tempHRef & "&timestamp=#dateformat(timestamp)#"></cfif>
<cfif isdefined("specdate")><cfset tempHRef = tempHRef & "&specdate=#specdate#"></cfif>
<cfif isdefined("todate")><cfset tempHRef = tempHRef & "&todate=#todate#"></cfif>
<cfif isdefined("fromdate")><cfset tempHRef = tempHRef & "&fromdate=#fromdate#"></cfif>
<cfif isdefined("sort")><cfset tempHRef = tempHRef & "&sort=#sort#"></cfif>
<cfif isdefined("operator")><cfset tempHRef = tempHRef & "&operator=#operator#"></cfif>
<cfif isdefined("fuseaction")><cfset tempHRef = tempHRef & "&fuseaction=results"></cfif>
<cfif StartRowBack GT 0>
	<cfset GTHRef = "#cgi.script_name#?startrow=#StartRowBack#&rowsperpage=#rowsperpage#" & "#tempHRef#&#client.urltoken#">
	<a href="javascript:redirect('#GTHRef#')">
	<img src="#rootpath#images/browseback.gif" align="center" width="40" height="16" alt="back #rowsperpage# records" border="0">
	</a>
</cfif>
<cfif startrownext LTE TotalRows>
	<cfset LTHRef = "#cgi.script_name#?startrow=#startrownext#&rowsperpage=#rowsperpage#" & "#tempHRef#&#client.urltoken#">
	<a href="javascript:redirect('#LTHRef#')">
	<img src="#rootpath#images/browsenext.gif" align="center" width="40" height="16" alt="next #rowsperpage# records" border="0">
	</a>
</cfif>
</cfoutput>


