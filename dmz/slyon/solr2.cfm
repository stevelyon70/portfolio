<cfset bidlist =""><cfset url.qt= #REreplace(url.qt, '"', '\"', "all")#>
<cftry><cfsearch name="search_Results2" collection="pbt_current_bids" criteria="#url.qt#" maxrows="300">
			    <cfif search_Results2.recordcount GT 0> 
			    	<cfset bidlist = listappend(bidlist,valuelist(search_results2.key))>
				</cfif> <cfcatch>wrong</cfcatch></cftry>

<cfdump var="#bidlist#">

<cfabort>

<cfset url.qt= #REreplace(url.qt, '"', '\"', "all")#>
<cfset shard = 'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_bids'>
				<cfhttp result="result2" method="GET" charset="utf-8" url='#shard#/browse'>
					<cfif len(bidid) and isnumeric(bidid)>
						<cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
					<cfelse>
						<cfhttpparam name="q" type="formfield" value="#url.qt#">
					</cfif>   
					<cfhttpparam name="shards" type="formfield" value="#shard#"> 
					<!---<cfhttpparam name="rows" type="formfield" value='79'>--->
					<cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard]'>
				</cfhttp>
				<cfset bids = deserializeJSON(result2.filecontent)>
				<cfset reslts_2 = #bids.response.docs#>
	

				<cfset recs = #arraylen(bids.response.docs)#>
				<cfloop from="1" to="#recs#" index="r">
					<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
				</cfloop>
<cfdump var="#bidlist#">


<cfabort>


<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_bids/tpc'>
    <cfhttpparam name="q" type="formfield" value="bidID:4878357">  
    <cfhttpparam name="fl" type="formfield" value='id,bidID, description,pdf_exists:exists(pdf),shard:[shard],pdf'>
</cfhttp>
<!--- bidID,pdf_exists:exists(pdf),CompanyName, _version_, city, county, description, id, key, last_modified, onviarefnum, owner, pdf, projectname, tag, zipcode,shard:[shard] --->
<!---<cfdump var="#result.filecontent#"><cfabort>--->

<cfset bids = deserializeJSON(result.filecontent)>
<cfset recs = #bids.response.docs#>
	
<!---<cfdump var=#bids.response.numFound#>--->
<!---<cfdump var=#arraylen(bids.response.docs[1].pdf)#>--->
<!---<cfdump var=#recs#>--->
	


<!---<cfabort>
<cfloop from="1" to="#recs#" index="r">
	<cfoutput>#bids.response.docs[r].bidID#</cfoutput>
</cfloop>--->

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

<cfscript>
		/*
		I highlight words in a string that are found in a keyword list. Useful for search result pages.
		@param str String to be searched
		@param searchterm Comma delimited list of keywords
		*/
		string function highlightKeywords( required string str, required string searchterm ){
		var j = "";
		var matches = "";
		var word = "";
		// loop through keywords
		for( var i=1; i lte ListLen( arguments.searchterm, " " ); i=i+1 ){
		// get current keyword and escape any special regular expression characters
		word = ReReplace( ListGetAt( arguments.searchterm, i, " " ), "\.|\^|\$|\*|\+|\?|\(|\)|\[|\]|\{|\}|\\", "" );
		// return matches for current keyword from string
		matches = ReMatchNoCase( word, arguments.str );
		// remove duplicate matches (case sensitive)
		matches = CreateObject( "java", "java.util.HashSet" ).init( matches ).toArray();
		// loop through matches
		for( j=1; j <= ArrayLen( matches ); j=j+1 ){
		// where match exists in string highlight it
		arguments.str = Replace( arguments.str, matches[ j ], "<span style='background:yellow;'>#matches[ j ]#</span>", "all" );
		}
		}
		return arguments.str;
		}
</cfscript>
<!---<cfoutput>#highlightKeywords( bids.response.docs[1].pdf[1], "BID BOND" )#</cfoutput>--->

