<cfparam name="url.bDate" default= '2017-10-01' />
<cfparam name="url.eDate" default= '2017-12-31' />
<cfset startMonth = month(bDate) />
<cfset month1 = url.bDate />
<cfset month2 = dateadd('m', +1, url.bDate) />
<cfset month3 = dateadd('m', +2, url.bDate) />
<cfset month1FirstDay = '#year(month1)#-#month(month1)#-01'/>
<cfset month1LastDay = '#year(month1)#-#month(month1)#-#DaysInMonth(month1)#'/>
<cfset month2FirstDay = '#year(month2)#-#month(month2)#-01'/>
<cfset month2LastDay = '#year(month2)#-#month(month2)#-#DaysInMonth(month2)#'/>
<cfset month3FirstDay = '#year(month3)#-#month(month3)#-01'/>
<cfset month3LastDay = '#year(month3)#-#month(month3)#-#DaysInMonth(month3)#'/>
<!doctype html>
<html>
<head>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>		
<cfquery datasource="paintsquare" name="qTotalPerQuarter">
		--count
	select sum(spec_count) as cnt, tag
	from pbt_market_brand_count
  	where paintpublishdate >= '#url.bDate# 00:00:00' and paintpublishdate <= '#url.eDate# 23:59:59'
    group by tag
	order by cnt desc
</cfquery>	
<!-- ECharts -->
<meta charset="UTF-8">
<title>Untitled Document</title>
</head>
<body>		
	<div class="pull-left">
			 <cftable colheaders="Yes" query="qTotalPerQuarter" htmltable="Yes">
			 	<cfcol text="#tag#" />
				 <cfcol text="#cnt#" />
			 </cftable>		
	</div>		 
	<cfinclude template="inc/filter.cfm" /> 
</body> 
</html>