<cfparam name="form.filterQtr" default="Q1" />
<cfparam name="form.filterYear" default="2018" />
<cfparam name="bDate" default= '2018-01-01' />
<cfparam name="eDate" default= '2018-03-31' />
<cfset request.filterUrl = '/?brand_share'/>
<cfswitch  expression="#form.filterQtr#">
	<cfcase value="Q1">
		<cfset bDate = '#form.filterYear#-01-01'/>
		<cfset eDate = '#form.filterYear#-03-31'/>
	</cfcase>
	<cfcase value="Q2">
		<cfset bDate = '#form.filterYear#-04-01'/>
		<cfset eDate = '#form.filterYear#-06-30'/>
	</cfcase>
	<cfcase value="Q3">
		<cfset bDate = '#form.filterYear#-07-01'/>
		<cfset eDate = '#form.filterYear#-09-30'/>
	</cfcase>
	<cfcase value="Q4">
		<cfset bDate = '#form.filterYear#-10-01'/>
		<cfset eDate = '#form.filterYear#-12-31'/>
	</cfcase>	
</cfswitch>
<cfset month1 = bDate />
<cfset month3 = dateadd('m', +2, bDate) />		
<cfquery datasource="paintsquare" name="qTotalPerQuarter">
		--count
	select sum(spec_count) as cnt, tag, (select sum(spec_count) from pbt_market_brand_count
  	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59') as totalCnt
	from pbt_market_brand_count
  	where paintpublishdate >= '#bDate# 00:00:00' and paintpublishdate <= '#eDate# 23:59:59'
    group by tag
	order by cnt desc
</cfquery>	

<!-- ECharts -->
<script src="../vendor/echarts/dist/echarts.min.js"></script>
	<style>
		.bimeBoxText {min-height: 75px; min-width: 550px;float: left;font-size: 1.8EM;margin-top:20px;text-align:center;}
		.bimeBoxChart {min-height: 350px; float: left;text-align:center;}
		.pageTitle {background-color: #003163;color:white;font-size: 1.5EM;min-height: 40px;padding-left:15px;}
		section {width: 100%;}
		.container {border:2px solid black;padding-left:0;padding-right: 0;margin-left: 5px;}
	</style>
	<div class="container">
		<section>
			<header class="pageTitle">Specification Share Rankings - <cfoutput>#dateformat(month1, 'mmm yyy')# - #dateformat(month3, 'mmm yyy')#</cfoutput></header>
		</section>
		<section>
			<cfinclude template="inc/filter.cfm" /> 
		</section>
		<section>
			<cftable colheaders="Yes" query="qTotalPerQuarter" htmltable="Yes" colspacing="25">				
				<cfcol text="#currentrow#" header="" />
			 	<cfcol text="#tag#" header="Brand Name/Manufacturer" />
			 	<cfcol text="#cnt#" header="Number of Specs" />
				<cfcol text="#round(cnt/totalCnt*100)#%" header="Spec Share [#totalCnt#]" />
			 </cftable>	
		</section>
		
	</div>
	 