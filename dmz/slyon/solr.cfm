<cfparam name="url.kw" default= "paint" />
<!---cfdump var="#session.qresults#" expand="no"--->
<cfset kw= #REreplace(url.kw, '"', '\"', "all")#>
<!---cfdump var="#kw#"--->



<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_bids/tpc'>
    
    <cfif isDefined("url.bidid")>
    <cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
    <cfelse>
    <cfhttpparam name="q" type="formfield" value="#url.kw#">
	</cfif>
    <!---<cfhttpparam name="fq" type="formfield" value='CompanyName:#url.kw#'>
    <cfhttpparam name="fq" type="formfield" value='city:#url.kw#'>
    <cfhttpparam name="fq" type="formfield" value='county:#url.kw#'>
    <cfhttpparam name="fq" type="formfield" value='description:#url.kw#'>
    <cfhttpparam name="fq" type="formfield" value='owner:#url.kw#'>
    <cfhttpparam name="fq" type="formfield" value='projectname:#url.kw#'>
    <cfhttpparam name="fq" type="formfield" value='tag:#url.kw#'>
    <cfhttpparam name="fq" type="formfield" value='zipcode:#url.kw#'>--->
    <cfhttpparam name="shards" type="formfield" value="http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_bids,http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_lowbids">

    <cfhttpparam name="rows" type="formfield" value='20'> 
    <cfhttpparam name="fl" type="formfield" value='id, onviarefnum,bidID, description,pdf_exists:exists(pdf),shard:[shard]'><!---,pdf--->
</cfhttp>

<!--- bidID,pdf_exists:exists(pdf),CompanyName, _version_, city, county, description, id, key, last_modified, onviarefnum, owner, pdf, projectname, tag, zipcode,shard:[shard] --->
<!---<cfdump var="#result.filecontent#"><cfabort>--->

<cfset bids = deserializeJSON(result.filecontent)>
<!---cfset recs = #bids.response.docs#--->
KEYWORD: <cfoutput>#url.kw#</cfoutput><br><br>	
<!---<cfdump var=#bids.response.numFound#>
<cfdump var = "#bids.highlighting#">--->
<cfdump var=#bids#>
	<cfabort>
<!---<cfdump var = "#session.qresults#">
<cfset hasPDf = application.searchObj.doesPdfExist(23323) />
<cfdump var = "#yesnoformat(hasPDf)#">--->
<!---
<cfset qresults = QueryNew( "bidID, pdf_exists, shard", "INTEGER, VARCHAR, VARCHAR" ) />
	<cfoutput>#arraylen(recs)#</cfoutput>
	<cfloop from="1" to="#arraylen(recs)#" index="_i">
		<cfoutput>#recs[_i].bidID#</cfoutput>
		<cfset QueryAddRow(qresults,1) />
		<cfset QuerySetCell(qresults, "bidID", recs[_i].bidID, _i) />
		<cfset QuerySetCell(qresults, "pdf_exists", recs[_i].pdf_exists, _i) />
		<cfset QuerySetCell(qresults, "shard", recs[_i].shard, _i) />
	</cfloop>
<cfdump var = "#qresults#"><cfabort>--->

<!------><cfabort>
<cfloop from="1" to="#recs#" index="r">
	<cfoutput>#bids.response.docs[r].bidID#</cfoutput>
</cfloop>

<cfdump var = "#bids.highlighting#">
<!---<cfdump var = "#bids.response.docs[1].companyname#">

<cfoutput>#bids.response.docs[2].onviarefnum[1]#</cfoutput>--->

<cfdump var = "#bids.response.docs#"><cfabort><!------>


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

<cfoutput>#highlightKeywords( bids.response.docs[1].pdf[1], "sidewalk" )#</cfoutput>


<!--- <cfif !IsJSON(result.filecontent)>
    <h3>The URL you requested does not provide valid JSON</h3>


<cfelse>
    <cfset bids = DeserializeJSON(result.filecontent)>
   <!--- <cfdump var=#bids# >--->
		<cfif structKeyExists( bids.response, 'docs' ) AND isArray(bids.response.docs)>
        <cfoutput>
         <cfloop index="i" from="1" to="#arraylen(bids.response.docs)#">#i#
            <h3>Company: #bids.response.docs[i].companyname[1]#</h3>
            <h4>Key: #bids.response.docs[i].key[1]#</h4>
        </cfloop>
        </cfoutput>
		</cfif>
</cfif>
--->