
<cfsilent>
<cfinclude template="user_trash.cfm">
<cfinclude template="search_results_excel_format.cfm">
</cfsilent>
<!--- Create new spreadsheet --->
       <cfset ProjectDir = spreadsheetNew()>
       <cfset project_file = #GetTempFile(GetTempDirectory(),"testFile")#>
        <!--- Create header row --->
        <cfset SpreadsheetAddRow(ProjectDir, "BidID, Project Name, Stage, Agency, City, State, Relevant Tags, Submittal Date, Estimated Value, Project Size, Bidder1, Bidder1Amount, Bidder2, Bidder2Amount, Bidder3, Bidder3Amount")>
        
        <!--- Set column widths --->
        <cfset SpreadSheetSetColumnWidth(ProjectDir,1,10)> 
        <cfset SpreadSheetSetColumnWidth(ProjectDir,2,25)> 

        <!--- Format column 1 --->
        <cfset formatProjectDir = structnew()>
        <cfset formatProjectDir.bold = "true">
        <cfset formatProjectDir.alignment = "left">
        <cfset SpreadsheetFormatRow(ProjectDir, formatProjectDir, 1)>
        
        <!--- Add orders from query --->
        <cfset SpreadsheetAddRows(ProjectDir,projectQuery)>
        
        <!--- Save spreadsheet --->
        <cflock name="ProjectList" timeout="20" type="exclusive">
            <cfspreadsheet action="write"
                name="ProjectDir"
                filename="#project_file#"
                overwrite="true">

            <!--- Open / Download Spreadsheet File --->
            <cfheader    name="Content-Disposition" 
                        value="inline; filename=paintbidtracker_projects.xls">
            <cfcontent    type="application/csv" 
                        file="#project_file#" 
                        deletefile="yes"> 
        </cflock>