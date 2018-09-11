<cfparam name="url.kw" default='bridge'><cfdump var="#session.qresults#" expand="yes"><cfabort>
<!---<cfset getShard = application.searchObj.getShard(url.bidid) />--->

<cfhttp result="result" method="GET" charset="utf-8" url='http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pdf_repository/select'>
    <cfhttpparam name="q" type="formfield" value="*:*">
    <cfhttpparam name="fq" type="formfield" value="ref:36400312">
    <cfhttpparam name="df" type="formfield" value="pdf">
    <cfhttpparam name="hl" type="formfield" value='on'>
    <cfhttpparam name="hl.q" type="formfield" value='#url.kw#'>
    <cfhttpparam name="hl.fl" type="formfield" value='pdf'>
    <!---<cfhttpparam name="hl.usePhraseHighlighter" type="formfield" value='on'>--->
    <cfhttpparam name="hl.snippets" type="formfield" value='10'>
    <cfhttpparam name="hl.fragsize" type="formfield" value='500'>
    <cfhttpparam name="hl.simple.pre" type="formfield" value='<span class="highlite">'>
    <cfhttpparam name="hl.simple.post" type="formfield" value='</span>'>
    <!---<cfhttpparam name="fl" type="formfield" value='id'>--->
</cfhttp>

<cfset bids = deserializeJSON(result.filecontent)>
<cfset recs = #arraylen(bids.highlighting['36400312/18340358.pdf|2018-06-01T09:13:30Z'].pdf)#>
	<tr><td>DOCUMENT: <cfoutput>#listlast(listfirst('36400312/18340358.pdf|2018-06-01T09:13:30Z',"|"),"/")#</cfoutput></td></tr>
	<cfloop from="1" to="#recs#" index="r">
		
		<tr>
			<td>
				<p>...<cfoutput>#bids.highlighting['36400312/18340358.pdf|2018-06-01T09:13:30Z'].pdf[r]#</cfoutput>...</p>
			</td>
		</tr>
	</cfloop>	


<cfdump var = "#bids.highlighting['36400312/18340358.pdf|2018-06-01T09:13:30Z'].pdf#"><br><cfabort>
<cfdump var = "#bids.highlighting['36400312/18340360.pdf|2018-06-01T09:13:44Z'].pdf#"><br>
<cfdump var = "#bids.highlighting['36400312/18340357.pdf|2018-06-01T09:13:26Z'].pdf#"><br>
<cfdump var = "#bids.highlighting['36400312/18340359.pdf|2018-06-01T09:13:42Z'].pdf#"><br>


<cfdump var = #bids#>
36400312/18340358.pdf|2018-06-01T09:13:30Z
36400312/18340360.pdf|2018-06-01T09:13:44Z
36400312/18340357.pdf|2018-06-01T09:13:26Z
36400312/18340359.pdf|2018-06-01T09:13:42Z