<!---modified on 10/5/11 by DS to migrate from Ultraseek to Solr--->

<!---run the search and return the results--->

<!--- Run the search against the Bid collection being passed over --->

	
<cfparam name="bidlist" default="">	
<cfset shardlist = ""/>
	
<cfif isdefined("project_stage") >
	<cfloop list="#project_stage#" index="i">
	 <cfswitch expression="#i#">
	 	  <cfcase value="1">
		   	<cfif not listcontains(project_stage, 12)>
			   	<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_advanced_notices')>
			</cfif>
		  </cfcase>
		   <cfcase value="2">
		   	<cfif not listcontains(project_stage, 12)>
			    <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_bids')>
			</cfif>
		  </cfcase>
		   <cfcase value="3">
		   	  <cfif not listcontains(project_stage, 12)>
			   <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_engineering')>
			 </cfif>
		  </cfcase>
		   <cfcase value="4">
		   	<cfif not listcontains(project_stage, 12)>
			    <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_subcontracting')>
			</cfif>
		  </cfcase>
		   <cfcase value="5">
		   	 <cfif not listcontains(project_stage,4) and not listcontains(project_stage, 12)>
			  <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_subcontracting')>
			</cfif>
		  </cfcase>
		   <cfcase value="6">
			    <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards')>
		  </cfcase>
		   <cfcase value="7">
		   	 <cfif not listcontains(project_stage,6) and not listcontains(project_stage, 13)>
			    <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_lowbids')>
			 </cfif>
		  </cfcase>
		   <cfcase value="8">
		   	  <cfif not listcontains(project_stage,6) and not listcontains(project_stage, 13)>
			   	<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards_results')>
			  </cfif>
		  </cfcase>
		   <cfcase value="9">
		   	  <cfif not listcontains(project_stage,6) and not listcontains(project_stage, 13)>
			    <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards')>
			 </cfif>
		  </cfcase>
		   <cfcase value="10">
		   	  <cfif listcontains(project_stage, 10)>
				<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_bids_00')>
				<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_bids_01')>
				<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_bids_02')>
			  </cfif>
		  </cfcase>
		   <cfcase value="11">
		   	  <cfif listcontains(project_stage, 11)>
			    <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_subcontracting')>
			  </cfif>
		  </cfcase>
		   <cfcase value="12">				 
				 <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_advanced_notices')>
				 <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_bids')>							 
		  </cfcase>
		   <cfcase value="13">
			    <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards')>
		  </cfcase>
		   <cfcase value="14">
			    <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_bids')>
			    <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_subcontracting')>
			   <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_engineering')>
		  </cfcase>
		   <cfcase value="15">
			    <cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_engineering')>
		  </cfcase>
		</cfswitch>
	</cfloop>
	<cfelseif isdefined("qt") and qt NEQ "">
			<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_bids')>
			<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_advanced_notices')>
			<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_engineering')>
			<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_subcontracting')>
			<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards')>
			<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_lowbids')>
			<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards_results')>
			<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_bids')>
			<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_subcontracting')>
			<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_engineering')>
	</cfif>	
<!---<cfdump var="#shardlist#"><cfabort>--->
<cfset url.qt= #REreplace(url.qt, '"', '\"', "all")#>

<cfhttp result="result" method="GET" charset="utf-8" url='#listfirst(shardlist)#/tpc'>
    <cfhttpparam name="q" type="formfield" value="#url.qt#"><!------>
    <cfhttpparam name="shards" type="formfield" value="#shardlist#">
    <!---<cfhttpparam name="fq" type="formfield" value='pdf:"#url.qt#"'>
    <cfhttpparam name="fq" type="formfield" value='description:"#url.qt#"'>--->
    <cfhttpparam name="rows" type="formfield" value='600'>
    <cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard]'>
</cfhttp>
<!---bidID,pdf_exists:exists(pdf),CompanyName, _version_, city, county, description, id, key, last_modified, onviarefnum, owner,projectname, tag, zipcode--->
	
<cfset bids = deserializeJSON(result.filecontent)>
<cfset reslts = #bids.response.docs#>
<!---<cfdump var=#reslts#>--->
<cfset session.qresults = QueryNew( "bidID, pdf_exists, shard", "INTEGER, VARCHAR, VARCHAR" ) />
<cfloop from="1" to="#arraylen(reslts)#" index="_i">
	<cfset QueryAddRow(session.qresults,1) />
	<cfset QuerySetCell(session.qresults, "bidID", reslts[_i].bidID, _i) />
	<cfset QuerySetCell(session.qresults, "pdf_exists", reslts[_i].pdf_exists, _i) />
	<cfset QuerySetCell(session.qresults, "shard", reslts[_i].shard, _i) />
</cfloop>	
	
<cfset recs = #arraylen(bids.response.docs)#>
<cfloop from="1" to="#recs#" index="r">
	<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
</cfloop>
<!---<cfdump var=#listlen(bidlist)#><cfabort>--->

