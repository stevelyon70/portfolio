<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_bids/tpc'>
    <cfhttpparam name="q" type="formfield" value="*:*">
    <!---<cfhttpparam name="shards" type="formfield" value="http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_bids,http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_lowbids">--->
    <cfhttpparam name="fq" type="formfield" value='pdf:"wastewater"'>
    <cfhttpparam name="fq" type="formfield" value='pdf:"sewage"'>
    <!---<cfhttpparam name="fq" type="formfield" value='CompanyName:"Pensacola"'>--->
    <!---<cfhttpparam name="rows" type="formfield" value='2000'>--->
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),CompanyName, _version_, city, county, description, id, key, last_modified, onviarefnum, owner,projectname, tag, zipcode'>

</cfhttp>
<!--- bidID,pdf_exists:exists(pdf),CompanyName, _version_, city, county, description, id, key, last_modified, onviarefnum, owner, pdf, projectname, tag, zipcode --->
<!---<cfdump var="#result.filecontent#"><cfabort>--->

<cfset bids = deserializeJSON(result.filecontent)>
<cfset recs = #arraylen(bids.response.docs)#>
<cfdump var=#bids.response.numFound#><br><!------>
<cfloop from="1" to="#recs#" index="r">
	<cfoutput>#bids.response.docs[r].bidID#</cfoutput>
</cfloop>


<!---<cfdump var = "#bids.response.docs[1].companyname#">

<cfoutput>#bids.response.docs[2].onviarefnum[1]#</cfoutput>--->

<cfdump var = "#bids.response.docs#">


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