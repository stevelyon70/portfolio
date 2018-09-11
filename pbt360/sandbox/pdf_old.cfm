<cfset the_dsn = "paintsquare">
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>		

<div id="echart_pie" style="height:500px; width:600px"></div>
<!-- ECharts -->
<script src="../vendor/echarts/dist/echarts.min.js"></script>
<!-- Custom Theme Scripts -->
<cfinclude template="echarts.cfm">
<cfabort>

<cfquery name="results" datasource="#the_dsn#">
SELECT        SUM(amount) as amount,  count(amount) as count, 'Jul 2017' as month
FROM            pbt_market_kpi_total_dollars_tagged 
WHERE        (stateID = 45) AND (tagID = 8) AND (paintpublishdate > '2017-07-01') AND (paintpublishdate < '2017-08-01')
UNION
SELECT        SUM(amount) as amount,  count(amount) as count, 'Aug 2017' as month
FROM            pbt_market_kpi_total_dollars_tagged
WHERE        (stateID = 45) AND (tagID = 8) AND (paintpublishdate > '2017-08-01') AND (paintpublishdate < '2017-09-01')
UNION
SELECT        SUM(amount) as amount,  count(amount) as count, 'Sep 2017' as month
FROM            pbt_market_kpi_total_dollars_tagged
WHERE        (stateID = 45) AND (tagID = 8) AND (paintpublishdate > '2017-09-01') AND (paintpublishdate < '2017-10-01')
</cfquery> 

<table>
<cfloop list="bar,line,pyramid,area,horizontalbar,cone,curve,cylinder,step,scatter,pie" index="c">
<tr>
<td>
<cfchart format="html" title="Total Cost" show3d="false">
	<cfchartseries type="#c#">
		<cfoutput query="results">
		
		<cfchartdata item="#month#" value="#amount#">
		</cfoutput>
		<!---<cfchartdata item="2014" value="#RandRange(300000,900000)#">
		<cfchartdata item="2015" value="#RandRange(300000,900000)#">--->
	</cfchartseries>
</cfchart>
</td>
<td>
<cfchart format="html" title="Total Projects" show3d="false">
	<cfchartseries type="#c#">
		<cfoutput query="results">
		<cfchartdata item="#month#" value="#count#">
		</cfoutput>
		<!---<cfchartdata item="2014" value="#RandRange(300000,900000)#">
		<cfchartdata item="2015" value="#RandRange(300000,900000)#">--->
	</cfchartseries>
</cfchart>
</td>
</tr>
</cfloop>
</table>

<!---<cfhtmltopdf margintop=".5" marginbottom=".5" 
 marginleft=".5" marginright=".5">
 <cfhtmltopdfitem type="header">Paint BidTracker Lead Details</cfhtmltopdfitem>
 <cfoutput>#session.leadDetail#</cfoutput>
<cfhtmltopdfitem type="pagebreak" />
<cfoutput>#session.leadDetail#</cfoutput>
 <cfhtmltopdfitem type="footer">Page: _PAGENUMBER of _LASTPAGENUMBER</cfhtmltopdfitem>
</cfhtmltopdf>--->