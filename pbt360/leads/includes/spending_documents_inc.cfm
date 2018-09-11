<cfset accessKeyId = "AKIAIT7QGBVAFGU4GTOA">
<cfset secretAccessKey = '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'>
<cfset s3 = createObject("component","pbt_gateway.amazons3.s3_v2").init(accessKeyId,secretAccessKey)>


	<cfloop query="listDocuments">
		 <CFINVOKE COMPONENT="FileSizeText" 
                METHOD="getText" 
                RETURNVARIABLE="outText">
        
                <CFINVOKEARGUMENT NAME="size"
                        VALUE="#file_size#">
        </CFINVOKE>
		<cfoutput>
		<cfset key = "#doc_filename#">
		<cfset timedLink = s3.getObject2("document.paintbidtracker.com",key)>
			<a href="#timedLink#" target="_blank"><font color="blue" size="2" face="arial"><strong>Capital Improvement Plan</strong></font></a>
	</cfoutput>
	</cfloop>
	