<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Untitled Document</title>
</head>
<cfparam default="roads" name="url.qt"/>
<body>
<cfparam name="url.kw" default= "paint" />
<cfset tickBegin = GetTickCount()>  
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

    <cfhttpparam name="rows" type="formfield" value='500'> 
    <cfhttpparam name="fl" type="formfield" value='id, onviarefnum,bidID, description,pdf_exists:exists(pdf),shard:[shard]'><!---,pdf--->
</cfhttp>
	<!---
<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_lowbids/tpc'>
    <cfhttpparam name="q" type="formfield" value="*:*">   
    <!---<cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>
    <cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>--->
    <cfhttpparam name="fq" type="formfield" value='description:"#url.qt#"'>
    <cfhttpparam name="rows" type="formfield" value='300'>
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf)'>
</cfhttp>
<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_advanced_notices/tpc'>
    <cfhttpparam name="q" type="formfield" value="*:*">   
    <!---<cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>
    <cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>--->
    <cfhttpparam name="fq" type="formfield" value='description:"#url.qt#"'>
    <cfhttpparam name="rows" type="formfield" value='300'>
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf)'>
</cfhttp>
<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_engineering/tpc'>
    <cfhttpparam name="q" type="formfield" value="*:*">   
    <!---<cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>
    <cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>--->
    <cfhttpparam name="fq" type="formfield" value='description:"#url.qt#"'>
    <cfhttpparam name="rows" type="formfield" value='300'>
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf)'>
</cfhttp>
<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_subcontracting/tpc'>
    <cfhttpparam name="q" type="formfield" value="*:*">   
    <!---<cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>
    <cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>--->
    <cfhttpparam name="fq" type="formfield" value='description:"#url.qt#"'>
    <cfhttpparam name="rows" type="formfield" value='300'>
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf)'>
</cfhttp>
<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards/tpc'>
    <cfhttpparam name="q" type="formfield" value="*:*">   
    <!---<cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>
    <cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>--->
    <cfhttpparam name="fq" type="formfield" value='description:"#url.qt#"'>
    <cfhttpparam name="rows" type="formfield" value='300'>
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf)'>
</cfhttp>
<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards_results/tpc'>
    <cfhttpparam name="q" type="formfield" value="*:*">   
    <!---<cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>
    <cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>--->
    <cfhttpparam name="fq" type="formfield" value='description:"#url.qt#"'>
    <cfhttpparam name="rows" type="formfield" value='300'>
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf)'>
</cfhttp>
<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_bids_00/tpc'>
    <cfhttpparam name="q" type="formfield" value="*:*">   
    <!---<cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>
    <cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>--->
    <cfhttpparam name="fq" type="formfield" value='description:"#url.qt#"'>
    <cfhttpparam name="rows" type="formfield" value='300'>
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf)'>
</cfhttp>
<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_bids_01/tpc'>
    <cfhttpparam name="q" type="formfield" value="*:*">   
    <!---<cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>
    <cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>--->
    <cfhttpparam name="fq" type="formfield" value='description:"#url.qt#"'>
    <cfhttpparam name="rows" type="formfield" value='300'>
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf)'>
</cfhttp>
<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_bids_02/tpc'>
    <cfhttpparam name="q" type="formfield" value="*:*">   
    <!---<cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>
    <cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>--->
    <cfhttpparam name="fq" type="formfield" value='description:"#url.qt#"'>
    <cfhttpparam name="rows" type="formfield" value='300'>
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf)'>
</cfhttp>
<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_subcontracting/tpc'>
    <cfhttpparam name="q" type="formfield" value="*:*">   
    <!---<cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>
    <cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>--->
    <cfhttpparam name="fq" type="formfield" value='description:"#url.qt#"'>
    <cfhttpparam name="rows" type="formfield" value='300'>
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf)'>
</cfhttp>
		--->
<cfset tickEnd = GetTickCount()> 
<cfset loopTime = tickEnd - tickBegin>

<cfset bids = deserializeJSON(result.filecontent)>
<cftry>
<cfset recs = #arraylen(bids.response.docs)#>
<cfoutput>#loopTime# ms for NEW #recs# records</cfoutput>	
<cfcatch></cfcatch></cftry>			
<cfset tickBegin = GetTickCount()> 		
<cfsearch name="search_Results1" collection="pbt_current_bids" criteria="#url.qt#" maxrows="300">	
<cfsearch name="search_Results1" collection="pbt_lowbids" criteria="#url.qt#" maxrows="300">
<!---<cfsearch name="search_Results1" collection="pbt_advanced_notices" criteria="#url.qt#" maxrows="300">
<cfsearch name="search_Results1" collection="pbt_engineering" criteria="#url.qt#" maxrows="300">
<cfsearch name="search_Results1" collection="pbt_current_subcontracting" criteria="#url.qt#" maxrows="300">
<cfsearch name="search_Results1" collection="pbt_awards" criteria="#url.qt#" maxrows="300">
<cfsearch name="search_Results1" collection="pbt_awards_results" criteria="#url.qt#" maxrows="300">
<cfsearch name="search_Results1" collection="pbt_expired_bids_00" criteria="#url.qt#" maxrows="300">
<cfsearch name="search_Results1" collection="pbt_expired_bids_01" criteria="#url.qt#" maxrows="300">
<cfsearch name="search_Results1" collection="pbt_expired_bids_02" criteria="#url.qt#" maxrows="300">
<cfsearch name="search_Results1" collection="pbt_expired_subcontracting" criteria="#url.qt#" maxrows="300">--->
	<cfset tickEnd = GetTickCount()> 
<cfset loopTime = tickEnd - tickBegin>
<cfoutput>#loopTime# ms for OLD #search_Results1.recordcount# records</cfoutput>	
</body>
</html>
	
	<!---
pbt_current_bids,pbt_lowbids,pbt_advanced_notices,pbt_engineering,pbt_current_subcontracting,pbt_awards,pbt_awards_results,pbt_expired_bids_00,pbt_expired_bids_01,pbt_expired_bids_02,pbt_expired_subcontracting
<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_bids/tpc'>
    <cfhttpparam name="q" type="formfield" value="*:*">
    <cfhttpparam name="shards" type="formfield" value="http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_lowbids,http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_advanced_notices,http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_engineering,http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_subcontracting,http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards,http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards_results,http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_bids_00,http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_bids_01,http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_bids_02,http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_subcontracting">
    <!---<cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>
    <cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>--->
    <cfhttpparam name="fq" type="formfield" value='description:"#url.qt#"'>
    <cfhttpparam name="rows" type="formfield" value='300'>
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf)'>
		<!---,CompanyName, _version_, city, county, description, id, key, last_modified, onviarefnum, owner,projectname, tag, zipcode--->

</cfhttp>
		
		--->