<cfset snippets = false>

<cfset getShard = application.searchObj.getShard(url.bidid) />

<cfhttp result="result" method="GET" charset="utf-8" url='#getShard#/tpc'>
    <cfhttpparam name="q" type="formfield" value="bidID:#url.bidid#">
    <cfhttpparam name="rows" type="formfield" value='1'>
    <cfhttpparam name="hl" type="formfield" value='on'>
    <cfhttpparam name="hl.q" type="formfield" value='"#url.kw#"'>
    <cfhttpparam name="hl.fl" type="formfield" value='pdf'>
    <cfhttpparam name="hl.usePhraseHighlighter" type="formfield" value='on'>
    <cfhttpparam name="hl.snippets" type="formfield" value='10'>
    <cfhttpparam name="hl.fragsize" type="formfield" value='500'>
    <cfhttpparam name="hl.simple.pre" type="formfield" value='<span class="highlite">'>
    <cfhttpparam name="hl.simple.post" type="formfield" value='</span>'>
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),id'>
</cfhttp>

<cfset bids = deserializeJSON(result.filecontent)>

<!---<cfdump var = #bids#><cfabort>--->
<cfif bids.response.docs[1].pdf_exists EQ 'YES' and NOT structIsEmpty(bids.highlighting[bids.response.docs[1].id])>
	<cfset snippets = true>
	<cfset recs = #arraylen(bids.highlighting[bids.response.docs[1].id].pdf)#>
</cfif>
<cfset url.kw= #replace(url.kw, '\', '', "all")#><cfoutput>#url.kw#</cfoutput>
<div>
	<form name="kwmodal" id="kwmodal" action="javascript:void(0);">
		<table>
			<tr>
				<td><input type="text" name="kw" id="kw" value='<cfoutput>#url.kw#</cfoutput>'> &nbsp; <input name="kwsearch" id="kwsearch" type="submit" value="Search Bid Document" class="btn btn-primary btn-sm" data-bidid="<cfoutput>#url.bidid#</cfoutput>"></td>
			</tr>
		</table>
	</form>
</div>

<cfif snippets>

	<div>
	<table class="table table-striped">
	<cfloop from="1" to="#recs#" index="r">
		<tr>
			<td>
				<p>...<cfoutput>#bids.highlighting[bids.response.docs[1].id].pdf[r]#</cfoutput>...</p>
			</td>
		</tr>
	</cfloop>		
	</table>
	</div>	

<cfelse>
	<div><p><br>No results in document, see <a href="../leads/?bidid=<cfoutput>#url.bidid#&keywords=#url.kw#</cfoutput>">project detail</a></p></div>
</cfif>

<style>
	.highlite{
		background:yellow;
	}	
</style>
<script>
		$("#kwsearch").click(function(e){	
		e.preventDefault();
		var bidID = $(this).attr('data-bidid');
		var kw = $('#kw').val();
		$(".dv-body").html("Content loading please wait...  <img src='../assets/images/spinner.svg'>");
		$(".dv-body").load('../leads/includes/docview.cfm?bidid=' + bidID + "&kw="+ encodeURIComponent(kw));
	});	
</script>
