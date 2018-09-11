<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Untitled Document</title>
</head>

<body>
	
	
	
	
	
	
<!---

******** new solr *****

--->
	
	
<cfset bidlist = ''/>
<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_bids/tpc'>
    <!---<cfhttpparam name="q" type="formfield" value="*:*">
    <cfhttpparam name="shards" type="formfield" value="http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_bids,http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_lowbids">
    <cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>
    <cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>
    <cfhttpparam name="fq" type="formfield" value='description:"#url.qt#*"'>--->
    <cfhttpparam name="q" type="formfield" value='"#url.qt#"'>
    <cfhttpparam name="rows" type="formfield" value='300'>
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),CompanyName, _version_, city, county, description, id, key, last_modified, onviarefnum, owner,projectname, tag, zipcode'>

</cfhttp>	
<cfset bids = deserializeJSON(result.filecontent)>
<cfset recs = bids.response.docs>
	
	<!---<cfdump var="#bids.response#" /><cfabort/>--->
	<cfloop from="1" to="#arraylen(bids.response.docs)#" index="r">
	<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
</cfloop>
	<cfset bidlist = listSort(listRemoveDuplicates(bidlist), "Numeric", "asc", ",")/>
	(<cfdump var="#arraylen(bids.response.docs)# - #listLen(bidlist)#" />) NEW SOLR<br>
	<cfdump var="#bidlist#" expand="yes" label="NEW Results" /><br>
<!---

******** old solr *****

--->	
	
	
<cfset bidlist = ''/>
	<cfsearch name="search_Results2" collection="pbt_current_bids" criteria="#qt#" maxrows="300" >
		<cfset bidlist = listappend(bidlist,valuelist(search_Results2.key))>
			<cfset bidlist = listSort(listRemoveDuplicates(bidlist), "Numeric", "asc", ",")/>
		(<cfdump var="#search_Results2.recordcount# - #listLen(bidlist)#" />) OLD SOLR<br>
		<cfdump var="#bidlist#" expand="yes" label="OLD Results" /><br>
	
<!---

******** live db *****

--->
	<cfset bidlist = ''/>	
	<cfquery datasource="paintsquare" name="q1">
		select *
		from pbt_current_bids_v2
		where 1=1
		and (PROJECTNAME like '%#url.qt#%'
		or tag like '%#url.qt#%' or description like '%#url.qt#%')
		order by bidid
	</cfquery>
			<cfset bidlist = listappend(bidlist,valuelist(q1.bidid))>
			<cfset bidlist = #listRemoveDuplicates(bidlist)#>
	(<cfdump var="#q1.recordcount# - #listLen(bidlist)#" />) LIVE DB
	<cfdump var="#bidlist#" expand="yes" label="DB Results" />
</body>
</html>