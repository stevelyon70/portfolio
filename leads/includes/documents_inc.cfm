<cfset accessKeyId = "AKIAIT7QGBVAFGU4GTOA">
<cfset secretAccessKey = "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">
<cfset s3 = createObject("component","amazons3.s3").init(accessKeyId,secretAccessKey)>
<cfset variables.exp_date = dateadd("d",-90,date)>
	<table cellpadding="2" cellspacing="1" border="0">
	<tr>
		<td width="173">File Name</td>
		<td width="173">Document Type</td>
		<td width="130">Date Posted</td>
		<td width="130">Size</td>
	</tr>
	<cfloop query="listDocuments">
		 <CFINVOKE COMPONENT="FileSizeText" 
                METHOD="getText" 
                RETURNVARIABLE="outText">
        
                <CFINVOKEARGUMENT NAME="size"
                        VALUE="#file_size#">
        </CFINVOKE>
		<cfoutput>
		<cfset key = "#onviarefnum#/#doc_filename#">
		<cfset timedLink = s3.getObject("docs.paintbidtracker.com",key)>
	<tr>
		<td width="173"><cfif date_received GT exp_date><a href="#timedLink#" target="_blank"><font color="blue" size="2" face="arial"><strong>#doc_filename#</strong></font></a><cfelse>#doc_filename#</cfif></td>
		<td width="173">#document_type#</td>
		<td width="130">#dateformat(date_received,"mm/dd/yyyy")#</td>
		<td width="130">#outText#</td>
	</tr></cfoutput>
	</cfloop>
	</table>
	<br>
	<font size="1" face="arial">*Please note: Documents are removed from system after 90 days.</font>