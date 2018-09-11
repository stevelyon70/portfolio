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
		--total dollars
	select sum(value) as total
	from (select sum(amount)/count(bidid) as value
  	FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
  	where paintpublishdate >= '#url.bDate# 00:00:00' and paintpublishdate <= '#url.eDate# 23:59:59'
	and [Sub Categories] like '%Bridges and Tunnels%'
  group by bidid, paintpublishdate, amount) as tbl
</cfquery>
 <cfquery datasource="paintsquare" name="qTotalPaintPerQuarter">
 --total dollars paint
  select sum(amount) as total
  from pbt_market_total_dollars_unique
  where paintpublishdate >= '#url.bDate# 00:00:00' and paintpublishdate <= '#url.eDate# 23:59:59' and valuetypeid=2
	and [Sub Categories] like '%Bridges and Tunnels%'
</cfquery>
	<cfquery datasource="paintsquare" name="qTotalPerQuarterPerMonth" result="r1">
		--total dollars per month
		select sum(mth1.value) as total, #DateFormat(month1, "m")# as mth, '#DateFormat(month1, "mmm")# #DateFormat(month1, "yyyy")#' as mthname
		from (select sum(amount)/count(bidid) as value
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month1FirstDay# 00:00:00' and paintpublishdate <= '#month1LastDay# 23:59:59' 
	and [Sub Categories] like '%Bridges and Tunnels%'
		group by bidid, paintpublishdate, amount) as mth1

		union 

		select sum(mth1.value) as total, #DateFormat(month2, "m")# as mth, '#DateFormat(month2, "mmm")# #DateFormat(month2, "yyyy")#' as mthname
		from (select sum(amount)/count(bidid) as value
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month2FirstDay# 00:00:00' and paintpublishdate <= '#month2LastDay# 23:59:59' 
	and [Sub Categories] like '%Bridges and Tunnels%'
		group by bidid, paintpublishdate, amount) as mth1

		union

		select sum(mth1.value) as total, #DateFormat(month3, "m")# as mth, '#DateFormat(month3, "mmm")# #DateFormat(month3, "yyyy")#' as mthname
		from (select sum(amount)/count(bidid) as value
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month3FirstDay# 00:00:00' and paintpublishdate <= '#month3LastDay# 23:59:59' 
	and [Sub Categories] like '%Bridges and Tunnels%'
		group by bidid, paintpublishdate, amount) as mth1

		order by mth
	</cfquery>
		
	<cfquery datasource="paintsquare" name="qAvgContractValuePerMonth" result="r2">
		select sum(mth1.value) as total, #DateFormat(month1, "m")# as mth, '#DateFormat(month1, "mmm")# #DateFormat(month1, "yyyy")#' as mthname, (select count(bidid)
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month1FirstDay# 00:00:00' and paintpublishdate <= '#month1LastDay# 23:59:59'
		and [Sub Categories] like '%Bridges and Tunnels%' ) as bidcount
		from (select sum(amount)/count(bidid) as value
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month1FirstDay# 00:00:00' and paintpublishdate <= '#month1LastDay# 23:59:59' 
	and [Sub Categories] like '%Bridges and Tunnels%'
		group by bidid, paintpublishdate, amount) as mth1

		union 

		select sum(mth1.value) as total, #DateFormat(month2, "m")# as mth, '#DateFormat(month2, "mmm")# #DateFormat(month2, "yyyy")#' as mthname, (select count(bidid)
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month2FirstDay# 00:00:00' and paintpublishdate <= '#month2LastDay# 23:59:59' 
	and [Sub Categories] like '%Bridges and Tunnels%') as bidcount
		from (select sum(amount)/count(bidid) as value
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month2FirstDay# 00:00:00' and paintpublishdate <= '#month2LastDay# 23:59:59' 
	and [Sub Categories] like '%Bridges and Tunnels%'
		group by bidid, paintpublishdate, amount) as mth1

		union

		select sum(mth1.value) as total, #DateFormat(month3, "m")# as mth, '#DateFormat(month3, "mmm")# #DateFormat(month3, "yyyy")#' as mthname, (select count(bidid)
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month2FirstDay# 00:00:00' and paintpublishdate <= '#month2LastDay# 23:59:59' 
	and [Sub Categories] like '%Bridges and Tunnels%') as bidcount
		from (select sum(amount)/count(bidid) as value
		FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
		where paintpublishdate >= '#month3FirstDay# 00:00:00' and paintpublishdate <= '#month3LastDay# 23:59:59' 
	and [Sub Categories] like '%Bridges and Tunnels%'
		group by bidid, paintpublishdate, amount) as mth1

		order by mth
	</cfquery>
		
<cfquery datasource="paintsquare" name="qAwardVolumnByState">
	select sum(value) as total, state
	from (select sum(amount)/count(bidid) as value, state
  	FROM [paintsquare].[dbo].[pbt_market_total_dollars_unique]
  	where paintpublishdate >= '#url.bDate# 00:00:00' and paintpublishdate <= '#url.eDate# 23:59:59'
	and [Sub Categories] like '%Bridges and Tunnels%'
    group by bidid, paintpublishdate, amount,state) as tbl
    Group By state
    order by state																				 
</cfquery>
<!-- ECharts -->
<script src="../vendor/echarts/dist/echarts.min.js"></script>
<meta charset="UTF-8">
<title>Untitled Document</title>
</head>