<!---
<cfif findNoCase ("BID BOND", bids.response.docs[1].pdf[1])>
<cfset wordFoundPos = listFindNoCase(bids.response.docs[1].pdf[1], "BID BOND", " ,.-:;") />
<cfset charPos = findnocase(#bids.response.docs[1].pdf[1]#, "BOND") />
<cfset context = mid(190, #charPos-90#, #bids.response.docs[1].pdf[1]#) />
<cfoutput>#charPos# </cfoutput>
</cfif>
--->
<cfparam name="url.kw" default= "bid" />
<cfset kwlen = #len(url.kw)#>

<cfloop from="1" to="#arraylen(bids.response.docs[1].pdf)#" index="r"><!------>
	<cfif len(bids.response.docs[1].pdf[r]) GT 0> 
		<!---|<cfoutput>#len(bids.response.docs[1].pdf[r])#,</cfoutput>--->
		<cfset position_list = "">
		<!--- Determine total number of instances of keyword in current document text --->
		<cfset variables.string = "#bids.response.docs[1].pdf[r]#" />
		<cfset variables.substring = "#url.kw#" />
		<cfset occurrences = ( Len(string) - Len(Replace(string,substring,'','all'))) / Len(substring) >
		<!---<cfdump var="(#occurrences#)">	--->
		
		<cfif occurrences GT 0>
			<cfif occurrences GT 1><cfset occurrences = occurrences - 1></cfif>
			
			<div>
				<table class="table table-striped">

					<!---<cfset lighted = replaceNoCase(bids.response.docs[1].pdf[r], kw, '<span class="highlite">#ucase(kw)#</span>', "all")> --->

					<!--- Search for positions of instances --->
					<cfloop from="1" to="#occurrences#" index="p">
						<cfif p EQ 1>
							<cfset currentInstance = refindNoCase(kw, bids.response.docs[1].pdf[r]) />
						<cfelse>						
							<cfif refindNoCase(kw, bids.response.docs[1].pdf[r], currentInstance+kwlen)>
								<cfset currentInstance = refindNoCase(kw, bids.response.docs[1].pdf[r], currentInstance+kwlen)>
							</cfif>				
						</cfif>	
						<cfset position_list = #listappend(position_list,currentInstance)#>
					</cfloop>
					<!---<cfdump var="[#position_list#]">--->	
					<cfset c= 1>
					<cfset old_pos = 0>
					<cfloop list="#position_list#" index="pos">

						<cfif c EQ 1 OR (pos - old_pos) GT 500>
							<!---<cfset alltext = insert('</span>', bids.response.docs[1].pdf[r], pos+kwlen-1)>
							<cfset alltext = insert('<span class="highlite">', alltext, pos-1)>	--->		
							<cfset context = mid(bids.response.docs[1].pdf[r], pos-200, 650) />
							<cfset lighted = replaceNoCase(context, kw, '<span class="highlite">#kw#</span>', "all")> 
							<tr>
								<td>
									<p>...<cfoutput><!--#pos# - ---> #lighted#</cfoutput>...</p>
								</td>
							</tr>						
							<cfif c GT 10><cfbreak><cfelse><cfset c=c+1></cfif>
							<cfset old_pos = pos>		
						</cfif>

					</cfloop>

				</table>
			</div>		
			<!---<cfset charPos = findnocase(kw, #bids.response.docs[1].pdf[r]#) />
			<cfif charPos GT 0>
				<cfset alltext = insert('</span>', bids.response.docs[1].pdf[r], charPos+kwlen-1)>
				<cfset alltext = insert('<span class="highlite">', alltext, charPos-1)>			
				<cfset context = mid(alltext, charPos-200, 650) />

				<br><cfoutput>...#context#...</cfoutput><br><br>-----<br><br>
			</cfif>--->
		</cfif>
	</cfif>
</cfloop><!------>





<style>
	.highlite{
		background:yellow;
	}	
</style>




