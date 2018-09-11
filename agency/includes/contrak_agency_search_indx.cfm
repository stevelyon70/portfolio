<!---Contractor index for search--->
<!---created by DS on 2/1/15 contrak search index--->



<cftransaction action="begin">
<cftry>
<!--- Retrieve all fields to be searched --->
		<cfquery name="getresults" datasource="pbt_analytics">
		select supplierID, agencyname as companyname
		from contrak_agency_search
		</cfquery>
		<!---cfdump var="#getresults#"---><br>
		<!--- Feedback --->
		Indexing data ...<br>
		<!--- Build 'custom' index on query result above --->
		<cfindex action="refresh"
		         collection="contrak_agency_search"
		         key="supplierID"
		         type="custom"
		         title="companyname"
		         query="getresults"
		         body="companyname">
		<!--- Feedback --->
		Collection complete<br><hr>

<cfcatch type="Database">
<CFMAIL
     
			SUBJECT="PBT Collection Indexing Problem"
			FROM="PaintBidtracker@paintsquare.com"
			to="dstevens@paintsquare.com"
			
			type="html">
			Aborted the indexing for collection [contrak_agency_search].
			Reason:  #cfcatch.ErrorCode#<br>
			Message: #cfcatch.Message#<br>
			Detail: #cfcatch.Detail#
			</cfmail>
</cfcatch>
</cftry>


</cftransaction>
	


