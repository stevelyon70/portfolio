<cfcomponent>
	<cffunction name="doesPdfExist" access="public" returntype="String">
		<cfargument name="bidid" type="numeric" required="yes">
		<cftry>
		<cfquery dbtype="query" name="qRslts">
			select pdf_exists
			from session.qresults
			where bidid = #arguments.bidid#
		</cfquery>	
		<cfset myResult=yesnoformat(qRslts.pdf_exists)>
		<cfcatch><cfset myResult='no'/></cfcatch></cftry>	
		<cfreturn myResult>
	</cffunction>
			
	<cffunction name="getShard" access="public" returntype="string">
		<cfargument name="bidid" type="numeric" required="yes">
		<cftry>
		<cfquery dbtype="query" name="qRslts">
			select shard
			from session.qresults
			where bidid = #arguments.bidid#
		</cfquery>	
		<cfset myResult=qRslts.shard>
		<cfcatch><cfset myResult='bad'/></cfcatch></cftry>	
		<cfreturn myResult>
	</cffunction>
			
			
	<cffunction name="getOnviarefnum" access="public" returntype="string">
		<cfargument name="bidid" type="numeric" required="yes">
		<cftry>
		<cfquery dbtype="query" name="qRslts" maxrows="1">
			select onviarefnum
			from session.qresults
			where bidid = #arguments.bidid#
		</cfquery>	
		<cfset myResult=qRslts.onviarefnum>
		<cfcatch><cfset myResult='bad'/></cfcatch></cftry>	
		<cfreturn myResult>
	</cffunction>
			
	<cffunction name="isPdfExpired" access="public" returntype="string">
		<cfargument name="bidID" type="numeric" required="true" />
		<cfargument name="pdffilename" type="string" required="true" />
		<cfargument name="compareDate" type="date" required="true" />
		
		<cfset onviarn = this.getOnviarefnum(arguments.bidid)/>
		
		<cfset variables.exp_date = dateadd("d",-90,compareDate)>
		
			<cfquery name="listDocuments" datasource="paintsquare">
				select top 1 pbt_docs.doc_filename,b.document_type,pbt_docs.date_received,pbt_docs.file_size,pbt_docs.onviarefnum
				from pbt_docs
				left outer join pbt_docs_definer b on b.doctypeID = pbt_docs.doctypeID
				where 0=0 and (pbt_docs.bidID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.bidid#"> or pbt_docs.onviarefnum = <cfqueryparam cfsqltype="CF_SQL_varchar" value="#onviarn#">)
					and pbt_docs.doc_filename = <cfqueryparam cfsqltype="CF_SQL_varchar" value="#arguments.pdffilename#">
					and pbt_docs.date_received >= <cfqueryparam cfsqltype="CF_SQL_DATE" value="#variables.exp_date#">			
			</cfquery>				
				<cfif listDocuments.recordcount eq 1>
					<cfset link = getPdfS3Link(listDocuments.onviarefnum,listDocuments.doc_filename) />
					<cfset _rtn = link />
				<cfelse>
					<cfset _rtn = 'false' />
				</cfif>
		<cfreturn _rtn />
	</cffunction>
				
	<cffunction name="getPdfS3Link" access="private" returntype="string">	
		<cfargument name="onviarefnum" type="string" required="true" />
		<cfargument name="doc_filename" type="string" required="true" />
		<cfset accessKeyId = "AKIAJHIZQ4L7H45IE2PQ"> 
		<cfset secretAccessKey = "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">
		<!---cfset accessKeyId = "AKIAIT7QGBVAFGU4GTOA">
		<cfset secretAccessKey = "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"--->
		<cfset s3 = createObject("component","amazons3.s3").init(accessKeyId,secretAccessKey)>
		<cfset key = "#arguments.onviarefnum#/#arguments.doc_filename#">
		<cfset timedLink = s3.getObject("docs.paintbidtracker.com",key)>
				
			<cfreturn timedLink />
			
	</cffunction>
				
				
</cfcomponent>