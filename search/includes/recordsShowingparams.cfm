<CFPARAM NAME="mystartrow" DEFAULT="1">
<CFPARAM NAME="realstartrow" DEFAULT="1">
<!-- Number of rows to display per next/back page --->
<cfset RowsPerPage = 20>
<!--- What row to start at?  Assume first by default --->
<cfparam name="URL.StartRow" Default="1" Type="Numeric">
<!---Allow for Show  All parameter in the URL --->
<cfparam name="URL.ShowAll" Type="boolean" Default="no">
<!--- We know the total number of rows from the query --->
<!---<cfset totalrows = total_results.total_returned>--->
<cfset totalrows = search_results.recordcount>
<!---Show all on page if ShowAll is passed in URL--->
<CFIF URL.ShowAll>
	<cfset Rowsperpage = TotalRows>
</cfif>
<!-- Last row is 10 rows past the starting row, or -->
<!-- total number of query rows, whichever is less -->
<cfif not isdefined("endrow")>
<cfset EndRow  = Min(URL.StartRow + RowsPerPage - 1, TotalRows)>
</cfif>
<cfif totalrows LT 20>
<cfset EndRow = totalrows>
</cfif>
<!-- Next button goes to 1 past current end row -->
<cfset StartRowNext = EndRow + 1>
<!-- Back button goes back N rows from start row -->
<cfset StartRowBack = URL.StartRow - RowsPerPage>	