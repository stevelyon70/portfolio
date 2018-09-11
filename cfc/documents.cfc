<cfcomponent>
		<cffunction name="listDocuments" access="public" output="false" returntype="query">
			<cfargument name="bidID" type="numeric" required="true" />
			<cfargument name="vendorID" type="numeric" required="false" />
			<cfquery name="listDocuments" datasource="paintsquare">
				select pbt_docs.doc_filename,b.document_type,pbt_docs.date_received,pbt_docs.file_size,pbt_docs.onviarefnum
				from pbt_docs
				left outer join pbt_docs_definer b on b.doctypeID = pbt_docs.doctypeID
				where pbt_docs.bidID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.bidid#">
				<cfif isdefined("arguments.vendorID") and arguments.vendorID NEQ "">or pbt_docs.onviarefnum = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.vendorID#"></cfif>
			</cfquery>
		<cfreturn listDocuments />
	</cffunction>
		<cffunction name="listSpendingDocuments" access="public" output="false" returntype="query">
			<cfargument name="bidID" type="numeric" required="true" />
			<cfquery name="listDocuments" datasource="paintsquare">
				select pbt_docs.doc_filename,b.document_type,pbt_docs.date_received,pbt_docs.file_size,pbt_docs.onviarefnum
				from pbt_docs
				left outer join pbt_docs_definer b on b.doctypeID = pbt_docs.doctypeID
				where pbt_docs.bidID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.bidid#">
				
			</cfquery>
		<cfreturn listDocuments />
	</cffunction>
</cfcomponent>