<body>		 
		 <cfoutput>
		 #url.bDate# - #url.eDate#<br/>
		 #month1# / #month2# / #month3#<br />
		 #month1FirstDay# #month1LastDay#	 <br />	 
		 #month2FirstDay# #month2LastDay#	 <br />	
		 #month3FirstDay# #month3LastDay#	 <br />	
		 <h1>Total Dollars - #dollarformat(qTotalPerQuarter.total)#</h1>
		 <h1>Total Dollars : Painting - #dollarformat(qTotalPaintPerQuarter.total)#</h1>
		 <h1>Award Volume by Month - #dollarformat(qTotalPerQuarterPerMonth.total[1])# #dollarformat(qTotalPerQuarterPerMonth.total[2])# #dollarformat(qTotalPerQuarterPerMonth.total[3])#</h1>
		 
		 <h1>Award Contract Avg by Month - #dollarformat(qAvgContractValuePerMonth.total[1]/qAvgContractValuePerMonth.bidcount[1])# #dollarformat(qAvgContractValuePerMonth.total[2]/qAvgContractValuePerMonth.bidcount[2])# #dollarformat(qAvgContractValuePerMonth.total[3]/qAvgContractValuePerMonth.bidcount[3])#</h1>
		 <cfdump var="#qAwardVolumnByState#" />
		 <!---<div id="echart_pie" style="height:500px; width:600px"></div>
		 <div id="echart_bar" style="height:500px; width:800px"></div>--->
		 <div id="main" style="width: 550px;height:350px;"></div>
		 <!---<iframe frameBorder="0" seamless id="frame1" name="frame1" scroll="no" height=820px width=1500px src="https://technologypublishing.bime.io/dashboard/market-performance-total_v2?access_token=#session.auth.user_access_token###year=#session.auth.default_year#&quarter=#session.auth.default_qtr#"></iframe>--->
		 
		 </cfoutput>
</body>
    
    <script type="text/javascript">
        // based on prepared DOM, initialize echarts instance
        var myChart = echarts.init(document.getElementById('main'));

        // specify chart configuration item and data
        var option = {
            title: {
                text: 'Award Volume by Month'
            },
            tooltip: {},
            /*legend: {
                data:['Month']
            },*/
            xAxis: {
              data: [<cfoutput>#QuotedValueList(qTotalPerQuarterPerMonth.mthname)#</cfoutput>]
            },
            yAxis: [
			  {
				type : 'value',
				axisLabel : {
                 formatter: function(value){return ['$' + (value /1000000) + 'M'];}
                  }/*,
				name: 'Y-Axis',
				nameLocation: 'middle',
				nameGap: 50*/
			  }
			],
            series: [{
                name: 'Month',
                type: 'bar',
                data: [<cfoutput>#QuotedValueList(qTotalPerQuarterPerMonth.total)#</cfoutput>]
            }]
        };

        // use configuration item and data specified to show chart
        myChart.setOption(option);
    </script>
<script>
	
	/*function init_echarts() {

		if( typeof (echarts) === 'undefined'){ return; }
		console.log('init_echarts');

			var echartBar = echarts.init(document.getElementById('echart_bar'));
			option = {
				xAxis: {
					type: 'category',
					data: ['Oct 2017', 'Nov 2017', 'Dec 2017']
				},
				yAxis: {
					type: 'value'
				},
				series: [{
					data: [<cfoutput>#qTotalPerQuarterPerMonth.total[1]#,#qTotalPerQuarterPerMonth.total[2]#,#qTotalPerQuarterPerMonth.total[3]#</cfoutput>],
					type: 'bar'
				}]
			};			
			echartBar.setOption(option);
						 
			var theme = {
			  color: [
				  '#26B99A', '#34495E', '#BDC3C7', '#3498DB',
				  '#9B59B6', '#8abb6f', '#759c6a', '#bfd3b7'
			  ]
			};*/
	

		//echart Pie		  
		/*if ($('#echart_pie').length ){  

		  var echartPie = echarts.init(document.getElementById('echart_pie'),theme);

		  echartPie.setOption({
			title: {
				text: '',
				left: 'center',
				top: 15,
				textStyle: {
					color: '#ccc'
				}
			},
			tooltip: {
			  trigger: 'item',
			  formatter: "{a} <br/>{b} : {c}" //({d}%)
			},
			legend: {
			  x: 'center',
			  y: 'bottom',
			  data: []
			},
			toolbox: {
			  show: true,
			  feature: {
				magicType: {
				  show: true,
				  type: ['pie', 'funnel'],
				  option: {
					funnel: {
					  x: '25%',
					  width: '50%',
					  funnelAlign: 'left',
					  max: 1548
					}
				  }
				}
			  }
			},
			calculable: true,
			series: [{
			  name: 'Click Totals',
			  type: 'pie',
			  radius: '50%',
			  center: ['50%', '50%'],
			  data: [],
			  itemStyle: {				  
				emphasis: {
					shadowBlur: 10,
					shadowOffsetX: 0,
					shadowColor: 'rgba(0, 0, 0, 0.5)'
				}
			  }
			}]
		  });


		  var placeHolderStyle = {
			normal: {
			  color: 'rgba(0,0,0,0)',
			  label: {
				show: false
			  },
			  labelLine: {
				show: false
			  }
			},
			emphasis: {
			  color: 'rgba(0,0,0,0)'
			}
		  };

			
		
		echartPie.showLoading();
			
			// Asynchronous data loading 
			$.get('process.cfm').done(function (data) {
				echartPie.hideLoading();
				_data = JSON.parse(data)
				console.log(_data);
				//alert(_data.leg);
				//alert(_data.items);
				// fill in data
				echartPie.setOption({
					legend: {
						data: _data.leg
					},
					series: [{
						data: _data.items						
					}]
				});
			});				
			
		};	
	};	** */
	
	
	/*$(document).ready(function() {

		init_echarts();	

	});	*/
</script>
</html>