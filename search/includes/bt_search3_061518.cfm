<!---modified on 10/5/11 by DS to migrate from Ultraseek to Solr--->

<!---run the search and return the results--->

<!--- Run the search against the Bid collection being passed over --->

	
<cfparam name="bidlist" default="">	
<cfset shardlist = ""/>
<cfset session.qresults = QueryNew( "bidID, pdf_exists, shard, onviarefnum, pdf_files", "INTEGER, VARCHAR, VARCHAR, INTEGER, VARCHAR" ) />
	
<cfif isdefined("project_stage") >
	<cfloop list="#project_stage#" index="i">
	 <cfswitch expression="#i#">
	 	  <cfcase value="1">
		   	<cfif not listcontains(project_stage, 12)>
			   	<!---<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_advanced_notices')>--->
			    <cfset shard = 'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_advanced_notices'>
				<cfhttp result="result1" method="GET" charset="utf-8" url='#shard#/tpc'>
					<cfif len(bidid) and isnumeric(bidid)>
						<cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
					<cfelse>
						<cfhttpparam name="q" type="formfield" value='#url.qt#'>
					</cfif>   
					<cfhttpparam name="shards" type="formfield" value="#shard#">
					<cfhttpparam name="rows" type="formfield" value='1000'>
					<cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard],onviarefnum,pdf_ids'>
				</cfhttp>
				<cfset bids = deserializeJSON(result1.filecontent)>
				<cfset reslts_1 = #bids.response.docs#>

				<cfloop from="1" to="#arraylen(reslts_1)#" index="_i">
					<cfset pdf_files_list ="">
					<cfparam name="reslts_1[_i].pdf_ids" default="" />
					<cfif isArray(reslts_1[_i].pdf_ids)>
						<cfset pdf_files_list = arrayToList(reslts_1[_i].pdf_ids)>
					</cfif>	
					<cfset QueryAddRow(session.qresults,1) />
					<cfset QuerySetCell(session.qresults, "bidID", reslts_1[_i].bidID) />
					<cfset QuerySetCell(session.qresults, "pdf_exists", reslts_1[_i].pdf_exists) />
					<cfset QuerySetCell(session.qresults, "shard", reslts_1[_i].shard) />
					<cfset QuerySetCell(session.qresults, "onviarefnum", reslts_1[_i].onviarefnum[1]) />
					<cfset QuerySetCell(session.qresults, "pdf_files", pdf_files_list) />
				</cfloop>	

				<cfset recs = #arraylen(bids.response.docs)#>
				<cfloop from="1" to="#recs#" index="r">
					<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
				</cfloop>			   	
			</cfif>
		  </cfcase>
		   <cfcase value="2">
		   	<cfif not listcontains(project_stage, 12)>
			    <!---<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_bids')>--->
			    <cfset shard = 'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_bids'>
				<cfhttp result="result2" method="GET" charset="utf-8" url='#shard#/tpc'>
					<cfif len(bidid) and isnumeric(bidid)>
						<cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
					<cfelse>
						<cfhttpparam name="q" type="formfield" value='#url.qt#'>
					</cfif>   
					<cfhttpparam name="shards" type="formfield" value="#shard#">
					<cfhttpparam name="rows" type="formfield" value='1000'>
					<cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard],onviarefnum,pdf_ids'>
				</cfhttp>
				<cfset bids = deserializeJSON(result2.filecontent)>
				<cfset reslts_2 = #bids.response.docs#>

				<cfloop from="1" to="#arraylen(reslts_2)#" index="_i">	
					<cfset pdf_files_list ="">
					<cfparam name="reslts_2[_i].pdf_ids" default="" />
					<cfif isArray(reslts_2[_i].pdf_ids)>
						<cfset pdf_files_list = arrayToList(reslts_2[_i].pdf_ids)>
					</cfif>					
					<cfset QueryAddRow(session.qresults,1) />
					<cfset QuerySetCell(session.qresults, "bidID", reslts_2[_i].bidID) />
					<cfset QuerySetCell(session.qresults, "pdf_exists", reslts_2[_i].pdf_exists) />
					<cfset QuerySetCell(session.qresults, "shard", reslts_2[_i].shard) />
					<cfset QuerySetCell(session.qresults, "onviarefnum", reslts_2[_i].onviarefnum[1]) />
					<cfset QuerySetCell(session.qresults, "pdf_files", pdf_files_list) />
				</cfloop>	

				<cfset recs = #arraylen(bids.response.docs)#>
				<cfloop from="1" to="#recs#" index="r">
					<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
				</cfloop>							    
			</cfif>
		  </cfcase>
		   <cfcase value="3">
		   	  <cfif not listcontains(project_stage, 12)>
			   	<!---<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_engineering')>--->
			    <cfset shard = 'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_engineering'>
				<cfhttp result="result3" method="GET" charset="utf-8" url='#shard#/tpc'>
					<cfif len(bidid) and isnumeric(bidid)>
						<cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
					<cfelse>
						<cfhttpparam name="q" type="formfield" value='#url.qt#'>
					</cfif>   
					<cfhttpparam name="shards" type="formfield" value="#shard#">
					<cfhttpparam name="rows" type="formfield" value='1000'>
					<cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard],onviarefnum,pdf_ids'>
				</cfhttp>
				<cfset bids = deserializeJSON(result3.filecontent)>
				<cfset reslts_3 = #bids.response.docs#>
				<!---<cfdump var=#reslts#>--->

				<cfloop from="1" to="#arraylen(reslts_3)#" index="_i">
					<cfset pdf_files_list ="">
					<cfparam name="reslts_3[_i].pdf_ids" default="" />
					<cfif isArray(reslts_3[_i].pdf_ids)>
						<cfset pdf_files_list = arrayToList(reslts_3[_i].pdf_ids)>
					</cfif>	
					<cfset QueryAddRow(session.qresults,1) />
					<cfset QuerySetCell(session.qresults, "bidID", reslts_3[_i].bidID) />
					<cfset QuerySetCell(session.qresults, "pdf_exists", reslts_3[_i].pdf_exists) />
					<cfset QuerySetCell(session.qresults, "shard", reslts_3[_i].shard) />
					<cfset QuerySetCell(session.qresults, "onviarefnum", reslts_3[_i].onviarefnum[1]) />
					<cfset QuerySetCell(session.qresults, "pdf_files", pdf_files_list) />
				</cfloop>	

				<cfset recs = #arraylen(bids.response.docs)#>
				<cfloop from="1" to="#recs#" index="r">
					<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
				</cfloop>			   
			 </cfif>
		  </cfcase>
		   <cfcase value="4">
		   	<cfif not listcontains(project_stage, 12)>
			    <!---<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_subcontracting')>--->
			    <cfset shard = 'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_subcontracting'>
				<cfhttp result="result4" method="GET" charset="utf-8" url='#shard#/tpc'>
					<cfif len(bidid) and isnumeric(bidid)>
						<cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
					<cfelse>
						<cfhttpparam name="q" type="formfield" value='#url.qt#'>
					</cfif>   
					<cfhttpparam name="shards" type="formfield" value="#shard#">
					<cfhttpparam name="rows" type="formfield" value='1000'>
					<cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard],onviarefnum,pdf_ids'>
				</cfhttp>
				<cfset bids = deserializeJSON(result4.filecontent)>
				<cfset reslts_4 = #bids.response.docs#>

				<cfloop from="1" to="#arraylen(reslts_4)#" index="_i">
					<cfset pdf_files_list ="">
					<cfparam name="reslts_4[_i].pdf_ids" default="" />
					<cfif isArray(reslts_4[_i].pdf_ids)>
						<cfset pdf_files_list = arrayToList(reslts_4[_i].pdf_ids)>
					</cfif>	
					<cfset QueryAddRow(session.qresults,1) />
					<cfset QuerySetCell(session.qresults, "bidID", reslts_4[_i].bidID) />
					<cfset QuerySetCell(session.qresults, "pdf_exists", reslts_4[_i].pdf_exists) />
					<cfset QuerySetCell(session.qresults, "shard", reslts_4[_i].shard) />
					<cfset QuerySetCell(session.qresults, "pdf_files", pdf_files_list) />
				</cfloop>	

				<cfset recs = #arraylen(bids.response.docs)#>
				<cfloop from="1" to="#recs#" index="r">
					<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
				</cfloop>			    
			</cfif>
		  </cfcase>		  
	   	  <cfcase value="5">
		   	 <cfif not listcontains(project_stage,4) and not listcontains(project_stage, 12)>
			    <!---<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_subcontracting')>--->
			    <cfset shard = 'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_current_subcontracting'>
				<cfhttp result="result5" method="GET" charset="utf-8" url='#shard#/tpc'>
					<cfif len(bidid) and isnumeric(bidid)>
						<cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
					<cfelse>
						<cfhttpparam name="q" type="formfield" value='#url.qt#'>
					</cfif>   
					<cfhttpparam name="shards" type="formfield" value="#shard#">
					<cfhttpparam name="rows" type="formfield" value='1000'>
					<cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard],onviarefnum,pdf_ids'>
				</cfhttp>
				<cfset bids = deserializeJSON(result5.filecontent)>
				<cfset reslts_5 = #bids.response.docs#>

				<cfloop from="1" to="#arraylen(reslts_5)#" index="_i">
					<cfset pdf_files_list ="">
					<cfparam name="reslts_5[_i].pdf_ids" default="" />
					<cfif isArray(reslts_5[_i].pdf_ids)>
						<cfset pdf_files_list = arrayToList(reslts_5[_i].pdf_ids)>
					</cfif>	
					<cfset QueryAddRow(session.qresults,1) />
					<cfset QuerySetCell(session.qresults, "bidID", reslts_5[_i].bidID) />
					<cfset QuerySetCell(session.qresults, "pdf_exists", reslts_5[_i].pdf_exists) />
					<cfset QuerySetCell(session.qresults, "shard", reslts_5[_i].shard) />
					<cfset QuerySetCell(session.qresults, "onviarefnum", reslts_5[_i].onviarefnum[1]) />
					<cfset QuerySetCell(session.qresults, "pdf_files", pdf_files_list) />
				</cfloop>	

				<cfset recs = #arraylen(bids.response.docs)#>
				<cfloop from="1" to="#recs#" index="r">
					<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
				</cfloop>			  
			</cfif>
		  </cfcase>
		   <cfcase value="6">
			    <!---<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards')>--->
			    <cfset shard = 'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards'>
				<cfhttp result="result6" method="GET" charset="utf-8" url='#shard#/tpc'>
					<cfif len(bidid) and isnumeric(bidid)>
						<cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
					<cfelse>
						<cfhttpparam name="q" type="formfield" value='#url.qt#'>
					</cfif>   
					<cfhttpparam name="shards" type="formfield" value="#shard#">
					<cfhttpparam name="rows" type="formfield" value='1000'>
					<cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard],onviarefnum,pdf_ids'>
				</cfhttp>
				<cfset bids = deserializeJSON(result6.filecontent)>
				<cfset reslts_6 = #bids.response.docs#>

				<cfloop from="1" to="#arraylen(reslts_6)#" index="_i">
					<cfset pdf_files_list ="">
					<cfparam name="reslts_6[_i].pdf_ids" default="" />
					<cfif isArray(reslts_6[_i].pdf_ids)>
						<cfset pdf_files_list = arrayToList(reslts_6[_i].pdf_ids)>
					</cfif>	
					<cfset QueryAddRow(session.qresults,1) />
					<cfset QuerySetCell(session.qresults, "bidID", reslts_6[_i].bidID) />
					<cfset QuerySetCell(session.qresults, "pdf_exists", reslts_6[_i].pdf_exists) />
					<cfset QuerySetCell(session.qresults, "shard", reslts_6[_i].shard) />
					<cfset QuerySetCell(session.qresults, "onviarefnum", reslts_6[_i].onviarefnum[1]) />
					<cfset QuerySetCell(session.qresults, "pdf_files", pdf_files_list) />
				</cfloop>	

				<cfset recs = #arraylen(bids.response.docs)#>
				<cfloop from="1" to="#recs#" index="r">
					<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
				</cfloop>			    
		  </cfcase>		  
		   <cfcase value="7">
		   	 <cfif not listcontains(project_stage,6) and not listcontains(project_stage, 13)>
			    <!---<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_lowbids')>--->
			    <cfset shard = 'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_lowbids'>
				<cfhttp result="result7" method="GET" charset="utf-8" url='#shard#/tpc'>
					<cfif len(bidid) and isnumeric(bidid)>
						<cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
					<cfelse>
						<cfhttpparam name="q" type="formfield" value='#url.qt#'>
					</cfif>    
					<cfhttpparam name="shards" type="formfield" value="#shard#">
					<cfhttpparam name="rows" type="formfield" value='1000'>
					<cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard],onviarefnum,pdf_ids'>
				</cfhttp>
				<cfset bids = deserializeJSON(result7.filecontent)>
				<cfset reslts_7 = #bids.response.docs#>
				<!---<cfdump var=#reslts#>--->

				<cfloop from="1" to="#arraylen(reslts_7)#" index="_i">
					<cfset pdf_files_list ="">
					<cfparam name="reslts_7[_i].pdf_ids" default="" />
					<cfif isArray(reslts_7[_i].pdf_ids)>
						<cfset pdf_files_list = arrayToList(reslts_7[_i].pdf_ids)>
					</cfif>	
					<cfset QueryAddRow(session.qresults,1) />
					<cfset QuerySetCell(session.qresults, "bidID", reslts_7[_i].bidID) />
					<cfset QuerySetCell(session.qresults, "pdf_exists", reslts_7[_i].pdf_exists) />
					<cfset QuerySetCell(session.qresults, "shard", reslts_7[_i].shard) />
					<cfset QuerySetCell(session.qresults, "onviarefnum", reslts_7[_i].onviarefnum[1]) />
					<cfset QuerySetCell(session.qresults, "pdf_files", pdf_files_list) />
				</cfloop>	

				<cfset recs = #arraylen(bids.response.docs)#>
				<cfloop from="1" to="#recs#" index="r">
					<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
				</cfloop>			    
			 </cfif>
		  </cfcase>
		   <cfcase value="8">
		   	  <cfif not listcontains(project_stage,6) and not listcontains(project_stage, 13)>
			    <!---<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards_results')>--->
			    <cfset shard = 'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards_results'>
				<cfhttp result="result8" method="GET" charset="utf-8" url='#shard#/tpc'>
					<cfif len(bidid) and isnumeric(bidid)>
						<cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
					<cfelse>
						<cfhttpparam name="q" type="formfield" value='#url.qt#'>
					</cfif>   
					<cfhttpparam name="shards" type="formfield" value="#shard#">
					<cfhttpparam name="rows" type="formfield" value='1000'>
					<cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard],onviarefnum,pdf_ids'>
				</cfhttp>
				<cfset bids = deserializeJSON(result8.filecontent)>
				<cfset reslts_8 = #bids.response.docs#>

				<cfloop from="1" to="#arraylen(reslts_8)#" index="_i">
					<cfset pdf_files_list ="">
					<cfparam name="reslts_8[_i].pdf_ids" default="" />
					<cfif isArray(reslts_8[_i].pdf_ids)>
						<cfset pdf_files_list = arrayToList(reslts_8[_i].pdf_ids)>
					</cfif>	
					<cfset QueryAddRow(session.qresults,1) />
					<cfset QuerySetCell(session.qresults, "bidID", reslts_8[_i].bidID) />
					<cfset QuerySetCell(session.qresults, "pdf_exists", reslts_8[_i].pdf_exists) />
					<cfset QuerySetCell(session.qresults, "shard", reslts_8[_i].shard) />
					<cfset QuerySetCell(session.qresults, "onviarefnum", reslts_8[_i].onviarefnum[1]) />
					<cfset QuerySetCell(session.qresults, "pdf_files", pdf_files_list) />
				</cfloop>	

				<cfset recs = #arraylen(bids.response.docs)#>
				<cfloop from="1" to="#recs#" index="r">
					<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
				</cfloop>			   	
			  </cfif>
		  </cfcase>
		   <cfcase value="9">
		   	  <cfif not listcontains(project_stage,6) and not listcontains(project_stage, 13)>
			    <!---<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards')>--->
			    <cfset shard = 'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_awards'>
				<cfhttp result="result9" method="GET" charset="utf-8" url='#shard#/tpc'>
					<cfif len(bidid) and isnumeric(bidid)>
						<cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
					<cfelse>
						<cfhttpparam name="q" type="formfield" value='#url.qt#'>
					</cfif>   
					<cfhttpparam name="shards" type="formfield" value="#shard#">
					<cfhttpparam name="rows" type="formfield" value='1000'>
					<cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard],onviarefnum,pdf_ids'>
				</cfhttp>
				<cfset bids = deserializeJSON(result9.filecontent)>
				<cfset reslts_9 = #bids.response.docs#>

				<cfloop from="1" to="#arraylen(reslts_9)#" index="_i">
					<cfset pdf_files_list ="">
					<cfparam name="reslts_9[_i].pdf_ids" default="" />
					<cfif isArray(reslts_9[_i].pdf_ids)>
						<cfset pdf_files_list = arrayToList(reslts_9[_i].pdf_ids)>
					</cfif>	
					<cfset QueryAddRow(session.qresults,1) />
					<cfset QuerySetCell(session.qresults, "bidID", reslts_9[_i].bidID) />
					<cfset QuerySetCell(session.qresults, "pdf_exists", reslts_9[_i].pdf_exists) />
					<cfset QuerySetCell(session.qresults, "shard", reslts_9[_i].shard) />
					<cfset QuerySetCell(session.qresults, "onviarefnum", reslts_9[_i].onviarefnum[1]) />
					<cfset QuerySetCell(session.qresults, "pdf_files", pdf_files_list) />
				</cfloop>	

				<cfset recs = #arraylen(bids.response.docs)#>
				<cfloop from="1" to="#recs#" index="r">
					<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
				</cfloop>			    
			 </cfif>
		  </cfcase>
		   <cfcase value="10">
		   	  <cfif listcontains(project_stage, 10)>
		   	  	<cfset shard = "">
				<cfset shard = listappend(shard,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_bids_00')>
				<cfset shard = listappend(shard,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_bids_01')>
				<cfset shard = listappend(shard,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_bids_02')>
				<cfhttp result="result10" method="GET" charset="utf-8" url='#listfirst(shard)#/tpc'>
					<cfif len(bidid) and isnumeric(bidid)>
						<cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
					<cfelse>
						<cfhttpparam name="q" type="formfield" value='#url.qt#'>
					</cfif>   
					<cfhttpparam name="shards" type="formfield" value="#shard#"> 
					<cfhttpparam name="rows" type="formfield" value='300'>
					<cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard],onviarefnum,pdf_ids'>
				</cfhttp>
				<cfset bids = deserializeJSON(result10.filecontent)>
				<cfset reslts_10 = #bids.response.docs#>

				<cfloop from="1" to="#arraylen(reslts_10)#" index="_i">
					<cfset pdf_files_list ="">
					<cfparam name="reslts_10[_i].pdf_ids" default="" />
					<cfif isArray(reslts_10[_i].pdf_ids)>
						<cfset pdf_files_list = arrayToList(reslts_10[_i].pdf_ids)>
					</cfif>	
					<cfset QueryAddRow(session.qresults,1) />
					<cfset QuerySetCell(session.qresults, "bidID", reslts_10[_i].bidID) />
					<cfset QuerySetCell(session.qresults, "pdf_exists", reslts_10[_i].pdf_exists) />
					<cfset QuerySetCell(session.qresults, "shard", reslts_10[_i].shard) />
					<cfset QuerySetCell(session.qresults, "onviarefnum", reslts_10[_i].onviarefnum[1]) />
					<cfset QuerySetCell(session.qresults, "pdf_files", pdf_files_list) />
				</cfloop>	

				<cfset recs = #arraylen(bids.response.docs)#>
				<cfloop from="1" to="#recs#" index="r">
					<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
				</cfloop>				
			  </cfif>
		  </cfcase>
		   <cfcase value="11">
		   	  <cfif listcontains(project_stage, 11)>
			    <!---<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_subcontracting')>--->
			    <cfset shard = 'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_subcontracting'>
				<cfhttp result="result11" method="GET" charset="utf-8" url='#shard#/tpc'>
					<cfif len(bidid) and isnumeric(bidid)>
						<cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
					<cfelse>
						<cfhttpparam name="q" type="formfield" value='#url.qt#'>
					</cfif>   
					<cfhttpparam name="shards" type="formfield" value="#shard#">
					<cfhttpparam name="rows" type="formfield" value='1000'>
					<cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard],onviarefnum,pdf_ids'>
				</cfhttp>
				<cfset bids = deserializeJSON(result11.filecontent)>
				<cfset reslts_11 = #bids.response.docs#>

				<cfloop from="1" to="#arraylen(reslts_11)#" index="_i">
					<cfset pdf_files_list ="">
					<cfparam name="reslts_11[_i].pdf_ids" default="" />
					<cfif isArray(reslts_11[_i].pdf_ids)>
						<cfset pdf_files_list = arrayToList(reslts_11[_i].pdf_ids)>
					</cfif>	
					<cfset QueryAddRow(session.qresults,1) />
					<cfset QuerySetCell(session.qresults, "bidID", reslts_11[_i].bidID) />
					<cfset QuerySetCell(session.qresults, "pdf_exists", reslts_11[_i].pdf_exists) />
					<cfset QuerySetCell(session.qresults, "shard", reslts_11[_i].shard) />
					<cfset QuerySetCell(session.qresults, "onviarefnum", reslts_11[_i].onviarefnum[1]) />
					<cfset QuerySetCell(session.qresults, "pdf_files", pdf_files_list) />
				</cfloop>	

				<cfset recs = #arraylen(bids.response.docs)#>
				<cfloop from="1" to="#recs#" index="r">
					<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
				</cfloop>			    
			  </cfif>
		  </cfcase>
		  <!--- Not in search selection
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
		  --->
		   <cfcase value="15">
			    <!---<cfset shardlist = listappend(shardlist,'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_engineering')>--->
			    <cfset shard = 'http://ec2-52-35-107-213.us-west-2.compute.amazonaws.com:8983/solr/pbt_expired_engineering'>
				<cfhttp result="result15" method="GET" charset="utf-8" url='#shard#/tpc'>
					<cfif len(bidid) and isnumeric(bidid)>
						<cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
					<cfelse>
						<cfhttpparam name="q" type="formfield" value='#url.qt#'>
					</cfif>   
					<cfhttpparam name="shards" type="formfield" value="#shard#">
					<cfhttpparam name="rows" type="formfield" value='1000'>
					<cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard],onviarefnum,pdf_ids'>
				</cfhttp>
				<cfset bids = deserializeJSON(result15.filecontent)>
				<cfset reslts_15 = #bids.response.docs#>
				
				<cfloop from="1" to="#arraylen(reslts_15)#" index="_i">	
					<cfset pdf_files_list ="">
					<cfparam name="reslts_15[_i].pdf_ids" default="" />
					<cfif isArray(reslts_15[_i].pdf_ids)>
						<cfset pdf_files_list = arrayToList(reslts_15[_i].pdf_ids)>
					</cfif>				
					<cfset QueryAddRow(session.qresults,1) />
					<cfset QuerySetCell(session.qresults, "bidID", reslts_15[_i].bidID) />
					<cfset QuerySetCell(session.qresults, "pdf_exists", reslts_15[_i].pdf_exists) />
					<cfset QuerySetCell(session.qresults, "shard", reslts_15[_i].shard) />
					<cfset QuerySetCell(session.qresults, "onviarefnum", reslts_15[_i].onviarefnum[1]) />
					<cfset QuerySetCell(session.qresults, "pdf_files", pdf_files_list) />
				</cfloop>	

				<cfset recs = #arraylen(bids.response.docs)#>
				<cfloop from="1" to="#recs#" index="r">
					<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
				</cfloop>			    
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
			
			<cfhttp result="result" method="GET" charset="utf-8" url='#listfirst(shardlist)#/tpc'>
				<cfif len(bidid) and isnumeric(bidid)>
					<cfhttpparam name="q" type="formfield" value='bidID:#url.bidid#'>
				<cfelse>
					<cfhttpparam name="q" type="formfield" value='#url.qt#'>
				</cfif>    
				<cfhttpparam name="shards" type="formfield" value="#shardlist#">
				<cfhttpparam name="rows" type="formfield" value='100'>
				<cfhttpparam name="fl" type="formfield" value='bidID,pdf_exists:exists(pdf),shard:[shard],onviarefnum,pdf_ids'>
			</cfhttp>

			<cfset bids = deserializeJSON(result.filecontent)>
			<cfset reslts = #bids.response.docs#>
			<!---<cfdump var=#reslts#>--->
			<cfset session.qresults = QueryNew( "bidID, pdf_exists, shard", "INTEGER, VARCHAR, VARCHAR" ) />
			<cfloop from="1" to="#arraylen(reslts)#" index="_i">
					<cfset pdf_files_list ="">
					<cfparam name="reslts[_i].pdf_ids" default="" />
					<cfif isArray(reslts[_i].pdf_ids)>
						<cfset pdf_files_list = arrayToList(reslts[_i].pdf_ids)>
					</cfif>	
				<cfset QueryAddRow(session.qresults,1) />
				<cfset QuerySetCell(session.qresults, "bidID", reslts[_i].bidID, _i) />
				<cfset QuerySetCell(session.qresults, "pdf_exists", reslts[_i].pdf_exists, _i) />
				<cfset QuerySetCell(session.qresults, "shard", reslts[_i].shard, _i) />
				<cfset QuerySetCell(session.qresults, "onviarefnum", reslts[_i].onviarefnum[1]) />
				<cfset QuerySetCell(session.qresults, "pdf_files", pdf_files_list) />
			</cfloop>	

			<cfset recs = #arraylen(bids.response.docs)#>
			<cfloop from="1" to="#recs#" index="r">
				<cfset bidlist = listappend(bidlist,bids.response.docs[r].bidID)/>
			</cfloop>			
			<!---<cfdump var="#shardlist#"><cfabort>--->			
			
	</cfif>	
	<cfset url.qt= #REreplace(url.qt, '"', '\"', "all")#>
<!---bidID,pdf_exists:exists(pdf),CompanyName, _version_, city, county, description, id, key, last_modified, onviarefnum, owner,projectname, tag, zipcode--->
<!---<cfdump var=#listlen(bidlist)#><cfabort>--->

